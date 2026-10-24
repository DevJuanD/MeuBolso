import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Gráfico de barras comparativo "Receitas x Despesas" do mês selecionado.
class GraficoResumoWidget extends StatelessWidget {
  final int receitasCentavos;
  final int despesasCentavos;

  const GraficoResumoWidget({
    super.key,
    required this.receitasCentavos,
    required this.despesasCentavos,
  });

  @override
  Widget build(BuildContext context) {
    final receitas = receitasCentavos / 100.0;
    final despesas = despesasCentavos / 100.0;
    final maiorValor = [receitas, despesas].reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 168,
      width: double.infinity,
      child: BarChart(
        BarChartData(
          maxY: maiorValor == 0 ? 100 : maiorValor * 1.25,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maiorValor == 0 ? 50 : maiorValor * 1.25 / 2,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.divider,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) => Text(
                  _formatarEixo(value),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) => Text(
                  switch (value.toInt()) {
                    0 => 'Receitas',
                    1 => 'Despesas',
                    _ => '',
                  },
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ),
          barGroups: [
            _criarBarra(x: 0, valor: receitas, cor: AppColors.chartPositive),
            _criarBarra(x: 1, valor: despesas, cor: AppColors.chartNegative),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _criarBarra({
    required int x,
    required double valor,
    required Color cor,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: valor,
          color: cor,
          width: 30,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  /// Formata o valor do eixo em reais compacto (ex: "R\$ 2,5 mil").
  static String _formatarEixo(double valorEmReais) {
    if (valorEmReais >= 1000) {
      final milhar = (valorEmReais / 1000).toStringAsFixed(1);
      return 'R\$ ${milhar.replaceAll('.', ',')} mil';
    }
    return 'R\$ ${valorEmReais.toStringAsFixed(0)}';
  }
}
