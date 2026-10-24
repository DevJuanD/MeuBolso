import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/relatorios/data/datasources/relatorio_local_datasource.dart';
import 'package:meu_bolso/features/relatorios/data/models/gasto_categoria_bruto.dart';
import 'package:meu_bolso/features/relatorios/data/models/totais_periodo_bruto.dart';
import 'package:meu_bolso/features/relatorios/data/repositories/relatorio_repository_impl.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/evolucao_mensal.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/filtro_relatorio.dart';

class _FakeRelatorioLocalDataSource implements RelatorioLocalDataSource {
  TotaisPeriodoBruto totais = const TotaisPeriodoBruto(
    totalReceitas: 0,
    totalDespesas: 0,
  );
  List<GastoCategoriaBruto> gastos = const [];
  List<EvolucaoMensal> evolucao = const [];

  FiltroRelatorio? ultimoFiltroTotais;
  FiltroRelatorio? ultimoFiltroGastos;
  FiltroRelatorio? ultimoFiltroEvolucao;

  @override
  Future<TotaisPeriodoBruto> obterTotais(FiltroRelatorio filtro) async {
    ultimoFiltroTotais = filtro;
    return totais;
  }

  @override
  Future<List<GastoCategoriaBruto>> obterGastosPorCategoria(
    FiltroRelatorio filtro,
  ) async {
    ultimoFiltroGastos = filtro;
    return gastos;
  }

  @override
  Future<List<EvolucaoMensal>> obterEvolucaoMensal(
    FiltroRelatorio filtro,
  ) async {
    ultimoFiltroEvolucao = filtro;
    return evolucao;
  }
}

void main() {
  group('RelatorioRepositoryImpl', () {
    late _FakeRelatorioLocalDataSource dataSource;
    late RelatorioRepositoryImpl repositorio;
    const filtro = FiltroRelatorio();

    setUp(() {
      dataSource = _FakeRelatorioLocalDataSource();
      repositorio = RelatorioRepositoryImpl(dataSource);
    });

    test('obterTotais calcula o saldo como receitas menos despesas', () async {
      dataSource.totais = const TotaisPeriodoBruto(
        totalReceitas: 325000,
        totalDespesas: 132000,
      );

      final totais = await repositorio.obterTotais(filtro);

      expect(totais.totalReceitas, 325000);
      expect(totais.totalDespesas, 132000);
      expect(totais.saldo, 193000);
      expect(dataSource.ultimoFiltroTotais, filtro);
    });

    test('obterTotais permite saldo negativo quando despesas superam receitas',
        () async {
      dataSource.totais = const TotaisPeriodoBruto(
        totalReceitas: 50000,
        totalDespesas: 80000,
      );

      final totais = await repositorio.obterTotais(filtro);

      expect(totais.saldo, -30000);
    });

    test('obterGastosPorCategoria calcula o percentual de cada categoria',
        () async {
      dataSource.gastos = const [
        GastoCategoriaBruto(categoriaNome: 'Alimentação', totalCentavos: 60000),
        GastoCategoriaBruto(categoriaNome: 'Transporte', totalCentavos: 30000),
        GastoCategoriaBruto(categoriaNome: 'Lazer', totalCentavos: 10000),
      ];

      final gastos = await repositorio.obterGastosPorCategoria(filtro);

      expect(gastos, hasLength(3));
      expect(gastos[0].categoriaNome, 'Alimentação');
      expect(gastos[0].percentual, closeTo(60, 0.001));
      expect(gastos[1].percentual, closeTo(30, 0.001));
      expect(gastos[2].percentual, closeTo(10, 0.001));
      expect(
        gastos.fold<double>(0, (soma, item) => soma + item.percentual),
        closeTo(100, 0.001),
      );
      expect(dataSource.ultimoFiltroGastos, filtro);
    });

    test('obterGastosPorCategoria retorna percentual zero sem despesas',
        () async {
      dataSource.gastos = const [];

      final gastos = await repositorio.obterGastosPorCategoria(filtro);

      expect(gastos, isEmpty);
    });

    test('obterEvolucaoMensal delega os dados ao DataSource', () async {
      dataSource.evolucao = const [
        EvolucaoMensal(
          competencia: '2026-08',
          totalReceitas: 300000,
          totalDespesas: 150000,
        ),
        EvolucaoMensal(
          competencia: '2026-09',
          totalReceitas: 320000,
          totalDespesas: 180000,
        ),
      ];

      final evolucao = await repositorio.obterEvolucaoMensal(filtro);

      expect(evolucao, hasLength(2));
      expect(evolucao.first.competencia, '2026-08');
      expect(evolucao.last.totalDespesas, 180000);
      expect(dataSource.ultimoFiltroEvolucao, filtro);
    });
  });
}
