import '../exceptions/falhas_transacao.dart';
import '../repositories/transacoes_repository.dart';

/// Caso de uso para restauração (desfazer exclusão) de uma transação pelo identificador.
class RestaurarTransacaoUseCase {
  final TransacoesRepository _repositorio;

  const RestaurarTransacaoUseCase(this._repositorio);

  Future<void> call(int id) async {
    if (id <= 0) {
      throw const TransacaoNaoEncontradaException();
    }
    await _repositorio.restaurarTransacao(id);
  }
}
