import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/icone_categoria.dart';
import '../../../categorias/domain/entities/categoria.dart';
import '../../../categorias/domain/usecases/criar_categoria_usecase.dart';
import '../../../categorias/domain/usecases/listar_categorias_por_tipo_usecase.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../domain/repositories/categoria_repository.dart';
import '../widgets/modal_form_categoria.dart';

/// Tela de gerenciamento de categorias (Receitas e Despesas) com abas.
class GerenciarCategoriasPage extends StatefulWidget {
  final ListarCategoriasPorTipoUseCase listarUseCase;
  final CriarCategoriaUseCase criarUseCase;
  final CategoriaRepository repositorio;

  const GerenciarCategoriasPage({
    super.key,
    required this.listarUseCase,
    required this.criarUseCase,
    required this.repositorio,
  });

  @override
  State<GerenciarCategoriasPage> createState() =>
      _GerenciarCategoriasPageState();
}

class _GerenciarCategoriasPageState extends State<GerenciarCategoriasPage> {
  List<Categoria> _categoriasReceita = [];
  List<Categoria> _categoriasDespesa = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarAmbas();
  }

  Future<void> _carregarAmbas() async {
    setState(() => _carregando = true);
    try {
      final receitas = await widget.listarUseCase(TipoTransacao.receita);
      final despesas = await widget.listarUseCase(TipoTransacao.despesa);
      if (mounted) {
        setState(() {
          _categoriasReceita = receitas;
          _categoriasDespesa = despesas;
          _carregando = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _criarCategoria(TipoTransacao tipo) async {
    Future<Categoria?> salva(String nome, String iconeId) async {
      return widget.criarUseCase(nome: nome, tipo: tipo);
    }

    final resultado = await mostrarModalFormCategoria(
      context,
      aoSalvar: salva,
    );

    if (resultado != null && mounted) {
      await _carregarAmbas();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${resultado.nome} salva com sucesso.',
              style: const TextStyle(fontFamily: 'PlusJakartaSans'),
            ),
          ),
        );
      }
    }
  }

  Future<void> _editarCategoria(Categoria categoria) async {
    Future<Categoria?> salva(String nome, String iconeId) async {
      final atualizada = categoria.copyWith(nome: nome, iconeId: iconeId);
      await widget.repositorio.atualizar(atualizada);
      return atualizada;
    }

    final resultado = await mostrarModalFormCategoria(
      context,
      categoriaExistente: categoria,
      aoSalvar: salva,
    );

    if (resultado != null && mounted) {
      await _carregarAmbas();
    }
  }

  Future<void> _excluirCategoria(Categoria categoria) async {
    if (categoria.isPadrao) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Categorias padrão não podem ser excluídas.',
            style: TextStyle(fontFamily: 'PlusJakartaSans'),
          ),
        ),
      );
      return;
    }

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir categoria?'),
        content: Text(
          'Tem certeza de que deseja excluir "${categoria.nome}"? Esta ação não poderá ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmado != true || !mounted) return;

    try {
      final sucesso = await widget.repositorio.excluir(categoria.id);
      if (!mounted) return;
      if (sucesso) {
        await _carregarAmbas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Categoria excluída.',
                style: TextStyle(fontFamily: 'PlusJakartaSans'),
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Categorias padrão não podem ser excluídas.',
                style: TextStyle(fontFamily: 'PlusJakartaSans'),
              ),
            ),
          );
        }
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível excluir a categoria.',
            style: TextStyle(fontFamily: 'PlusJakartaSans'),
          ),
        ),
      );
    }
  }

  Widget _listaCategorias(List<Categoria> categorias) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categorias.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma categoria cadastrada.',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        final icone = iconeParaCategoria(categoria.iconeId);
        final ehReceita = categoria.tipo.isReceita;
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (ehReceita
                      ? AppColors.positiveSoft
                      : AppColors.negativeSoft)
                  .withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icone,
              size: 20,
              color: ehReceita ? AppColors.positive : AppColors.negative,
            ),
          ),
          title: Text(
            categoria.nome,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            categoria.isPadrao ? 'Padrão do sistema' : 'Personalizada',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 10.5,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: AppColors.textSecondary,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'editar',
                child: const Text('Editar'),
              ),
              if (!categoria.isPadrao)
                PopupMenuItem(
                  value: 'excluir',
                  child: const Text('Excluir'),
                ),
            ],
            onSelected: (valor) {
              if (valor == 'editar') {
                _editarCategoria(categoria);
              } else if (valor == 'excluir') {
                _excluirCategoria(categoria);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Gerenciar Categorias',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(text: 'Receitas'),
                Tab(text: 'Despesas'),
              ],
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _listaCategorias(_categoriasReceita),
                  _listaCategorias(_categoriasDespesa),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final tabIndex = DefaultTabController.of(context).index;
          final tipo =
              tabIndex == 0 ? TipoTransacao.receita : TipoTransacao.despesa;
          _criarCategoria(tipo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
