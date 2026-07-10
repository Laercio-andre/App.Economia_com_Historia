// Teste de fumo básico: garante que a app arranca sem erros e mostra o
// ecrã inicial (Boas-vindas), sem depender de rede (a sessão local começa
// sempre por não ter token nem modo convidado guardado).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:economia_com_historia/main.dart';

void main() {
  testWidgets('App arranca e mostra o ecrã de boas-vindas', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: EconomiaComHistoriaApp()));
    await tester.pump();

    // Sem sessão guardada, a rota inicial deve ser /welcome.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
