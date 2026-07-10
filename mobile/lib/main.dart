import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/auth_repository.dart';

void main() {
  runApp(const ProviderScope(child: EconomiaComHistoriaApp()));
}

class EconomiaComHistoriaApp extends ConsumerStatefulWidget {
  const EconomiaComHistoriaApp({super.key});

  @override
  ConsumerState<EconomiaComHistoriaApp> createState() => _EconomiaComHistoriaAppState();
}

class _EconomiaComHistoriaAppState extends ConsumerState<EconomiaComHistoriaApp> {
  @override
  void initState() {
    super.initState();
    // Tenta restaurar a sessão local (se o utilizador já tiver feito login antes).
    Future.microtask(() => ref.read(authProvider.notifier).tryRestoreSession());
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Economia com História',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
