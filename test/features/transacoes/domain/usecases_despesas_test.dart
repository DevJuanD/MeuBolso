import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/core/domain/enums/categoria_despesa.dart';
import 'package:meu_bolso/features/core/domain/enums/modalidade_pagamento.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';
import 'package:meu_bolso/features/transacoes/domain/entities/transacao.dart';
import 'package:meu_bolso/features/transacoes/domain/exceptions/falhas_transacao.dart';
import 'package:meu_bolso/features/transacoes/domain/repositories/transacoes_repository.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/excluir_transacao_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/listar_transacoes_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/obter_transacao_por_id_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/restaurar_transacao_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/salvar_transacao_usecase.dart';

class _FakeTransacoesRepository implements TransacoesRepository {
  final List<Transacao> itens = [];
  int _proximoId = 1;

  @override
  Future<Transacao> salvarTransacao(Transacao transacao) async {
    if (transacao.id == null) {
      final nova = transacao.copyWith(id: _proximoId++);
      itens.add(nova);
      return nova;
    }
    final indice = itens.indexWhere((t) => t.id == transacao.id);
    if (indice == -1) throw const TransacaoNaoEncontradaException();
    itens[indice] = transacao;
    return transacao;
  }

  @override
  Future<List<Transacao>> listarTransacoes({
    TipoTransacao? tipo,
    String? competencia,
    bool incluirExcluidas = false,
  }) async {
    return itens.where((t) {
      if (!incluirExcluidas && t.isExcluida) return false;
      if (tipo != null && t.tipo != tipo) return false;
      if (competencia != null && t.competencia != competencia) return false;
      return true;
    }).toList();
  }

  @override
  Future<void> excluirTransacao(int id) async {
    final indice = itens.indexWhere((t) => t.id == id);
    if (indice == -1) throw const TransacaoNaoEncontradaException();
    itens[indice] = itens[indice].copyWith(excluidaEm: DateTime.now());
  }

  @override
  Future<void> restaurarTransacao(int id) async {
    final indice = itens.indexWhere((t) => t.id == id);
    if (indice == -1) throw const TransacaoNaoEncontradaException();
    itens[indice] = itens[indice].copyWith(excluidaEm: null);
  }

  @override
  Future<Transacao?> obterTransacaoPorId(int id) async {
    final encontrados = itens.where((t) => t.id == id);
    if (encontrados.isEmpty) return null;
    return encontrados.first;
  }
}

void main() {
  group('Gerenciamento de Despesas - Casos de Uso', () {
    late _FakeTransacoesRepository repositorio;
    late SalvarTransacaoUseCase salvarUseCase;
    late ListarTransacoesUseCase listarUseCase;
    late ExcluirTransacaoUseCase excluirUseCase;
    late RestaurarTransacaoUseCase restaurarUseCase;
    late ObterTransacaoPorIdUseCase obterPorIdUseCase;

    setUp(() {
      repositorio = _FakeTransacoesRepository();
      salvarUseCase = SalvarTransacaoUseCase(repositorio);
      listarUseCase = ListarTransacoesUseCase(repositorio);
      excluirUseCase = ExcluirTransacaoUseCase(repositorio);
      restaurarUseCase = RestaurarTransacaoUseCase(repositorio);
      obterPorIdUseCase = ObterTransacaoPorIdUseCase(repositorio);
    });

    test('salva despesa com sucesso e calcula competência quando ausente', () async {
      final despesa = Transacao(
        descricao: '',
        valorCentavos: 15000,
        tipo: TipoTransacao.despesa,
        categoria: CategoriaDespesa.alimentacao.rotulo,
        modalidade: ModalidadePagamento.debito,
        data: DateTime(2026, 10, 15),
        competencia: '',
        criadoEm: DateTime(2026, 10, 15),
      );

      final salva = await salvarUseCase(despesa);

      expect(salva.id, isNotNull);
      expect(salva.descricao, CategoriaDespesa.alimentacao.rotulo);
      expect(salva.competencia, '2026-10');
      expect(salva.isDespesa, isTrue);
      expect(salva.valorCentavos, 15000);
    });

    test('rejeita despesa com valor inválido (zero ou negativo)', () async {
      final despesaInvalida = Transacao(
        descricao: 'Aluguel',
        valorCentavos: 0,
        tipo: TipoTransacao.despesa,
        categoria: CategoriaDespesa.moradia.rotulo,
        data: DateTime(2026, 10, 1),
        competencia: '2026-10',
        criadoEm: DateTime(2026, 10, 1),
      );

      expect(
        () => salvarUseCase(despesaInvalida),
        throwsA(isA<ValorInvalidoException>()),
      );
    });

    test('rejeita despesa sem categoria informada', () async {
      final despesaSemCategoria = Transacao(
        descricao: 'Gasto misterioso',
        valorCentavos: 5000,
        tipo: TipoTransacao.despesa,
        categoria: '   ',
        data: DateTime(2026, 10, 1),
        competencia: '2026-10',
        criadoEm: DateTime(2026, 10, 1),
      );

      expect(
        () => salvarUseCase(despesaSemCategoria),
        throwsA(isA<CategoriaObrigatoriaException>()),
      );
    });

    test('rejeita despesa com descrição excedendo 80 caracteres', () async {
      final despesaTextoLongo = Transacao(
        descricao: 'A' * 81,
        valorCentavos: 2500,
        tipo: TipoTransacao.despesa,
        categoria: CategoriaDespesa.outros.rotulo,
        data: DateTime(2026, 10, 1),
        competencia: '2026-10',
        criadoEm: DateTime(2026, 10, 1),
      );

      expect(
        () => salvarUseCase(despesaTextoLongo),
        throwsA(isA<DescricaoInvalidaException>()),
      );
    });

    test('lista despesas filtrando por tipo e competência com exclusão lógica', () async {
      final d1 = await salvarUseCase(
        Transacao(
          descricao: 'Supermercado',
          valorCentavos: 35000,
          tipo: TipoTransacao.despesa,
          categoria: CategoriaDespesa.alimentacao.rotulo,
          data: DateTime(2026, 10, 5),
          competencia: '2026-10',
          criadoEm: DateTime(2026, 10, 5),
        ),
      );

      await salvarUseCase(
        Transacao(
          descricao: 'Salário',
          valorCentavos: 350000,
          tipo: TipoTransacao.receita,
          categoria: 'Salário',
          data: DateTime(2026, 10, 5),
          competencia: '2026-10',
          criadoEm: DateTime(2026, 10, 5),
        ),
      );

      final apenasDespesas = await listarUseCase(tipo: TipoTransacao.despesa);
      expect(apenasDespesas, hasLength(1));
      expect(apenasDespesas.first.descricao, 'Supermercado');

      // Exclusão lógica
      await excluirUseCase(d1.id!);

      final ativas = await listarUseCase(tipo: TipoTransacao.despesa);
      expect(ativas, isEmpty);

      final todas = await listarUseCase(
        tipo: TipoTransacao.despesa,
        incluirExcluidas: true,
      );
      expect(todas, hasLength(1));
      expect(todas.first.isExcluida, isTrue);

      // Desfazer exclusão lógica (restaurar)
      await restaurarUseCase(d1.id!);
      final restauradas = await listarUseCase(tipo: TipoTransacao.despesa);
      expect(restauradas, hasLength(1));
      expect(restauradas.first.isExcluida, isFalse);
    });

    test('busca por id ou falha caso id não exista', () async {
      final salva = await salvarUseCase(
        Transacao(
          descricao: 'Farmácia',
          valorCentavos: 4200,
          tipo: TipoTransacao.despesa,
          categoria: CategoriaDespesa.saude.rotulo,
          data: DateTime(2026, 10, 10),
          competencia: '2026-10',
          criadoEm: DateTime(2026, 10, 10),
        ),
      );

      final buscada = await obterPorIdUseCase(salva.id!);
      expect(buscada.descricao, 'Farmácia');

      expect(
        () => obterPorIdUseCase(999),
        throwsA(isA<TransacaoNaoEncontradaException>()),
      );
    });
  });
}
