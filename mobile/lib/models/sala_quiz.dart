/// Espelha EstadoSalaQuiz.java.
enum EstadoSalaQuiz {
  aguardando,
  emAndamento,
  finalizada;

  static EstadoSalaQuiz fromJson(String? value) {
    switch (value) {
      case "EM_ANDAMENTO":
        return EstadoSalaQuiz.emAndamento;
      case "FINALIZADA":
        return EstadoSalaQuiz.finalizada;
      case "AGUARDANDO":
      default:
        return EstadoSalaQuiz.aguardando;
    }
  }

  String get label {
    switch (this) {
      case EstadoSalaQuiz.emAndamento:
        return "Em andamento";
      case EstadoSalaQuiz.finalizada:
        return "Finalizada";
      case EstadoSalaQuiz.aguardando:
        return "Aguardando";
    }
  }
}

/// Espelha SalaQuizResponse.java.
class SalaQuiz {
  final String id;
  final String forumId;
  final String? conteudoId;
  final int limiteUtilizadores;
  final int tempoLimiteMs;
  final int pontosBase;
  final EstadoSalaQuiz estado;

  const SalaQuiz({
    required this.id,
    required this.forumId,
    this.conteudoId,
    required this.limiteUtilizadores,
    required this.tempoLimiteMs,
    required this.pontosBase,
    required this.estado,
  });

  factory SalaQuiz.fromJson(Map<String, dynamic> json) {
    return SalaQuiz(
      id: json["id"] as String,
      forumId: json["forumId"] as String? ?? "",
      conteudoId: json["conteudoId"] as String?,
      limiteUtilizadores: (json["limiteUtilizadores"] as num?)?.toInt() ?? 1,
      tempoLimiteMs: (json["tempoLimiteMs"] as num?)?.toInt() ?? 10000,
      pontosBase: (json["pontosBase"] as num?)?.toInt() ?? 100,
      estado: EstadoSalaQuiz.fromJson(json["estado"] as String?),
    );
  }
}

/// Espelha PerguntaQuizPayload.java (versão pública, sem a resposta certa).
class PerguntaQuiz {
  final String id;
  final String salaId;
  final String enunciado;
  final List<String> alternativas;
  final int ordem;
  final int tempoLimiteMs;

  const PerguntaQuiz({
    required this.id,
    required this.salaId,
    required this.enunciado,
    required this.alternativas,
    required this.ordem,
    required this.tempoLimiteMs,
  });

  factory PerguntaQuiz.fromJson(Map<String, dynamic> json) {
    return PerguntaQuiz(
      id: json["id"] as String,
      salaId: json["salaId"] as String? ?? "",
      enunciado: json["enunciado"] as String? ?? "",
      alternativas: (json["alternativas"] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      ordem: (json["ordem"] as num?)?.toInt() ?? 0,
      tempoLimiteMs: (json["tempoLimiteMs"] as num?)?.toInt() ?? 10000,
    );
  }
}

/// Espelha ResultadoRespostaPayload.java, recebido via WebSocket depois de responder.
class ResultadoResposta {
  final String perguntaId;
  final bool correta;
  final int pontos;
  final int pontuacaoAcumulada;

  const ResultadoResposta({
    required this.perguntaId,
    required this.correta,
    required this.pontos,
    required this.pontuacaoAcumulada,
  });

  factory ResultadoResposta.fromJson(Map<String, dynamic> json) {
    return ResultadoResposta(
      perguntaId: json["perguntaId"] as String? ?? "",
      correta: json["correta"] as bool? ?? false,
      pontos: (json["pontos"] as num?)?.toInt() ?? 0,
      pontuacaoAcumulada: (json["pontuacaoAcumulada"] as num?)?.toInt() ?? 0,
    );
  }
}

/// Espelha RankingSalaResponse.java.
class RankingSalaEntry {
  final String utilizadorId;
  final int pontuacao;

  const RankingSalaEntry({required this.utilizadorId, required this.pontuacao});

  factory RankingSalaEntry.fromJson(Map<String, dynamic> json) {
    return RankingSalaEntry(
      utilizadorId: json["utilizadorId"] as String? ?? "",
      pontuacao: (json["pontuacao"] as num?)?.toInt() ?? 0,
    );
  }
}
