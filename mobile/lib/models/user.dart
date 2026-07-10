import "role.dart";

/// Espelha o UtilizadorResponse.java devolvido pelo backend, com um estado
/// extra local (isGuest) para o modo "Explorar sem conta".
class AppUser {
  final String id;
  final String email;
  final Role role;
  final int pontosAcumulados;
  final String? regiao;
  final String? instituicao;
  final bool isGuest;

  const AppUser({
    this.id = "",
    required this.email,
    this.role = Role.visitante,
    this.pontosAcumulados = 0,
    this.regiao,
    this.instituicao,
    this.isGuest = false,
  });

  /// O backend não guarda "nome"; derivamos um nome de exibição do email.
  String get displayName {
    if (isGuest) return "Convidado";
    if (email.isEmpty) return "Utilizador";
    final localPart = email.split("@").first;
    final parts = localPart.replaceAll(RegExp(r"[._-]+"), " ").trim().split(" ");
    return parts.map((p) => p.isEmpty ? p : "${p[0].toUpperCase()}${p.substring(1)}").join(" ");
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json["id"] as String? ?? "",
      email: json["email"] as String? ?? "",
      role: Role.fromJson(json["role"] as String?),
      pontosAcumulados: (json["pontosAcumulados"] as num?)?.toInt() ?? 0,
      regiao: json["regiao"] as String?,
      instituicao: json["instituicao"] as String?,
    );
  }

  AppUser copyWith({
    String? id,
    String? email,
    Role? role,
    int? pontosAcumulados,
    String? regiao,
    String? instituicao,
    bool? isGuest,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      pontosAcumulados: pontosAcumulados ?? this.pontosAcumulados,
      regiao: regiao ?? this.regiao,
      instituicao: instituicao ?? this.instituicao,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  static const guest = AppUser(email: "", isGuest: true);
}
