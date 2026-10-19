// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_finances_app/repositories/lancamentos_repository.dart';
import 'package:my_finances_app/services/lancamentos_api_service.dart';
import 'package:my_finances_app/viewmodels/dashboard_view_model.dart';

import 'package:my_finances_app/main.dart';

void main() {
  testWidgets('shows the PDF file selector', (WidgetTester tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

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
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(find.text('Seu resumo financeiro'), findsOneWidget);
    expect(find.text('R\$ 6.000,00'), findsOneWidget);
    expect(find.text('Salário'), findsOneWidget);

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
    expect(find.text('R\$ 6.000,00'), findsOneWidget);
  });

  testWidgets('filters the dashboard by the selected month and year', (
    WidgetTester tester,
  ) async {
    final List<Uri> requestedUris = <Uri>[];
    await tester.pumpWidget(_testApp(requestedUris: requestedUris));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Selecionar mês e ano'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jan'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '2025');
    await tester.tap(find.text('Aplicar'));
    await tester.pumpAndSettle();

    expect(find.text('Janeiro 2025'), findsOneWidget);
    expect(
      requestedUris.where((Uri uri) => uri.queryParameters['mes'] == '2025-01'),
      hasLength(2),
    );
  });
}

Widget _testApp({List<Uri>? requestedUris}) {
  return MyApp(
    dashboardViewModel: DashboardViewModel(
      repository: LancamentosRepository(
        apiService: LancamentosApiService(
          client: MockClient((http.Request request) async {
            requestedUris?.add(request.url);
            if (request.url.path.endsWith('/resumo')) {
              return http.Response(
                jsonEncode(<String, Object>{
                  'receitas': 7000,
                  'despesas': 1000,
                  'saldoTotal': 6000,
                }),
                200,
              );
            }
            return http.Response(
              jsonEncode(<Map<String, Object>>[
                <String, Object>{
                  'id': 1,
                  'data': '2026-10-18',
                  'descricao': 'Salário',
                  'valor': 7000,
                },
                <String, Object>{
                  'id': 2,
                  'data': '2026-10-17',
                  'descricao': 'Mercado',
                  'valor': -1000,
                },
              ]),
              200,
            );
          }),
        ),
      ),
    ),
  );
}
