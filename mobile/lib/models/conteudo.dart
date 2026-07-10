/// Espelha ConteudoResponse.java.
///
/// NOTA sobre `tipo`: o documento "ROTAS E CONFIGURACAO PARA APP MOBILE"
/// confirma "TEXTO" como valor de exemplo; VIDEO/PODCAST continuam por
/// confirmar (só temos os DTOs, não o ficheiro TipoConteudo.java). Guardamos
/// o valor tal como o servidor o devolve (string), sem impor um enum Dart
/// fixo, para nunca partir a desserialização por causa de um valor que eu
/// não previ.
class Conteudo {
  final String id;
  final String titulo;
  final String? descricao;
  final String tipo;
  final String categoria;
  final List<String> tags;
  final String? urlMidia;
  final String? corpoTexto;
  final bool approved;
  final bool exclusivo;
  final String autorId;
  final DateTime? dataCriacao;

  const Conteudo({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.tipo,
    required this.categoria,
    this.tags = const [],
    this.urlMidia,
    this.corpoTexto,
    this.approved = true,
    this.exclusivo = false,
    required this.autorId,
    this.dataCriacao,
  });

  factory Conteudo.fromJson(Map<String, dynamic> json) {
    return Conteudo(
      id: json["id"] as String,
      titulo: json["titulo"] as String? ?? "",
      descricao: json["descricao"] as String?,
      tipo: json["tipo"] as String? ?? "TEXTO",
      categoria: json["categoria"] as String? ?? "",
      tags: (json["tags"] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      urlMidia: json["urlMidia"] as String?,
      corpoTexto: json["corpoTexto"] as String?,
      approved: json["approved"] as bool? ?? true,
      exclusivo: json["exclusivo"] as bool? ?? false,
      autorId: json["autorId"] as String? ?? "",
      dataCriacao: json["dataCriacao"] == null ? null : DateTime.tryParse(json["dataCriacao"] as String),
    );
  }
}
