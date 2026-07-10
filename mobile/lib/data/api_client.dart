import 'dart:convert';
import 'package:http/http.dart' as http;

/// Endereço do backend Spring Boot.
/// Emulador Android → 10.0.2.2 aponta para o localhost do PC.
/// Dispositivo físico → substitui pelo IP da tua máquina na rede local.
const String _kBase = 'http://10.216.153.56:8080';// http://10.42.0.1:8080

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  String? _token;

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;
  bool get hasToken => _token != null;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json; charset=utf-8',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // ── GET ─────────────────────────────────────────────────
  Future<dynamic> get(String path) async {
    final res = await http.get(Uri.parse('$_kBase$path'), headers: _headers);
    return _handle(res);
  }

  // ── POST ────────────────────────────────────────────────
  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$_kBase$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handle(res);
  }

  // ── PATCH ───────────────────────────────────────────────
  Future<dynamic> patch(String path, [Map<String, dynamic>? body]) async {
    final res = await http.patch(
      Uri.parse('$_kBase$path'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handle(res);
  }

  // ── Handler ─────────────────────────────────────────────
  dynamic _handle(http.Response res) {
    final decoded = jsonDecode(utf8.decode(res.bodyBytes));
    if (res.statusCode >= 200 && res.statusCode < 300) return decoded;
    final msg = decoded is Map ? (decoded['mensagem'] ?? 'Erro ${res.statusCode}') : 'Erro ${res.statusCode}';
    throw ApiException(msg.toString(), res.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  const ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
