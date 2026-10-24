import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatador_moeda.dart';
import '../../../financas/presentation/widgets/app_header.dart';
import '../../../financas/presentation/widgets/finance_widgets.dart';
import '../../../financas/presentation/widgets/meubolso_bottom_nav.dart';
import '../../domain/entities/resumo_mensal.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/card_indicador_widget.dart';
import '../widgets/grafico_resumo_widget.dart';

/// Tela T02 (Início): resumo financeiro do mês selecionado.
class DashboardPage extends StatefulWidget {
  final DashboardController controller;
  final VoidCallback onAbrirMovimentacoes;
  final ValueChanged<int> onAbaSelecionada;

  const DashboardPage({
    super.key,
    required this.controller,
    required this.onAbrirMovimentacoes,
    required this.onAbaSelecionada,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.carregar();
  }

  Future<void> _escolherMes() async {
    final atual = widget.controller.mesSelecionado;
    final opcoes = List.generate(
      12,
      (indice) => DateTime(atual.year, atual.month - indice),
    );

    final mesEscolhido = await showModalBottomSheet<DateTime>(
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
                Text(
                  'Selecione o mês',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHeading,
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: opcoes.length,
                    itemBuilder: (context, indice) {
                      final mes = opcoes[indice];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          FormatadorMoeda.formatarMesAno(mes),
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        trailing: mes == atual
                            ? Icon(
                                Icons.check_rounded,
                                color: AppColors.primary,
                              )
                            : null,
                        onTap: () => Navigator.of(context).pop(mes),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (mesEscolhido != null) {
      await widget.controller.selecionarMes(mesEscolhido);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final resumo = widget.controller.resumo;
        return Scaffold(
          backgroundColor: AppColors.background,
          bottomNavigationBar: MeuBolsoBottomNav(
            selectedIndex: 0,
            onSelected: widget.onAbaSelecionada,
          ),
          body: SafeArea(
            bottom: false,
            child: widget.controller.carregando
                ? const Center(child: CircularProgressIndicator())
                : widget.controller.mensagemErro != null
                    ? _MensagemErro(
                        mensagem: widget.controller.mensagemErro!,
                        aoTentarNovamente: widget.controller.carregar,
                      )
                    : _ConteudoDashboard(
                        controller: widget.controller,
                        resumo: resumo!,
                        aoEscolherMes: _escolherMes,
                        aoVerTodas: widget.onAbrirMovimentacoes,
                      ),
          ),
        );
      },
    );
  }
}

class _ConteudoDashboard extends StatelessWidget {
  final DashboardController controller;
  final ResumoMensal resumo;
  final VoidCallback aoEscolherMes;
  final VoidCallback aoVerTodas;

  const _ConteudoDashboard({
    required this.controller,
    required this.resumo,
    required this.aoEscolherMes,
    required this.aoVerTodas,
  });

  String get _saudacao {
    final nome = controller.perfil?.nome.trim();
    return (nome == null || nome.isEmpty) ? 'Olá!' : 'Olá, $nome!';
  }

  @override
  Widget build(BuildContext context) {
    final ultimas = controller.ultimasTransacoes;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHeader(
            showAvatar: true,
            initials: _iniciais(controller.perfil?.nome),
          ),
          Text(
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
          Text(
            _saudacao,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.7,
              color: AppColors.textHeading,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Aqui está um resumo das suas finanças.',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          CardIndicadorWidget(
            tipo: TipoIndicador.saldo,
            rotulo: 'Saldo disponível',
            valorCentavos: resumo.saldo,
            variacaoPercentual: resumo.variacaoSaldo,
            icone: Icons.visibility_outlined,
            destaque: true,
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardIndicadorWidget(
                tipo: TipoIndicador.receita,
                rotulo: 'Receitas',
                valorCentavos: resumo.totalReceitas,
                variacaoPercentual: resumo.variacaoReceitas,
                icone: Icons.arrow_upward_rounded,
              ),
              const SizedBox(width: 9),
              CardIndicadorWidget(
                tipo: TipoIndicador.despesa,
                rotulo: 'Despesas',
                valorCentavos: resumo.totalDespesas,
                variacaoPercentual: resumo.variacaoDespesas,
                icone: Icons.arrow_downward_rounded,
              ),
            ],
          ),
          const SizedBox(height: 17),
          MonthSelector(
            label: FormatadorMoeda.formatarMesAno(resumo.mesAtual),
            onTap: aoEscolherMes,
          ),
          const SizedBox(height: 16),
          SurfaceCard(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 15),
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
                  'Totais do mês • ${FormatadorMoeda.formatarMesAno(resumo.mesAtual)}',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                GraficoResumoWidget(
                  receitasCentavos: resumo.totalReceitas,
                  despesasCentavos: resumo.totalDespesas,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Últimas transações',
            subtitle: 'Movimentações recentes',
            trailing: GestureDetector(
              onTap: aoVerTodas,
              child: Row(
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
                  const SizedBox(width: 2),
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
            child: ultimas.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(18),
                    child: Center(
                      child: Text(
                        'Nenhuma movimentação neste mês.',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < ultimas.length; i++)
                        TransactionTile(
                          title: ultimas[i].descricao,
                          subtitle:
                              '${ultimas[i].categoria} • ${FormatadorMoeda.formatarDataAbreviada(ultimas[i].data)}',
                          value: FormatadorMoeda.formatar(
                            ultimas[i].isDespesa
                                ? -ultimas[i].valorCentavos
                                : ultimas[i].valorCentavos,
                            comSinal: ultimas[i].isReceita,
                          ),
                          icon: _iconeCategoria(ultimas[i].categoria),
                          isExpense: ultimas[i].isDespesa,
                          showDivider: i < ultimas.length - 1,
                          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  static String _iniciais(String? nome) {
    final partes = nome?.trim().split(RegExp(r'\s+')) ?? const [];
    if (partes.isEmpty || partes.first.isEmpty) return 'MB';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes.last.substring(0, 1))
        .toUpperCase();
  }

  /// Mapeia a categoria da transação para um ícone representativo.
  static IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Salário':
        return Icons.work_outline_rounded;
      case 'Freelance':
      case 'Renda extra':
        return Icons.laptop_mac_rounded;
      case 'Vendas':
      case 'Compras':
        return Icons.shopping_bag_outlined;
      case 'Rendimentos':
        return Icons.trending_up_rounded;
      case 'Presente':
        return Icons.card_giftcard_rounded;
      case 'Alimentação':
        return Icons.restaurant_rounded;
      case 'Transporte':
        return Icons.directions_bus_filled_outlined;
      case 'Moradia':
        return Icons.home_outlined;
      case 'Contas e serviços':
      case 'Internet':
        return Icons.wifi_rounded;
      case 'Saúde':
        return Icons.favorite_border_rounded;
      case 'Lazer':
        return Icons.local_activity_outlined;
      case 'Educação':
        return Icons.school_outlined;
      case 'Supermercado':
        return Icons.shopping_cart_outlined;
      case 'Combustível':
        return Icons.local_gas_station_outlined;
      case 'Conta de energia':
        return Icons.lightbulb_outline_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }
}

class _MensagemErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback aoTentarNovamente;

  const _MensagemErro({
    required this.mensagem,
    required this.aoTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            PillButton(
              label: 'Tentar novamente',
              onTap: aoTentarNovamente,
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
