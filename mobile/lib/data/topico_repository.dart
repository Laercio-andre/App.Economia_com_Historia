import "../core/network/api_client.dart";
import "../models/topico.dart";

/// Ver TopicoController.java. Listar/obter são públicos para fóruns
/// públicos; criar exige INSCRITO+.
class TopicoRepository {
  final ApiClient _api;
  TopicoRepository([ApiClient? api]) : _api = api ?? apiClient;

  Future<List<Topico>> listarPorForum(String forumId) async {
    final json = await _api.get("/api/foruns/$forumId/topicos") as List<dynamic>;
    return json.map((e) => Topico.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Topico> obter(String id) async {
    final json = await _api.get("/api/topicos/$id") as Map<String, dynamic>;
    return Topico.fromJson(json);
  }

  Future<Topico> criar({required String forumId, required String titulo, required String conteudo}) async {
    final json = await _api.post("/api/topicos", body: {
      "forumId": forumId,
      "titulo": titulo,
      "conteudo": conteudo,
    }) as Map<String, dynamic>;
    return Topico.fromJson(json);
  }
}

/// Ver ComentarioController.java.
class ComentarioRepository {
  final ApiClient _api;
  ComentarioRepository([ApiClient? api]) : _api = api ?? apiClient;

  Future<List<Comentario>> arvore(String topicoId) async {
    final json = await _api.get("/api/topicos/$topicoId/comentarios/arvore") as List<dynamic>;
    return json.map((e) => Comentario.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Comentario> criar(String topicoId, {required String texto, String? comentarioPaiId}) async {
    final json = await _api.post("/api/topicos/$topicoId/comentarios", body: {
      "texto": texto,
      "comentarioPaiId": comentarioPaiId,
    }) as Map<String, dynamic>;
    return Comentario.fromJson(json);
  }

  Future<void> apagar(String id) async {
    await _api.delete("/api/comentarios/$id");
  }
}
