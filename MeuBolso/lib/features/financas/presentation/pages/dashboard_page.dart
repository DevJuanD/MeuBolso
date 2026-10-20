import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/cor_financeira.dart';
import '../../domain/models/movimentacao.dart';
import '../../domain/models/relatorio.dart';
import '../controllers/financas_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/finance_widgets.dart';
import '../widgets/financial_chart.dart';
import '../widgets/meubolso_bottom_nav.dart';

class DashboardPage extends StatefulWidget {
  final FinancasController controller;
  final VoidCallback onAbrirReceitas;
  final VoidCallback onAbrirMovimentacoes;
  final VoidCallback onAbrirFiltros;
  final ValueChanged<int> onAbaSelecionada;

  const DashboardPage({
    super.key,
    required this.controller,
    required this.onAbrirReceitas,
    required this.onAbrirMovimentacoes,
    required this.onAbrirFiltros,
    required this.onAbaSelecionada,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _mesSelecionado = 'Outubro 2026';

  Future<void> _escolherMes() async {
    final opcao = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecione o mês',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHeading,
                  ),
                ),
                const SizedBox(height: 10),
                for (final mes in [
                  'Outubro 2026',
                  'Setembro 2026',
                  'Agosto 2026',
                ])
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      mes,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    trailing: mes == _mesSelecionado
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: () => Navigator.of(context).pop(mes),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (opcao != null && mounted) {
      setState(() => _mesSelecionado = opcao);
    }
  }

  @override
  Widget build(BuildContext context) {
    final corFinanceira = CorFinanceira.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        const mes = PontoGrafico(
          rotulo: 'Out 2025',
          receitasCentavos: 325000,
          despesasCentavos: 132000,
        );
        return Scaffold(
          backgroundColor: AppColors.background,
          bottomNavigationBar: MeuBolsoBottomNav(
            selectedIndex: 0,
            onSelected: widget.onAbaSelecionada,
          ),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(showAvatar: true),
                  const Text(
                    'VISÃO GERAL',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Olá, Isaac!',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.7,
                      color: AppColors.textHeading,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Aqui está um resumo das suas finanças.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  PrimaryBalanceCard(
                    label: 'Saldo disponível',
                    value: formatarMoeda(widget.controller.saldoCentavos),
                    helper: '+12,5% em relação ao mês anterior',
                    icon: Icons.visibility_outlined,
                    illustration: const WalletIllustration(),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SummaryStatCard(
                        label: 'Receitas',
                        value: formatarMoeda(
                          widget.controller.totalReceitasCentavos,
                        ),
                        change: '+8,2%',
                        icon: Icons.arrow_upward_rounded,
                        accent: corFinanceira.positivo,
                        softColor: AppColors.positiveSoft,
                        onTap: widget.onAbrirReceitas,
                      ),
                      const SizedBox(width: 9),
                      SummaryStatCard(
                        label: 'Despesas',
                        value: formatarMoeda(
                          widget.controller.totalDespesasCentavos,
                        ),
                        change: '−4,7%',
                        icon: Icons.arrow_downward_rounded,
                        accent: AppColors.negative,
                        softColor: AppColors.negativeSoft,
                        negativeChange: true,
                      ),
                      const SizedBox(width: 9),
                      SummaryStatCard(
                        label: 'Saldo',
                        value: formatarMoeda(widget.controller.saldoCentavos),
                        change: '+12,5%',
                        icon: Icons.receipt_long_outlined,
                        accent: AppColors.primary,
                        softColor: AppColors.primarySoft,
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  MonthSelector(
                    label: _mesSelecionado,
                    onTap: _escolherMes,
                    trailing: FilterSquareButton(
                      onTap: widget.onAbrirFiltros,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SurfaceCard(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Indicadores financeiros',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textHeading,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Evolução das suas finanças',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _legendDot(
                                  'Receitas',
                                  AppColors.primary,
                                  selected: true,
                                ),
                                const SizedBox(height: 5),
                                _legendDot(
                                  'Despesas',
                                  AppColors.purpleLegendSoft,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.fromLTRB(13, 14, 13, 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A1E293B),
                                blurRadius: 22,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Receitas x Despesas',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textHeading,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Totais do mês • Outubro de 2025',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _legendDot(
                                    'Receitas',
                                    AppColors.chartPositive,
                                    selected: true,
                                  ),
                                  const SizedBox(width: 14),
                                  _legendDot(
                                    'Despesas',
                                    AppColors.chartNegative,
                                    selected: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              ReceitasDespesasChart(
                                pontos: [mes],
                                height: 168,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Um único mês selecionado, sem projeção de evolução.',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SectionHeader(
                    title: 'Últimas transações',
                    subtitle: 'Movimentações recentes',
                    trailing: GestureDetector(
                      onTap: widget.onAbrirMovimentacoes,
                      child: const Row(
                        children: [
                          Text(
                            'Ver todas',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 15,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SurfaceCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        TransactionTile(
                          title: 'Salário',
                          subtitle: 'Receita • 15 Out',
                          value: formatarMoeda(325000, comSinal: true),
                          icon: Icons.work_outline_rounded,
                          isExpense: false,
                          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                        ),
                        TransactionTile(
                          title: 'Mercado',
                          subtitle: 'Alimentação • 10 Out',
                          value: formatarMoeda(-14250),
                          icon: Icons.shopping_cart_outlined,
                          isExpense: true,
                          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                        ),
                        TransactionTile(
                          title: 'Internet',
                          subtitle: 'Serviços • 05 Out',
                          value: formatarMoeda(-9990),
                          icon: Icons.wifi_rounded,
                          isExpense: true,
                          showDivider: false,
                          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _legendDot(String label, Color color, {bool selected = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5.5,
          height: 5.5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 7.5,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            color: AppColors.textBody,
          ),
        ),
      ],
    );
  }
}

