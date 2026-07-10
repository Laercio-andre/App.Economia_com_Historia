/// Espelha RankingResponse.java: um ranking agregado (soma de pontos de
/// todos os utilizadores de uma região ou instituição), não um ranking
/// individual por pessoa. `chave` é o nome da região/instituição.
class RankingEntry {
  final String chave;
  final int pontos;

  const RankingEntry({required this.chave, required this.pontos});

  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      chave: json["chave"] as String? ?? "—",
      pontos: (json["pontos"] as num?)?.toInt() ?? 0,
    );
  }
}
