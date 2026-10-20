import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/models/movimentacao.dart';
import '../domain/models/relatorio.dart';

abstract final class DadosDemonstracao {
  static List<CategoriaFinanceira> get categoriasReceita => [
    CategoriaFinanceira(
      nome: 'Salário',
      icone: Icons.work_outline_rounded,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Freelance',
      icone: Icons.laptop_mac_rounded,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Vendas',
      icone: Icons.shopping_bag_outlined,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Rendimentos',
      icone: Icons.trending_up_rounded,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Presente',
      icone: Icons.card_giftcard_rounded,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Outros',
      icone: Icons.more_horiz_rounded,
      cor: AppColors.primary,
    ),
  ];

  static List<CategoriaFinanceira> get categoriasDespesa => [
    CategoriaFinanceira(
      nome: 'Alimentação',
      icone: Icons.restaurant_rounded,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Transporte',
      icone: Icons.directions_car_outlined,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Moradia',
      icone: Icons.home_outlined,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Contas e serviços',
      icone: Icons.receipt_long_outlined,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Saúde',
      icone: Icons.favorite_border_rounded,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Lazer',
      icone: Icons.local_activity_outlined,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Compras',
      icone: Icons.shopping_bag_outlined,
      cor: AppColors.primary,
    ),
    CategoriaFinanceira(
      nome: 'Outros',
      icone: Icons.more_horiz_rounded,
      cor: AppColors.primary,
    ),
  ];

  static const List<String> categoriasRelatorio = [
    'Moradia',
    'Alimentação',
    'Transporte',
    'Lazer',
    'Saúde',
    'Contas e serviços',
    'Outros',
    'Salário',
    'Renda extra',
  ];

  static List<Movimentacao> receitasIniciais() => [
        Movimentacao(
          id: 101,
          descricao: 'Salário',
          categoria: 'Salário',
          valorCentavos: 250000,
          data: _data5Out2026,
          tipo: TipoMovimentacao.receita,
        ),
        Movimentacao(
          id: 102,
          descricao: 'Freelance',
          categoria: 'Freelance',
          valorCentavos: 45000,
          data: _data12Out2026,
          tipo: TipoMovimentacao.receita,
        ),
        Movimentacao(
          id: 103,
          descricao: 'Rendimentos',
          categoria: 'Rendimentos',
          valorCentavos: 20000,
          data: _data18Out2026,
          tipo: TipoMovimentacao.receita,
        ),
        Movimentacao(
          id: 104,
          descricao: 'Venda de produto',
          categoria: 'Vendas',
          valorCentavos: 10000,
          data: _data20Out2026,
          tipo: TipoMovimentacao.receita,
        ),
      ];

  static List<Movimentacao> despesasIniciais() => [
        Movimentacao(
          id: 201,
          descricao: 'Supermercado',
          categoria: 'Alimentação',
          valorCentavos: 12000,
          data: _data18Out2026,
          tipo: TipoMovimentacao.despesa,
        ),
        Movimentacao(
          id: 202,
          descricao: 'Combustível',
          categoria: 'Transporte',
          valorCentavos: 8000,
          data: _data17Out2026,
          tipo: TipoMovimentacao.despesa,
        ),
        Movimentacao(
          id: 203,
          descricao: 'Internet',
          categoria: 'Contas e serviços',
          valorCentavos: 10000,
          data: _data15Out2026,
          tipo: TipoMovimentacao.despesa,
        ),
        Movimentacao(
          id: 204,
          descricao: 'Restaurante',
          categoria: 'Alimentação',
          valorCentavos: 6500,
          data: _data14Out2026,
          tipo: TipoMovimentacao.despesa,
        ),
        Movimentacao(
          id: 205,
          descricao: 'Conta de energia',
          categoria: 'Contas e serviços',
          valorCentavos: 15000,
          data: _data12Out2026,
          tipo: TipoMovimentacao.despesa,
        ),
      ];

  static final List<Movimentacao> movimentacoesOutubro2025 = [
    Movimentacao(
      id: 301,
      descricao: 'Papelaria',
      categoria: 'Outros',
      valorCentavos: 3000,
      data: _data28Out2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 302,
      descricao: 'Freelance',
      categoria: 'Renda extra',
      valorCentavos: 25000,
      data: _data25Out2025,
      tipo: TipoMovimentacao.receita,
    ),
    Movimentacao(
      id: 303,
      descricao: 'Internet e celular',
      categoria: 'Contas e serviços',
      valorCentavos: 9000,
      data: _data24Out2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 304,
      descricao: 'Farmácia',
      categoria: 'Saúde',
      valorCentavos: 8000,
      data: _data22Out2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 305,
      descricao: 'Cinema e passeios',
      categoria: 'Lazer',
      valorCentavos: 10000,
      data: _data19Out2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 306,
      descricao: 'Transporte mensal',
      categoria: 'Transporte',
      valorCentavos: 14000,
      data: _data15Out2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 307,
      descricao: 'Mercado',
      categoria: 'Alimentação',
      valorCentavos: 28000,
      data: _data10Out2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 308,
      descricao: 'Aluguel',
      categoria: 'Moradia',
      valorCentavos: 60000,
      data: _data5Out2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 309,
      descricao: 'Salário',
      categoria: 'Salário',
      valorCentavos: 300000,
      data: _data3Out2025,
      tipo: TipoMovimentacao.receita,
    ),
  ];

  static final List<Movimentacao> movimentacoesSetembro2025 = [
    Movimentacao(
      id: 401,
      descricao: 'Papelaria',
      categoria: 'Outros',
      valorCentavos: 3000,
      data: _data27Set2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 402,
      descricao: 'Freelance',
      categoria: 'Renda extra',
      valorCentavos: 20000,
      data: _data25Set2025,
      tipo: TipoMovimentacao.receita,
    ),
    Movimentacao(
      id: 403,
      descricao: 'Internet e celular',
      categoria: 'Contas e serviços',
      valorCentavos: 9000,
      data: _data24Set2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 404,
      descricao: 'Farmácia',
      categoria: 'Saúde',
      valorCentavos: 8000,
      data: _data21Set2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 405,
      descricao: 'Cinema e passeios',
      categoria: 'Lazer',
      valorCentavos: 13000,
      data: _data18Set2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 406,
      descricao: 'Transporte mensal',
      categoria: 'Transporte',
      valorCentavos: 16000,
      data: _data15Set2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 407,
      descricao: 'Mercado',
      categoria: 'Alimentação',
      valorCentavos: 31000,
      data: _data10Set2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 408,
      descricao: 'Aluguel',
      categoria: 'Moradia',
      valorCentavos: 60000,
      data: _data5Set2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 409,
      descricao: 'Salário',
      categoria: 'Salário',
      valorCentavos: 280000,
      data: _data3Set2025,
      tipo: TipoMovimentacao.receita,
    ),
  ];

  static final List<Movimentacao> movimentacoesAgosto2025 = [
    Movimentacao(
      id: 501,
      descricao: 'Papelaria',
      categoria: 'Outros',
      valorCentavos: 6000,
      data: _data28Ago2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 502,
      descricao: 'Freelance',
      categoria: 'Renda extra',
      valorCentavos: 10000,
      data: _data25Ago2025,
      tipo: TipoMovimentacao.receita,
    ),
    Movimentacao(
      id: 503,
      descricao: 'Internet e celular',
      categoria: 'Contas e serviços',
      valorCentavos: 11000,
      data: _data24Ago2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 504,
      descricao: 'Farmácia',
      categoria: 'Saúde',
      valorCentavos: 10000,
      data: _data21Ago2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 505,
      descricao: 'Cinema e passeios',
      categoria: 'Lazer',
      valorCentavos: 14000,
      data: _data18Ago2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 506,
      descricao: 'Transporte mensal',
      categoria: 'Transporte',
      valorCentavos: 18000,
      data: _data15Ago2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 507,
      descricao: 'Mercado',
      categoria: 'Alimentação',
      valorCentavos: 31000,
      data: _data10Ago2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 508,
      descricao: 'Aluguel',
      categoria: 'Moradia',
      valorCentavos: 60000,
      data: _data5Ago2025,
      tipo: TipoMovimentacao.despesa,
    ),
    Movimentacao(
      id: 509,
      descricao: 'Salário',
      categoria: 'Salário',
      valorCentavos: 300000,
      data: _data3Ago2025,
      tipo: TipoMovimentacao.receita,
    ),
  ];

  static List<Movimentacao> _movimentacoesGeradas(int ano, int mes, int id) {
    final ultimoDia = DateTime(ano, mes + 1, 0).day;
    return [
      Movimentacao(
        id: id,
        descricao: 'Papelaria',
        categoria: 'Outros',
        valorCentavos: 3000,
        data: DateTime(ano, mes, ultimoDia - 2),
        tipo: TipoMovimentacao.despesa,
      ),
      Movimentacao(
        id: id + 1,
        descricao: 'Freelance',
        categoria: 'Renda extra',
        valorCentavos: 20000,
        data: DateTime(ano, mes, ultimoDia - 5),
        tipo: TipoMovimentacao.receita,
      ),
      Movimentacao(
        id: id + 2,
        descricao: 'Internet e celular',
        categoria: 'Contas e serviços',
        valorCentavos: 9000,
        data: DateTime(ano, mes, ultimoDia - 7),
        tipo: TipoMovimentacao.despesa,
      ),
      Movimentacao(
        id: id + 3,
        descricao: 'Farmácia',
        categoria: 'Saúde',
        valorCentavos: 8000,
        data: DateTime(ano, mes, ultimoDia - 10),
        tipo: TipoMovimentacao.despesa,
      ),
      Movimentacao(
        id: id + 4,
        descricao: 'Cinema e passeios',
        categoria: 'Lazer',
        valorCentavos: 10000,
        data: DateTime(ano, mes, ultimoDia - 12),
        tipo: TipoMovimentacao.despesa,
      ),
      Movimentacao(
        id: id + 5,
        descricao: 'Transporte mensal',
        categoria: 'Transporte',
        valorCentavos: 14000,
        data: DateTime(ano, mes, ultimoDia - 15),
        tipo: TipoMovimentacao.despesa,
      ),
      Movimentacao(
        id: id + 6,
        descricao: 'Mercado',
        categoria: 'Alimentação',
        valorCentavos: 46000,
        data: DateTime(ano, mes, ultimoDia - 20),
        tipo: TipoMovimentacao.despesa,
      ),
      Movimentacao(
        id: id + 7,
        descricao: 'Aluguel',
        categoria: 'Moradia',
        valorCentavos: 60000,
        data: DateTime(ano, mes, 5),
        tipo: TipoMovimentacao.despesa,
      ),
      Movimentacao(
        id: id + 8,
        descricao: 'Salário',
        categoria: 'Salário',
        valorCentavos: 280000,
        data: DateTime(ano, mes, 3),
        tipo: TipoMovimentacao.receita,
      ),
    ];
  }

  static List<Movimentacao> _movimentacoesDoMes(int mes) {
    switch (mes) {
      case 8:
        return movimentacoesAgosto2025;
      case 9:
        return movimentacoesSetembro2025;
      case 10:
        return movimentacoesOutubro2025;
      default:
        return _movimentacoesGeradas(2025, mes, 600 + mes * 10);
    }
  }

  static final Map<int, List<int>> _totaisPorMes = {
    1: [280000, 140000],
    2: [280000, 140000],
    3: [280000, 140000],
    4: [280000, 140000],
    5: [290000, 150000],
    6: [285000, 150000],
    7: [295000, 150000],
    8: [310000, 150000],
    9: [300000, 140000],
    10: [325000, 132000],
  };

  static List<CategoriaRelatorio> _categoriasDoPeriodo(
    List<Movimentacao> movimentacoes,
  ) {
    const ordem = [
      'Moradia',
      'Alimentação',
      'Transporte',
      'Lazer',
      'Saúde',
      'Contas e serviços',
      'Outros',
    ];
    final despesas = movimentacoes.where((m) => !m.tipo.isReceita);
    final total = despesas.fold<int>(0, (soma, m) => soma + m.valorCentavos);
    if (total == 0) return const [];

    final porCategoria = <String, int>{};
    for (final item in despesas) {
      porCategoria.update(
        item.categoria,
        (valor) => valor + item.valorCentavos,
        ifAbsent: () => item.valorCentavos,
      );
    }

    final resultado = <CategoriaRelatorio>[];
    for (var i = 0; i < ordem.length; i++) {
      final nome = ordem[i];
      final valor = porCategoria[nome] ?? 0;
      if (valor == 0) continue;
      resultado.add(
        CategoriaRelatorio(
          nome: nome,
          valorCentavos: valor,
          percentual: (valor / total) * 100,
          cor: AppColors.categoryPalette[i],
        ),
      );
    }
    return resultado;
  }

  static ConteudoRelatorio relatorio(FiltroRelatorio filtro) {
    switch (filtro.periodo) {
      case PeriodoRelatorio.esteMes:
        return _filtrar(
          _relatorioMensal(),
          filtro,
        );
      case PeriodoRelatorio.ultimoMes:
        return _filtrar(
          _relatorioUltimoMes(),
          filtro,
        );
      case PeriodoRelatorio.ultimos3Meses:
        return _filtrar(
          _relatorioTresMeses(),
          filtro,
        );
      case PeriodoRelatorio.ultimos6Meses:
        return _filtrar(
          _relatorioMultiplosMeses(
            meses: [5, 6, 7, 8, 9, 10],
            titulo: 'Últimos 6 meses • Mai–Out 2025',
            referencia: 'Mai–Out 2025',
            intervalo: '01/05/2025 a 31/10/2025',
            descricaoGrafico: 'Evolução mensal • Maio a outubro de 2025',
            descricaoComparativo:
                'Mai–Out 2025 em relação a Nov 2024–Abr 2025',
            comparativo: const ComparativoPeriodo(
              descricao: 'Mai–Out 2025 em relação a Nov 2024–Abr 2025',
              receitasAnteriorCentavos: 1720000,
              receitasAtualCentavos: 1805000,
              despesasAnteriorCentavos: 910000,
              despesasAtualCentavos: 872000,
              saldoAnteriorCentavos: 810000,
              saldoAtualCentavos: 933000,
              percentualReceitas: '+4,94%',
              percentualDespesas: '−4,18%',
            ),
          ),
          filtro,
        );
      case PeriodoRelatorio.esteAno:
        return _filtrar(
          _relatorioMultiplosMeses(
            meses: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            titulo: 'Este ano • Jan–Out 2025',
            referencia: 'Jan–Out 2025',
            intervalo: '01/01/2025 a 31/10/2025',
            descricaoGrafico: 'Evolução mensal • Janeiro a outubro de 2025',
            descricaoComparativo: '2025 em relação ao mesmo período de 2024',
            comparativo: const ComparativoPeriodo(
              descricao: '2025 em relação ao mesmo período de 2024',
              receitasAnteriorCentavos: 2680000,
              receitasAtualCentavos: 2925000,
              despesasAnteriorCentavos: 1480000,
              despesasAtualCentavos: 1432000,
              saldoAnteriorCentavos: 1200000,
              saldoAtualCentavos: 1493000,
              percentualReceitas: '+9,14%',
              percentualDespesas: '−3,24%',
            ),
          ),
          filtro,
        );
      case PeriodoRelatorio.personalizado:
        final base = _relatorioPersonalizado(filtro.dataInicial, filtro.dataFinal);
        return _filtrar(base, filtro);
    }
  }

  static ConteudoRelatorio _relatorioMensal() {
    final categorias = _categoriasDoPeriodo(movimentacoesOutubro2025);
    const totalReceitas = 325000;
    const totalDespesas = 132000;
    return ConteudoRelatorio(
      tituloPeriodo: 'Este mês • Outubro 2025',
      referencia: 'Outubro 2025',
      intervalo: '01/10/2025 a 31/10/2025',
      totalReceitasCentavos: totalReceitas,
      totalDespesasCentavos: totalDespesas,
      pontos: const [
        PontoGrafico(
          rotulo: 'Out 2025',
          receitasCentavos: 325000,
          despesasCentavos: 132000,
        ),
      ],
      tituloGrafico: 'Receitas x Despesas',
      subtituloGrafico: 'Totais do mês • Outubro de 2025',
      rodapeGrafico: 'Um único mês selecionado, sem projeção de evolução.',
      categorias: categorias,
      movimentacoes: movimentacoesOutubro2025,
      totalMovimentacoes: 9,
      movimentacoesResumo: 4,
      comparativo: const ComparativoPeriodo(
        descricao: 'Outubro de 2025 em relação a setembro de 2025',
        receitasAnteriorCentavos: 300000,
        receitasAtualCentavos: 325000,
        despesasAnteriorCentavos: 140000,
        despesasAtualCentavos: 132000,
        saldoAnteriorCentavos: 160000,
        saldoAtualCentavos: 193000,
        percentualReceitas: '+8,33%',
        percentualDespesas: '−5,71%',
      ),
      resumoComparativo: 'Receitas maiores e despesas menores no período.',
    );
  }

  static ConteudoRelatorio _relatorioUltimoMes() {
    final categorias = _categoriasDoPeriodo(movimentacoesSetembro2025);
    return ConteudoRelatorio(
      tituloPeriodo: 'Último mês • Setembro 2025',
      referencia: 'Setembro 2025',
      intervalo: '01/09/2025 a 30/09/2025',
      totalReceitasCentavos: 300000,
      totalDespesasCentavos: 140000,
      pontos: const [
        PontoGrafico(
          rotulo: 'Set 2025',
          receitasCentavos: 300000,
          despesasCentavos: 140000,
        ),
      ],
      tituloGrafico: 'Receitas x Despesas',
      subtituloGrafico: 'Totais do mês • Setembro de 2025',
      rodapeGrafico: 'Um único mês selecionado, sem projeção de evolução.',
      categorias: categorias,
      movimentacoes: movimentacoesSetembro2025,
      totalMovimentacoes: 9,
      movimentacoesResumo: 4,
      comparativo: const ComparativoPeriodo(
        descricao: 'Setembro de 2025 em relação a agosto de 2025',
        receitasAnteriorCentavos: 310000,
        receitasAtualCentavos: 300000,
        despesasAnteriorCentavos: 150000,
        despesasAtualCentavos: 140000,
        saldoAnteriorCentavos: 160000,
        saldoAtualCentavos: 160000,
        percentualReceitas: '−3,23%',
        percentualDespesas: '−6,67%',
      ),
      resumoComparativo: 'Receitas e despesas menores no período.',
    );
  }

  static ConteudoRelatorio _relatorioTresMeses() {
    final movimentacoes = [
      ...movimentacoesOutubro2025,
      ...movimentacoesSetembro2025,
      ...movimentacoesAgosto2025,
    ]..sort((a, b) => b.data.compareTo(a.data));
    final categorias = _categoriasDoPeriodo(movimentacoes);
    return ConteudoRelatorio(
      tituloPeriodo: 'Últimos 3 meses • Ago–Out 2025',
      referencia: 'Ago–Out 2025',
      intervalo: '01/08/2025 a 31/10/2025',
      totalReceitasCentavos: 935000,
      totalDespesasCentavos: 422000,
      pontos: const [
        PontoGrafico(
          rotulo: 'Ago 2025',
          receitasCentavos: 310000,
          despesasCentavos: 150000,
        ),
        PontoGrafico(
          rotulo: 'Set 2025',
          receitasCentavos: 300000,
          despesasCentavos: 140000,
        ),
        PontoGrafico(
          rotulo: 'Out 2025',
          receitasCentavos: 325000,
          despesasCentavos: 132000,
        ),
      ],
      tituloGrafico: 'Receitas x Despesas',
      subtituloGrafico: 'Evolução mensal • Agosto a outubro de 2025',
      rodapeGrafico: 'Receitas superaram as despesas nos 3 meses.',
      categorias: categorias,
      movimentacoes: movimentacoes,
      totalMovimentacoes: 27,
      movimentacoesResumo: 4,
      comparativo: const ComparativoPeriodo(
        descricao: 'Ago–Out 2025 em relação a Mai–Jul 2025',
        receitasAnteriorCentavos: 870000,
        receitasAtualCentavos: 935000,
        despesasAnteriorCentavos: 450000,
        despesasAtualCentavos: 422000,
        saldoAnteriorCentavos: 420000,
        saldoAtualCentavos: 513000,
        percentualReceitas: '+7,47%',
        percentualDespesas: '−6,22%',
      ),
      resumoComparativo: 'Receitas maiores e despesas menores no período.',
    );
  }

  static ConteudoRelatorio _relatorioMultiplosMeses({
    required List<int> meses,
    required String titulo,
    required String referencia,
    required String intervalo,
    required String descricaoGrafico,
    required String descricaoComparativo,
    required ComparativoPeriodo comparativo,
  }) {
    final movimentacoes = <Movimentacao>[];
    for (final mes in meses) {
      movimentacoes.addAll(_movimentacoesDoMes(mes));
    }
    movimentacoes.sort((a, b) => b.data.compareTo(a.data));

    final pontos = meses
        .map(
          (mes) => PontoGrafico(
            rotulo: formatarMesCurto(DateTime(2025, mes)),
            receitasCentavos: _totaisPorMes[mes]![0],
            despesasCentavos: _totaisPorMes[mes]![1],
          ),
        )
        .toList();

    final totalReceitas = meses.fold<int>(
      0,
      (soma, mes) => soma + _totaisPorMes[mes]![0],
    );
    final totalDespesas = meses.fold<int>(
      0,
      (soma, mes) => soma + _totaisPorMes[mes]![1],
    );

    return ConteudoRelatorio(
      tituloPeriodo: titulo,
      referencia: referencia,
      intervalo: intervalo,
      totalReceitasCentavos: totalReceitas,
      totalDespesasCentavos: totalDespesas,
      pontos: pontos,
      tituloGrafico: 'Receitas x Despesas',
      subtituloGrafico: descricaoGrafico,
      rodapeGrafico: 'Receitas superaram as despesas nos meses selecionados.',
      categorias: _categoriasDoPeriodo(movimentacoes),
      movimentacoes: movimentacoes,
      totalMovimentacoes: movimentacoes.length,
      movimentacoesResumo: 4,
      comparativo: comparativo,
      resumoComparativo: 'Receitas maiores e despesas menores no período.',
    );
  }

  static ConteudoRelatorio _relatorioPersonalizado(
    DateTime inicio,
    DateTime fim,
  ) {
    final todas = <Movimentacao>[];
    for (var mes = 1; mes <= 10; mes++) {
      todas.addAll(_movimentacoesDoMes(mes));
    }
    final filtradas = todas
        .where(
          (m) =>
              !m.data.isBefore(DateTime(inicio.year, inicio.month, inicio.day)) &&
              !m.data.isAfter(DateTime(fim.year, fim.month, fim.day, 23, 59)),
        )
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));

    final totalReceitas = filtradas
        .where((m) => m.tipo.isReceita)
        .fold<int>(0, (soma, m) => soma + m.valorCentavos);
    final totalDespesas = filtradas
        .where((m) => !m.tipo.isReceita)
        .fold<int>(0, (soma, m) => soma + m.valorCentavos);

    return ConteudoRelatorio(
      tituloPeriodo: 'Personalizado • ${formatarDataCurta(inicio)} a ${formatarDataCurta(fim)}',
      referencia: '${formatarDataCurta(inicio)} a ${formatarDataCurta(fim)}',
      intervalo: '${formatarDataCurta(inicio)} a ${formatarDataCurta(fim)}',
      totalReceitasCentavos: totalReceitas,
      totalDespesasCentavos: totalDespesas,
      pontos: [
        PontoGrafico(
          rotulo: formatarMesCurto(inicio),
          receitasCentavos: totalReceitas,
          despesasCentavos: totalDespesas,
        ),
      ],
      tituloGrafico: 'Receitas x Despesas',
      subtituloGrafico: 'Totais do período personalizado',
      rodapeGrafico: 'Período personalizado selecionado nos filtros.',
      categorias: _categoriasDoPeriodo(filtradas),
      movimentacoes: filtradas,
      totalMovimentacoes: filtradas.length,
      movimentacoesResumo: filtradas.length > 4 ? 4 : filtradas.length,
      comparativo: const ComparativoPeriodo(
        descricao: 'Período personalizado em relação ao período anterior',
        receitasAnteriorCentavos: 300000,
        receitasAtualCentavos: 325000,
        despesasAnteriorCentavos: 140000,
        despesasAtualCentavos: 132000,
        saldoAnteriorCentavos: 160000,
        saldoAtualCentavos: 193000,
        percentualReceitas: '+8,33%',
        percentualDespesas: '−5,71%',
      ),
      resumoComparativo: 'Receitas maiores e despesas menores no período.',
    );
  }

  static ConteudoRelatorio _filtrar(
    ConteudoRelatorio base,
    FiltroRelatorio filtro,
  ) {
    var movimentacoes = base.movimentacoes;

    if (filtro.tipo == TipoFiltroRelatorio.receitas) {
      movimentacoes =
          movimentacoes.where((m) => m.tipo.isReceita).toList(growable: false);
    } else if (filtro.tipo == TipoFiltroRelatorio.despesas) {
      movimentacoes =
          movimentacoes.where((m) => !m.tipo.isReceita).toList(growable: false);
    }

    if (filtro.categoria != 'Todas as categorias') {
      movimentacoes = movimentacoes
          .where((m) => m.categoria == filtro.categoria)
          .toList(growable: false);
    }

    final totalReceitas = movimentacoes
        .where((m) => m.tipo.isReceita)
        .fold<int>(0, (soma, m) => soma + m.valorCentavos);
    final totalDespesas = movimentacoes
        .where((m) => !m.tipo.isReceita)
        .fold<int>(0, (soma, m) => soma + m.valorCentavos);

    final semFiltro = filtro.tipo == TipoFiltroRelatorio.todas &&
        filtro.categoria == 'Todas as categorias';

    return base.copyWith(
      movimentacoes: movimentacoes,
      totalReceitasCentavos:
          semFiltro ? base.totalReceitasCentavos : totalReceitas,
      totalDespesasCentavos:
          semFiltro ? base.totalDespesasCentavos : totalDespesas,
    );
  }

  static IconData iconeCategoria(String categoria) {
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
      case 'Internet':
        return Icons.wifi_rounded;
      case 'Restaurante':
        return Icons.restaurant_rounded;
      case 'Conta de energia':
        return Icons.lightbulb_outline_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }

  static IconData iconeDespesa(String descricao) {
    switch (descricao) {
      case 'Supermercado':
        return Icons.shopping_cart_outlined;
      case 'Combustível':
        return Icons.local_gas_station_outlined;
      case 'Internet':
        return Icons.wifi_rounded;
      case 'Restaurante':
        return Icons.restaurant_rounded;
      case 'Conta de energia':
        return Icons.lightbulb_outline_rounded;
      case 'Curso online':
        return Icons.school_outlined;
      default:
        return Icons.more_horiz_rounded;
    }
  }

  static IconData iconeReceita(String categoria) {
    switch (categoria) {
      case 'Salário':
        return Icons.work_outline_rounded;
      case 'Freelance':
        return Icons.laptop_mac_rounded;
      case 'Vendas':
        return Icons.shopping_bag_outlined;
      case 'Rendimentos':
        return Icons.trending_up_rounded;
      case 'Presente':
        return Icons.card_giftcard_rounded;
      case 'Consultoria':
        return Icons.assignment_turned_in_outlined;
      default:
        return Icons.more_horiz_rounded;
    }
  }
}

final _data5Out2026 = DateTime(2026, 10, 5);
final _data12Out2026 = DateTime(2026, 10, 12);
final _data18Out2026 = DateTime(2026, 10, 18);
final _data20Out2026 = DateTime(2026, 10, 20);
final _data17Out2026 = DateTime(2026, 10, 17);
final _data15Out2026 = DateTime(2026, 10, 15);
final _data14Out2026 = DateTime(2026, 10, 14);

final _data3Out2025 = DateTime(2025, 10, 3);
final _data5Out2025 = DateTime(2025, 10, 5);
final _data10Out2025 = DateTime(2025, 10, 10);
final _data15Out2025 = DateTime(2025, 10, 15);
final _data19Out2025 = DateTime(2025, 10, 19);
final _data22Out2025 = DateTime(2025, 10, 22);
final _data24Out2025 = DateTime(2025, 10, 24);
final _data25Out2025 = DateTime(2025, 10, 25);
final _data28Out2025 = DateTime(2025, 10, 28);

final _data3Set2025 = DateTime(2025, 9, 3);
final _data5Set2025 = DateTime(2025, 9, 5);
final _data10Set2025 = DateTime(2025, 9, 10);
final _data15Set2025 = DateTime(2025, 9, 15);
final _data18Set2025 = DateTime(2025, 9, 18);
final _data21Set2025 = DateTime(2025, 9, 21);
final _data24Set2025 = DateTime(2025, 9, 24);
final _data25Set2025 = DateTime(2025, 9, 25);
final _data27Set2025 = DateTime(2025, 9, 27);

final _data3Ago2025 = DateTime(2025, 8, 3);
final _data5Ago2025 = DateTime(2025, 8, 5);
final _data10Ago2025 = DateTime(2025, 8, 10);
final _data15Ago2025 = DateTime(2025, 8, 15);
final _data18Ago2025 = DateTime(2025, 8, 18);
final _data21Ago2025 = DateTime(2025, 8, 21);
final _data24Ago2025 = DateTime(2025, 8, 24);
final _data25Ago2025 = DateTime(2025, 8, 25);
final _data28Ago2025 = DateTime(2025, 8, 28);

