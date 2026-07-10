import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_guard.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/conteudo_repository.dart';
import '../../data/subscricao_repository.dart';
import '../../data/voto_repository.dart';
import '../../models/conteudo.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

class ArticleDetailScreen extends ConsumerStatefulWidget {
  final String articleId;
  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  ConsumerState<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  final _repo = ConteudoRepository();
  final _votoRepo = VotoRepository();
  final _subscricaoRepo = SubscricaoRepository();
  late Future<Conteudo> _future;
  int? _scoreOverride;
  bool _isSubscribing = false;
  bool? _subscrito;

  @override
  void initState() {
    super.initState();
    _future = _repo.obter(widget.articleId);
  }

  Future<void> _votar(String tipoVoto) async {
    if (!requireAuth(context, ref, message: 'Cria uma conta para poderes votar neste conteúdo.')) return;
    try {
      final resultado = await _votoRepo.votar(
        entidadeId: widget.articleId,
        tipoEntidade: TipoEntidadeVoto.conteudo,
        tipoVoto: tipoVoto,
      );
      setState(() => _scoreOverride = resultado.score);
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  Future<void> _seguir() async {
    if (!requireAuth(context, ref, message: 'Cria uma conta para poderes seguir este conteúdo.')) return;
    setState(() => _isSubscribing = true);
    try {
      final sub = await _subscricaoRepo.subscrever(conteudoId: widget.articleId);
      setState(() {
        _subscrito = sub.ativo;
        _isSubscribing = false;
      });
    } on ApiException catch (e) {
      setState(() => _isSubscribing = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Conteúdo'),
      body: FutureBuilder<Conteudo>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary));
          }
          if (snapshot.hasError) {
            final message =
                snapshot.error is ApiException ? (snapshot.error as ApiException).mensagem : 'Conteúdo não encontrado.';
            return Center(child: Text(message, style: AppTextStyles.body, textAlign: TextAlign.center));
          }
          final conteudo = snapshot.data!;
          final hasImage = conteudo.urlMidia != null && conteudo.urlMidia!.isNotEmpty;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(conteudo.categoria, style: AppTextStyles.eyebrow),
                const SizedBox(height: 10),
                Text(conteudo.titulo, style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.label_outline, size: 14, color: AppColors.greySoft2),
                    const SizedBox(width: 4),
                    Text(conteudo.tipo, style: AppTextStyles.bodyMuted),
                  ],
                ),
                const SizedBox(height: 20),
                if (hasImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        conteudo.urlMidia!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: AppColors.wineCard),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (conteudo.descricao != null && conteudo.descricao!.isNotEmpty) ...[
                  Text(conteudo.descricao!, style: AppTextStyles.bodyMuted),
                  const SizedBox(height: 14),
                ],
                if (conteudo.corpoTexto != null && conteudo.corpoTexto!.isNotEmpty)
                  Text(conteudo.corpoTexto!, style: AppTextStyles.body),
                const SizedBox(height: 24),
                Row(
                  children: [
                    IconButton(onPressed: () => _votar(TipoVoto.up), icon: const Icon(Icons.thumb_up_outlined, color: AppColors.goldAccent)),
                    Text('${_scoreOverride ?? 0}', style: AppTextStyles.body),
                    IconButton(onPressed: () => _votar(TipoVoto.down), icon: const Icon(Icons.thumb_down_outlined, color: AppColors.greySoft2)),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _isSubscribing ? null : _seguir,
                      icon: Icon(_subscrito == true ? Icons.notifications_active : Icons.notifications_none, color: AppColors.goldAccent),
                      label: Text(_subscrito == true ? 'A Seguir' : 'Seguir', style: AppTextStyles.bodyMuted.copyWith(color: AppColors.goldAccent)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
