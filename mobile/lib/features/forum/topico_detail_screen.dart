import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_guard.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/auth_repository.dart';
import '../../data/topico_repository.dart';
import '../../data/voto_repository.dart';
import '../../models/topico.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

class TopicoDetailScreen extends ConsumerStatefulWidget {
  final String topicoId;
  const TopicoDetailScreen({super.key, required this.topicoId});

  @override
  ConsumerState<TopicoDetailScreen> createState() => _TopicoDetailScreenState();
}

class _TopicoDetailScreenState extends ConsumerState<TopicoDetailScreen> {
  final _topicoRepo = TopicoRepository();
  final _comentarioRepo = ComentarioRepository();
  final _votoRepo = VotoRepository();
  final _respostaController = TextEditingController();

  late Future<Topico> _topicoFuture;
  late Future<List<Comentario>> _comentariosFuture;
  String? _respondendoA;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _topicoFuture = _topicoRepo.obter(widget.topicoId);
    _comentariosFuture = _comentarioRepo.arvore(widget.topicoId);
  }

  Future<void> _reloadComentarios() async {
    setState(() => _comentariosFuture = _comentarioRepo.arvore(widget.topicoId));
    await _comentariosFuture;
  }

  Future<void> _enviarComentario() async {
    // ROTAS E CONFIGURACAO: POST /api/topicos/{id}/comentarios é pública —
    // um convidado (visitante) também pode comentar, por isso não pedimos
    // login aqui.
    if (_respostaController.text.trim().isEmpty) return;
    setState(() => _isSending = true);
    try {
      await _comentarioRepo.criar(widget.topicoId, texto: _respostaController.text.trim(), comentarioPaiId: _respondendoA);
      _respostaController.clear();
      setState(() {
        _respondendoA = null;
        _isSending = false;
      });
      await _reloadComentarios();
    } on ApiException catch (e) {
      setState(() => _isSending = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  Future<void> _votarComentario(Comentario comentario) async {
    if (!requireAuth(context, ref, message: 'Cria uma conta para poderes votar.')) return;
    try {
      await _votoRepo.votar(entidadeId: comentario.id, tipoEntidade: TipoEntidadeVoto.comentario, tipoVoto: TipoVoto.up);
      await _reloadComentarios();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  Future<void> _apagarComentario(Comentario comentario) async {
    try {
      await _comentarioRepo.apagar(comentario.id);
      await _reloadComentarios();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authProvider).user?.id;

    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Tópico'),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _reloadComentarios,
              color: AppColors.goldPrimary,
              backgroundColor: AppColors.wineDeep,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  FutureBuilder<Topico>(
                    future: _topicoFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Center(child: CircularProgressIndicator(color: AppColors.goldPrimary)),
                        );
                      }
                      final topico = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(topico.titulo, style: AppTextStyles.h2.copyWith(fontSize: 20)),
                            const SizedBox(height: 10),
                            Text(topico.conteudo, style: AppTextStyles.body),
                            const SizedBox(height: 10),
                            Text('${topico.score} pontos', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(color: AppColors.wineCard),
                  const SizedBox(height: 10),
                  Text('Comentários', style: AppTextStyles.h3),
                  const SizedBox(height: 12),
                  FutureBuilder<List<Comentario>>(
                    future: _comentariosFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator(color: AppColors.goldPrimary)),
                        );
                      }
                      if (snapshot.hasError) {
                        final message = snapshot.error is ApiException
                            ? (snapshot.error as ApiException).mensagem
                            : 'Não foi possível carregar os comentários.';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(message, style: AppTextStyles.bodyMuted),
                        );
                      }
                      final comentarios = snapshot.data ?? [];
                      if (comentarios.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text('Ainda sem comentários. Sê o primeiro!', style: AppTextStyles.bodyMuted),
                        );
                      }
                      return Column(
                        children: comentarios
                            .map((c) => _ComentarioTile(
                                  comentario: c,
                                  userId: userId,
                                  depth: 0,
                                  onResponder: (id) => setState(() => _respondendoA = id),
                                  onVotar: _votarComentario,
                                  onApagar: _apagarComentario,
                                ))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_respondendoA != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Text('A responder a um comentário', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => setState(() => _respondendoA = null),
                            child: const Icon(Icons.close, size: 16, color: AppColors.greySoft2),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: '',
                          hint: 'Escreve um comentário…',
                          icon: Icons.chat_bubble_outline,
                          controller: _respostaController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 90,
                        child: PrimaryButton(label: 'Enviar', showArrow: false, isLoading: _isSending, onPressed: _enviarComentario),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComentarioTile extends StatelessWidget {
  final Comentario comentario;
  final String? userId;
  final int depth;
  final void Function(String) onResponder;
  final void Function(Comentario) onVotar;
  final void Function(Comentario) onApagar;

  const _ComentarioTile({
    required this.comentario,
    required this.userId,
    required this.depth,
    required this.onResponder,
    required this.onVotar,
    required this.onApagar,
  });

  @override
  Widget build(BuildContext context) {
    final isOwn = userId != null && userId == comentario.autorId;
    return Padding(
      padding: EdgeInsets.only(left: depth * 18, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.wineDeep, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comentario.texto, style: AppTextStyles.body.copyWith(color: AppColors.textWhite)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => onVotar(comentario),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_upward, size: 14, color: AppColors.goldAccent),
                          const SizedBox(width: 4),
                          Text('${comentario.score}', style: AppTextStyles.label),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => onResponder(comentario.id),
                      child: Text('Responder', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                    ),
                    if (isOwn) ...[
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => onApagar(comentario),
                        child: Text('Apagar', style: AppTextStyles.label.copyWith(color: AppColors.greySoft2)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          for (final resposta in comentario.respostas)
            _ComentarioTile(
              comentario: resposta,
              userId: userId,
              depth: depth + 1,
              onResponder: onResponder,
              onVotar: onVotar,
              onApagar: onApagar,
            ),
        ],
      ),
    );
  }
}
