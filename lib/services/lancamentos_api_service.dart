import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/lancamento.dart';
import '../models/resumo_lancamentos.dart';

class LancamentosApiService {
  LancamentosApiService({
    http.Client? client,
    Uri? baseUri,
  }) : _client = client ?? http.Client(),
       _baseUri = baseUri ?? ApiConfig.lancamentosEndpoint;

  final http.Client _client;
  final Uri _baseUri;

  Future<List<Lancamento>> getLancamentos({required DateTime mes}) async {
    final Object? json = await _getJson(_uriForMonth(_baseUri, mes));
    if (json is! List<dynamic>) {
      throw const LancamentosApiException(
        'A resposta de api/lancamentos não é uma lista.',
      );
    }

    try {
      return json.map((Object? item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException(
            'A lista contém um lançamento em formato inválido.',
          );
        }
        return Lancamento.fromJson(item);
      }).toList();
    } on FormatException catch (error) {
      throw LancamentosApiException(error.message);
    }
  }

  Future<ResumoLancamentos> getResumo({required DateTime mes}) async {
    final Uri endpoint = _uriForMonth(
      _baseUri.replace(path: '${_baseUri.path}/resumo'),
      mes,
    );
    final Object? json = await _getJson(endpoint);
    if (json is! Map<String, dynamic>) {
      throw const LancamentosApiException(
        'A resposta de api/lancamentos/resumo está em formato inválido.',
      );
    }

    try {
      return ResumoLancamentos.fromJson(json);
    } on FormatException catch (error) {
      throw LancamentosApiException(error.message);
    }
  }

  Uri _uriForMonth(Uri endpoint, DateTime mes) {
    final String month =
        '${mes.year.toString().padLeft(4, '0')}-'
        '${mes.month.toString().padLeft(2, '0')}';
    return endpoint.replace(
      queryParameters: <String, String>{
        ...endpoint.queryParameters,
        'mes': month,
      },
    );
  }

  Future<Object?> _getJson(Uri endpoint) async {
    final http.Response response;
    try {
      response = await _client.get(
        endpoint,
        headers: const <String, String>{'Accept': 'application/json'},
      );
    } on http.ClientException catch (error) {
      throw LancamentosApiException(
        'Não foi possível conectar à API de lançamentos: ${error.message}',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LancamentosApiException(
        'A API de lançamentos retornou HTTP ${response.statusCode}.',
      );
    }

    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw const LancamentosApiException(
        'A API retornou uma resposta JSON inválida.',
      );
    }
  }

  void dispose() => _client.close();
}

class LancamentosApiException implements Exception {
  const LancamentosApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
