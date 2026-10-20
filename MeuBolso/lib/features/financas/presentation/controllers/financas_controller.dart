import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/dados_demonstracao.dart';
import '../../domain/models/movimentacao.dart';
import '../../domain/models/relatorio.dart';

class FinancasController extends ChangeNotifier {
  FinancasController() {
    _receitas = DadosDemonstracao.receitasIniciais();
    _despesas = DadosDemonstracao.despesasIniciais();
    _receitas.sort((a, b) => a.data.compareTo(b.data));
    _despesas.sort((a, b) => b.data.compareTo(a.data));
  }

  late List<Movimentacao> _receitas;
  late List<Movimentacao> _despesas;

  int _totalReceitasCentavos = 325000;
  int _totalDespesasCentavos = 132000;

  bool _mostrarAcoesReceitas = false;
  bool _mostrarAcoesDespesas = true;

  final List<CategoriaFinanceira> _categoriasReceitaExtras = [];
  final List<CategoriaFinanceira> _categoriasDespesaExtras = [];

  Movimentacao? _ultimaReceitaExcluida;
  Movimentacao? _ultimaDespesaExcluida;
  bool _ultimaReceitaExcluidaMostravaAcoes = false;
  int _totalDespesasAntesExclusao = 0;

  FiltroRelatorio _filtro = FiltroRelatorio(
    dataInicial: DateTime(2025, 10, 1),
    dataFinal: DateTime(2025, 10, 31),
  );

  List<Movimentacao> get receitas => List.unmodifiable(_receitas);
  List<Movimentacao> get despesas => List.unmodifiable(_despesas);

  int get totalReceitasCentavos => _totalReceitasCentavos;
  int get totalDespesasCentavos => _totalDespesasCentavos;
  int get saldoCentavos => _totalReceitasCentavos - _totalDespesasCentavos;

  bool get mostrarAcoesReceitas => _mostrarAcoesReceitas;
  bool get mostrarAcoesDespesas => _mostrarAcoesDespesas;

  List<CategoriaFinanceira> get categoriasReceita => [
        ...DadosDemonstracao.categoriasReceita,
        ..._categoriasReceitaExtras,
      ];

  List<CategoriaFinanceira> get categoriasDespesa => [
        ...DadosDemonstracao.categoriasDespesa,
        ..._categoriasDespesaExtras,
      ];

  List<String> get nomesCategoriasReceita =>
      categoriasReceita.map((c) => c.nome).toList(growable: false);

  List<String> get nomesCategoriasDespesa =>
      categoriasDespesa.map((c) => c.nome).toList(growable: false);

  FiltroRelatorio get filtro => _filtro;
  ConteudoRelatorio get relatorio => DadosDemonstracao.relatorio(_filtro);

  void aplicarFiltro(FiltroRelatorio filtro) {
    _filtro = filtro;
    notifyListeners();
  }

  void limparFiltros() {
    _filtro = FiltroRelatorio(
      dataInicial: DateTime(2025, 10, 1),
      dataFinal: DateTime(2025, 10, 31),
    );
    notifyListeners();
  }

  CategoriaFinanceira adicionarCategoriaReceita(String nome) {
    final existente = categoriasReceita.where((c) => c.nome == nome);
    if (existente.isNotEmpty) return existente.first;
    final categoria = CategoriaFinanceira(
      nome: nome,
      icone: Icons.assignment_turned_in_outlined,
      cor: AppColors.primary,
    );
    _categoriasReceitaExtras.add(categoria);
    notifyListeners();
    return categoria;
  }

  CategoriaFinanceira adicionarCategoriaDespesa(String nome) {
    final existente = categoriasDespesa.where((c) => c.nome == nome);
    if (existente.isNotEmpty) return existente.first;
    final categoria = CategoriaFinanceira(
      nome: nome,
      icone: Icons.school_outlined,
      cor: AppColors.primary,
    );
    _categoriasDespesaExtras.add(categoria);
    notifyListeners();
    return categoria;
  }

  void adicionarReceita({
    required String descricao,
    required String categoria,
    required int valorCentavos,
    required DateTime data,
  }) {
    _receitas.add(
      Movimentacao(
        id: DateTime.now().microsecondsSinceEpoch,
        descricao: descricao.isEmpty ? categoria : descricao,
        categoria: categoria,
        valorCentavos: valorCentavos,
        data: data,
        tipo: TipoMovimentacao.receita,
      ),
    );
    _receitas.sort((a, b) {
      final porData = a.data.compareTo(b.data);
      if (porData != 0) return porData;
      return a.id.compareTo(b.id);
    });
    _totalReceitasCentavos += valorCentavos;
    _mostrarAcoesReceitas = true;
    notifyListeners();
  }

  void editarReceita(
    Movimentacao original, {
    required String descricao,
    required String categoria,
    required int valorCentavos,
    required DateTime data,
  }) {
    final indice = _receitas.indexWhere((m) => m.id == original.id);
    if (indice == -1) return;
    _receitas[indice] = original.copyWith(
      descricao: descricao.isEmpty ? categoria : descricao,
      categoria: categoria,
      valorCentavos: valorCentavos,
      data: data,
    );
    _receitas.sort((a, b) {
      final porData = a.data.compareTo(b.data);
      if (porData != 0) return porData;
      return a.id.compareTo(b.id);
    });
    _totalReceitasCentavos += valorCentavos - original.valorCentavos;
    _mostrarAcoesReceitas = true;
    notifyListeners();
  }

  void excluirReceita(Movimentacao movimentacao) {
    _ultimaReceitaExcluida = movimentacao;
    _ultimaReceitaExcluidaMostravaAcoes = _mostrarAcoesReceitas;
    _receitas.removeWhere((m) => m.id == movimentacao.id);
    _totalReceitasCentavos -= movimentacao.valorCentavos;
    _mostrarAcoesReceitas = false;
    notifyListeners();
  }

  void desfazerExclusaoReceita() {
    final movimentacao = _ultimaReceitaExcluida;
    if (movimentacao == null) return;
    _receitas.add(movimentacao);
    _receitas.sort((a, b) {
      final porData = a.data.compareTo(b.data);
      if (porData != 0) return porData;
      return a.id.compareTo(b.id);
    });
    _totalReceitasCentavos += movimentacao.valorCentavos;
    _mostrarAcoesReceitas = _ultimaReceitaExcluidaMostravaAcoes;
    _ultimaReceitaExcluida = null;
    notifyListeners();
  }

  void adicionarDespesa({
    required String descricao,
    required String categoria,
    required int valorCentavos,
    required DateTime data,
  }) {
    _despesas.add(
      Movimentacao(
        id: DateTime.now().microsecondsSinceEpoch,
        descricao: descricao.isEmpty ? categoria : descricao,
        categoria: categoria,
        valorCentavos: valorCentavos,
        data: data,
        tipo: TipoMovimentacao.despesa,
      ),
    );
    _despesas.sort((a, b) {
      final porData = b.data.compareTo(a.data);
      if (porData != 0) return porData;
      return b.id.compareTo(a.id);
    });
    _totalDespesasCentavos += valorCentavos;
    _mostrarAcoesDespesas = true;
    notifyListeners();
  }

  void editarDespesa(
    Movimentacao original, {
    required String descricao,
    required String categoria,
    required int valorCentavos,
    required DateTime data,
  }) {
    final indice = _despesas.indexWhere((m) => m.id == original.id);
    if (indice == -1) return;
    _despesas[indice] = original.copyWith(
      descricao: descricao.isEmpty ? categoria : descricao,
      categoria: categoria,
      valorCentavos: valorCentavos,
      data: data,
    );
    _despesas.sort((a, b) {
      final porData = b.data.compareTo(a.data);
      if (porData != 0) return porData;
      return b.id.compareTo(a.id);
    });
    _totalDespesasCentavos += valorCentavos - original.valorCentavos;
    _mostrarAcoesDespesas = true;
    notifyListeners();
  }

  void excluirDespesa(Movimentacao movimentacao) {
    _ultimaDespesaExcluida = movimentacao;
    _totalDespesasAntesExclusao = _totalDespesasCentavos;
    _despesas.removeWhere((m) => m.id == movimentacao.id);
    _totalDespesasCentavos -= movimentacao.valorCentavos;
    _mostrarAcoesDespesas = true;
    notifyListeners();
  }

  void desfazerExclusaoDespesa() {
    final movimentacao = _ultimaDespesaExcluida;
    if (movimentacao == null) return;
    _despesas.add(movimentacao);
    _despesas.sort((a, b) {
      final porData = b.data.compareTo(a.data);
      if (porData != 0) return porData;
      return b.id.compareTo(a.id);
    });
    _totalDespesasCentavos = _totalDespesasAntesExclusao;
    _ultimaDespesaExcluida = null;
    _mostrarAcoesDespesas = true;
    notifyListeners();
  }

  Movimentacao? get ultimaDespesaExcluida => _ultimaDespesaExcluida;
  Movimentacao? get ultimaReceitaExcluida => _ultimaReceitaExcluida;
}
