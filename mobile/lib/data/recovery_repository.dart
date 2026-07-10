import "../core/network/api_client.dart";

/// Rotas públicas (SecurityConfig: /api/recuperacao/** é permitAll).
/// Fluxo em 3 passos: solicitar (envia OTP por email) -> validar (confirma
/// o código) -> redefinir-senha (troca a senha, reenviando o mesmo código).
class RecoveryRepository {
  final ApiClient _api;
  RecoveryRepository([ApiClient? api]) : _api = api ?? apiClient;

  Future<String> solicitar(String email) async {
    final json = await _api.post("/api/recuperacao/solicitar", body: {"email": email}) as Map<String, dynamic>;
    return json["mensagem"] as String? ?? "Código enviado por email.";
  }

  Future<String> validar(String email, String codigo) async {
    final json = await _api.post("/api/recuperacao/validar", body: {
      "email": email,
      "codigo": codigo,
    }) as Map<String, dynamic>;
    return json["mensagem"] as String? ?? "Código validado.";
  }

  Future<String> redefinirSenha(String email, String codigo, String novaSenha) async {
    final json = await _api.post("/api/recuperacao/redefinir-senha", body: {
      "email": email,
      "codigo": codigo,
      "novaSenha": novaSenha,
    }) as Map<String, dynamic>;
    return json["mensagem"] as String? ?? "Senha redefinida.";
  }
}
