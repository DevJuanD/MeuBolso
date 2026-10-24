import '../../domain/entities/evolucao_mensal.dart';
import '../../domain/entities/filtro_relatorio.dart';
import '../../domain/entities/gasto_por_categoria.dart';
import '../../domain/entities/totais_periodo.dart';
import '../../domain/repositories/relatorio_repository.dart';
import '../datasources/relatorio_local_datasource.dart';

/// Implementação do repositório de relatórios sobre o SQLite local.
///
/// Centraliza os cálculos que o SQLite não realiza com precisão em
/// agrupamentos: o saldo do período e o percentual de cada categoria.
class RelatorioRepositoryImpl implements RelatorioRepository {
  final RelatorioLocalDataSource _dataSource;

  const RelatorioRepositoryImpl(this._dataSource);

  @override
  Future<TotaisPeriodo> obterTotais(FiltroRelatorio filtro) async {
    final brutos = await _dataSource.obterTotais(filtro);

    return TotaisPeriodo(
      totalReceitas: brutos.totalReceitas,
      totalDespesas: brutos.totalDespesas,
      saldo: brutos.totalReceitas - brutos.totalDespesas,
    );
  }

  @override
  Future<List<GastoPorCategoria>> obterGastosPorCategoria(
    FiltroRelatorio filtro,
  ) async {
    final brutos = await _dataSource.obterGastosPorCategoria(filtro);
    final totalDespesas = brutos.fold<int>(
      0,
      (soma, item) => soma + item.totalCentavos,
    );

    return brutos
        .map(
          (item) => GastoPorCategoria(
            categoriaNome: item.categoriaNome,
            totalCentavos: item.totalCentavos,
            percentual: _calcularPercentual(item.totalCentavos, totalDespesas),
          ),
        )
        .toList();
  }

  @override
  Future<List<EvolucaoMensal>> obterEvolucaoMensal(
    FiltroRelatorio filtro,
  ) {
    return _dataSource.obterEvolucaoMensal(filtro);
  }

  /// Regra de três simples: participação da categoria no total de despesas.
  static double _calcularPercentual(int totalCategoria, int totalDespesas) {
    if (totalDespesas <= 0) return 0;
    return (totalCategoria / totalDespesas) * 100;
  }
}
