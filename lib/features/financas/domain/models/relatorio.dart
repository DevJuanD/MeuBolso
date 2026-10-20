import 'movimentacao.dart';

enum PeriodoRelatorio {
  esteMes,
  ultimoMes,
  ultimos3Meses,
  ultimos6Meses,
  esteAno,
  personalizado;

  String get rotulo {
    switch (this) {
      case PeriodoRelatorio.esteMes:
        return 'Este mês';
      case PeriodoRelatorio.ultimoMes:
        return 'Último mês';
      case PeriodoRelatorio.ultimos3Meses:
        return 'Últimos 3 meses';
      case PeriodoRelatorio.ultimos6Meses:
        return 'Últimos 6 meses';
      case PeriodoRelatorio.esteAno:
        return 'Este ano';
      case PeriodoRelatorio.personalizado:
        return 'Personalizado';
    }
  }
}

enum TipoFiltroRelatorio {
  todas,
  receitas,
  despesas;

  String get rotulo {
    switch (this) {
      case TipoFiltroRelatorio.todas:
        return 'Todas';
      case TipoFiltroRelatorio.receitas:
        return 'Receitas';
      case TipoFiltroRelatorio.despesas:
        return 'Despesas';
    }
  }
}

class FiltroRelatorio {
  final PeriodoRelatorio periodo;
  final DateTime dataInicial;
  final DateTime dataFinal;
  final TipoFiltroRelatorio tipo;
  final String categoria;

  const FiltroRelatorio({
    this.periodo = PeriodoRelatorio.esteMes,
    required this.dataInicial,
    required this.dataFinal,
    this.tipo = TipoFiltroRelatorio.todas,
    this.categoria = 'Todas as categorias',
  });

  FiltroRelatorio copyWith({
    PeriodoRelatorio? periodo,
    DateTime? dataInicial,
    DateTime? dataFinal,
    TipoFiltroRelatorio? tipo,
    String? categoria,
  }) {
    return FiltroRelatorio(
      periodo: periodo ?? this.periodo,
      dataInicial: dataInicial ?? this.dataInicial,
      dataFinal: dataFinal ?? this.dataFinal,
      tipo: tipo ?? this.tipo,
      categoria: categoria ?? this.categoria,
    );
  }
}

class PontoGrafico {
  final String rotulo;
  final int receitasCentavos;
  final int despesasCentavos;

  const PontoGrafico({
    required this.rotulo,
    required this.receitasCentavos,
    required this.despesasCentavos,
  });
}

class ComparativoPeriodo {
  final String descricao;
  final int receitasAnteriorCentavos;
  final int receitasAtualCentavos;
  final int despesasAnteriorCentavos;
  final int despesasAtualCentavos;
  final int saldoAnteriorCentavos;
  final int saldoAtualCentavos;
  final String percentualReceitas;
  final String percentualDespesas;

  const ComparativoPeriodo({
    required this.descricao,
    required this.receitasAnteriorCentavos,
    required this.receitasAtualCentavos,
    required this.despesasAnteriorCentavos,
    required this.despesasAtualCentavos,
    required this.saldoAnteriorCentavos,
    required this.saldoAtualCentavos,
    required this.percentualReceitas,
    required this.percentualDespesas,
  });
}

class ConteudoRelatorio {
  final String tituloPeriodo;
  final String referencia;
  final String intervalo;
  final int totalReceitasCentavos;
  final int totalDespesasCentavos;
  final List<PontoGrafico> pontos;
  final String tituloGrafico;
  final String subtituloGrafico;
  final String rodapeGrafico;
  final List<CategoriaRelatorio> categorias;
  final List<Movimentacao> movimentacoes;
  final int totalMovimentacoes;
  final int movimentacoesResumo;
  final ComparativoPeriodo comparativo;
  final String resumoComparativo;

  const ConteudoRelatorio({
    required this.tituloPeriodo,
    required this.referencia,
    required this.intervalo,
    required this.totalReceitasCentavos,
    required this.totalDespesasCentavos,
    required this.pontos,
    required this.tituloGrafico,
    required this.subtituloGrafico,
    required this.rodapeGrafico,
    required this.categorias,
    required this.movimentacoes,
    required this.totalMovimentacoes,
    required this.movimentacoesResumo,
    required this.comparativo,
    required this.resumoComparativo,
  });

  int get saldoCentavos => totalReceitasCentavos - totalDespesasCentavos;

  CategoriaRelatorio? get maiorCategoria =>
      categorias.isEmpty ? null : categorias.first;

  ConteudoRelatorio copyWith({
    List<Movimentacao>? movimentacoes,
    int? totalReceitasCentavos,
    int? totalDespesasCentavos,
  }) {
    return ConteudoRelatorio(
      tituloPeriodo: tituloPeriodo,
      referencia: referencia,
      intervalo: intervalo,
      totalReceitasCentavos:
          totalReceitasCentavos ?? this.totalReceitasCentavos,
      totalDespesasCentavos:
          totalDespesasCentavos ?? this.totalDespesasCentavos,
      pontos: pontos,
      tituloGrafico: tituloGrafico,
      subtituloGrafico: subtituloGrafico,
      rodapeGrafico: rodapeGrafico,
      categorias: categorias,
      movimentacoes: movimentacoes ?? this.movimentacoes,
      totalMovimentacoes: totalMovimentacoes,
      movimentacoesResumo: movimentacoesResumo,
      comparativo: comparativo,
      resumoComparativo: resumoComparativo,
    );
  }
}
