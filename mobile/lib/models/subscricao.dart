class Subscricao {
  final String id;
  final String? conteudoId;
  final String? forumId;
  final bool ativo;
  final DateTime? dataInicio;

  const Subscricao({required this.id, this.conteudoId, this.forumId, required this.ativo, this.dataInicio});

  factory Subscricao.fromJson(Map<String, dynamic> json) {
    return Subscricao(
      id: json["id"] as String,
      conteudoId: json["conteudoId"] as String?,
      forumId: json["forumId"] as String?,
      ativo: json["ativo"] as bool? ?? true,
      dataInicio: json["dataInicio"] == null ? null : DateTime.tryParse(json["dataInicio"] as String),
    );
  }
}
