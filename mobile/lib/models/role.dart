/// Espelha o enum Role.java do backend.
/// Convertido sempre como texto exatamente igual ao nome do enum.
enum Role {
  visitante,
  inscrito,
  criador,
  revisor,
  master;

  static Role fromJson(String? value) {
    switch (value) {
      case "INSCRITO":
        return Role.inscrito;
      case "CRIADOR":
        return Role.criador;
      case "REVISOR":
        return Role.revisor;
      case "MASTER":
        return Role.master;
      case "VISITANTE":
      default:
        return Role.visitante;
    }
  }

  String toJson() {
    switch (this) {
      case Role.inscrito:
        return "INSCRITO";
      case Role.criador:
        return "CRIADOR";
      case Role.revisor:
        return "REVISOR";
      case Role.master:
        return "MASTER";
      case Role.visitante:
        return "VISITANTE";
    }
  }

  String get label {
    switch (this) {
      case Role.inscrito:
        return "Inscrito";
      case Role.criador:
        return "Criador";
      case Role.revisor:
        return "Revisor";
      case Role.master:
        return "Master";
      case Role.visitante:
        return "Visitante";
    }
  }
}
