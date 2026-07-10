/// Espelha ForumResponse.java. No backend, um "Forum" é uma comunidade/sala
/// com dono e membros (não um post/tópico leve) — é aí que se criam salas de
/// quiz e se juntam membros com papéis (DONO/MODERADOR/MEMBRO).
class ForumInfo {
  final String id;
  final String donoId;
  final String nome;
  final String? descricao;
  final bool privado;
  final int limiteUtilizadores;
  final DateTime? dataCriacao;

  const ForumInfo({
    required this.id,
    required this.donoId,
    required this.nome,
    this.descricao,
    required this.privado,
    required this.limiteUtilizadores,
    this.dataCriacao,
  });

  factory ForumInfo.fromJson(Map<String, dynamic> json) {
    return ForumInfo(
      id: json["id"] as String,
      donoId: json["donoId"] as String? ?? "",
      nome: json["nome"] as String? ?? "",
      descricao: json["descricao"] as String?,
      privado: json["privado"] as bool? ?? false,
      limiteUtilizadores: (json["limiteUtilizadores"] as num?)?.toInt() ?? 1,
      dataCriacao: json["dataCriacao"] == null ? null : DateTime.tryParse(json["dataCriacao"] as String),
    );
  }
}
