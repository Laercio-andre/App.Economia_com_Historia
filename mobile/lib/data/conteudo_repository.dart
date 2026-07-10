import "../core/network/api_client.dart";
import "../models/conteudo.dart";

/// GET /api/conteudos e GET /api/conteudos/{id} são públicos. Criar/aprovar
/// exigem papéis CRIADOR/REVISOR/MASTER, que um estudante normal (INSCRITO)
/// não tem — por isso não implementámos criação de conteúdo na app.
class ConteudoRepository {
  final ApiClient _api;
  ConteudoRepository([ApiClient? api]) : _api = api ?? apiClient;

  Future<List<Conteudo>> explorar({String? tipo, String? categoria, String? tag}) async {
    final json = await _api.get("/api/conteudos", query: {
      if (tipo != null) "tipo": tipo,
      if (categoria != null) "categoria": categoria,
      if (tag != null) "tag": tag,
    }) as List<dynamic>;
    return json.map((e) => Conteudo.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Conteudo> obter(String id) async {
    final json = await _api.get("/api/conteudos/$id") as Map<String, dynamic>;
    return Conteudo.fromJson(json);
  }
}
