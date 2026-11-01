import 'package:flutter/material.dart';

import '../../../../core/navegacao/rotas_app.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatador_moeda.dart';
import '../../../../core/utils/icone_categoria.dart';
import '../../domain/entities/transacao.dart';
import '../controllers/transacoes_controller.dart';
import '../../../financas/presentation/widgets/app_header.dart';
import '../../../financas/presentation/widgets/finance_widgets.dart';
import '../../../financas/presentation/widgets/form_widgets.dart';
import '../../../financas/presentation/widgets/meubolso_bottom_nav.dart';

class TransacoesPage extends StatefulWidget {
  final TransacoesController controller;
  final ValueChanged<int> onAbaSelecionada;
  final VoidCallback? onAbrirMovimentacoes;

  const TransacoesPage({
    super.key,
    required this.controller,
    required this.onAbaSelecionada,
    this.onAbrirMovimentacoes,
  });

  @override
  State<TransacoesPage> createState() => _TransacoesPageState();
}

class _TransacoesPageState extends State<TransacoesPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.carregar();
  }

  Future<void> _abrirSeletorTipo() async {
    final opcao = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Adicionar transação',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: AppColors.textHeading,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Escolha o tipo para continuar',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                _OpcaoTipo(
                  titulo: 'Receita',
                  descricao: 'Adicionar uma entrada',
                  cor: const Color(0xFF22C55E),
                  onTap: () => Navigator.of(sheetContext).pop('receita'),
                ),
                const SizedBox(height: 10),
                _OpcaoTipo(
                  titulo: 'Despesa',
                  descricao: 'Adicionar um gasto',
                  cor: const Color(0xFFEF4444),
                  onTap: () => Navigator.of(sheetContext).pop('despesa'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || opcao == null) return;
    if (opcao == 'receita') {
      await Navigator.of(context).pushNamed(RotasApp.receitaForm);
    } else if (opcao == 'despesa') {
      await Navigator.of(context).pushNamed(RotasApp.despesaForm);
    }
  }

  Future<void> _editar(Transacao transacao) async {
    final rota = transacao.isReceita
        ? RotasApp.receitaForm
        : RotasApp.despesaForm;
    await Navigator.of(context).pushNamed(rota, arguments: transacao);
  }

  Future<void> _excluir(Transacao transacao) async {
    final confirmou = transacao.isReceita
        ? await mostrarDialogoExcluirReceita(context)
        : await mostrarDialogoExcluirDespesa(context);
    if (!confirmou || !mounted) return;

    final sucesso = await widget.controller.excluir(transacao);
    if (!mounted) return;

    if (!sucesso) {
      final erro = widget.controller.mensagemErro;
      if (erro != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(erro)));
        widget.controller.limparErro();
      }
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transação excluída.'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: widget.controller.restaurarUltimaExclusao,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        final transacoes = controller.transacoes;

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
                    title: 'Transações',
                    subtitle: 'Todas as receitas e despesas',
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
                    label: 'Saldo do mês',
                    value: FormatadorMoeda.formatar(controller.saldoCentavos),
                    illustration: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.swap_vert_rounded,
                        size: 21,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                  const SectionHeader(title: 'Movimentações'),
                  SurfaceCard(
                    padding: EdgeInsets.zero,
                    child: transacoes.isEmpty
                        ? _MensagemVazia(
                            texto: controller.carregando
                                ? 'Carregando transações...'
                                : 'Nenhuma transação registrada neste mês.',
                          )
                        : Column(
                            children: [
                              for (var i = 0; i < transacoes.length; i++)
                                TransactionTile(
                                  title: transacoes[i].descricao,
                                  subtitle:
                                      FormatadorMoeda.formatarDataAbreviada(
                                        transacoes[i].data,
                                      ),
                                  value: FormatadorMoeda.formatar(
                                    transacoes[i].isReceita
                                        ? transacoes[i].valorCentavos
                                        : -transacoes[i].valorCentavos,
                                    comSinal: true,
                                  ),
                                  icon: iconeParaCategoria(
                                    transacoes[i].categoria,
                                  ),
                                  isExpense: transacoes[i].isDespesa,
                                  showDivider: i < transacoes.length - 1,
                                  padding: const EdgeInsets.fromLTRB(
                                    14,
                                    14,
                                    8,
                                    14,
                                  ),
                                  onTap: () => _editar(transacoes[i]),
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
                                        _editar(transacoes[i]);
                                      } else {
                                        _excluir(transacoes[i]);
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
                                              'Editar transação',
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
                                            borderRadius: BorderRadius.circular(
                                              11,
                                            ),
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
                                                'Excluir transação',
                                                style: TextStyle(
                                                  fontFamily: 'PlusJakartaSans',
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
                  const SizedBox(height: 16),
                  PillButton(
                    label: 'Adicionar Transação',
                    onTap: _abrirSeletorTipo,
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

class _OpcaoTipo extends StatelessWidget {
  final String titulo;
  final String descricao;
  final Color cor;
  final VoidCallback onTap;

  const _OpcaoTipo({
    required this.titulo,
    required this.descricao,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 11, 10, 11),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                titulo == 'Receita'
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                size: 19,
                color: cor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeading,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    descricao,
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
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
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
