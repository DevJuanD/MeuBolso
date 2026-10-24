import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/app.dart';
import 'package:meu_bolso/dependencias_app.dart';
import 'package:meu_bolso/features/autenticacao/domain/entities/perfil_local.dart';
import 'package:meu_bolso/features/autenticacao/domain/repositories/autenticacao_repository.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/cadastrar_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/login_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/obter_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/verificar_perfil_usecase.dart';
import 'package:meu_bolso/features/categorias/domain/entities/categoria.dart';
import 'package:meu_bolso/features/categorias/domain/repositories/categoria_repository.dart';
import 'package:meu_bolso/features/categorias/domain/usecases/criar_categoria_usecase.dart';
import 'package:meu_bolso/features/categorias/domain/usecases/listar_categorias_por_tipo_usecase.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';
import 'package:meu_bolso/features/dashboard/domain/entities/resumo_mensal.dart';
import 'package:meu_bolso/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:meu_bolso/features/dashboard/domain/usecases/obter_resumo_dashboard_usecase.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/evolucao_mensal.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/filtro_relatorio.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/gasto_por_categoria.dart';
import 'package:meu_bolso/features/relatorios/domain/entities/totais_periodo.dart';
import 'package:meu_bolso/features/relatorios/domain/repositories/relatorio_repository.dart';
import 'package:meu_bolso/features/relatorios/domain/usecases/obter_evolucao_mensal_usecase.dart';
import 'package:meu_bolso/features/relatorios/domain/usecases/obter_gastos_por_categoria_usecase.dart';
import 'package:meu_bolso/features/relatorios/domain/usecases/obter_totais_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/entities/transacao.dart';
import 'package:meu_bolso/features/transacoes/domain/repositories/transacoes_repository.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/excluir_transacao_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/listar_transacoes_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/restaurar_transacao_usecase.dart';
import 'package:meu_bolso/features/transacoes/domain/usecases/salvar_transacao_usecase.dart';

class FakeAutenticacaoRepository implements AutenticacaoRepository {
  PerfilLocal? perfilArmazenado;

  @override
  Future<bool> verificarExistenciaPerfil() async => perfilArmazenado != null;

  @override
  Future<void> cadastrarPerfil(String nome, String email, String senhaClara) async {
    perfilArmazenado = PerfilLocal(nome: nome, email: email);
  }

  @override
  Future<PerfilLocal> realizarLogin(String senhaClara) async => perfilArmazenado!;

  @override
  Future<PerfilLocal?> obterPerfil() async => perfilArmazenado;
}

class FakeDashboardRepository implements DashboardRepository {
  @override
  Future<ResumoMensal> obterResumoMensal(DateTime mesReferencia) async {
    return ResumoMensal(
      mesAtual: DateTime(mesReferencia.year, mesReferencia.month),
      totalReceitas: 325000,
      totalDespesas: 132000,
      saldo: 193000,
      variacaoSaldo: 12.5,
      variacaoReceitas: 8.2,
      variacaoDespesas: -4.7,
    );
  }

  @override
  Future<List<Transacao>> obterUltimasTransacoes(
    DateTime mesReferencia,
    int limite,
  ) async {
    return [
      Transacao(
        descricao: 'Salário',
        valorCentavos: 325000,
        tipo: TipoTransacao.receita,
        categoria: 'Salário',
        data: DateTime(mesReferencia.year, mesReferencia.month, 15),
        competencia:
            '${mesReferencia.year}-${mesReferencia.month.toString().padLeft(2, '0')}',
        criadoEm: DateTime.now(),
      ),
    ];
  }
}

class FakeTransacoesRepository implements TransacoesRepository {
  final List<Transacao> dados = [];
  int _proximoId = 1;

  @override
  Future<void> excluirTransacao(int id) async {
    final indice = dados.indexWhere((t) => t.id == id);
    if (indice != -1) {
      dados[indice] = dados[indice].copyWith(excluidaEm: DateTime.now());
    }
  }

  @override
  Future<List<Transacao>> listarTransacoes({
    TipoTransacao? tipo,
    String? competencia,
    bool incluirExcluidas = false,
  }) async {
    return dados.where((t) {
      if (!incluirExcluidas && t.isExcluida) return false;
      if (tipo != null && t.tipo != tipo) return false;
      if (competencia != null && t.competencia != competencia) return false;
      return true;
    }).toList();
  }

  @override
  Future<Transacao?> obterTransacaoPorId(int id) async {
    for (final transacao in dados) {
      if (transacao.id == id) return transacao;
    }
    return null;
  }

  @override
  Future<void> restaurarTransacao(int id) async {
    final indice = dados.indexWhere((t) => t.id == id);
    if (indice != -1) {
      dados[indice] = dados[indice].copyWith(excluidaEm: null);
    }
  }

  @override
  Future<Transacao> salvarTransacao(Transacao transacao) async {
    if (transacao.id == null) {
      final salva = transacao.copyWith(id: _proximoId++);
      dados.add(salva);
      return salva;
    }
    final indice = dados.indexWhere((t) => t.id == transacao.id);
    if (indice != -1) dados[indice] = transacao;
    return transacao;
  }
}

class FakeCategoriaRepository implements CategoriaRepository {
  final List<Categoria> dados = [];

  @override
  Future<Categoria?> buscarPorNomeETipo(
    String nome,
    TipoTransacao tipo,
  ) async {
    for (final categoria in dados) {
      if (categoria.nome == nome && categoria.tipo == tipo) return categoria;
    }
    return null;
  }

  @override
  Future<List<Categoria>> listarPorTipo(TipoTransacao tipo) async {
    return dados.where((c) => c.tipo == tipo).toList();
  }

  @override
  Future<Categoria?> obterPorId(String id) async {
    for (final categoria in dados) {
      if (categoria.id == id) return categoria;
    }
    return null;
  }

  @override
  Future<Categoria> salvar(Categoria categoria) async {
    dados.add(categoria);
    return categoria;
  }
}

class FakeRelatorioRepository implements RelatorioRepository {
  @override
  Future<List<EvolucaoMensal>> obterEvolucaoMensal(
    FiltroRelatorio filtro,
  ) async {
    return const [];
  }

  @override
  Future<List<GastoPorCategoria>> obterGastosPorCategoria(
    FiltroRelatorio filtro,
  ) async {
    return const [];
  }

  @override
  Future<TotaisPeriodo> obterTotais(FiltroRelatorio filtro) async {
    return const TotaisPeriodo(
      totalReceitas: 0,
      totalDespesas: 0,
      saldo: 0,
    );
  }
}

DependenciasApp _criarDependencias(FakeAutenticacaoRepository autenticacao) {
  final transacoes = FakeTransacoesRepository();
  final categorias = FakeCategoriaRepository();
  final relatorios = FakeRelatorioRepository();

  return DependenciasApp(
    verificarPerfilUseCase: VerificarPerfilUseCase(autenticacao),
    cadastrarPerfilUseCase: CadastrarPerfilUseCase(autenticacao),
    loginUseCase: LoginUseCase(autenticacao),
    obterPerfilUseCase: ObterPerfilUseCase(autenticacao),
    obterResumoDashboardUseCase: ObterResumoDashboardUseCase(
      FakeDashboardRepository(),
    ),
    salvarTransacaoUseCase: SalvarTransacaoUseCase(transacoes),
    listarTransacoesUseCase: ListarTransacoesUseCase(transacoes),
    excluirTransacaoUseCase: ExcluirTransacaoUseCase(transacoes),
    restaurarTransacaoUseCase: RestaurarTransacaoUseCase(transacoes),
    criarCategoriaUseCase: CriarCategoriaUseCase(categorias),
    listarCategoriasPorTipoUseCase: ListarCategoriasPorTipoUseCase(categorias),
    obterTotaisUseCase: ObterTotaisUseCase(relatorios),
    obterGastosPorCategoriaUseCase: ObterGastosPorCategoriaUseCase(relatorios),
    obterEvolucaoMensalUseCase: ObterEvolucaoMensalUseCase(relatorios),
  );
}

void main() {
  testWidgets('MeuBolsoApp carrega tela inicial com sucesso', (tester) async {
    final repo = FakeAutenticacaoRepository();

    await tester.pumpWidget(
      MeuBolsoApp(dependencias: _criarDependencias(repo)),
    );
    await tester.pumpAndSettle();

    expect(find.text('MeuBolso'), findsOneWidget);
    expect(find.text('Crie seu perfil local'), findsOneWidget);
  });

  testWidgets('login abre o dashboard e alterna para o tema escuro',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repo = FakeAutenticacaoRepository();
    await repo.cadastrarPerfil('Juliana', 'juliana@email.com', '123456');

    await tester.pumpWidget(
      MeuBolsoApp(dependencias: _criarDependencias(repo)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Olá, Juliana!'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('VISÃO GERAL'), findsOneWidget);

    await tester.tap(find.text('Mais').last);
    await tester.pumpAndSettle();
    expect(find.text('Tema escuro'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final contexto = tester.element(find.text('Tema escuro'));
    expect(Theme.of(contexto).brightness, Brightness.dark);
  });
}
