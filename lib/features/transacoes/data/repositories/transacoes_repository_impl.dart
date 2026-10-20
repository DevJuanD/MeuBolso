import '../../../core/domain/enums/tipo_transacao.dart';
import '../../domain/entities/transacao.dart';
import '../../domain/exceptions/falhas_transacao.dart';
import '../../domain/repositories/transacoes_repository.dart';
import '../datasources/transacoes_local_datasource.dart';
import '../models/transacao_model.dart';

/// Implementação do repositório de transações financeiras utilizando SQLite local.
class TransacoesRepositoryImpl implements TransacoesRepository {
  final TransacoesLocalDataSource _dataSource;

  const TransacoesRepositoryImpl(this._dataSource);

  @override
  Future<Transacao> salvarTransacao(Transacao transacao) async {
    final model = TransacaoModel.deEntidade(transacao);

    if (transacao.id == null) {
      final novoId = await _dataSource.inserir(model);
      return transacao.copyWith(id: novoId);
    } else {
      final linhasAfetadas = await _dataSource.atualizar(model);
      if (linhasAfetadas == 0) {
        throw const TransacaoNaoEncontradaException();
      }
      return transacao;
    }
  }

  @override
  Future<List<Transacao>> listarTransacoes({
    TipoTransacao? tipo,
    String? competencia,
    bool incluirExcluidas = false,
  }) async {
    final modelos = await _dataSource.listar(
      tipo: tipo,
      competencia: competencia,
      incluirExcluidas: incluirExcluidas,
    );
    return modelos.map((m) => m.paraEntidade()).toList();
  }

  @override
  Future<void> excluirTransacao(int id) async {
    final existente = await _dataSource.obterPorId(id);
    if (existente == null) {
      throw const TransacaoNaoEncontradaException();
    }
    await _dataSource.marcarExclusaoLogica(id, DateTime.now());
  }

  @override
  Future<void> restaurarTransacao(int id) async {
    final existente = await _dataSource.obterPorId(id);
    if (existente == null) {
      throw const TransacaoNaoEncontradaException();
    }
    await _dataSource.restaurarExclusaoLogica(id);
  }

  @override
  Future<Transacao?> obterTransacaoPorId(int id) async {
    final model = await _dataSource.obterPorId(id);
    return model?.paraEntidade();
  }
}
