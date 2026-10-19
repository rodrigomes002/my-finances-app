import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_finances_app/services/lancamentos_api_service.dart';

void main() {
  test('loads launches and summary from their REST endpoints', () async {
    final List<Uri> requestedUris = <Uri>[];
    final LancamentosApiService service = LancamentosApiService(
      client: MockClient((http.Request request) async {
        requestedUris.add(request.url);
        if (request.url.path.endsWith('/resumo')) {
          return http.Response(
            jsonEncode(<String, Object>{
              'receitas': 5000.5,
              'despesas': 1250.25,
              'saldoTotal': 3750.25,
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode(<Map<String, Object>>[
            <String, Object>{
              'id': 1,
              'data': '2026-10-18',
              'descricao': 'Pagamento',
              'valor': 5000.5,
            },
          ]),
          200,
        );
      }),
    );
    addTearDown(service.dispose);

    final DateTime mes = DateTime(2026, 10);
    final launches = await service.getLancamentos(mes: mes);
    final summary = await service.getResumo(mes: mes);

    expect(requestedUris.map((Uri uri) => uri.path), <String>[
      '/api/lancamentos',
      '/api/lancamentos/resumo',
    ]);
    expect(requestedUris.map((Uri uri) => uri.queryParameters['mes']), <String>[
      '2026-10',
      '2026-10',
    ]);
    expect(launches, hasLength(1));
    expect(launches.single.data, DateTime(2026, 10, 18));
    expect(launches.single.descricao, 'Pagamento');
    expect(launches.single.valor, 5000.5);
    expect(summary.receitas, 5000.5);
    expect(summary.despesas, 1250.25);
    expect(summary.saldoTotal, 3750.25);
  });

  test('reports unsuccessful API responses', () async {
    final LancamentosApiService service = LancamentosApiService(
      client: MockClient((http.Request request) async {
        return http.Response('Not found', 404);
      }),
    );
    addTearDown(service.dispose);

    expect(
      service.getResumo(mes: DateTime(2026, 10)),
      throwsA(
        isA<LancamentosApiException>().having(
          (LancamentosApiException error) => error.message,
          'message',
          contains('HTTP 404'),
        ),
      ),
    );
  });
}
