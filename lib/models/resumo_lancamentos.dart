class ResumoLancamentos {
  const ResumoLancamentos({
    required this.receitas,
    required this.despesas,
    required this.saldoTotal,
  });

  factory ResumoLancamentos.fromJson(Map<String, dynamic> json) {
    return ResumoLancamentos(
      receitas: _readAmount(json, 'receitas'),
      despesas: _readAmount(json, 'despesas'),
      saldoTotal: _readAmount(json, 'saldoTotal'),
    );
  }

  final double receitas;
  final double despesas;
  final double saldoTotal;

  static double _readAmount(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    final double? amount = switch (value) {
      num number => number.toDouble(),
      String number => double.tryParse(number),
      _ => null,
    };
    if (amount == null || !amount.isFinite) {
      throw FormatException('O campo "$key" não contém um valor válido.');
    }
    return amount;
  }
}
