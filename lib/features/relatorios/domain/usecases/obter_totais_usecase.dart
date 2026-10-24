import '../entities/filtro_relatorio.dart';
import '../entities/totais_periodo.dart';
import '../exceptions/falhas_relatorio.dart';
import '../repositories/relatorio_repository.dart';

/// Caso de uso para obter os totais de receitas, despesas e saldo do período.
class ObterTotaisUseCase {
  final RelatorioRepository _repositorio;

  const ObterTotaisUseCase(this._repositorio);

  Future<TotaisPeriodo> call(FiltroRelatorio filtro) {
    if (!filtro.periodoValido) {
      throw const PeriodoInvalidoException();
    }
    return _repositorio.obterTotais(filtro);
  }
}
