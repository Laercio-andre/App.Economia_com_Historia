import "dart:async";
import "dart:convert";
import "package:web_socket_channel/web_socket_channel.dart";
import "api_client.dart";

/// Cliente STOMP minimalista, feito à mão (sem depender de nenhum pacote
/// STOMP externo) para falar com o WebSocketConfig.java do backend.
///
/// O backend regista o endpoint SockJS em "/ws" com `.withSockJS()`. Em vez
/// de implementar o protocolo SockJS completo, ligamos diretamente ao
/// transporte WebSocket puro que o SockJS do Spring expõe em "/ws/websocket"
/// — funciona porque falamos STOMP "puro" sobre esse WebSocket, tal como o
/// SockJS faria por baixo. O token vai na query string (?token=...) porque é
/// assim que o JwtHandshakeInterceptor.java o extrai.
class QuizStompClient {
  WebSocketChannel? _channel;
  final _messagesController = StreamController<_StompFrame>.broadcast();
  final Map<String, String> _subscriptions = {}; // destination -> subscriptionId
  int _subCounter = 0;
  bool _connected = false;

  /// Constrói o URL do WebSocket a partir do baseUrl HTTP configurado
  /// (troca http/https por ws/wss e aponta para /ws/websocket).
  static Uri _wsUri(String token) {
    final httpUri = Uri.parse(ApiConfig.baseUrl);
    final scheme = httpUri.scheme == "https" ? "wss" : "ws";
    return Uri(scheme: scheme, host: httpUri.host, port: httpUri.port, path: "/ws/websocket", queryParameters: {"token": token});
  }

  Future<void> connect(String token) async {
    final uri = _wsUri(token);
    _channel = WebSocketChannel.connect(uri);
    _channel!.stream.listen(_onData, onError: (_) => _connected = false, onDone: () => _connected = false);

    _send(_StompFrame("CONNECT", {"accept-version": "1.1,1.2", "heart-beat": "10000,10000"}));

    // Espera o CONNECTED antes de aceitar subscribes/sends.
    await _messagesController.stream.firstWhere((f) => f.command == "CONNECTED").timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw ApiException(statusCode: 0, codigo: "WS_TIMEOUT", mensagem: "Não foi possível ligar ao servidor em tempo real."),
        );
    _connected = true;
  }

  bool get isConnected => _connected;

  /// Subscreve um destino e devolve um Stream com o corpo (já decodificado
  /// de JSON) de cada mensagem recebida nesse destino.
  Stream<dynamic> subscribe(String destination) {
    final id = _subscriptions.putIfAbsent(destination, () {
      final subId = "sub-${_subCounter++}";
      _send(_StompFrame("SUBSCRIBE", {"id": subId, "destination": destination}));
      return subId;
    });

    return _messagesController.stream
        .where((f) => f.command == "MESSAGE" && f.headers["subscription"] == id)
        .map((f) => f.body.isEmpty ? null : jsonDecode(f.body));
  }

  void sendJson(String destination, Object body) {
    _send(_StompFrame("SEND", {"destination": destination, "content-type": "application/json"}, jsonEncode(body)));
  }

  void _send(_StompFrame frame) {
    _channel?.sink.add(frame.encode());
  }

  void _onData(dynamic data) {
    final text = data is String ? data : utf8.decode(data as List<int>);
    for (final raw in text.split("\x00")) {
      final trimmed = raw.replaceAll("\r\n", "\n").trim();
      if (trimmed.isEmpty) continue;
      _messagesController.add(_StompFrame.parse(trimmed));
    }
  }

  Future<void> disconnect() async {
    try {
      _send(_StompFrame("DISCONNECT", {}));
    } catch (_) {}
    _connected = false;
    await _channel?.sink.close();
  }

  void dispose() {
    _messagesController.close();
  }
}

class _StompFrame {
  final String command;
  final Map<String, String> headers;
  final String body;

  _StompFrame(this.command, this.headers, [this.body = ""]);

  String encode() {
    final buffer = StringBuffer()..writeln(command);
    headers.forEach((key, value) => buffer.writeln("$key:$value"));
    buffer.writeln();
    buffer.write(body);
    buffer.write("\x00");
    return buffer.toString();
  }

  factory _StompFrame.parse(String raw) {
    final lines = raw.split("\n");
    final command = lines.first.trim();
    final headers = <String, String>{};
    var i = 1;
    for (; i < lines.length; i++) {
      final line = lines[i];
      if (line.isEmpty) {
        i++;
        break;
      }
      final sepIndex = line.indexOf(":");
      if (sepIndex == -1) continue;
      headers[line.substring(0, sepIndex)] = line.substring(sepIndex + 1);
    }
    final body = lines.length > i ? lines.sublist(i).join("\n") : "";
    return _StompFrame(command, headers, body);
  }
}
