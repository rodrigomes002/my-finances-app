import 'package:flutter/material.dart';

import '../models/lancamento.dart';
import '../viewmodels/dashboard_view_model.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key, required this.viewModel});

  final DashboardViewModel viewModel;

  static const Color _muted = Color(0xFF7C8985);
  static const Color _green = Color(0xFF178A70);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (BuildContext context, Widget? child) {
        if (viewModel.resumo == null && viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (viewModel.resumo == null && viewModel.error != null) {
          return _DashboardLoadError(
            message: viewModel.error!,
            onRetry: viewModel.load,
          );
        }

        final resumo = viewModel.resumo;
        if (resumo == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _GreetingHeader(),
                  const SizedBox(height: 22),
                  _BalanceCard(balance: resumo.saldoTotal),
                  const SizedBox(height: 18),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final bool sideBySide = constraints.maxWidth >= 560;
                          final Widget income = _SummaryCard(
                            title: 'Receitas',
                            amount: Lancamento.formatCurrency(resumo.receitas),
                            icon: Icons.south_west_rounded,
                            color: _green,
                          );
                          final Widget expenses = _SummaryCard(
                            title: 'Despesas',
                            amount: Lancamento.formatCurrency(resumo.despesas),
                            icon: Icons.north_east_rounded,
                            color: const Color(0xFFE18B5A),
                          );

                          if (!sideBySide) {
                            return Column(
                              children: <Widget>[
                                income,
                                const SizedBox(height: 12),
                                expenses,
                              ],
                            );
                          }

                          return Row(
                            children: <Widget>[
                              Expanded(child: income),
                              const SizedBox(width: 14),
                              Expanded(child: expenses),
                            ],
                          );
                        },
                  ),
                  const SizedBox(height: 22),
                  _SectionHeading(
                    title: 'Visão geral',
                    subtitle: 'Fluxo dos lançamentos recentes',
                    trailing: _CurrentMonthLabel(
                      mes: viewModel.mesSelecionado,
                      onPressed: () async {
                        final DateTime? mes = await showDialog<DateTime>(
                          context: context,
                          builder: (BuildContext context) =>
                              _MonthYearPickerDialog(
                                initialMonth: viewModel.mesSelecionado,
                              ),
                        );
                        if (mes != null) {
                          await viewModel.selecionarMes(mes);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SpendingChartCard(lancamentos: viewModel.lancamentos),
                  const SizedBox(height: 22),
                  const _SectionHeading(
                    title: 'Movimentações recentes',
                    subtitle: 'Lançamentos da sua conta',
                    trailing: Icon(
                      Icons.receipt_long_outlined,
                      color: _green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _RecentTransactionsCard(lancamentos: viewModel.lancamentos),
                  if (viewModel.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Center(
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  if (viewModel.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        viewModel.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    'Dados atualizados pela sua conta',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DashboardLoadError extends StatelessWidget {
  const _DashboardLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.cloud_off_outlined,
              color: Color(0xFF7C8985),
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'Não foi possível carregar seus dados',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Olá, que bom ter você por aqui',
                style: TextStyle(
                  color: Color(0xFF7C8985),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Seu resumo financeiro',
                style: TextStyle(
                  color: Color(0xFF182522),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE8EEEB)),
          ),
          child: IconButton(
            tooltip: 'Notificações',
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF394943),
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF176D5C), Color(0xFF124E46)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -48,
            right: -34,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 28,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Saldo total',
                      style: TextStyle(
                        color: Color(0xFFD0E6DF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                Lancamento.formatCurrency(balance),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Saldo atualizado',
                style: TextStyle(color: Color(0xFFB7D5CC), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 19),
                ),
                const Spacer(),
                const Icon(Icons.more_horiz_rounded, color: Color(0xFF7C8985)),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(color: Color(0xFF7C8985), fontSize: 12),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                amount,
                style: const TextStyle(
                  color: Color(0xFF182522),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF182522),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF7C8985), fontSize: 12),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}

class _CurrentMonthLabel extends StatelessWidget {
  const _CurrentMonthLabel({required this.mes, required this.onPressed});

  final DateTime mes;
  final VoidCallback onPressed;

  static const List<String> _meses = <String>[
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Selecionar mês e ano',
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF394943),
          side: const BorderSide(color: Color(0xFFE8EEEB)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '${_meses[mes.month - 1]} ${mes.year}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}

class _MonthYearPickerDialog extends StatefulWidget {
  const _MonthYearPickerDialog({required this.initialMonth});

  final DateTime initialMonth;

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _yearController = TextEditingController(
    text: widget.initialMonth.year.toString(),
  );
  late int _month = widget.initialMonth.month;

  static const List<String> _months = <String>[
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];
  static const List<String> _monthAbbreviations = <String>[
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Selecionar período'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Wrap(
              spacing: 4,
              runSpacing: 0,
              children: List<Widget>.generate(
                _months.length,
                (int index) => Tooltip(
                  message: _months[index],
                  child: ChoiceChip(
                    label: Center(child: Text(_monthAbbreviations[index])),
                    selected: _month == index + 1,
                    onSelected: (_) => setState(() => _month = index + 1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Ano'),
              validator: (String? value) {
                final int? year = int.tryParse(value ?? '');
                if (year == null || year < 1 || year > 9999) {
                  return 'Informe um ano válido.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            Navigator.of(context)
                .pop(DateTime(int.parse(_yearController.text), _month));
          },
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}

class _SpendingChartCard extends StatelessWidget {
  const _SpendingChartCard({required this.lancamentos});

  final List<Lancamento> lancamentos;

  @override
  Widget build(BuildContext context) {
    final List<Lancamento> entries = lancamentos
        .take(12)
        .toList()
        .reversed
        .toList();
    final List<double> incomeValues = entries
        .map((Lancamento entry) => entry.valor > 0 ? entry.valor : 0.0)
        .toList();
    final List<double> expenseValues = entries
        .map((Lancamento entry) => entry.valor < 0 ? entry.valor.abs() : 0.0)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text(
                  'Entradas e saídas',
                  style: TextStyle(
                    color: Color(0xFF394943),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (entries.isNotEmpty) ...<Widget>[
                  const _LegendDot(color: Color(0xFF178A70), label: 'Receitas'),
                  const SizedBox(width: 12),
                  const _LegendDot(color: Color(0xFFF0B18A), label: 'Despesas'),
                ],
              ],
            ),
            if (entries.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Sem lançamentos para exibir.',
                    style: TextStyle(color: Color(0xFF7C8985), fontSize: 12),
                  ),
                ),
              )
            else ...<Widget>[
              const SizedBox(height: 16),
              SizedBox(
                height: 138,
                width: double.infinity,
                child: CustomPaint(
                  painter: _CashFlowChartPainter(
                    income: incomeValues,
                    expenses: expenseValues,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  for (final int index in _labelIndices(entries.length))
                    _ChartLabel(
                      '${entries[index].data.day.toString().padLeft(2, '0')}/'
                      '${entries[index].data.month.toString().padLeft(2, '0')}',
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<int> _labelIndices(int length) {
    if (length <= 5) {
      return List<int>.generate(length, (int index) => index);
    }
    return <int>[0, (length - 1) ~/ 3, 2 * (length - 1) ~/ 3, length - 1];
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 7,
          width: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF7C8985), fontSize: 10),
        ),
      ],
    );
  }
}

class _ChartLabel extends StatelessWidget {
  const _ChartLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Color(0xFF9AA5A1), fontSize: 9),
    );
  }
}

class _CashFlowChartPainter extends CustomPainter {
  const _CashFlowChartPainter({required this.income, required this.expenses});

  final List<double> income;
  final List<double> expenses;

  @override
  void paint(Canvas canvas, Size size) {
    final double maxValue = <double>[
      ...income,
      ...expenses,
    ].fold<double>(0, (double max, double value) => value > max ? value : max);
    if (maxValue == 0) {
      return;
    }

    final Paint gridPaint = Paint()
      ..color = const Color(0xFFF0F3F1)
      ..strokeWidth = 1;
    final Paint incomePaint = Paint()
      ..color = const Color(0xFF178A70)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final Paint expensesPaint = Paint()
      ..color = const Color(0xFFF0B18A)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int row = 0; row < 4; row++) {
      final double y = size.height * row / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    Path makeLine(List<double> points) {
      final Path path = Path();
      for (int index = 0; index < points.length; index++) {
        final Offset point = Offset(
          points.length == 1
              ? size.width / 2
              : size.width * index / (points.length - 1),
          size.height * (1 - points[index] / maxValue * 0.85),
        );
        if (index == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      return path;
    }

    canvas
      ..drawPath(makeLine(expenses), expensesPaint)
      ..drawPath(makeLine(income), incomePaint);
  }

  @override
  bool shouldRepaint(covariant _CashFlowChartPainter oldDelegate) =>
      oldDelegate.income != income || oldDelegate.expenses != expenses;
}

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard({required this.lancamentos});

  final List<Lancamento> lancamentos;

  @override
  Widget build(BuildContext context) {
    if (lancamentos.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              'Nenhum lançamento encontrado.',
              style: TextStyle(color: Color(0xFF7C8985), fontSize: 12),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: <Widget>[
          for (int index = 0; index < lancamentos.length; index++) ...<Widget>[
            _TransactionRow(lancamento: lancamentos[index]),
            if (index != lancamentos.length - 1)
              const Divider(height: 1, indent: 64, endIndent: 16),
          ],
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.lancamento});

  final Lancamento lancamento;

  @override
  Widget build(BuildContext context) {
    final bool isIncome = lancamento.valor >= 0;
    final Color color = isIncome
        ? const Color(0xFF178A70)
        : const Color(0xFFE18B5A);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: color,
              size: 19,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  lancamento.descricao,
                  style: const TextStyle(
                    color: Color(0xFF27332F),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  lancamento.formattedDate,
                  style: const TextStyle(
                    color: Color(0xFF8C9894),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isIncome ? '+' : ''}'
            '${Lancamento.formatCurrency(lancamento.valor.abs())}',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
