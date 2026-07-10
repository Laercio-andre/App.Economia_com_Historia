import "../core/network/api_client.dart";
import "../models/ranking_entry.dart";

/// Rotas públicas (ver SecurityConfig: GET /api/rankings/** é permitAll).
/// Cada resultado é a soma de pontos de todos os utilizadores agrupados por
/// região ou instituição — não é um ranking pessoa a pessoa.
class RankingRepository {
  final ApiClient _api;
  RankingRepository([ApiClient? api]) : _api = api ?? apiClient;

  Future<List<RankingEntry>> fetchPorRegiao() async {
    final json = await _api.get("/api/rankings/regioes") as List<dynamic>;
    return json.map((e) => RankingEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<RankingEntry>> fetchPorInstituicao() async {
    final json = await _api.get("/api/rankings/instituicoes") as List<dynamic>;
    return json.map((e) => RankingEntry.fromJson(e as Map<String, dynamic>)).toList();
  }
}
