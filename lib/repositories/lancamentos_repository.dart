import '../models/lancamento.dart';
import '../models/resumo_lancamentos.dart';
import '../services/lancamentos_api_service.dart';

class LancamentosRepository {
  const LancamentosRepository({required this.apiService});

  final LancamentosApiService apiService;

  Future<List<Lancamento>> getLancamentos({required DateTime mes}) =>
      apiService.getLancamentos(mes: mes);

  Future<ResumoLancamentos> getResumo({required DateTime mes}) =>
      apiService.getResumo(mes: mes);

  void dispose() => apiService.dispose();
}
