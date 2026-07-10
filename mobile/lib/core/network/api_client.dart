import "dart:convert";
import "package:http/http.dart" as http;

/// Configuração de rede para o backend "plataforma-aprendizagem".
///
/// O backend corre no PC do André, ligado a um hotspot Wi-Fi criado no
/// próprio PC (interface wlo1, IP 10.42.0.1 — visto em `ifconfig`). O
/// telemóvel liga-se a esse hotspot, por isso o IP correto para o app
/// alcançar o backend é o do PC nessa rede: 10.42.0.1.
///
/// Se um dia o hotspot mudar de IP (ou passares a usar o router de casa em
/// vez do hotspot do PC), corre `ifconfig` (Linux/Mac) ou `ipconfig`
/// (Windows) de novo e atualiza o valor abaixo — é sempre o IP do
/// adaptador Wi-Fi que o telemóvel está a usar para alcançar o PC, nunca
/// `localhost` nem `10.0.2.2` (esse é só para emulador Android).
class ApiConfig {
  ApiConfig._();

  /// Base URL do backend, na rede do hotspot criado pelo PC.
  static const String baseUrl = "http://10.216.153.56:8080";
}

/// Erro estruturado devolvido pelo backend, seguindo o formato
/// ApiErrorResponse descrito em mappings_sistema.txt.
class ApiException implements Exception {
  final int statusCode;
  final String codigo;
  final String mensagem;
  final List<String> detalhes;

  ApiException({
    required this.statusCode,
    required this.codigo,
    required this.mensagem,
    this.detalhes = const [],
  });

  factory ApiException.fromResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiException(
        statusCode: response.statusCode,
        codigo: body["codigo"] as String? ?? "ERRO_DESCONHECIDO",
        mensagem: body["mensagem"] as String? ?? "Ocorreu um erro inesperado.",
        detalhes: (body["detalhes"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      );
    } catch (_) {
      return ApiException(
        statusCode: response.statusCode,
        codigo: "ERRO_DESCONHECIDO",
        mensagem: response.statusCode == 0
            ? "Não foi possível ligar ao servidor. Verifica se o backend está a correr no teu laptop e se o telemóvel está na mesma rede."
            : "Ocorreu um erro (${response.statusCode}).",
      );
    }
  }

  @override
  String toString() => mensagem;
}

/// Cliente HTTP simples para consumir a API REST do backend.
class ApiClient {
  final String baseUrl;
  String? _token;

  ApiClient({this.baseUrl = ApiConfig.baseUrl});

  /// Define o token JWT a usar nas rotas protegidas (Authorization: Bearer ...).
  void setToken(String? token) {
    _token = token;
  }

  /// Token atualmente em uso (necessário para ligar ao WebSocket, que passa
  /// o token na query string em vez de num header).
  String? get token => _token;

  Map<String, String> get _headers {
    final headers = {"Content-Type": "application/json"};
    if (_token != null) headers["Authorization"] = "Bearer $_token";
    return headers;
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final normalized = path.startsWith("/") ? path : "/$path";
    final resolved = Uri.parse("$baseUrl$normalized");
    if (query == null || query.isEmpty) return resolved;
    return resolved.replace(
      queryParameters: {
        ...resolved.queryParameters,
        ...query.map((key, value) => MapEntry(key, value.toString())),
      },
    );
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw ApiException.fromResponse(response);
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await http.get(_uri(path, query), headers: _headers);
      return _decode(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(statusCode: 0, codigo: "SEM_LIGACAO", mensagem: "Não foi possível ligar ao servidor ($baseUrl). Verifica se o backend está a correr.");
    }
  }

  Future<dynamic> post(String path, {Object? body, Map<String, dynamic>? query}) async {
    try {
      final response = await http.post(_uri(path, query), headers: _headers, body: body == null ? null : jsonEncode(body));
      return _decode(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(statusCode: 0, codigo: "SEM_LIGACAO", mensagem: "Não foi possível ligar ao servidor ($baseUrl). Verifica se o backend está a correr.");
    }
  }

  Future<dynamic> patch(String path, {Object? body, Map<String, dynamic>? query}) async {
    try {
      final response = await http.patch(_uri(path, query), headers: _headers, body: body == null ? null : jsonEncode(body));
      return _decode(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(statusCode: 0, codigo: "SEM_LIGACAO", mensagem: "Não foi possível ligar ao servidor ($baseUrl). Verifica se o backend está a correr.");
    }
  }

  Future<dynamic> delete(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await http.delete(_uri(path, query), headers: _headers);
      return _decode(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(statusCode: 0, codigo: "SEM_LIGACAO", mensagem: "Não foi possível ligar ao servidor ($baseUrl). Verifica se o backend está a correr.");
    }
  }
}

/// Instância partilhada por toda a app.
final apiClient = ApiClient();
