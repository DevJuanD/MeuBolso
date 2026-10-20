import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/movimentacao.dart';
import '../../domain/models/relatorio.dart';

class SegmentedTabs extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  const SegmentedTabs({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: option == selected
                        ? AppColors.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: option == selected
                        ? const [
                            BoxShadow(
                              color: Color(0x0A1E293B),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 10.5,
                      fontWeight: option == selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: option == selected
                          ? AppColors.primary
                          : AppColors.textBody,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ReportMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool positive;

  const ReportMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppColors.positive : AppColors.negative;
    final soft = positive ? AppColors.positiveSoft : AppColors.negativeSoft;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x071E293B),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: soft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 9.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textBody,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                color: AppColors.textHeading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportBalanceCard extends StatelessWidget {
  final String value;
  final String helper;

  const ReportBalanceCard({
    super.key,
    required this.value,
    required this.helper,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x268350FF),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saldo do período',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.9,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                helper,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 8.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xE6FFFFFF),
                ),
              ),
            ],
          ),
          const Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.calendar_month_outlined,
              size: 20,
              color: Color(0xE6FFFFFF),
            ),
          ),
        ],
      ),
    );
  }
}

class MovementSummaryCard extends StatelessWidget {
  final int receitasCentavos;
  final int despesasCentavos;
  final int saldoCentavos;
  final String note;

  const MovementSummaryCard({
    super.key,
    required this.receitasCentavos,
    required this.despesasCentavos,
    required this.saldoCentavos,
    this.note = 'Saldo = receitas − despesas; não é saldo bancário.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x071E293B),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(
            'Total de receitas',
            formatarMoeda(receitasCentavos, comSinal: true),
            AppColors.positive,
          ),
          const SizedBox(height: 10),
          _row(
            'Total de despesas',
            formatarMoeda(-despesasCentavos),
            AppColors.negativeDark,
          ),
          const SizedBox(height: 10),
          _row(
            'Saldo do período',
            formatarMoeda(saldoCentavos),
            AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            note,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 8.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, Color valueColor) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textBody,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class ComparisonSection extends StatelessWidget {
  final ComparativoPeriodo comparativo;
  final String resumo;

  const ComparisonSection({
    super.key,
    required this.comparativo,
    required this.resumo,
  });

  @override
  Widget build(BuildContext context) {
    final saldoDiferenca =
        comparativo.saldoAtualCentavos - comparativo.saldoAnteriorCentavos;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x071E293B),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comparativo financeiro',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: AppColors.textHeading,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            comparativo.descricao,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 9.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          _linha(
            label: 'Receitas',
            percentual: comparativo.percentualReceitas,
            de: comparativo.receitasAnteriorCentavos,
            para: comparativo.receitasAtualCentavos,
            corPercentual: AppColors.positive,
          ),
          const SizedBox(height: 12),
          _linha(
            label: 'Despesas',
            percentual: comparativo.percentualDespesas,
            de: comparativo.despesasAnteriorCentavos,
            para: comparativo.despesasAtualCentavos,
            corPercentual: AppColors.positive,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Saldo do período',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBody,
                    ),
                  ),
                ),
                Text(
                  formatarMoeda(saldoDiferenca, comSinal: true),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${formatarMoeda(comparativo.saldoAnteriorCentavos)} → ${formatarMoeda(comparativo.saldoAtualCentavos)}',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            resumo,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _linha({
    required String label,
    required String percentual,
    required int de,
    required int para,
    required Color corPercentual,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHeading,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${formatarMoeda(de)} → ${formatarMoeda(para)}',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          percentual,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: corPercentual,
          ),
        ),
      ],
    );
  }
}

class FilterChoice extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FilterChoice({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.1 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(
                Icons.check_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.primary : AppColors.textBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
