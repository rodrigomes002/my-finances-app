class Lancamento {
  const Lancamento({
    required this.data,
    required this.descricao,
    required this.valor,
  });

  factory Lancamento.fromJson(Map<String, dynamic> json) {
    final Object? rawDate = json['data'];
    final Object? rawDescription = json['descricao'];
    final Object? rawAmount = json['valor'];
    if (rawDate is! String || rawDescription is! String) {
      throw const FormatException(
        'Um lançamento contém campos obrigatórios inválidos.',
      );
    }

    final double? amount = switch (rawAmount) {
      num value => value.toDouble(),
      String value => double.tryParse(value),
      _ => null,
    };
    if (amount == null || !amount.isFinite) {
      throw const FormatException(
        'O valor de um lançamento não é um número válido.',
      );
    }

    try {
      return Lancamento(
        data: DateTime.parse(rawDate),
        descricao: rawDescription,
        valor: amount,
      );
    } on FormatException {
      throw const FormatException(
        'A data de um lançamento não está no formato ISO esperado.',
      );
    }
  }

  final DateTime data;
  final String descricao;
  final double valor;

  static String formatCurrency(double value) {
    final bool isNegative = value < 0;
    final String fixed = value.abs().toStringAsFixed(2);
    final List<String> parts = fixed.split('.');
    final String whole = parts.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return '${isNegative ? '- ' : ''}R\$ $whole,${parts.last}';
  }

  String get formattedDate =>
      '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}/${data.year}';
}
