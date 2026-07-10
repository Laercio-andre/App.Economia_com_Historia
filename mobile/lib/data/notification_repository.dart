import "../core/network/api_client.dart";
import "../models/app_notification.dart";

/// Rotas: GET /api/notificacoes e PATCH /api/notificacoes/{id}/lida.
/// Ambas exigem autenticação (ver mappings_sistema.txt, secção 13).
class NotificationRepository {
  final ApiClient _api;
  NotificationRepository([ApiClient? api]) : _api = api ?? apiClient;

  Future<List<AppNotification>> fetchAll() async {
    final json = await _api.get("/api/notificacoes") as List<dynamic>;
    return json.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AppNotification> markAsRead(String id) async {
    final json = await _api.patch("/api/notificacoes/$id/lida") as Map<String, dynamic>;
    return AppNotification.fromJson(json);
  }
}
