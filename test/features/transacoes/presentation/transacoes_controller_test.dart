import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/categorias/domain/entities/categoria.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';
import 'package:meu_bolso/features/transacoes/domain/entities/transacao.dart';

import '../../../helpers/fakes_financeiros.dart';

const _categoriaDespesa = Categoria(
  id: 'cat_desp_1',
  nome: 'Alimentação',
  tipo: TipoTransacao.despesa,
);

const _categoriaReceita = Categoria(
  id: 'cat_rec_1',
  nome: 'Salário',
  tipo: TipoTransacao.receita,
);

Transacao _transacao({
  int? id,
  TipoTransacao tipo = TipoTransacao.despesa,
  String categoria = 'Alimentação',
  int valorCentavos = 45000,
  DateTime? data,
  String competencia = '2026-10',
}) {
  return Transacao(
    id: id,
    descricao: 'Supermercado',
    valorCentavos: valorCentavos,
    tipo: tipo,
    categoria: categoria,
    categoriaId: tipo.isReceita ? _categoriaReceita.id : _categoriaDespesa.id,
    data: data ?? DateTime(2026, 10, 10),
    competencia: competencia,
    criadoEm: DateTime(2026, 10, 10),
  );
}

void main() {
  group('TransacoesController', () {
    late FakeTransacoesRepository transacoesRepositorio;
    late FakeCategoriaRepository categoriasRepositorio;

    setUp(() {
      transacoesRepositorio = FakeTransacoesRepository();
      categoriasRepositorio = FakeCategoriaRepository();
    });

    test('carrega somente as transações da competência informada', () async {
      transacoesRepositorio.dados.addAll([
        _transacao(id: 1),
        _transacao(
          id: 2,
          data: DateTime(2026, 11, 3),
          competencia: '2026-11',
        ),
      ]);
      final controller = criarTransacoesController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
      );

      await controller.carregar(mes: DateTime(2026, 10, 20));

      expect(controller.mesReferencia, DateTime(2026, 10));
      expect(controller.competencia, '2026-10');
      expect(controller.transacoes, hasLength(1));
      expect(controller.transacoes.single.id, 1);
      expect(controller.carregando, isFalse);
      expect(controller.mensagemErro, isNull);
    });

    test('carrega as categorias reais separadas por tipo', () async {
      categoriasRepositorio.dados.addAll([
        _categoriaDespesa,
        _categoriaReceita,
      ]);
      final controller = criarTransacoesController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
      );

      await controller.carregar(mes: DateTime(2026, 10));

      expect(controller.categoriasDespesa, [_categoriaDespesa]);
      expect(controller.categoriasReceita, [_categoriaReceita]);
    });

    test('salvarDespesa converte o valor formatado e recarrega do banco',
        () async {
      var recargas = 0;
      final controller = criarTransacoesController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
        aoAlterarDados: () async => recargas++,
      );

      final sucesso = await controller.salvarDespesa(
        descricao: 'Aluguel',
        categoria: _categoriaDespesa,
        valorFormatado: 'R\$ 1.250,00',
        data: DateTime(2026, 10, 5),
      );

      expect(sucesso, isTrue);
      expect(transacoesRepositorio.dados, hasLength(1));
      final salva = transacoesRepositorio.dados.single;
      expect(salva.valorCentavos, 125000);
      expect(salva.categoriaId, _categoriaDespesa.id);
      expect(salva.tipo, TipoTransacao.despesa);
      expect(salva.competencia, '2026-10');
      expect(salva.descricao, 'Aluguel');
      expect(controller.transacoes, hasLength(1));
      expect(controller.totalDespesasCentavos, 125000);
      expect(recargas, 1);
      expect(controller.salvando, isFalse);
    });

    test('salvarReceita grava a transação com o tipo correto', () async {
      final controller = criarTransacoesController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
      );

      final sucesso = await controller.salvarReceita(
        descricao: 'Pagamento',
        categoria: _categoriaReceita,
        valorFormatado: '2.500,00',
        data: DateTime(2026, 10, 7),
      );

      expect(sucesso, isTrue);
      final salva = transacoesRepositorio.dados.single;
      expect(salva.tipo, TipoTransacao.receita);
      expect(salva.valorCentavos, 250000);
      expect(controller.totalReceitasCentavos, 250000);
      expect(controller.saldoCentavos, 250000);
    });

    test('recusa valor zerado sem gravar e informa o erro', () async {
      final controller = criarTransacoesController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
      );

      final sucesso = await controller.salvarDespesa(
        descricao: 'Sem valor',
        categoria: _categoriaDespesa,
        valorFormatado: '0,00',
        data: DateTime(2026, 10, 5),
      );

      expect(sucesso, isFalse);
      expect(controller.mensagemErro, 'Informe um valor maior que zero.');
      expect(transacoesRepositorio.dados, isEmpty);
    });

    test('excluir remove da lista e restaurar desfaz a exclusão', () async {
      transacoesRepositorio.dados.add(_transacao(id: 9));
      var recargas = 0;
      final controller = criarTransacoesController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
        aoAlterarDados: () async => recargas++,
      );

      await controller.carregar(mes: DateTime(2026, 10));
      expect(controller.transacoes, hasLength(1));

      final excluiu = await controller.excluir(controller.transacoes.single);

      expect(excluiu, isTrue);
      expect(controller.transacoes, isEmpty);
      expect(controller.ultimaExcluida?.id, 9);
      expect(transacoesRepositorio.dados.single.isExcluida, isTrue);
      expect(recargas, 1);

      final restaurou = await controller.restaurarUltimaExclusao();

      expect(restaurou, isTrue);
      expect(controller.transacoes, hasLength(1));
      expect(controller.ultimaExcluida, isNull);
      expect(transacoesRepositorio.dados.single.isExcluida, isFalse);
      expect(recargas, 2);
    });

    test('criarCategoria atualiza as categorias em tempo real', () async {
      final controller = criarTransacoesController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
      );
      await controller.carregar(mes: DateTime(2026, 10));
      expect(controller.categoriasDespesa, isEmpty);

      final criada = await controller.criarCategoria(
        'mercado',
        TipoTransacao.despesa,
      );

      expect(criada, isNotNull);
      expect(criada!.nome, 'Mercado');
      expect(controller.categoriasDespesa.single.nome, 'Mercado');
      expect(controller.categoriasReceita, isEmpty);

      final duplicada = await controller.criarCategoria(
        'Mercado',
        TipoTransacao.despesa,
      );

      expect(duplicada, isNull);
      expect(controller.mensagemErro, isNotNull);
      expect(controller.categoriasDespesa, hasLength(1));
    });

    testWidgets('salvarDespesa fecha o formulário pela navigatorKey',
        (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      final controller = criarTransacoesController(
        transacoesRepositorio: transacoesRepositorio,
        categoriasRepositorio: categoriasRepositorio,
        navigatorKey: navigatorKey,
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const Text('inicio'),
        ),
      );
      navigatorKey.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Text('formulario'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('formulario'), findsOneWidget);

      final sucesso = await controller.salvarDespesa(
        descricao: 'Farmácia',
        categoria: _categoriaDespesa,
        valorFormatado: '89,90',
        data: DateTime(2026, 10, 8),
      );
      await tester.pumpAndSettle();

      expect(sucesso, isTrue);
      expect(find.text('formulario'), findsNothing);
      expect(find.text('inicio'), findsOneWidget);
    });
  });
}
