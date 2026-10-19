import 'package:flutter/foundation.dart';

import '../models/lancamento.dart';
import '../models/resumo_lancamentos.dart';
import '../repositories/lancamentos_repository.dart';
import '../services/lancamentos_api_service.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel({LancamentosRepository? repository})
    : _repository =
          repository ??
          LancamentosRepository(
            apiService: LancamentosApiService(),
          );

  final LancamentosRepository _repository;
  List<Lancamento> _lancamentos = <Lancamento>[];
  ResumoLancamentos? _resumo;
  DateTime _mesSelecionado = DateTime(DateTime.now().year, DateTime.now().month);
  String? _error;
  bool _isLoading = false;
  bool _isDisposed = false;
  int _loadGeneration = 0;

  List<Lancamento> get lancamentos => _lancamentos;
  ResumoLancamentos? get resumo => _resumo;
  DateTime get mesSelecionado => _mesSelecionado;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> selecionarMes(DateTime mes) async {
    final DateTime mesNormalizado = DateTime(mes.year, mes.month);
    if (mesNormalizado.year == _mesSelecionado.year &&
        mesNormalizado.month == _mesSelecionado.month) {
      return;
    }

    _mesSelecionado = mesNormalizado;
    _notifyIfActive();
    await load();
  }

  Future<void> load() async {
    final int generation = ++_loadGeneration;
    final DateTime mes = _mesSelecionado;
    _isLoading = true;
    _error = null;
    _notifyIfActive();

    try {
      final List<Object> responses = await Future.wait<Object>(
        <Future<Object>>[
          _repository.getLancamentos(mes: mes),
          _repository.getResumo(mes: mes),
        ],
      );
      if (generation != _loadGeneration) {
        return;
      }
      final List<Lancamento> lancamentos =
          responses[0] as List<Lancamento>;
      final ResumoLancamentos resumo = responses[1] as ResumoLancamentos;

      lancamentos.sort((Lancamento first, Lancamento second) {
        return second.data.compareTo(first.data);
      });
      _lancamentos = lancamentos;
      _resumo = resumo;
    } on LancamentosApiException catch (error) {
      if (generation == _loadGeneration) {
        _error = error.message;
      }
    } finally {
      if (generation == _loadGeneration) {
        _isLoading = false;
        _notifyIfActive();
      }
    }
  }

  void _notifyIfActive() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _repository.dispose();
    super.dispose();
  }
}
