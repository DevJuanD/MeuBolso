import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/meubolso_logo.dart';
import '../../data/dados_demonstracao.dart';
import '../../domain/models/movimentacao.dart';
import '../../domain/models/relatorio.dart';
import '../controllers/financas_controller.dart';
import '../widgets/meubolso_bottom_nav.dart';
import '../widgets/report_widgets.dart';

class FiltrosRelatorioPage extends StatefulWidget {
  final FinancasController controller;
  final ValueChanged<int> onAbaSelecionada;

  const FiltrosRelatorioPage({
    super.key,
    required this.controller,
    required this.onAbaSelecionada,
  });

  @override
  State<FiltrosRelatorioPage> createState() => _FiltrosRelatorioPageState();
}

class _FiltrosRelatorioPageState extends State<FiltrosRelatorioPage> {
  late PeriodoRelatorio _periodo;
  late DateTime _dataInicial;
  late DateTime _dataFinal;
  late TipoFiltroRelatorio _tipo;
  late String _categoria;

  @override
  void initState() {
    super.initState();
    final filtro = widget.controller.filtro;
    _periodo = filtro.periodo;
    _dataInicial = filtro.dataInicial;
    _dataFinal = filtro.dataFinal;
    _tipo = filtro.tipo;
    _categoria = filtro.categoria;
  }

  void _selecionarPeriodo(PeriodoRelatorio periodo) {
    setState(() {
      _periodo = periodo;
      switch (periodo) {
        case PeriodoRelatorio.esteMes:
          _dataInicial = DateTime(2025, 10, 1);
          _dataFinal = DateTime(2025, 10, 31);
        case PeriodoRelatorio.ultimoMes:
          _dataInicial = DateTime(2025, 9, 1);
          _dataFinal = DateTime(2025, 9, 30);
        case PeriodoRelatorio.ultimos3Meses:
          _dataInicial = DateTime(2025, 8, 1);
          _dataFinal = DateTime(2025, 10, 31);
        case PeriodoRelatorio.ultimos6Meses:
          _dataInicial = DateTime(2025, 5, 1);
          _dataFinal = DateTime(2025, 10, 31);
        case PeriodoRelatorio.esteAno:
          _dataInicial = DateTime(2025, 1, 1);
          _dataFinal = DateTime(2025, 10, 31);
        case PeriodoRelatorio.personalizado:
          break;
      }
    });
  }

  String get _referencia {
    switch (_periodo) {
      case PeriodoRelatorio.esteMes:
        return 'Outubro 2025 • mês de referência deste relatório';
      case PeriodoRelatorio.ultimoMes:
        return 'Setembro 2025 • mês de referência deste relatório';
      case PeriodoRelatorio.ultimos3Meses:
        return 'Ago–Out 2025 • período de referência deste relatório';
      case PeriodoRelatorio.ultimos6Meses:
        return 'Mai–Out 2025 • período de referência deste relatório';
      case PeriodoRelatorio.esteAno:
        return 'Jan–Out 2025 • período de referência deste relatório';
      case PeriodoRelatorio.personalizado:
        return '${formatarDataCurta(_dataInicial)} a ${formatarDataCurta(_dataFinal)}';
    }
  }

  Future<void> _escolherData({required bool inicial}) async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: inicial ? _dataInicial : _dataFinal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (selecionada == null || !mounted) return;
    setState(() {
      if (inicial) {
        _dataInicial = selecionada;
      } else {
        _dataFinal = selecionada;
      }
      _periodo = PeriodoRelatorio.personalizado;
    });
  }

  void _aplicar() {
    widget.controller.aplicarFiltro(
      FiltroRelatorio(
        periodo: _periodo,
        dataInicial: _dataInicial,
        dataFinal: _dataFinal,
        tipo: _tipo,
        categoria: _categoria,
      ),
    );
    Navigator.of(context).pop();
  }

  void _limpar() {
    setState(() {
      _periodo = PeriodoRelatorio.esteMes;
      _dataInicial = DateTime(2025, 10, 1);
      _dataFinal = DateTime(2025, 10, 31);
      _tipo = TipoFiltroRelatorio.todas;
      _categoria = 'Todas as categorias';
    });
    widget.controller.limparFiltros();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtros limpos.')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          'Filtros do relatório',
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
                          'Personalize sua análise financeira',
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
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x081E293B),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Período',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeading,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final periodo in PeriodoRelatorio.values)
                          FilterChoice(
                            label: periodo.rotulo,
                            selected: _periodo == periodo,
                            onTap: () => _selecionarPeriodo(periodo),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _referencia,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 9.5,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ou escolha datas personalizadas',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBody,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data inicial',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _FilterDateField(
                                value: formatarDataCurta(_dataInicial),
                                onTap: () => _escolherData(inicial: true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data final',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _FilterDateField(
                                value: formatarDataCurta(_dataFinal),
                                onTap: () => _escolherData(inicial: false),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Tipo de movimentação',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeading,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tipo in TipoFiltroRelatorio.values)
                          FilterChoice(
                            label: tipo.rotulo,
                            selected: _tipo == tipo,
                            onTap: () => setState(() => _tipo = tipo),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Categoria',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeading,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChoice(
                          label: 'Todas as categorias',
                          selected: _categoria == 'Todas as categorias',
                          onTap: () => setState(
                            () => _categoria = 'Todas as categorias',
                          ),
                        ),
                        for (final categoria
                            in DadosDemonstracao.categoriasRelatorio)
                          FilterChoice(
                            label: categoria,
                            selected: _categoria == categoria,
                            onTap: () => setState(() => _categoria = categoria),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _aplicar,
                        icon: const Icon(
                          Icons.filter_alt_outlined,
                          size: 17,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Aplicar filtros',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _limpar,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          backgroundColor: AppColors.primarySofter,
                          side: BorderSide(color: AppColors.primarySoft),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Limpar filtros',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  'Os filtros se aplicam aos indicadores, gráficos, movimentações e prévias do relatório.',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10.5,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterDateField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const _FilterDateField({
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 11.5,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
