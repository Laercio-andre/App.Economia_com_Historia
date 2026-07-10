import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_guard.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/forum_repository.dart';
import '../../models/forum_info.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/primary_button.dart';

class ForumScreen extends ConsumerStatefulWidget {
  const ForumScreen({super.key});

  @override
  ConsumerState<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends ConsumerState<ForumScreen> {
  final _repo = ForumRepository();
  late Future<List<ForumInfo>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.listar();
  }

  Future<void> _reload() async {
    setState(() => _future = _repo.listar());
    await _future;
  }

  void _showNovoForumSheet() {
    if (!requireAuth(context, ref, message: 'Cria uma conta para poderes criar fóruns.')) return;

    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();
    final limiteController = TextEditingController(text: '20');
    bool privado = false;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.wineDeep,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Novo Fórum', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  AppTextField(label: 'Nome', hint: 'ex: Debate sobre Câmbio', icon: Icons.forum_outlined, controller: nomeController),
                  const SizedBox(height: 14),
                  AppTextField(label: 'Descrição', hint: 'do que trata este fórum', icon: Icons.notes_outlined, controller: descricaoController),
                  const SizedBox(height: 14),
                  AppTextField(label: 'Limite de membros', hint: '20', icon: Icons.group_outlined, controller: limiteController, keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Switch(
                        value: privado,
                        activeColor: AppColors.goldPrimary,
                        onChanged: (v) => setSheetState(() => privado = v),
                      ),
                      Text('Fórum privado (só por convite)', style: AppTextStyles.bodyMuted),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Criar Fórum',
                    showArrow: false,
                    isLoading: isSaving,
                    onPressed: () async {
                      if (nomeController.text.trim().isEmpty) return;
                      setSheetState(() => isSaving = true);
                      try {
                        await _repo.criar(
                          nome: nomeController.text.trim(),
                          descricao: descricaoController.text.trim(),
                          privado: privado,
                          limiteUtilizadores: int.tryParse(limiteController.text.trim()),
                        );
                        if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                        await _reload();
                      } on ApiException catch (e) {
                        setSheetState(() => isSaving = false);
                        if (sheetContext.mounted) {
                          ScaffoldMessenger.of(sheetContext).showSnackBar(SnackBar(content: Text(e.mensagem)));
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.wineDarkest,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Fóruns', style: AppTextStyles.h2.copyWith(fontSize: 22)),
                  IconButton(
                    onPressed: () => context.push('/notificacoes'),
                    icon: const Icon(Icons.notifications_none, color: AppColors.goldLight),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _reload,
                color: AppColors.goldPrimary,
                backgroundColor: AppColors.wineDeep,
                child: FutureBuilder<List<ForumInfo>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary));
                    }
                    if (snapshot.hasError) {
                      final message = snapshot.error is ApiException
                          ? (snapshot.error as ApiException).mensagem
                          : 'Não foi possível carregar os fóruns.';
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

                    final foruns = snapshot.data ?? [];
                    if (foruns.isEmpty) {
                      return ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          const SizedBox(height: 60),
                          const Icon(Icons.forum_outlined, color: AppColors.greySoft2, size: 40),
                          const SizedBox(height: 12),
                          Text('Ainda não há fóruns. Sê o primeiro a criar um!', style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                        ],
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
                      itemCount: foruns.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final forum = foruns[index];
                        return AppCard(
                          onTap: () => context.push('/forum/${forum.id}'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(forum.nome, style: AppTextStyles.body.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w700)),
                                  ),
                                  if (forum.privado)
                                    const Icon(Icons.lock_outline, size: 16, color: AppColors.greySoft2)
                                  else
                                    const Icon(Icons.public, size: 16, color: AppColors.greySoft2),
                                ],
                              ),
                              if (forum.descricao != null && forum.descricao!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(forum.descricao!, style: AppTextStyles.bodyMuted, maxLines: 2, overflow: TextOverflow.ellipsis),
                              ],
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.group_outlined, size: 14, color: AppColors.goldAccent),
                                  const SizedBox(width: 4),
                                  Text('até ${forum.limiteUtilizadores} membros', style: AppTextStyles.label),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                backgroundColor: AppColors.goldPrimary,
                foregroundColor: AppColors.backgroundBlack,
                onPressed: _showNovoForumSheet,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
