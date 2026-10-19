import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  static const Color _muted = Color(0xFF7C8985);
  static const Color _green = Color(0xFF178A70);

  @override
  Widget build(BuildContext context) {
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
              const _BalanceCard(),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool sideBySide = constraints.maxWidth >= 560;
                  final Widget income = const _SummaryCard(
                    title: 'Receitas',
                    amount: 'R\$ 8.450,00',
                    change: '+12,8%',
                    icon: Icons.south_west_rounded,
                    color: _green,
                    isPositive: true,
                  );
                  final Widget expenses = const _SummaryCard(
                    title: 'Despesas',
                    amount: 'R\$ 3.280,00',
                    change: '-4,2%',
                    icon: Icons.north_east_rounded,
                    color: Color(0xFFE18B5A),
                    isPositive: false,
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
              const _SectionHeading(
                title: 'Visão geral',
                subtitle: 'Acompanhe seu fluxo financeiro',
                trailing: _PeriodSelector(),
              ),
              const SizedBox(height: 12),
              const _SpendingChartCard(),
              const SizedBox(height: 22),
              const _SectionHeading(
                title: 'Movimentações recentes',
                subtitle: 'Suas últimas atividades',
                trailing: Text(
                  'Ver todas',
                  style: TextStyle(color: _green, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              const _RecentTransactionsCard(),
              const SizedBox(height: 12),
              const Text(
                'Valores demonstrativos',
                style: TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
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
  const _BalanceCard();

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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      children: <Widget>[
                        Icon(
                          Icons.trending_up_rounded,
                          size: 15,
                          color: Color(0xFFA9E6C9),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '8,4%',
                          style: TextStyle(
                            color: Color(0xFFC8F0DD),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'R\$ 24.580,00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Seu patrimônio neste mês',
                style: TextStyle(color: Color(0xFFB7D5CC), fontSize: 12),
              ),
              const SizedBox(height: 20),
              const Row(
                children: <Widget>[
                  _BalanceAction(icon: Icons.add_rounded, label: 'Adicionar'),
                  SizedBox(width: 10),
                  _BalanceAction(
                    icon: Icons.swap_horiz_rounded,
                    label: 'Transferir',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceAction extends StatelessWidget {
  const _BalanceAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 17, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
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
    required this.change,
    required this.icon,
    required this.color,
    required this.isPositive,
  });

  final String title;
  final String amount;
  final String change;
  final IconData icon;
  final Color color;
  final bool isPositive;

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
                Text(
                  change,
                  style: TextStyle(
                    color: isPositive
                        ? const Color(0xFF178A70)
                        : const Color(0xFF178A70),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(
                  isPositive
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 13,
                  color: const Color(0xFF178A70),
                ),
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

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8EEEB)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: <Widget>[
          Text(
            'Este mês',
            style: TextStyle(
              color: Color(0xFF394943),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_rounded, size: 16),
        ],
      ),
    );
  }
}

class _SpendingChartCard extends StatelessWidget {
  const _SpendingChartCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Text(
                  'Fluxo de caixa',
                  style: TextStyle(
                    color: Color(0xFF394943),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                _LegendDot(color: Color(0xFF178A70), label: 'Receitas'),
                SizedBox(width: 12),
                _LegendDot(color: Color(0xFFF0B18A), label: 'Despesas'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 138,
              width: double.infinity,
              child: CustomPaint(painter: _CashFlowChartPainter()),
            ),
            const SizedBox(height: 6),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _ChartLabel('01 Jun'),
                _ChartLabel('07 Jun'),
                _ChartLabel('14 Jun'),
                _ChartLabel('21 Jun'),
                _ChartLabel('30 Jun'),
              ],
            ),
          ],
        ),
      ),
    );
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
  @override
  void paint(Canvas canvas, Size size) {
    const List<double> income = <double>[
      0.65,
      0.44,
      0.55,
      0.30,
      0.48,
      0.38,
      0.59,
      0.28,
      0.42,
      0.22,
      0.35,
      0.16,
    ];
    const List<double> expenses = <double>[
      0.82,
      0.70,
      0.77,
      0.61,
      0.74,
      0.65,
      0.78,
      0.58,
      0.71,
      0.52,
      0.62,
      0.48,
    ];
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
          size.width * index / (points.length - 1),
          size.height * points[index],
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
  bool shouldRepaint(covariant _CashFlowChartPainter oldDelegate) => false;
}

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard();

  static const List<_Transaction> _transactions = <_Transaction>[
    _Transaction(
      title: 'Mercado Central',
      category: 'Alimentação · Hoje, 10:42',
      amount: '- R\$ 186,50',
      icon: Icons.shopping_basket_outlined,
      color: Color(0xFFE7A85C),
    ),
    _Transaction(
      title: 'Salário',
      category: 'Renda · Hoje, 08:15',
      amount: '+ R\$ 5.200,00',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFF178A70),
      isIncome: true,
    ),
    _Transaction(
      title: 'Assinatura de streaming',
      category: 'Entretenimento · Ontem',
      amount: '- R\$ 39,90',
      icon: Icons.play_circle_outline_rounded,
      color: Color(0xFF8B80C4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          for (
            int index = 0;
            index < _transactions.length;
            index++
          ) ...<Widget>[
            _TransactionRow(transaction: _transactions[index]),
            if (index != _transactions.length - 1)
              const Divider(height: 1, indent: 64, endIndent: 16),
          ],
        ],
      ),
    );
  }
}

class _Transaction {
  const _Transaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.icon,
    required this.color,
    this.isIncome = false,
  });

  final String title;
  final String category;
  final String amount;
  final IconData icon;
  final Color color;
  final bool isIncome;
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction});

  final _Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: transaction.color.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(transaction.icon, color: transaction.color, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Color(0xFF27332F),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.category,
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
            transaction.amount,
            style: TextStyle(
              color: transaction.isIncome
                  ? const Color(0xFF178A70)
                  : const Color(0xFF27332F),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
