import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/evolucao_mensal.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/filtro_relatorio.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/gasto_por_categoria.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/totais_periodo.dart';
import 'package:meu_bolso/features/relatorios/domain/exceptions/falhas_relatorio.dart';
import 'package:meu_bolso/features/relatorios/domain/repositories/relatorio_repository.dart';
import 'package:meu_bolso/features/relatorios/domain/usecases/obter_evolucao_mensal_usecase.dart';
import 'package:meu_bolso/features/relatorios/domain/usecases/obter_gastos_por_categoria_usecase.dart';
import 'package:meu_bolso/features/relatorios/domain/usecases/obter_totais_usecase.dart';

class _FakeRelatorioRepository implements RelatorioRepository {
  final List<FiltroRelatorio> filtrosRecebidos = [];

  @override
  Future<TotaisPeriodo> obterTotais(FiltroRelatorio filtro) async {
    filtrosRecebidos.add(filtro);
    return const TotaisPeriodo(
      totalReceitas: 100000,
      totalDespesas: 40000,
      saldo: 60000,
    );
  }

  @override
  Future<List<GastoPorCategoria>> obterGastosPorCategoria(
    FiltroRelatorio filtro,
  ) async {
    filtrosRecebidos.add(filtro);
    return const [
      GastoPorCategoria(
        categoriaNome: 'Alimentação',
        totalCentavos: 40000,
        percentual: 100,
      ),
    ];
  }

  @override
  Future<List<EvolucaoMensal>> obterEvolucaoMensal(
    FiltroRelatorio filtro,
  ) async {
    filtrosRecebidos.add(filtro);
    return const [
      EvolucaoMensal(
        competencia: '2026-09',
        totalReceitas: 100000,
        totalDespesas: 40000,
      ),
    ];
  }
}

void main() {
  late _FakeRelatorioRepository repositorio;

  setUp(() {
    repositorio = _FakeRelatorioRepository();
  });

  final periodoInvertido = FiltroRelatorio(
    dataInicial: DateTime(2026, 10, 31),
    dataFinal: DateTime(2026, 10, 1),
  );

  group('ObterTotaisUseCase', () {
    test('delega o filtro ao repositório e retorna os totais', () async {
      final useCase = ObterTotaisUseCase(repositorio);
      const filtro = FiltroRelatorio(tipo: TipoTransacao.despesa);

      final totais = await useCase(filtro);

      expect(totais.saldo, 60000);
      expect(repositorio.filtrosRecebidos, [filtro]);
    });

    test('lança PeriodoInvalidoException quando data inicial > data final',
        () async {
      final useCase = ObterTotaisUseCase(repositorio);

      await expectLater(
        () => useCase(periodoInvertido),
        throwsA(isA<PeriodoInvalidoException>()),
      );
      expect(repositorio.filtrosRecebidos, isEmpty);
    });

    test('aceita período com datas iguais e com apenas uma data', () async {
      final useCase = ObterTotaisUseCase(repositorio);
      final mesmoDia = FiltroRelatorio(
        dataInicial: DateTime(2026, 10, 5),
        dataFinal: DateTime(2026, 10, 5),
      );
      final apenasInicial =
          FiltroRelatorio(dataInicial: DateTime(2026, 10, 5));

      await useCase(mesmoDia);
      await useCase(apenasInicial);

      expect(repositorio.filtrosRecebidos, [mesmoDia, apenasInicial]);
    });
  });

  group('ObterGastosPorCategoriaUseCase', () {
    test('delega o filtro e retorna os gastos por categoria', () async {
      final useCase = ObterGastosPorCategoriaUseCase(repositorio);
      const filtro = FiltroRelatorio(categoriaId: 'padrao_desp_1');

      final gastos = await useCase(filtro);

      expect(gastos.single.categoriaNome, 'Alimentação');
      expect(repositorio.filtrosRecebidos, [filtro]);
    });

    test('lança PeriodoInvalidoException com período invertido', () async {
      final useCase = ObterGastosPorCategoriaUseCase(repositorio);

      await expectLater(
        () => useCase(periodoInvertido),
        throwsA(isA<PeriodoInvalidoException>()),
      );
      expect(repositorio.filtrosRecebidos, isEmpty);
    });
  });

  group('ObterEvolucaoMensalUseCase', () {
    test('delega o filtro e retorna a evolução mensal', () async {
      final useCase = ObterEvolucaoMensalUseCase(repositorio);
      final filtro = FiltroRelatorio(
        dataInicial: DateTime(2026, 1, 1),
        dataFinal: DateTime(2026, 12, 31),
      );

      final evolucao = await useCase(filtro);

      expect(evolucao.single.competencia, '2026-09');
      expect(repositorio.filtrosRecebidos, [filtro]);
    });

    test('lança PeriodoInvalidoException com período invertido', () async {
      final useCase = ObterEvolucaoMensalUseCase(repositorio);

      await expectLater(
        () => useCase(periodoInvertido),
        throwsA(isA<PeriodoInvalidoException>()),
      );
      expect(repositorio.filtrosRecebidos, isEmpty);
    });
  });
}
