import '../../../core/domain/enums/tipo_transacao.dart';
import '../entities/transacao.dart';
import '../repositories/transacoes_repository.dart';

/// Caso de uso para listar transações aplicando filtros opcionais de tipo,
/// competência e inclusão de itens logicamente excluídos.
class ListarTransacoesUseCase {
  final TransacoesRepository _repositorio;

  const ListarTransacoesUseCase(this._repositorio);

  Future<List<Transacao>> call({
    TipoTransacao? tipo,
    String? competencia,
    bool incluirExcluidas = false,
  }) {
    return _repositorio.listarTransacoes(
      tipo: tipo,
      competencia: competencia,
      incluirExcluidas: incluirExcluidas,
    );
  }
}
