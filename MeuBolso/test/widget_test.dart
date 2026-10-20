import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/app.dart';

void main() {
  testWidgets('MeuBolsoApp abre o dashboard financeiro', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MeuBolsoApp());
    await tester.pumpAndSettle();

    expect(find.text('VISÃO GERAL'), findsOneWidget);
    expect(find.textContaining('1.930,00'), findsWidgets);
    expect(find.text('Início'), findsWidgets);
  });
}
