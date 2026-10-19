// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:my_finances_app/main.dart';

void main() {
  testWidgets('shows the PDF file selector', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Upload').last);
    await tester.pumpAndSettle();

    expect(find.text('Upload de documentos'), findsOneWidget);
    expect(find.text('PDF file'), findsOneWidget);
    expect(find.text('Selecionar arquivo PDF'), findsOneWidget);
    expect(find.text('Enviar documento'), findsOneWidget);
  });

  testWidgets('navigates between Dashboard and Upload', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Seu resumo financeiro'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Upload').last);
    await tester.pumpAndSettle();

    expect(find.text('PDF file'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dashboard').last);
    await tester.pumpAndSettle();

    expect(find.text('Seu resumo financeiro'), findsOneWidget);
    expect(find.text('R\$ 24.580,00'), findsOneWidget);
  });
}
