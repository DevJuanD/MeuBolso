import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/dados_demonstracao.dart';
import '../../domain/models/movimentacao.dart';
import '../controllers/financas_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/finance_widgets.dart';
import '../widgets/form_widgets.dart';
import '../widgets/meubolso_bottom_nav.dart';
import 'despesa_form_page.dart';

class DespesasPage extends StatelessWidget {
  final FinancasController controller;
  final ValueChanged<int> onAbaSelecionada;
  final VoidCallback onAbrirMovimentacoes;

  const DespesasPage({
    super.key,
    required this.controller,
    required this.onAbaSelecionada,
    required this.onAbrirMovimentacoes,
  });

  Future<void> _abrirFormulario(
    BuildContext context, {
    Movimentacao? despesa,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DespesaFormPage(
          controller: controller,
          despesa: despesa,
        ),
      ),
    );
  }

  Future<void> _excluir(BuildContext context, Movimentacao despesa) async {
    final confirmado = await mostrarDialogoExcluirDespesa(context);
    if (!confirmado) return;
    controller.excluirDespesa(despesa);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Despesa excluída.'),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.white,
          onPressed: controller.desfazerExclusaoDespesa,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          bottomNavigationBar: MeuBolsoBottomNav(
            selectedIndex: 1,
            onSelected: onAbaSelecionada,
          ),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(),
                  const PageTitle(
                    title: 'Minhas despesas',
                    subtitle: 'Veja para onde seu dinheiro vai',
                  ),
                  const MonthSelector(label: 'Outubro 2026'),
                  const SizedBox(height: 16),
                  PrimaryBalanceCard(
                    label: 'Total gasto no mês',
                    value: formatarMoeda(controller.totalDespesasCentavos),
                    illustration: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.upload_rounded,
                        size: 21,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                  const SectionHeader(title: 'Despesas registradas'),
                  SurfaceCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < controller.despesas.length; i++)
                          TransactionTile(
                            title: controller.despesas[i].descricao,
                            subtitle: formatarDataAbreviada(
                              controller.despesas[i].data,
                            ),
                            value: formatarMoeda(
                              -controller.despesas[i].valorCentavos,
                            ),
                            icon: DadosDemonstracao.iconeDespesa(
                              controller.despesas[i].descricao,
                            ),
                            isExpense: true,
                            showDivider: i < controller.despesas.length - 1,
                            padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                            trailing: controller.mostrarAcoesDespesas
                                ? PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    iconSize: 18,
                                    color: AppColors.surface,
                                    surfaceTintColor: Colors.transparent,
                                    elevation: 12,
                                    position: PopupMenuPosition.under,
                                    offset: const Offset(-140, 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    icon: Icon(
                                      Icons.more_vert_rounded,
                                      color: AppColors.textSecondary,
                                    ),
                                    onSelected: (opcao) {
                                      if (opcao == 'editar') {
                                        _abrirFormulario(
                                          context,
                                          despesa: controller.despesas[i],
                                        );
                                      } else {
                                        _excluir(
                                          context,
                                          controller.despesas[i],
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'editar',
                                        height: 41,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit_outlined,
                                              size: 20,
                                              color: AppColors.textHeading,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Editar despesa',
                                              style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textHeading,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'excluir',
                                        height: 43,
                                        padding: EdgeInsets.zero,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.negativeSoft,
                                            borderRadius:
                                                BorderRadius.circular(11),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete_outline_rounded,
                                                size: 20,
                                                color: AppColors.danger,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                'Excluir despesa',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'PlusJakartaSans',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.danger,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: onAbrirMovimentacoes,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            'Ver todas as despesas',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  PillButton(
                    label: '+ Adicionar despesa',
                    onTap: () => _abrirFormulario(context),
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
