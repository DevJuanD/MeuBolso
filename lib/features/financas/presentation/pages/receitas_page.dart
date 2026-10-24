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

class ReceitasPage extends StatefulWidget {
  final TransacoesController controller;
  final ValueChanged<int> onAbaSelecionada;

  const ReceitasPage({
    super.key,
    required this.controller,
    required this.onAbaSelecionada,
  });

  @override
  State<ReceitasPage> createState() => _ReceitasPageState();
}

class _ReceitasPageState extends State<ReceitasPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.carregar();
  }

  Future<void> _abrirFormulario({Transacao? receita}) async {
    await Navigator.of(context).pushNamed(
      RotasApp.receitaForm,
      arguments: receita,
    );
  }

  Future<void> _excluir(Transacao receita) async {
    final confirmado = await mostrarDialogoExcluirReceita(context);
    if (!confirmado || !mounted) return;

    final sucesso = await widget.controller.excluir(receita);
    if (!mounted) return;

    if (!sucesso) {
      _mostrarErro(widget.controller.mensagemErro);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Receita excluída.'),
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
        final receitas = controller.receitas;

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
                  const AppHeader(),
                  const PageTitle(
                    title: 'Minhas receitas',
                    subtitle: 'Veja o dinheiro que entrou',
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
                    label: 'Total recebido no mês',
                    value: FormatadorMoeda.formatar(
                      controller.totalReceitasCentavos,
                    ),
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
                    child: receitas.isEmpty
                        ? _MensagemVazia(
                            texto: controller.carregando
                                ? 'Carregando receitas...'
                                : 'Nenhuma receita registrada neste mês.',
                          )
                        : Column(
                            children: [
                              for (var i = 0; i < receitas.length; i++)
                                TransactionTile(
                                  title: receitas[i].descricao,
                                  subtitle: FormatadorMoeda.formatarDataAbreviada(
                                    receitas[i].data,
                                  ),
                                  value: FormatadorMoeda.formatar(
                                    receitas[i].valorCentavos,
                                  ),
                                  icon: iconeParaCategoria(
                                    receitas[i].categoria,
                                  ),
                                  isExpense: false,
                                  showDivider: i < receitas.length - 1,
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 14, 8, 14),
                                  trailing: PopupMenuButton<String>(
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
                                          receita: receitas[i],
                                        );
                                      } else {
                                        _excluir(receitas[i]);
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
                                  ),
                                ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 22),
                  PillButton(
                    label: '+ Adicionar receita',
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
