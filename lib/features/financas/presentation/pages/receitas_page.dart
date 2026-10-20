import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/dados_demonstracao.dart';
import '../../domain/models/movimentacao.dart';
import '../controllers/financas_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/finance_widgets.dart';
import '../widgets/form_widgets.dart';
import '../widgets/meubolso_bottom_nav.dart';
import 'receita_form_page.dart';

class ReceitasPage extends StatelessWidget {
  final FinancasController controller;
  final ValueChanged<int> onAbaSelecionada;

  const ReceitasPage({
    super.key,
    required this.controller,
    required this.onAbaSelecionada,
  });

  Future<void> _abrirFormulario(
    BuildContext context, {
    Movimentacao? receita,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReceitaFormPage(
          controller: controller,
          receita: receita,
        ),
      ),
    );
  }

  Future<void> _excluir(BuildContext context, Movimentacao receita) async {
    final confirmado = await mostrarDialogoExcluirReceita(context);
    if (!confirmado) return;
    controller.excluirReceita(receita);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Receita excluída.'),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.white,
          onPressed: controller.desfazerExclusaoReceita,
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
            selectedIndex: 0,
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
                    title: 'Minhas receitas',
                    subtitle: 'Veja o dinheiro que entrou',
                  ),
                  const MonthSelector(label: 'Outubro 2026'),
                  const SizedBox(height: 16),
                  PrimaryBalanceCard(
                    label: 'Total recebido no mês',
                    value: formatarMoeda(controller.totalReceitasCentavos),
                    illustration: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.download_rounded,
                        size: 21,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                  const SectionHeader(title: 'Receitas recebidas'),
                  SurfaceCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < controller.receitas.length; i++)
                          TransactionTile(
                            title: controller.receitas[i].descricao,
                            subtitle: formatarDataAbreviada(
                              controller.receitas[i].data,
                            ),
                            value: formatarMoeda(
                              controller.receitas[i].valorCentavos,
                            ),
                            icon: DadosDemonstracao.iconeReceita(
                              controller.receitas[i].categoria,
                            ),
                            isExpense: false,
                            showDivider: i < controller.receitas.length - 1,
                            padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                            trailing: controller.mostrarAcoesReceitas
                                ? PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    iconSize: 18,
                                    color: AppColors.surface,
                                    surfaceTintColor: Colors.transparent,
                                    elevation: 10,
                                    position: PopupMenuPosition.under,
                                    offset: const Offset(-70, 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    icon: Icon(
                                      Icons.more_vert_rounded,
                                      color: AppColors.textSecondary,
                                    ),
                                    onSelected: (opcao) {
                                      if (opcao == 'editar') {
                                        _abrirFormulario(
                                          context,
                                          receita: controller.receitas[i],
                                        );
                                      } else {
                                        _excluir(
                                          context,
                                          controller.receitas[i],
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'editar',
                                        height: 39,
                                        child: Text(
                                          'Editar receita',
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textHeading,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'excluir',
                                        height: 39,
                                        child: Text(
                                          'Excluir receita',
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.danger,
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
                  const SizedBox(height: 22),
                  PillButton(
                    label: '+ Adicionar receita',
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
