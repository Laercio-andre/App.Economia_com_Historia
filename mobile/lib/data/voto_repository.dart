import "../core/network/api_client.dart";

/// TipoEntidadeVoto continua assumido (não recebi o ficheiro do enum, só o
/// nome "TOPICO" confirmado no exemplo do documento de rotas). TipoVoto foi
/// CONFIRMADO no documento "ROTAS E CONFIGURACAO PARA APP MOBILE": usa
/// "UP" (visto no exemplo `{"tipoVoto":"UP"}`); "DOWN" é a suposição
/// simétrica para o downvote.
abstract class TipoEntidadeVoto {
  static const topico = "TOPICO";
  static const comentario = "COMENTARIO";
  static const conteudo = "CONTEUDO";
}

abstract class TipoVoto {
  static const up = "UP";
  static const down = "DOWN";
}

class VotoResultado {
  final String entidadeId;
  final String tipoEntidade;
  final String? votoAtual;
  final int score;

  const VotoResultado({required this.entidadeId, required this.tipoEntidade, this.votoAtual, required this.score});

  factory VotoResultado.fromJson(Map<String, dynamic> json) {
    return VotoResultado(
      entidadeId: json["entidadeId"] as String? ?? "",
      tipoEntidade: json["tipoEntidade"] as String? ?? "",
      votoAtual: json["votoAtual"] as String?,
      score: (json["score"] as num?)?.toInt() ?? 0,
    );
  }
}

/// POST /api/votos — exige INSCRITO+. Votar de novo com o mesmo tipo
/// costuma "des-votar" no backend (padrão comum), mas isso depende da
/// implementação de VotoServiceImpl, que não recebi.
class VotoRepository {
  final ApiClient _api;
  VotoRepository([ApiClient? api]) : _api = api ?? apiClient;

  Future<VotoResultado> votar({required String entidadeId, required String tipoEntidade, required String tipoVoto}) async {
    final json = await _api.post("/api/votos", body: {
      "entidadeId": entidadeId,
      "tipoEntidade": tipoEntidade,
      "tipoVoto": tipoVoto,
    }) as Map<String, dynamic>;
    return VotoResultado.fromJson(json);
  }
}
