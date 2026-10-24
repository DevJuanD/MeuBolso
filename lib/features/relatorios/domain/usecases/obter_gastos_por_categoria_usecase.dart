import '../entities/filtro_relatorio.dart';
import '../entities/gasto_por_categoria.dart';
import '../exceptions/falhas_relatorio.dart';
import '../repositories/relatorio_repository.dart';

/// Caso de uso para obter as despesas agrupadas por categoria no período.
class ObterGastosPorCategoriaUseCase {
  final RelatorioRepository _repositorio;

  const ObterGastosPorCategoriaUseCase(this._repositorio);

  Future<List<GastoPorCategoria>> call(FiltroRelatorio filtro) {
    if (!filtro.periodoValido) {
      throw const PeriodoInvalidoException();
    }
    return _repositorio.obterGastosPorCategoria(filtro);
  }
}
