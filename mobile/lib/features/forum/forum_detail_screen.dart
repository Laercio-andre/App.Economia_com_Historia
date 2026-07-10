import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_guard.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/forum_repository.dart';
import '../../data/quiz_sala_repository.dart';
import '../../data/topico_repository.dart';
import '../../models/forum_info.dart';
import '../../models/sala_quiz.dart';
import '../../models/topico.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/outline_button_widget.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/simple_back_app_bar.dart';
import '../quiz/sala_quiz_screen.dart';

class ForumDetailScreen extends ConsumerStatefulWidget {
  final String forumId;
  const ForumDetailScreen({super.key, required this.forumId});

  @override
  ConsumerState<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends ConsumerState<ForumDetailScreen> {
  final _repo = ForumRepository();
  final _quizRepo = QuizSalaRepository();
  final _topicoRepo = TopicoRepository();
  late Future<ForumInfo> _future;
  late Future<List<Topico>> _topicosFuture;
  late Future<List<SalaQuiz>> _salasFuture;

  @override
  void initState() {
    super.initState();
    _future = _repo.obter(widget.forumId);
    _topicosFuture = _topicoRepo.listarPorForum(widget.forumId);
    _salasFuture = _carregarSalas();
  }

  /// GET /api/quiz/salas lista TODAS as salas (sem filtro por fórum
  /// documentado), por isso filtramos aqui pelo forumId.
  Future<List<SalaQuiz>> _carregarSalas() async {
    final todas = await _quizRepo.listar();
    return todas.where((s) => s.forumId == widget.forumId).toList();
  }

  Future<void> _reloadSalas() async {
    setState(() => _salasFuture = _carregarSalas());
    await _salasFuture;
  }

  Future<void> _reloadTopicos() async {
    setState(() => _topicosFuture = _topicoRepo.listarPorForum(widget.forumId));
    await _topicosFuture;
  }

  void _showNovoTopicoSheet() {
    if (!requireAuth(context, ref, message: 'Cria uma conta para poderes criar tópicos.')) return;
    final tituloController = TextEditingController();
    final conteudoController = TextEditingController();
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
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Novo Tópico', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  AppTextField(label: 'Título', hint: 'do que se trata?', icon: Icons.title, controller: tituloController),
                  const SizedBox(height: 14),
                  AppTextField(label: 'Conteúdo', hint: 'desenvolve a tua ideia…', icon: Icons.notes_outlined, controller: conteudoController),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Publicar',
                    showArrow: false,
                    isLoading: isSaving,
                    onPressed: () async {
                      if (tituloController.text.trim().isEmpty || conteudoController.text.trim().isEmpty) return;
                      setSheetState(() => isSaving = true);
                      try {
                        await _topicoRepo.criar(
                          forumId: widget.forumId,
                          titulo: tituloController.text.trim(),
                          conteudo: conteudoController.text.trim(),
                        );
                        if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                        await _reloadTopicos();
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

  Future<void> _criarSalaQuiz(ForumInfo forum) async {
    if (!requireAuth(context, ref, message: 'Cria uma conta para poderes criar uma sala de quiz.')) return;
    try {
      final sala = await _quizRepo.criar(forumId: forum.id, tempoLimiteMs: 15000, pontosBase: 100, limiteUtilizadores: forum.limiteUtilizadores);
      await _reloadSalas();
      if (mounted) Navigator.of(context).push(MaterialPageRoute(builder: (_) => SalaQuizScreen(salaInicial: sala)));
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  Future<void> _entrarSalaQuiz() async {
    // ROTAS E CONFIGURACAO: POST /api/quiz/salas/{id}/entrar é pública —
    // um convidado pode entrar (mas reentrar reinicia a pontuação dele).
    final controller = TextEditingController();
    final salaId = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.wineDeep,
        title: Text('Entrar numa Sala', style: AppTextStyles.h3),
        content: AppTextField(label: 'ID da Sala', hint: 'cole o ID partilhado', icon: Icons.tag, controller: controller),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
          TextButton(onPressed: () => context.pop(controller.text.trim()), child: const Text('Entrar')),
        ],
      ),
    );
    if (salaId == null || salaId.isEmpty) return;
    try {
      final sala = await _quizRepo.entrar(salaId);
      if (mounted) Navigator.of(context).push(MaterialPageRoute(builder: (_) => SalaQuizScreen(salaInicial: sala)));
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Fórum'),
      body: FutureBuilder<ForumInfo>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary));
          }
          if (snapshot.hasError) {
            final message = snapshot.error is ApiException
                ? (snapshot.error as ApiException).mensagem
                : 'Não foi possível carregar este fórum.';
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(child: Text(message, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center)),
            );
          }

          final forum = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(child: Text(forum.nome, style: AppTextStyles.h2.copyWith(fontSize: 22))),
                  Icon(forum.privado ? Icons.lock_outline : Icons.public, color: AppColors.greySoft2, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              if (forum.descricao != null && forum.descricao!.isNotEmpty)
                Text(forum.descricao!, style: AppTextStyles.bodyMuted),
              const SizedBox(height: 20),
              _InfoRow(icon: Icons.group_outlined, label: 'Limite de membros', value: '${forum.limiteUtilizadores}'),
              const SizedBox(height: 12),
              _InfoRow(icon: forum.privado ? Icons.lock_outline : Icons.public, label: 'Visibilidade', value: forum.privado ? 'Privado' : 'Público'),
              if (forum.dataCriacao != null) ...[
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.event_outlined, label: 'Criado em', value: _formatDate(forum.dataCriacao!)),
              ],
              const SizedBox(height: 28),
              Text('Quiz ao Vivo', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              PrimaryButton(label: 'Criar Sala de Quiz', showArrow: false, onPressed: () => _criarSalaQuiz(forum)),
              const SizedBox(height: 10),
              AppOutlineButton(label: 'Entrar com ID', onPressed: _entrarSalaQuiz),
              const SizedBox(height: 16),
              FutureBuilder<List<SalaQuiz>>(
                future: _salasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator(color: AppColors.goldPrimary)),
                    );
                  }
                  final salas = snapshot.data ?? [];
                  if (salas.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Salas abertas', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                      const SizedBox(height: 8),
                      ...salas.map((sala) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: AppCard(
                              onTap: () async {
                                try {
                                  final salaAtualizada = await _quizRepo.entrar(sala.id);
                                  if (mounted) {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SalaQuizScreen(salaInicial: salaAtualizada)));
                                  }
                                } on ApiException catch (e) {
                                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    sala.estado == EstadoSalaQuiz.aguardando ? Icons.hourglass_empty : Icons.play_circle_outline,
                                    color: AppColors.goldAccent,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(sala.estado.label, style: AppTextStyles.body.copyWith(color: AppColors.textWhite))),
                                  Text('${sala.pontosBase} pts base', style: AppTextStyles.bodyMuted),
                                ],
                              ),
                            ),
                          )),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tópicos', style: AppTextStyles.h3),
                  TextButton(
                    onPressed: _showNovoTopicoSheet,
                    child: Text('+ Novo Tópico', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Topico>>(
                future: _topicosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator(color: AppColors.goldPrimary)),
                    );
                  }
                  if (snapshot.hasError) {
                    final message = snapshot.error is ApiException
                        ? (snapshot.error as ApiException).mensagem
                        : 'Não foi possível carregar os tópicos.';
                    return Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(message, style: AppTextStyles.bodyMuted));
                  }
                  final topicos = snapshot.data ?? [];
                  if (topicos.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text('Ainda não há tópicos. Começa a conversa!', style: AppTextStyles.bodyMuted),
                    );
                  }
                  return Column(
                    children: topicos
                        .map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AppCard(
                                onTap: () => context.push('/topico/${t.id}'),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.titulo, style: AppTextStyles.body.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    Text(t.conteudo, style: AppTextStyles.bodyMuted, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8),
                                    Text('${t.score} pontos', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.goldAccent, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: AppTextStyles.bodyMuted)),
        Text(value, style: AppTextStyles.body.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
