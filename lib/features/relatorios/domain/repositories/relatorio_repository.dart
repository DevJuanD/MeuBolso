import '../entities/evolucao_mensal.dart';
import '../entities/filtro_relatorio.dart';
import '../entities/gasto_por_categoria.dart';
import '../entities/totais_periodo.dart';

/// Contrato de consultas agregadas para os relatórios financeiros (T05).
abstract class RelatorioRepository {
  /// Retorna receitas, despesas e saldo do período filtrado.
  Future<TotaisPeriodo> obterTotais(FiltroRelatorio filtro);

  /// Retorna as despesas agrupadas por categoria, em ordem decrescente de valor.
  Future<List<GastoPorCategoria>> obterGastosPorCategoria(
    FiltroRelatorio filtro,
  );

  /// Retorna receitas e despesas agrupadas por competência (AAAA-MM).
  Future<List<EvolucaoMensal>> obterEvolucaoMensal(FiltroRelatorio filtro);
}
