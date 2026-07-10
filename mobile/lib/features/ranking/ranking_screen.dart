import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/auth_repository.dart';
import '../../data/ranking_repository.dart';
import '../../models/ranking_entry.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

/// O backend agrega pontos por região/instituição (ver RankingServiceImpl),
/// não é um ranking pessoa a pessoa. Por isso mostramos o total de cada
/// grupo, destacando o grupo a que o utilizador autenticado pertence.
class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> with SingleTickerProviderStateMixin {
  final _repo = RankingRepository();
  late final TabController _tabController;
  late Future<List<RankingEntry>> _regioesFuture;
  late Future<List<RankingEntry>> _instituicoesFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _regioesFuture = _repo.fetchPorRegiao();
    _instituicoesFuture = _repo.fetchPorInstituicao();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _regioesFuture = _repo.fetchPorRegiao();
      _instituicoesFuture = _repo.fetchPorInstituicao();
    });
    await Future.wait([_regioesFuture, _instituicoesFuture]);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: SimpleBackAppBar(
        title: 'Ranking',
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.goldPrimary,
          labelColor: AppColors.goldPrimary,
          unselectedLabelColor: AppColors.greySoft2,
          tabs: const [Tab(text: 'REGIÕES'), Tab(text: 'INSTITUIÇÕES')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RankingList(
            future: _regioesFuture,
            highlight: user != null && !user.isGuest ? user.regiao : null,
            onRefresh: _reload,
          ),
          _RankingList(
            future: _instituicoesFuture,
            highlight: user != null && !user.isGuest ? user.instituicao : null,
            onRefresh: _reload,
          ),
        ],
      ),
    );
  }
}

class _RankingList extends StatelessWidget {
  final Future<List<RankingEntry>> future;
  final String? highlight;
  final Future<void> Function() onRefresh;

  const _RankingList({required this.future, required this.highlight, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.goldPrimary,
      backgroundColor: AppColors.wineDeep,
      child: FutureBuilder<List<RankingEntry>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary));
          }
          if (snapshot.hasError) {
            final message =
                snapshot.error is ApiException ? (snapshot.error as ApiException).mensagem : 'Não foi possível carregar o ranking.';
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.wifi_off, color: AppColors.greySoft2, size: 40),
                const SizedBox(height: 12),
                Text(message, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
              ],
            );
          }

          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 60),
                Text('Ainda não há dados suficientes para este ranking.', style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final position = index + 1;
              final isHighlighted = highlight != null && highlight!.isNotEmpty && entry.chave == highlight;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isHighlighted ? AppColors.wineDeep : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: isHighlighted ? Border.all(color: AppColors.goldPrimary) : null,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text(
                        '$position',
                        style: AppTextStyles.body.copyWith(
                          color: position <= 3 ? AppColors.goldPrimary : AppColors.greySoft2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.chave,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    Text('${entry.pontos} pts', style: AppTextStyles.bodyMuted),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
