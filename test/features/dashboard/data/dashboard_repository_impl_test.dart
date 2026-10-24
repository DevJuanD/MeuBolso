import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:meu_bolso/features/dashboard/data/models/totais_do_mes.dart';
import 'package:meu_bolso/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';
import 'package:meu_bolso/features/transacoes/data/models/transacao_model.dart';
import 'package:meu_bolso/features/core/domain/enums/modalidade_pagamento.dart';

class _FakeDashboardLocalDataSource implements DashboardLocalDataSource {
  final Map<String, TotaisDoMes> totaisPorCompetencia = {};
  final List<TransacaoModel> transacoes = [];

  @override
  Future<TotaisDoMes> obterTotaisPorCompetencia(String competencia) async {
    return totaisPorCompetencia[competencia] ??
        const TotaisDoMes(receitasCentavos: 0, despesasCentavos: 0);
  }

  @override
  Future<List<TransacaoModel>> listarUltimas(
    String competencia,
    int limite,
  ) async {
    final doMes = transacoes.where((t) => t.competencia == competencia).toList()
      ..sort((a, b) => b.data.compareTo(a.data));
    return doMes.take(limite).toList();
  }
}

TransacaoModel _criarTransacao({
  required int id,
  required String competencia,
  required TipoTransacao tipo,
  required int valorCentavos,
  required DateTime data,
}) {
  return TransacaoModel(
    id: id,
    descricao: 'Transação $id',
    valorCentavos: valorCentavos,
    tipo: tipo,
    categoria: 'Outros',
    modalidade: ModalidadePagamento.pix,
    data: data,
    competencia: competencia,
    criadoEm: data,
  );
}

void main() {
  group('DashboardRepositoryImpl', () {
    late _FakeDashboardLocalDataSource fakeDataSource;
    late DashboardRepositoryImpl repositorio;

    setUp(() {
      fakeDataSource = _FakeDashboardLocalDataSource();
      repositorio = DashboardRepositoryImpl(fakeDataSource);
    });

    test('obterResumoMensal calcula saldo e variações frente ao mês anterior',
        () async {
      fakeDataSource.totaisPorCompetencia['2026-10'] = const TotaisDoMes(
        receitasCentavos: 325000,
        despesasCentavos: 132000,
      );
      fakeDataSource.totaisPorCompetencia['2026-09'] = const TotaisDoMes(
        receitasCentavos: 300000,
        despesasCentavos: 140000,
      );

      final resumo = await repositorio.obterResumoMensal(DateTime(2026, 10));

      expect(resumo.mesAtual, DateTime(2026, 10));
      expect(resumo.totalReceitas, 325000);
      expect(resumo.totalDespesas, 132000);
      expect(resumo.saldo, 193000);
      expect(resumo.variacaoReceitas, closeTo(8.33, 0.01));
      expect(resumo.variacaoDespesas, closeTo(-5.71, 0.01));
      expect(resumo.variacaoSaldo, closeTo(20.625, 0.01));
    });

    test('obterResumoMensal retorna variação zero quando mês anterior é vazio',
        () async {
      fakeDataSource.totaisPorCompetencia['2026-10'] = const TotaisDoMes(
        receitasCentavos: 325000,
        despesasCentavos: 132000,
      );

      final resumo = await repositorio.obterResumoMensal(DateTime(2026, 10));

      expect(resumo.variacaoSaldo, 0);
      expect(resumo.variacaoReceitas, 0);
      expect(resumo.variacaoDespesas, 0);
    });

    test('obterUltimasTransacoes respeita o limite informado', () async {
      final mes = DateTime(2026, 10);
      fakeDataSource.transacoes.addAll([
        for (var i = 1; i <= 7; i++)
          _criarTransacao(
            id: i,
            competencia: '2026-10',
            tipo: i.isEven ? TipoTransacao.despesa : TipoTransacao.receita,
            valorCentavos: i * 1000,
            data: DateTime(2026, 10, i),
          ),
      ]);

      final ultimas = await repositorio.obterUltimasTransacoes(mes, 5);

      expect(ultimas, hasLength(5));
      expect(ultimas.map((t) => t.id), [7, 6, 5, 4, 3]);
    });
  });
}
