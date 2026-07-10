/// Espelha TopicoResponse.java.
class Topico {
  final String id;
  final String forumId;
  final String autorId;
  final String titulo;
  final String conteudo;
  final int score;
  final DateTime? dataCriacao;

  const Topico({
    required this.id,
    required this.forumId,
    required this.autorId,
    required this.titulo,
    required this.conteudo,
    required this.score,
    this.dataCriacao,
  });

  factory Topico.fromJson(Map<String, dynamic> json) {
    return Topico(
      id: json["id"] as String,
      forumId: json["forumId"] as String? ?? "",
      autorId: json["autorId"] as String? ?? "",
      titulo: json["titulo"] as String? ?? "",
      conteudo: json["conteudo"] as String? ?? "",
      score: (json["score"] as num?)?.toInt() ?? 0,
      dataCriacao: json["dataCriacao"] == null ? null : DateTime.tryParse(json["dataCriacao"] as String),
    );
  }
}

/// Espelha ComentarioResponse.java, incluindo a árvore de respostas
/// aninhadas devolvida por GET /api/topicos/{id}/comentarios/arvore.
class Comentario {
  final String id;
  final String topicoId;
  final String autorId;
  final String? comentarioPaiId;
  final String texto;
  final int score;
  final DateTime? dataCriacao;
  final List<Comentario> respostas;

  const Comentario({
    required this.id,
    required this.topicoId,
    required this.autorId,
    this.comentarioPaiId,
    required this.texto,
    required this.score,
    this.dataCriacao,
    this.respostas = const [],
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json["id"] as String,
      topicoId: json["topicoId"] as String? ?? "",
      autorId: json["autorId"] as String? ?? "",
      comentarioPaiId: json["comentarioPaiId"] as String?,
      texto: json["texto"] as String? ?? "",
      score: (json["score"] as num?)?.toInt() ?? 0,
      dataCriacao: json["dataCriacao"] == null ? null : DateTime.tryParse(json["dataCriacao"] as String),
      respostas: (json["respostas"] as List<dynamic>? ?? []).map((e) => Comentario.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
