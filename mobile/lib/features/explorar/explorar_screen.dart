import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/conteudo_repository.dart';
import '../../models/conteudo.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/filter_chip_widget.dart';

/// `tipo` "TEXTO" é CONFIRMADO no documento de rotas (exemplo de criação de
/// conteúdo). VIDEO/PODCAST continuam por confirmar.
class ExplorarScreen extends StatefulWidget {
  const ExplorarScreen({super.key});

  @override
  State<ExplorarScreen> createState() => _ExplorarScreenState();
}

class _ExplorarScreenState extends State<ExplorarScreen> {
  final _repo = ConteudoRepository();
  String _selected = 'TUDO';
  late Future<List<Conteudo>> _future;

  static const _tabs = ['TUDO', 'ARTIGOS', 'VÍDEOS', 'PODCASTS'];
  static const _tipoPorTab = {'ARTIGOS': 'TEXTO', 'VÍDEOS': 'VIDEO', 'PODCASTS': 'PODCAST'};

  @override
  void initState() {
    super.initState();
    _future = _repo.explorar();
  }

  void _select(String tab) {
    setState(() {
      _selected = tab;
      _future = _repo.explorar(tipo: _tipoPorTab[tab]);
    });
  }

  Future<void> _reload() async {
    setState(() => _future = _repo.explorar(tipo: _tipoPorTab[_selected]));
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.wineDarkest,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.h2,
                        children: [
                          const TextSpan(text: 'Explorar '),
                          TextSpan(text: 'Angola', style: AppTextStyles.h2.copyWith(color: AppColors.goldPrimary)),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/notificacoes'),
                    icon: const Icon(Icons.notifications_none, color: AppColors.goldLight),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                'Uma selecção criteriosa de pesquisas económicas, análises geopolíticas e estratégias de gestão de recursos que definem o cenário angolano.',
                style: AppTextStyles.bodyMuted,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final tab = _tabs[index];
                  return AppFilterChip(label: tab, selected: _selected == tab, onTap: () => _select(tab));
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _reload,
                color: AppColors.goldPrimary,
                backgroundColor: AppColors.wineDeep,
                child: FutureBuilder<List<Conteudo>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary));
                    }
                    if (snapshot.hasError) {
                      final message = snapshot.error is ApiException
                          ? (snapshot.error as ApiException).mensagem
                          : 'Não foi possível carregar o conteúdo.';
                      return ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          const SizedBox(height: 40),
                          Text(message, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                        ],
                      );
                    }
                    final conteudos = snapshot.data ?? [];
                    if (conteudos.isEmpty) {
                      return ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          const SizedBox(height: 40),
                          Center(child: Text('Sem conteúdo nesta categoria.', style: AppTextStyles.bodyMuted)),
                        ],
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: conteudos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => _ConteudoCard(conteudo: conteudos[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConteudoCard extends StatelessWidget {
  final Conteudo conteudo;
  const _ConteudoCard({required this.conteudo});

  @override
  Widget build(BuildContext context) {
    final hasImage = conteudo.urlMidia != null && conteudo.urlMidia!.isNotEmpty;
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push('/artigo/${conteudo.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  conteudo.urlMidia!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.wineCard),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(conteudo.categoria, style: AppTextStyles.eyebrow)),
                    if (conteudo.exclusivo) const Icon(Icons.workspace_premium_outlined, color: AppColors.goldAccent, size: 18),
                  ],
                ),
                const SizedBox(height: 8),
                Text(conteudo.titulo, style: AppTextStyles.h3, maxLines: 2, overflow: TextOverflow.ellipsis),
                if (conteudo.descricao != null && conteudo.descricao!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(conteudo.descricao!, style: AppTextStyles.bodyMuted, maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.label_outline, size: 14, color: AppColors.greySoft2),
                    const SizedBox(width: 4),
                    Text(conteudo.tipo, style: AppTextStyles.bodyMuted),
                    const SizedBox(width: 16),
                    Text('Ler mais →', style: AppTextStyles.body.copyWith(color: AppColors.goldAccent, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
