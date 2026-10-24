import '../entities/evolucao_mensal.dart';
import '../entities/filtro_relatorio.dart';
import '../exceptions/falhas_relatorio.dart';
import '../repositories/relatorio_repository.dart';

/// Caso de uso para obter a evolução mensal de receitas e despesas.
class ObterEvolucaoMensalUseCase {
  final RelatorioRepository _repositorio;

  const ObterEvolucaoMensalUseCase(this._repositorio);

  Future<List<EvolucaoMensal>> call(FiltroRelatorio filtro) {
    if (!filtro.periodoValido) {
      throw const PeriodoInvalidoException();
    }
    return _repositorio.obterEvolucaoMensal(filtro);
  }
}
