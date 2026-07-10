import "../core/network/api_client.dart";
import "../models/subscricao.dart";

/// POST /api/subscricoes e GET /api/subscricoes/minhas exigem INSCRITO+.
class SubscricaoRepository {
  final ApiClient _api;
  SubscricaoRepository([ApiClient? api]) : _api = api ?? apiClient;

  Future<Subscricao> subscrever({String? conteudoId, String? forumId}) async {
    final json = await _api.post("/api/subscricoes", body: {
      "conteudoId": conteudoId,
      "forumId": forumId,
    }) as Map<String, dynamic>;
    return Subscricao.fromJson(json);
  }

  Future<List<Subscricao>> minhas() async {
    final json = await _api.get("/api/subscricoes/minhas") as List<dynamic>;
    return json.map((e) => Subscricao.fromJson(e as Map<String, dynamic>)).toList();
  }
}
