import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../data/auth_repository.dart";
import "../theme/app_colors.dart";
import "../theme/app_text_styles.dart";

/// Verifica se o utilizador está autenticado "a sério" (não convidado).
/// Se não estiver, mostra um diálogo a convidar para login/registo e devolve
/// false, para que o chamador cancele a ação protegida.
///
/// Usa isto em qualquer ação que exija Authorization: Bearer <token> no
/// backend (ver mappings_sistema.txt): criar tópicos, comentar, votar,
/// subscrever, entrar em salas de quiz, editar perfil, notificações, etc.
bool requireAuth(
  BuildContext context,
  WidgetRef ref, {
  String message = "Esta funcionalidade precisa de uma conta. Inicia sessão ou cria uma conta para continuar.",
}) {
  final auth = ref.read(authProvider);
  if (auth.isAuthenticated) return true;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.wineDeep,
      title: Text("Acesso restrito", style: AppTextStyles.h3),
      content: Text(message, style: AppTextStyles.body),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text("Agora não")),
        TextButton(
          onPressed: () {
            context.pop();
            context.push("/register");
          },
          child: const Text("Criar conta"),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            context.push("/login");
          },
          child: const Text("Fazer login"),
        ),
      ],
    ),
  );
  return false;
}
