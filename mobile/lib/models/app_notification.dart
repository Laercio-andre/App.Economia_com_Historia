class AppNotification {
  final String id;
  final String destinatarioId;
  final String? remetenteId;
  final String tipoEvento;
  final String mensagem;
  final String? entidadeAlvoId;
  final bool lida;
  final String dataCriacao;

  const AppNotification({
    required this.id,
    required this.destinatarioId,
    this.remetenteId,
    required this.tipoEvento,
    required this.mensagem,
    this.entidadeAlvoId,
    required this.lida,
    required this.dataCriacao,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json["id"] as String,
      destinatarioId: json["destinatarioId"] as String? ?? "",
      remetenteId: json["remetenteId"] as String?,
      tipoEvento: json["tipoEvento"] as String? ?? "",
      mensagem: json["mensagem"] as String? ?? "",
      entidadeAlvoId: json["entidadeAlvoId"] as String?,
      lida: json["lida"] as bool? ?? false,
      dataCriacao: json["dataCriacao"] as String? ?? "",
    );
  }

  AppNotification copyWith({bool? lida}) {
    return AppNotification(
      id: id,
      destinatarioId: destinatarioId,
      remetenteId: remetenteId,
      tipoEvento: tipoEvento,
      mensagem: mensagem,
      entidadeAlvoId: entidadeAlvoId,
      lida: lida ?? this.lida,
      dataCriacao: dataCriacao,
    );
  }
}
