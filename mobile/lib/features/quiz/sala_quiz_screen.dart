import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/network/quiz_websocket_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/auth_repository.dart';
import '../../data/quiz_sala_repository.dart';
import '../../models/sala_quiz.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

/// Sala de quiz "ao vivo", ligada a /api/quiz/salas.
///
/// Responder às perguntas usa a rota REST POST /api/quiz/salas/{id}/responder
/// (confirmada no documento "ROTAS E CONFIGURACAO PARA APP MOBILE" — pública,
/// visitante pode responder). O WebSocket STOMP só é usado, quando há sessão
/// autenticada, para receber o ranking da sala em tempo real
/// (/topic/quiz/{salaId}/ranking); para convidados, o ranking é atualizado
/// pedindo-o de novo por REST depois de cada resposta.
///
/// LIMITAÇÃO CONHECIDA: o backend não expõe nenhum evento a dizer "a
/// pergunta atual mudou para todos" — cada participante avança pela lista
/// de perguntas (GET .../perguntas) ao seu próprio ritmo, respondendo uma de
/// cada vez.
class SalaQuizScreen extends ConsumerStatefulWidget {
  final SalaQuiz salaInicial;
  const SalaQuizScreen({super.key, required this.salaInicial});

  @override
  ConsumerState<SalaQuizScreen> createState() => _SalaQuizScreenState();
}

class _SalaQuizScreenState extends ConsumerState<SalaQuizScreen> {
  final _repo = QuizSalaRepository();
  final _stomp = QuizStompClient();

  late SalaQuiz _sala;
  List<PerguntaQuiz> _perguntas = [];
  List<RankingSalaEntry> _ranking = [];
  int _currentIndex = 0;
  String? _selecionada;
  ResultadoResposta? _ultimoResultado;
  bool _isLoading = true;
  String? _erro;
  DateTime? _perguntaMostradaEm;

  StreamSubscription? _rankingSub;

  @override
  void initState() {
    super.initState();
    _sala = widget.salaInicial;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final perguntas = await _repo.perguntas(_sala.id);
      final token = apiClient.token;
      if (token != null) {
        try {
          await _stomp.connect(token);
          _rankingSub = _stomp.subscribe("/topic/quiz/${_sala.id}/ranking").listen((data) {
            if (data == null) return;
            setState(() {
              _ranking = (data as List<dynamic>).map((e) => RankingSalaEntry.fromJson(e as Map<String, dynamic>)).toList();
            });
          });
        } catch (_) {
          // O ranking ao vivo é só um extra; se o WebSocket falhar, a app
          // continua a funcionar via REST (atualizado a cada resposta).
        }
      }
      final rankingInicial = await _repo.ranking(_sala.id);
      setState(() {
        _perguntas = perguntas..sort((a, b) => a.ordem.compareTo(b.ordem));
        _ranking = rankingInicial;
        _isLoading = false;
        _perguntaMostradaEm = DateTime.now();
      });
    } on ApiException catch (e) {
      setState(() {
        _erro = e.mensagem;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _rankingSub?.cancel();
    _stomp.disconnect();
    _stomp.dispose();
    super.dispose();
  }

  Future<void> _iniciarSala() async {
    try {
      final sala = await _repo.iniciar(_sala.id);
      setState(() => _sala = sala);
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  Future<void> _responder(String alternativa) async {
    if (_currentIndex >= _perguntas.length) return;
    final pergunta = _perguntas[_currentIndex];
    final tempoGasto = DateTime.now().difference(_perguntaMostradaEm ?? DateTime.now()).inMilliseconds;

    setState(() => _selecionada = alternativa);
    try {
      final resultado = await _repo.responder(_sala.id, perguntaId: pergunta.id, resposta: alternativa, tempoGastoMs: tempoGasto);
      setState(() => _ultimoResultado = resultado);
      // Atualiza o ranking mesmo sem WebSocket ligado (ex.: convidado sem token).
      final ranking = await _repo.ranking(_sala.id);
      if (mounted) setState(() => _ranking = ranking);
    } on ApiException catch (e) {
      setState(() => _selecionada = null);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  void _proximaPergunta() {
    setState(() {
      _currentIndex++;
      _selecionada = null;
      _ultimoResultado = null;
      _perguntaMostradaEm = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authProvider).user?.id;

    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: SimpleBackAppBar(title: 'Sala · ${_sala.estado.label}'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary))
          : _erro != null
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text(_erro!, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center)),
                )
              : _buildBody(userId),
    );
  }

  Widget _buildBody(String? userId) {
    if (_sala.estado == EstadoSalaQuiz.aguardando) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty, color: AppColors.goldAccent, size: 44),
            const SizedBox(height: 16),
            Text('À espera do início', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'ID da sala: ${_sala.id}\nPartilha este ID com quem quiseres juntar à sala.',
              style: AppTextStyles.bodyMuted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Iniciar Sala (moderador)', showArrow: false, onPressed: _iniciarSala),
          ],
        ),
      );
    }

    if (_sala.estado == EstadoSalaQuiz.finalizada || _currentIndex >= _perguntas.length) {
      return _buildRanking(userId, finalizada: true);
    }

    final pergunta = _perguntas[_currentIndex];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Pergunta ${_currentIndex + 1} de ${_perguntas.length}', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
        const SizedBox(height: 10),
        Text(pergunta.enunciado, style: AppTextStyles.h3),
        const SizedBox(height: 18),
        for (final alt in pergunta.alternativas)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              color: _selecionada == alt ? AppColors.wineCard : null,
              onTap: _selecionada == null ? () => _responder(alt) : null,
              child: Text(alt, style: AppTextStyles.body.copyWith(color: AppColors.textWhite)),
            ),
          ),
        if (_ultimoResultado != null && _ultimoResultado!.perguntaId == pergunta.id) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _ultimoResultado!.correta ? AppColors.wineDeep : AppColors.wineCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _ultimoResultado!.correta ? AppColors.goldPrimary : AppColors.greySoft2),
            ),
            child: Row(
              children: [
                Icon(_ultimoResultado!.correta ? Icons.check_circle : Icons.cancel, color: _ultimoResultado!.correta ? AppColors.goldPrimary : AppColors.greySoft2),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _ultimoResultado!.correta
                        ? '+${_ultimoResultado!.pontos} pontos · total ${_ultimoResultado!.pontuacaoAcumulada}'
                        : 'Não foi desta vez · total ${_ultimoResultado!.pontuacaoAcumulada}',
                    style: AppTextStyles.body.copyWith(color: AppColors.textWhite),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: _currentIndex + 1 >= _perguntas.length ? 'Ver Resultado Final' : 'Próxima Pergunta',
            showArrow: false,
            onPressed: _proximaPergunta,
          ),
        ],
      ],
    );
  }

  Widget _buildRanking(String? userId, {required bool finalizada}) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (finalizada) ...[
          const Icon(Icons.emoji_events, color: AppColors.goldPrimary, size: 44),
          const SizedBox(height: 12),
          Text('Fim do Quiz', style: AppTextStyles.h2.copyWith(fontSize: 20)),
          const SizedBox(height: 20),
        ],
        Text('Classificação da Sala', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        for (var i = 0; i < _ranking.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: _ranking[i].utilizadorId == userId ? AppColors.wineDeep : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: _ranking[i].utilizadorId == userId ? Border.all(color: AppColors.goldPrimary) : null,
              ),
              child: Row(
                children: [
                  SizedBox(width: 28, child: Text('${i + 1}', style: AppTextStyles.body.copyWith(color: AppColors.goldAccent, fontWeight: FontWeight.w700))),
                  Expanded(
                    child: Text(
                      _ranking[i].utilizadorId == userId ? 'Tu' : _ranking[i].utilizadorId.substring(0, 8),
                      style: AppTextStyles.body.copyWith(color: AppColors.textWhite),
                    ),
                  ),
                  Text('${_ranking[i].pontuacao} pts', style: AppTextStyles.bodyMuted),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
