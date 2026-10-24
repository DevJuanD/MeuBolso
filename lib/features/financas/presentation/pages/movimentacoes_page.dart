import 'package:flutter/material.dart';

import '../../../../core/navegacao/rotas_app.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatador_moeda.dart';
import '../../../../core/utils/icone_categoria.dart';
import '../../../../core/widgets/meubolso_logo.dart';
import '../../../transacoes/domain/entities/transacao.dart';
import '../../../transacoes/presentation/controllers/transacoes_controller.dart';
import '../widgets/finance_widgets.dart';
import '../widgets/form_widgets.dart';
import '../widgets/meubolso_bottom_nav.dart';
import '../widgets/report_widgets.dart';

class MovimentacoesPage extends StatefulWidget {
  final TransacoesController controller;
  final ValueChanged<int> onAbaSelecionada;

  const MovimentacoesPage({
    super.key,
    required this.controller,
    required this.onAbaSelecionada,
  });

  @override
  State<MovimentacoesPage> createState() => _MovimentacoesPageState();
}

class _MovimentacoesPageState extends State<MovimentacoesPage> {
  String _filtro = 'Todas';

  @override
  void initState() {
    super.initState();
    widget.controller.carregar();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro)),
        );
        widget.controller.limparErro();
      }
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Movimentação excluída.'),
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
        final movimentacoes = controller.transacoes.where((m) {
          if (_filtro == 'Receitas') return m.isReceita;
          if (_filtro == 'Despesas') return m.isDespesa;
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          bottomNavigationBar: MeuBolsoBottomNav(
            selectedIndex: 0,
            onSelected: widget.onAbaSelecionada,
          ),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MeuBolsoLogo(),
                  const SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(11),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 19,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Movimentações',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                                letterSpacing: -0.6,
                                color: AppColors.textHeading,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Todas as movimentações do período',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
                    decoration: BoxDecoration(
                      color: AppColors.primarySofter,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            FormatadorMoeda.formatarMesAno(
                              controller.mesReferencia,
                            ),
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Text(
                          '${movimentacoes.length} itens',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SurfaceCard(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SegmentedTabs(
                          options: const ['Todas', 'Receitas', 'Despesas'],
                          selected: _filtro,
                          onChanged: (valor) =>
                              setState(() => _filtro = valor),
                        ),
                        const SizedBox(height: 8),
                        if (movimentacoes.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 36),
                            child: Center(
                              child: Text(
                                controller.carregando
                                    ? 'Carregando movimentações...'
                                    : 'Nenhuma movimentação neste filtro.',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        else
                          for (var i = 0; i < movimentacoes.length; i++)
                            TransactionTile(
                              title: movimentacoes[i].descricao,
                              subtitle:
                                  '${movimentacoes[i].categoria} • ${FormatadorMoeda.formatarDataCurta(movimentacoes[i].data)}',
                              value: FormatadorMoeda.formatar(
                                movimentacoes[i].isReceita
                                    ? movimentacoes[i].valorCentavos
                                    : -movimentacoes[i].valorCentavos,
                                comSinal: true,
                              ),
                              icon: iconeParaCategoria(
                                movimentacoes[i].categoria,
                              ),
                              isExpense: movimentacoes[i].isDespesa,
                              showDivider: i < movimentacoes.length - 1,
                              showTypeLabel: true,
                              padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
                              onTap: () => _editar(movimentacoes[i]),
                              trailing: PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                splashRadius: 18,
                                icon: Icon(
                                  Icons.more_vert_rounded,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                                onSelected: (acao) {
                                  if (acao == 'editar') {
                                    _editar(movimentacoes[i]);
                                  } else {
                                    _excluir(movimentacoes[i]);
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: 'editar',
                                    child: Text('Editar'),
                                  ),
                                  PopupMenuItem(
                                    value: 'excluir',
                                    child: Text('Excluir'),
                                  ),
                                ],
                              ),
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Resumo financeiro do período: receitas de '
                    '${FormatadorMoeda.formatar(controller.totalReceitasCentavos)} '
                    'e despesas de '
                    '${FormatadorMoeda.formatar(controller.totalDespesasCentavos)}.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 9.5,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
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
}
