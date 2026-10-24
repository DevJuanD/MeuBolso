import 'package:flutter/widgets.dart';

import '../../../core/domain/enums/modalidade_pagamento.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../../../core/utils/formatador_moeda.dart';
import '../../../categorias/domain/entities/categoria.dart';
import '../../../categorias/domain/exceptions/falhas_categoria.dart';
import '../../../categorias/domain/usecases/criar_categoria_usecase.dart';
import '../../../categorias/domain/usecases/listar_categorias_por_tipo_usecase.dart';
import '../../domain/entities/transacao.dart';
import '../../domain/exceptions/falhas_transacao.dart';
import '../../domain/usecases/excluir_transacao_usecase.dart';
import '../../domain/usecases/listar_transacoes_usecase.dart';
import '../../domain/usecases/restaurar_transacao_usecase.dart';
import '../../domain/usecases/salvar_transacao_usecase.dart';

/// Controlador de apresentação das telas T03/T04.
///
/// Mantém em memória as transações do mês de referência e as categorias
/// persistidas no SQLite, recarregando tudo após cada mutação para garantir
/// que a interface reflita imediatamente o banco de dados.
class TransacoesController extends ChangeNotifier {
  final SalvarTransacaoUseCase _salvarTransacaoUseCase;
  final ListarTransacoesUseCase _listarTransacoesUseCase;
  final ExcluirTransacaoUseCase _excluirTransacaoUseCase;
  final RestaurarTransacaoUseCase _restaurarTransacaoUseCase;
  final CriarCategoriaUseCase _criarCategoriaUseCase;
  final ListarCategoriasPorTipoUseCase _listarCategoriasPorTipoUseCase;

  /// Notifica a raiz para que dashboard e relatórios também recarreguem.
  final Future<void> Function()? aoAlterarDados;

  /// Chave usada para fechar o formulário após o salvamento com sucesso.
  final GlobalKey<NavigatorState>? navigatorKey;

  TransacoesController({
    required SalvarTransacaoUseCase salvarTransacaoUseCase,
    required ListarTransacoesUseCase listarTransacoesUseCase,
    required ExcluirTransacaoUseCase excluirTransacaoUseCase,
    required RestaurarTransacaoUseCase restaurarTransacaoUseCase,
    required CriarCategoriaUseCase criarCategoriaUseCase,
    required ListarCategoriasPorTipoUseCase listarCategoriasPorTipoUseCase,
    this.aoAlterarDados,
    this.navigatorKey,
  })  : _salvarTransacaoUseCase = salvarTransacaoUseCase,
        _listarTransacoesUseCase = listarTransacoesUseCase,
        _excluirTransacaoUseCase = excluirTransacaoUseCase,
        _restaurarTransacaoUseCase = restaurarTransacaoUseCase,
        _criarCategoriaUseCase = criarCategoriaUseCase,
        _listarCategoriasPorTipoUseCase = listarCategoriasPorTipoUseCase;

  bool _carregando = false;
  bool _salvando = false;
  String? _mensagemErro;

  List<Transacao> _transacoes = const [];
  List<Categoria> _categoriasReceita = const [];
  List<Categoria> _categoriasDespesa = const [];
  Transacao? _ultimaExcluida;

  DateTime _mesReferencia = _iniciarMes(DateTime.now());

  bool get carregando => _carregando;
  bool get salvando => _salvando;
  String? get mensagemErro => _mensagemErro;

  DateTime get mesReferencia => _mesReferencia;

  /// Competência no formato AAAA-MM usada nas consultas do mês atual.
  String get competencia =>
      '${_mesReferencia.year}-${_mesReferencia.month.toString().padLeft(2, '0')}';

  List<Transacao> get transacoes => List.unmodifiable(_transacoes);

  List<Transacao> get receitas =>
      List.unmodifiable(_transacoes.where((t) => t.isReceita));

  List<Transacao> get despesas =>
      List.unmodifiable(_transacoes.where((t) => t.isDespesa));

  List<Categoria> get categoriasReceita => List.unmodifiable(_categoriasReceita);

  List<Categoria> get categoriasDespesa => List.unmodifiable(_categoriasDespesa);

  int get totalReceitasCentavos => _transacoes
      .where((t) => t.isReceita)
      .fold(0, (soma, t) => soma + t.valorCentavos);

  int get totalDespesasCentavos => _transacoes
      .where((t) => t.isDespesa)
      .fold(0, (soma, t) => soma + t.valorCentavos);

  int get saldoCentavos => totalReceitasCentavos - totalDespesasCentavos;

  Transacao? get ultimaExcluida => _ultimaExcluida;

  /// Carrega transações do mês de referência e as categorias persistidas.
  Future<void> carregar({DateTime? mes}) async {
    if (mes != null) {
      _mesReferencia = _iniciarMes(mes);
    }

    _carregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final transacoes = await _listarTransacoesUseCase(
        competencia: competencia,
      );
      await _carregarCategoriasInterno();
      _transacoes = transacoes;
    } catch (_) {
      _mensagemErro = 'Não foi possível carregar as transações.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  /// Recarrega apenas as categorias, mantendo a lista reativa.
  Future<void> carregarCategorias() async {
    await _carregarCategoriasInterno();
    notifyListeners();
  }

  /// Cria uma categoria persistida e devolve a entidade criada.
  Future<Categoria?> criarCategoria(String nome, TipoTransacao tipo) async {
    _mensagemErro = null;
    try {
      final categoria = await _criarCategoriaUseCase(nome: nome, tipo: tipo);
      await _carregarCategoriasInterno();
      notifyListeners();
      return categoria;
    } on FalhaCategoria catch (falha) {
      _mensagemErro = falha.mensagem;
    } catch (_) {
      _mensagemErro = 'Não foi possível criar a categoria.';
    }
    notifyListeners();
    return null;
  }

  /// Persiste uma receita recebendo o valor monetário formatado pela UI.
  Future<bool> salvarReceita({
    Transacao? existente,
    required String descricao,
    required Categoria categoria,
    required String valorFormatado,
    required DateTime data,
  }) {
    return _salvar(
      existente: existente,
      descricao: descricao,
      categoria: categoria,
      valorFormatado: valorFormatado,
      data: data,
      tipo: TipoTransacao.receita,
    );
  }

  /// Persiste uma despesa recebendo o valor monetário formatado pela UI.
  Future<bool> salvarDespesa({
    Transacao? existente,
    required String descricao,
    required Categoria categoria,
    required String valorFormatado,
    required DateTime data,
  }) {
    return _salvar(
      existente: existente,
      descricao: descricao,
      categoria: categoria,
      valorFormatado: valorFormatado,
      data: data,
      tipo: TipoTransacao.despesa,
    );
  }

  /// Exclui logicamente a transação e recarrega a lista do banco.
  Future<bool> excluir(Transacao transacao) async {
    final id = transacao.id;
    if (id == null) return false;

    _mensagemErro = null;
    try {
      await _excluirTransacaoUseCase(id);
      _ultimaExcluida = transacao;
      await carregar();
      await aoAlterarDados?.call();
      return true;
    } on FalhaTransacao catch (falha) {
      _mensagemErro = falha.mensagem;
    } catch (_) {
      _mensagemErro = 'Não foi possível excluir a transação.';
    }
    notifyListeners();
    return false;
  }

  /// Desfaz a última exclusão lógica restaurando o registro no banco.
  Future<bool> restaurarUltimaExclusao() async {
    final transacao = _ultimaExcluida;
    final id = transacao?.id;
    if (id == null) return false;

    _mensagemErro = null;
    try {
      await _restaurarTransacaoUseCase(id);
      _ultimaExcluida = null;
      await carregar();
      await aoAlterarDados?.call();
      return true;
    } on FalhaTransacao catch (falha) {
      _mensagemErro = falha.mensagem;
    } catch (_) {
      _mensagemErro = 'Não foi possível desfazer a exclusão.';
    }
    notifyListeners();
    return false;
  }

  void limparErro() {
    if (_mensagemErro == null) return;
    _mensagemErro = null;
    notifyListeners();
  }

  Future<bool> _salvar({
    required TipoTransacao tipo,
    required String descricao,
    required Categoria categoria,
    required String valorFormatado,
    required DateTime data,
    Transacao? existente,
  }) async {
    if (_salvando) return false;

    final valorCentavos =
        FormatadorMoeda.converterTextoParaCentavos(valorFormatado);
    if (valorCentavos <= 0) {
      _mensagemErro = 'Informe um valor maior que zero.';
      notifyListeners();
      return false;
    }

    _salvando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final transacao = Transacao(
        id: existente?.id,
        descricao: descricao,
        valorCentavos: valorCentavos,
        tipo: tipo,
        categoria: categoria.nome,
        categoriaId: categoria.id,
        modalidade: existente?.modalidade ?? ModalidadePagamento.pix,
        data: data,
        competencia: _competenciaDe(data),
        recorrenciaId: existente?.recorrenciaId,
        criadoEm: existente?.criadoEm ?? DateTime.now(),
      );

      await _salvarTransacaoUseCase(transacao);
      await carregar(mes: data);
      await aoAlterarDados?.call();

      // Conclui o formulário aberto, conforme o fluxo definido na spec.
      navigatorKey?.currentState?.maybePop();
      return true;
    } on FalhaTransacao catch (falha) {
      _mensagemErro = falha.mensagem;
    } catch (_) {
      _mensagemErro = 'Não foi possível salvar a transação.';
    } finally {
      _salvando = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> _carregarCategoriasInterno() async {
    final receitas = await _listarCategoriasPorTipoUseCase(
      TipoTransacao.receita,
    );
    final despesas = await _listarCategoriasPorTipoUseCase(
      TipoTransacao.despesa,
    );
    _categoriasReceita = receitas;
    _categoriasDespesa = despesas;
  }

  static DateTime _iniciarMes(DateTime data) => DateTime(data.year, data.month);

  static String _competenciaDe(DateTime data) {
    final mes = data.month.toString().padLeft(2, '0');
    return '${data.year}-$mes';
  }
}
