import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/autenticacao/domain/entities/perfil_local.dart';
import 'package:meu_bolso/features/autenticacao/domain/repositories/autenticacao_repository.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/cadastrar_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/login_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/obter_perfil_usecase.dart';
import 'package:meu_bolso/features/autenticacao/domain/usecases/verificar_perfil_usecase.dart';
import 'package:meu_bolso/features/dashboard/domain/entities/resumo_mensal.dart';
import 'package:meu_bolso/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:meu_bolso/features/dashboard/domain/usecases/obter_resumo_dashboard_usecase.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';
import 'package:meu_bolso/features/transacoes/domain/entities/transacao.dart';
import 'package:meu_bolso/app.dart';

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

void main() {
  testWidgets('MeuBolsoApp carrega tela inicial com sucesso', (tester) async {
    final repo = FakeAutenticacaoRepository();

    await tester.pumpWidget(
      MeuBolsoApp(
        verificarPerfilUseCase: VerificarPerfilUseCase(repo),
        cadastrarPerfilUseCase: CadastrarPerfilUseCase(repo),
        loginUseCase: LoginUseCase(repo),
        obterPerfilUseCase: ObterPerfilUseCase(repo),
        obterResumoDashboardUseCase: ObterResumoDashboardUseCase(
          FakeDashboardRepository(),
        ),
      ),
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
      MeuBolsoApp(
        verificarPerfilUseCase: VerificarPerfilUseCase(repo),
        cadastrarPerfilUseCase: CadastrarPerfilUseCase(repo),
        loginUseCase: LoginUseCase(repo),
        obterPerfilUseCase: ObterPerfilUseCase(repo),
        obterResumoDashboardUseCase: ObterResumoDashboardUseCase(
          FakeDashboardRepository(),
        ),
      ),
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
