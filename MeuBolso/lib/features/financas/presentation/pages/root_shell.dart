import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/financas_controller.dart';
import 'dashboard_page.dart';
import 'despesas_page.dart';
import 'filtros_relatorio_page.dart';
import 'movimentacoes_page.dart';
import 'receitas_page.dart';
import 'relatorios_page.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  final FinancasController _controller = FinancasController();
  int _aba = 0;

  void _selecionarAba(int indice) {
    if (indice == 3) {
      _abrirMais();
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() => _aba = indice);
  }

  void _voltarAoInicio() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (_aba != 0) {
      setState(() => _aba = 0);
    }
  }

  void _abrirReceitas() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() => _aba = 0);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReceitasPage(
          controller: _controller,
          onAbaSelecionada: _selecionarAba,
        ),
      ),
    );
  }

  void _abrirMovimentacoes() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() => _aba = 0);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovimentacoesPage(
          controller: _controller,
          onAbaSelecionada: _selecionarAba,
        ),
      ),
    );
  }

  void _abrirFiltros() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FiltrosRelatorioPage(
          controller: _controller,
          onAbaSelecionada: _selecionarAba,
        ),
      ),
    );
  }

  Future<void> _abrirMais() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
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
                const Text(
                  'Mais opções',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: AppColors.textHeading,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Acesse outras áreas do MeuBolso',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                _MaisOpcao(
                  icon: Icons.arrow_downward_rounded,
                  titulo: 'Receitas',
                  descricao: 'Veja e gerencie suas entradas',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    setState(() => _aba = 0);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReceitasPage(
                          controller: _controller,
                          onAbaSelecionada: _selecionarAba,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _MaisOpcao(
                  icon: Icons.arrow_upward_rounded,
                  titulo: 'Despesas',
                  descricao: 'Veja e gerencie seus gastos',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _selecionarAba(1);
                  },
                ),
                const SizedBox(height: 10),
                _MaisOpcao(
                  icon: Icons.flag_outlined,
                  titulo: 'relatório',
                  descricao: 'Analise sua vida financeira',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _selecionarAba(2);
                  },
                ),
                const SizedBox(height: 10),
                _MaisOpcao(
                  icon: Icons.home_outlined,
                  titulo: 'Início',
                  descricao: 'Volte para a visão geral',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _voltarAoInicio();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_aba) {
      case 1:
        return DespesasPage(
          controller: _controller,
          onAbaSelecionada: _selecionarAba,
          onAbrirMovimentacoes: _abrirMovimentacoes,
        );
      case 2:
        return RelatoriosPage(
          controller: _controller,
          onAbaSelecionada: _selecionarAba,
        );
      default:
        return DashboardPage(
          controller: _controller,
          onAbrirReceitas: _abrirReceitas,
          onAbrirMovimentacoes: _abrirMovimentacoes,
          onAbrirFiltros: _abrirFiltros,
          onAbaSelecionada: _selecionarAba,
        );
    }
  }
}

class _MaisOpcao extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descricao;
  final VoidCallback onTap;

  const _MaisOpcao({
    required this.icon,
    required this.titulo,
    required this.descricao,
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
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 19, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeading,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    descricao,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
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
