import "../core/network/api_client.dart";
import "../models/sala_quiz.dart";

/// Ver QuizController.java (/api/quiz/salas). Criar sala e adicionar
/// perguntas exige ser dono/moderador do fórum (validado no backend);
/// entrar exige INSCRITO+; perguntas e ranking da sala são públicos.
class QuizSalaRepository {
  final ApiClient _api;
  QuizSalaRepository([ApiClient? api]) : _api = api ?? apiClient;

  Future<SalaQuiz> criar({
    required String forumId,
    String? conteudoId,
    int? limiteUtilizadores,
    required int tempoLimiteMs,
    required int pontosBase,
  }) async {
    final json = await _api.post("/api/quiz/salas", body: {
      "forumId": forumId,
      "conteudoId": conteudoId,
      "limiteUtilizadores": limiteUtilizadores,
      "tempoLimiteMs": tempoLimiteMs,
      "pontosBase": pontosBase,
    }) as Map<String, dynamic>;
    return SalaQuiz.fromJson(json);
  }

  Future<PerguntaQuiz> adicionarPergunta(
    String salaId, {
    required String enunciado,
    required List<String> alternativas,
    required String respostaCorreta,
    required int ordem,
  }) async {
    final json = await _api.post("/api/quiz/salas/$salaId/perguntas", body: {
      "enunciado": enunciado,
      "alternativas": alternativas,
      "respostaCorreta": respostaCorreta,
      "ordem": ordem,
    }) as Map<String, dynamic>;
    return PerguntaQuiz.fromJson(json);
  }

  Future<SalaQuiz> entrar(String salaId) async {
    final json = await _api.post("/api/quiz/salas/$salaId/entrar") as Map<String, dynamic>;
    return SalaQuiz.fromJson(json);
  }

  /// CONFIRMADO no documento "ROTAS E CONFIGURACAO PARA APP MOBILE": existe
  /// uma rota REST pública para responder, além do WebSocket. Usamos esta
  /// como caminho principal (mais simples e fiável do que o STOMP escrito à
  /// mão) e o WebSocket só para receber o ranking da sala em tempo real.
  Future<ResultadoResposta> responder(String salaId, {required String perguntaId, required String resposta, required int tempoGastoMs}) async {
    final json = await _api.post("/api/quiz/salas/$salaId/responder", body: {
      "perguntaId": perguntaId,
      "resposta": resposta,
      "tempoGastoMs": tempoGastoMs,
    }) as Map<String, dynamic>;
    return ResultadoResposta.fromJson(json);
  }

  /// GET /api/quiz/salas — lista salas existentes (útil para mostrar salas
  /// abertas em vez de exigir colar um ID às cegas).
  Future<List<SalaQuiz>> listar() async {
    final json = await _api.get("/api/quiz/salas") as List<dynamic>;
    return json.map((e) => SalaQuiz.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SalaQuiz> iniciar(String salaId) async {
    final json = await _api.post("/api/quiz/salas/$salaId/iniciar") as Map<String, dynamic>;
    return SalaQuiz.fromJson(json);
  }

  Future<SalaQuiz> finalizar(String salaId) async {
    final json = await _api.post("/api/quiz/salas/$salaId/finalizar") as Map<String, dynamic>;
    return SalaQuiz.fromJson(json);
  }

  Future<List<PerguntaQuiz>> perguntas(String salaId) async {
    final json = await _api.get("/api/quiz/salas/$salaId/perguntas") as List<dynamic>;
    return json.map((e) => PerguntaQuiz.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<RankingSalaEntry>> ranking(String salaId) async {
    final json = await _api.get("/api/quiz/salas/$salaId/ranking") as List<dynamic>;
    return json.map((e) => RankingSalaEntry.fromJson(e as Map<String, dynamic>)).toList();
  }
}
