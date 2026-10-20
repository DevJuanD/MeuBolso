import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/core/database/esquema_banco.dart';
import 'package:meu_bolso/features/core/domain/enums/categoria_despesa.dart';
import 'package:meu_bolso/features/core/domain/enums/modalidade_pagamento.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';
import 'package:meu_bolso/features/transacoes/data/models/transacao_model.dart';
import 'package:meu_bolso/features/transacoes/domain/entities/transacao.dart';

void main() {
  group('TransacaoModel', () {
    test('converte de entidade para modelo e mapa SQLite para despesa', () {
      final data = DateTime(2026, 10, 18, 14, 30);
      final criadoEm = DateTime(2026, 10, 18, 14, 30);
      final excluidaEm = DateTime(2026, 10, 19, 9, 0);

      final transacao = Transacao(
        id: 42,
        descricao: 'Almoço Executivo',
        valorCentavos: 3590,
        tipo: TipoTransacao.despesa,
        categoria: CategoriaDespesa.alimentacao.rotulo,
        modalidade: ModalidadePagamento.credito,
        data: data,
        competencia: '2026-10',
        recorrenciaId: null,
        excluidaEm: excluidaEm,
        criadoEm: criadoEm,
      );

      final model = TransacaoModel.deEntidade(transacao);
      final mapa = model.paraMapa();

      expect(mapa[EsquemaBanco.colTransacaoId], 42);
      expect(mapa[EsquemaBanco.colTransacaoDescricao], 'Almoço Executivo');
      expect(mapa[EsquemaBanco.colTransacaoValorCentavos], 3590);
      expect(mapa[EsquemaBanco.colTransacaoTipo], 'despesa');
      expect(mapa[EsquemaBanco.colTransacaoCategoria], CategoriaDespesa.alimentacao.rotulo);
      expect(mapa[EsquemaBanco.colTransacaoModalidade], 'credito');
      expect(mapa[EsquemaBanco.colTransacaoDataTransacao], data.toIso8601String());
      expect(mapa[EsquemaBanco.colTransacaoCompetencia], '2026-10');
      expect(mapa[EsquemaBanco.colTransacaoExcluidaEm], excluidaEm.toIso8601String());
      expect(mapa[EsquemaBanco.colTransacaoCriadoEm], criadoEm.toIso8601String());

      final reconstruido = TransacaoModel.doMapa(mapa);
      final entidadeReconstruida = reconstruido.paraEntidade();

      expect(entidadeReconstruida.id, 42);
      expect(entidadeReconstruida.descricao, 'Almoço Executivo');
      expect(entidadeReconstruida.valorCentavos, 3590);
      expect(entidadeReconstruida.isDespesa, isTrue);
      expect(entidadeReconstruida.categoria, CategoriaDespesa.alimentacao.rotulo);
      expect(entidadeReconstruida.modalidade, ModalidadePagamento.credito);
      expect(entidadeReconstruida.excluidaEm, excluidaEm);
      expect(entidadeReconstruida.isExcluida, isTrue);
    });
  });
}
