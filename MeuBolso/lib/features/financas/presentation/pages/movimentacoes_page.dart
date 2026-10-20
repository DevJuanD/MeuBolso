import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/meubolso_logo.dart';
import '../../data/dados_demonstracao.dart';
import '../../domain/models/movimentacao.dart';
import '../controllers/financas_controller.dart';
import '../widgets/finance_widgets.dart';
import '../widgets/form_widgets.dart';
import '../widgets/meubolso_bottom_nav.dart';
import '../widgets/report_widgets.dart';
import 'despesa_form_page.dart';
import 'receita_form_page.dart';

class MovimentacoesPage extends StatefulWidget {
  final FinancasController controller;
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

  Future<void> _editar(Movimentacao movimentacao) async {
    if (movimentacao.tipo.isReceita) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ReceitaFormPage(
            controller: widget.controller,
            receita: movimentacao,
          ),
        ),
      );
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DespesaFormPage(
            controller: widget.controller,
            despesa: movimentacao,
          ),
        ),
      );
    }
  }

  Future<void> _excluir(Movimentacao movimentacao) async {
    final isReceita = movimentacao.tipo.isReceita;
    final confirmou = isReceita
        ? await mostrarDialogoExcluirReceita(context)
        : await mostrarDialogoExcluirDespesa(context);
    if (!confirmou || !mounted) return;

    if (isReceita) {
      widget.controller.excluirReceita(movimentacao);
    } else {
      widget.controller.excluirDespesa(movimentacao);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Movimentação excluída.'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            if (isReceita) {
              widget.controller.desfazerExclusaoReceita();
            } else {
              widget.controller.desfazerExclusaoDespesa();
            }
          },
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
        final movimentacoes = relatorio.movimentacoes.where((m) {
          if (_filtro == 'Receitas') return m.tipo.isReceita;
          if (_filtro == 'Despesas') return !m.tipo.isReceita;
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
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 19,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
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
                            SizedBox(height: 5),
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
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            relatorio.tituloPeriodo,
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Text(
                          '${movimentacoes.length} itens',
                          style: const TextStyle(
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
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 36),
                            child: Center(
                              child: Text(
                                'Nenhuma movimentação neste filtro.',
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
                                  '${movimentacoes[i].categoria} • ${formatarDataCurta(movimentacoes[i].data)}',
                              value: formatarMoeda(
                                movimentacoes[i].tipo.isReceita
                                    ? movimentacoes[i].valorCentavos
                                    : -movimentacoes[i].valorCentavos,
                                comSinal: true,
                              ),
                              icon: DadosDemonstracao.iconeCategoria(
                                movimentacoes[i].categoria,
                              ),
                              isExpense: !movimentacoes[i].tipo.isReceita,
                              showDivider: i < movimentacoes.length - 1,
                              showTypeLabel: true,
                              padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
                              onTap: () => _editar(movimentacoes[i]),
                              trailing: PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                splashRadius: 18,
                                icon: const Icon(
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
                    'Resumo financeiro do período: receitas de ${formatarMoeda(relatorio.totalReceitasCentavos)} e despesas de ${formatarMoeda(relatorio.totalDespesasCentavos)}.',
                    style: const TextStyle(
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
