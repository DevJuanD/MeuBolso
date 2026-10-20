import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/meubolso_logo.dart';
import '../../data/dados_demonstracao.dart';
import '../../domain/models/movimentacao.dart';
import '../../domain/models/relatorio.dart';
import '../controllers/financas_controller.dart';
import '../widgets/finance_widgets.dart';
import '../widgets/financial_chart.dart';
import '../widgets/meubolso_bottom_nav.dart';
import '../widgets/report_widgets.dart';
import 'filtros_relatorio_page.dart';
import 'movimentacoes_page.dart';

class RelatoriosPage extends StatefulWidget {
  final FinancasController controller;
  final ValueChanged<int> onAbaSelecionada;

  const RelatoriosPage({
    super.key,
    required this.controller,
    required this.onAbaSelecionada,
  });

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  String _filtroMovimentacoes = 'Todas';

  void _abrirFiltros() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FiltrosRelatorioPage(
          controller: widget.controller,
          onAbaSelecionada: widget.onAbaSelecionada,
        ),
      ),
    );
  }

  void _abrirMovimentacoes() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovimentacoesPage(
          controller: widget.controller,
          onAbaSelecionada: widget.onAbaSelecionada,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final relatorio = widget.controller.relatorio;
        final filtro = widget.controller.filtro;
        return Scaffold(
          backgroundColor: AppColors.background,
          bottomNavigationBar: MeuBolsoBottomNav(
            selectedIndex: 2,
            onSelected: widget.onAbaSelecionada,
          ),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const MeuBolsoLogo(),
                      const Spacer(),
                      InkWell(
                        onTap: _abrirFiltros,
                        borderRadius: BorderRadius.circular(11),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Icon(
                            Icons.calendar_month_outlined,
                            size: 19,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Relatórios financeiros',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      letterSpacing: -0.7,
                      color: AppColors.textHeading,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Entenda para onde seu dinheiro vai',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: _abrirFiltros,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x071E293B),
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(
                              Icons.filter_alt_outlined,
                              size: 17,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  relatorio.tituloPeriodo,
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textHeading,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${filtro.tipo.rotulo} • ${filtro.categoria}',
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
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ReportMetricCard(
                          label: 'Total de receitas',
                          value: formatarMoeda(relatorio.totalReceitasCentavos),
                          icon: Icons.arrow_downward_rounded,
                          positive: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ReportMetricCard(
                          label: 'Total de despesas',
                          value: formatarMoeda(relatorio.totalDespesasCentavos),
                          icon: Icons.arrow_upward_rounded,
                          positive: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ReportBalanceCard(
                    value: formatarMoeda(relatorio.saldoCentavos),
                    helper:
                        'Receitas − despesas. Não é o saldo bancário real.',
                  ),
                  const SizedBox(height: 14),
                  SurfaceCard(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Receitas x Despesas',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHeading,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          relatorio.subtituloGrafico,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            _legend('Receitas', AppColors.chartPositive),
                            const SizedBox(width: 16),
                            _legend('Despesas', AppColors.chartNegative),
                          ],
                        ),
                        const SizedBox(height: 3),
                        ReceitasDespesasChart(
                          pontos: relatorio.pontos,
                          height: 168,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          relatorio.rodapeGrafico,
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
                  const SizedBox(height: 14),
                  SurfaceCard(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Onde você mais gastou',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHeading,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Distribuição das despesas por categoria',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            DonutChart(
                              categorias: relatorio.categorias,
                              totalCentavos: relatorio.totalDespesasCentavos,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MAIOR CATEGORIA',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    relatorio.maiorCategoria?.nome ?? '—',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textHeading,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    relatorio.maiorCategoria == null
                                        ? ''
                                        : '${relatorio.maiorCategoria!.percentual.toStringAsFixed(2).replaceAll('.', ',')}% das despesas',
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
                          ],
                        ),
                        const SizedBox(height: 14),
                        CategoryBreakdown(categorias: relatorio.categorias),
                        const SizedBox(height: 10),
                        Text(
                          'Percentuais arredondados a duas casas decimais.',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 8.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MovementsPanel(
                    relatorio: relatorio,
                    selected: _filtroMovimentacoes,
                    onChanged: (valor) {
                      setState(() => _filtroMovimentacoes = valor);
                    },
                    onVerTodas: _abrirMovimentacoes,
                  ),
                  const SizedBox(height: 14),
                  ComparisonSection(
                    comparativo: relatorio.comparativo,
                    resumo: relatorio.resumoComparativo,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 8,
            fontWeight: FontWeight.w400,
            color: AppColors.textBody,
          ),
        ),
      ],
    );
  }
}

class _MovementsPanel extends StatelessWidget {
  final ConteudoRelatorio relatorio;
  final String selected;
  final ValueChanged<String> onChanged;
  final VoidCallback onVerTodas;

  const _MovementsPanel({
    required this.relatorio,
    required this.selected,
    required this.onChanged,
    required this.onVerTodas,
  });

  @override
  Widget build(BuildContext context) {
    final filtradas = relatorio.movimentacoes.where((m) {
      if (selected == 'Receitas') return m.tipo.isReceita;
      if (selected == 'Despesas') return !m.tipo.isReceita;
      return true;
    }).take(4).toList();

    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Movimentações do período',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textHeading,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Resumo: ${relatorio.movimentacoesResumo} de ${relatorio.totalMovimentacoes} movimentações • não é a lista completa',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 9.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SegmentedTabs(
            options: const ['Todas', 'Receitas', 'Despesas'],
            selected: selected,
            onChanged: onChanged,
          ),
          const SizedBox(height: 8),
          if (filtradas.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Nenhuma movimentação neste filtro.',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            for (var i = 0; i < filtradas.length; i++)
              TransactionTile(
                title: filtradas[i].descricao,
                subtitle:
                    '${filtradas[i].categoria} • ${formatarDataCurta(filtradas[i].data)}',
                value: formatarMoeda(
                  filtradas[i].tipo.isReceita
                      ? filtradas[i].valorCentavos
                      : -filtradas[i].valorCentavos,
                  comSinal: true,
                ),
                icon: DadosDemonstracao.iconeCategoria(
                  filtradas[i].categoria,
                ),
                isExpense: !filtradas[i].tipo.isReceita,
                showDivider: i < filtradas.length - 1,
                showTypeLabel: true,
                smallerValue: true,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: AppColors.primarySofter,
              borderRadius: BorderRadius.circular(11),
              child: InkWell(
                onTap: onVerTodas,
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: AppColors.primarySoft),
                  ),
                  child: Text(
                    'Ver todas as movimentações',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
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
