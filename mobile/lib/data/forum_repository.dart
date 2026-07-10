import "../core/network/api_client.dart";
import "../models/forum_info.dart";

/// Ver ForumController.java. GET /api/foruns e GET /api/foruns/{id} são
/// públicos (SecurityConfig permite GET sem autenticação, mas um convidado
/// só vê fóruns não-privados). Criar fórum e gerir membros exige token.
class ForumRepository {
  final ApiClient _api;
  ForumRepository([ApiClient? api]) : _api = api ?? apiClient;

  Future<List<ForumInfo>> listar() async {
    final json = await _api.get("/api/foruns") as List<dynamic>;
    return json.map((e) => ForumInfo.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ForumInfo> obter(String id) async {
    final json = await _api.get("/api/foruns/$id") as Map<String, dynamic>;
    return ForumInfo.fromJson(json);
  }

  Future<ForumInfo> criar({
    required String nome,
    String? descricao,
    bool privado = false,
    int? limiteUtilizadores,
  }) async {
    final json = await _api.post("/api/foruns", body: {
      "nome": nome,
      "descricao": descricao,
      "privado": privado,
      "limiteUtilizadores": limiteUtilizadores,
    }) as Map<String, dynamic>;
    return ForumInfo.fromJson(json);
  }

  /// Requer ser DONO/MODERADOR do fórum (backend valida e devolve 403 se não).
  Future<void> adicionarMembro(String forumId, {required String utilizadorId, String papel = "MEMBRO"}) async {
    await _api.post("/api/foruns/$forumId/membros", body: {
      "utilizadorId": utilizadorId,
      "papel": papel,
    });
  }

  Future<void> removerMembro(String forumId, String membroId) async {
    await _api.delete("/api/foruns/$forumId/membros/$membroId");
  }

  Future<void> alterarPermissaoFala(String forumId, String membroId, {required bool podeFalar, DateTime? suspensoAte}) async {
    await _api.patch("/api/foruns/$forumId/membros/$membroId/fala", body: {
      "podeFalar": podeFalar,
      "suspensoAte": suspensoAte?.toIso8601String(),
    });
  }
}
