import 'package:flutter/material.dart';

import '../../../../core/navegacao/rotas_app.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatador_moeda.dart';
import '../../../../core/utils/icone_categoria.dart';
import '../../../transacoes/domain/entities/transacao.dart';
import '../../../transacoes/presentation/controllers/transacoes_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/finance_widgets.dart';
import '../widgets/form_widgets.dart';
import '../widgets/meubolso_bottom_nav.dart';

class DespesasPage extends StatefulWidget {
  final TransacoesController controller;
  final ValueChanged<int> onAbaSelecionada;
  final VoidCallback onAbrirMovimentacoes;

  const DespesasPage({
    super.key,
    required this.controller,
    required this.onAbaSelecionada,
    required this.onAbrirMovimentacoes,
  });

  @override
  State<DespesasPage> createState() => _DespesasPageState();
}

class _DespesasPageState extends State<DespesasPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.carregar();
  }

  Future<void> _abrirFormulario({Transacao? despesa}) async {
    await Navigator.of(context).pushNamed(
      RotasApp.despesaForm,
      arguments: despesa,
    );
  }

  Future<void> _excluir(Transacao despesa) async {
    final confirmado = await mostrarDialogoExcluirDespesa(context);
    if (!confirmado || !mounted) return;

    final sucesso = await widget.controller.excluir(despesa);
    if (!mounted) return;

    if (!sucesso) {
      _mostrarErro(widget.controller.mensagemErro);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Despesa excluída.'),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.white,
          onPressed: widget.controller.restaurarUltimaExclusao,
        ),
      ),
    );
  }

  void _mostrarErro(String? mensagem) {
    if (mensagem == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
    widget.controller.limparErro();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        final despesas = controller.despesas;

        return Scaffold(
          backgroundColor: AppColors.background,
          bottomNavigationBar: MeuBolsoBottomNav(
            selectedIndex: 1,
            onSelected: widget.onAbaSelecionada,
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
                  MonthSelector(
                    label: FormatadorMoeda.formatarMesAno(
                      controller.mesReferencia,
                    ),
                  ),
                  if (controller.carregando) ...[
                    const SizedBox(height: 12),
                    const LinearProgressIndicator(minHeight: 3),
                  ],
                  const SizedBox(height: 16),
                  PrimaryBalanceCard(
                    label: 'Total gasto no mês',
                    value: FormatadorMoeda.formatar(
                      controller.totalDespesasCentavos,
                    ),
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
                    child: despesas.isEmpty
                        ? _MensagemVazia(
                            texto: controller.carregando
                                ? 'Carregando despesas...'
                                : 'Nenhuma despesa registrada neste mês.',
                          )
                        : Column(
                            children: [
                              for (var i = 0; i < despesas.length; i++)
                                TransactionTile(
                                  title: despesas[i].descricao,
                                  subtitle: FormatadorMoeda.formatarDataAbreviada(
                                    despesas[i].data,
                                  ),
                                  value: FormatadorMoeda.formatar(
                                    -despesas[i].valorCentavos,
                                  ),
                                  icon: iconeParaCategoria(
                                    despesas[i].categoria,
                                  ),
                                  isExpense: true,
                                  showDivider: i < despesas.length - 1,
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 14, 8, 14),
                                  trailing: PopupMenuButton<String>(
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
                                          despesa: despesas[i],
                                        );
                                      } else {
                                        _excluir(despesas[i]);
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
                                  ),
                                ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: widget.onAbrirMovimentacoes,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
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
                    onTap: _abrirFormulario,
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

class _MensagemVazia extends StatelessWidget {
  final String texto;

  const _MensagemVazia({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Text(
          texto,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
