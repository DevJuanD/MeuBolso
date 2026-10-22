import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/usecases/criar_categoria_usecase.dart';
import '../../domain/usecases/listar_categorias_por_tipo_usecase.dart';
import 'modal_nova_categoria.dart';

/// Componente visual reutilizável para seleção de categoria financeira.
///
/// Exibe a lista de opções com o botão fixo "+ Criar novo tipo" ao final e
/// integra a abertura do modal de criação e feedback imediato por chips.
class SeletorCategoriaWidget extends StatefulWidget {
  final TipoTransacao tipo;
  final String? categoriaSelecionada;
  final ValueChanged<Categoria> aoSelecionar;
  final ListarCategoriasPorTipoUseCase? listarUseCase;
  final CriarCategoriaUseCase? criarUseCase;
  final List<Categoria>? categoriasIniciais;
  final String? dica;
  final bool exibirChipsAposCriacao;

  const SeletorCategoriaWidget({
    super.key,
    required this.tipo,
    this.categoriaSelecionada,
    required this.aoSelecionar,
    this.listarUseCase,
    this.criarUseCase,
    this.categoriasIniciais,
    this.dica,
    this.exibirChipsAposCriacao = true,
  });

  @override
  State<SeletorCategoriaWidget> createState() => _SeletorCategoriaWidgetState();
}

class _SeletorCategoriaWidgetState extends State<SeletorCategoriaWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  double _largura = 300;

  List<Categoria> _categorias = [];
  String? _categoriaAtual;
  bool _mostrarChips = false;
  bool _carregando = false;

  bool get _aberto => _overlayEntry != null;

  @override
  void initState() {
    super.initState();
    _categoriaAtual = widget.categoriaSelecionada;
    if (widget.categoriasIniciais != null) {
      _categorias = List.of(widget.categoriasIniciais!);
    } else {
      _carregarCategorias();
    }
  }

  @override
  void didUpdateWidget(covariant SeletorCategoriaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoriaSelecionada != widget.categoriaSelecionada) {
      _categoriaAtual = widget.categoriaSelecionada;
    }
    if (oldWidget.categoriasIniciais != widget.categoriasIniciais &&
        widget.categoriasIniciais != null) {
      _categorias = List.of(widget.categoriasIniciais!);
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  Future<void> _carregarCategorias() async {
    if (widget.listarUseCase == null) return;
    setState(() => _carregando = true);
    try {
      final lista = await widget.listarUseCase!(widget.tipo);
      if (mounted) {
        setState(() {
          _categorias = lista;
          _carregando = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _alternarOverlay() {
    if (_aberto) {
      _fecharOverlay();
    } else {
      _abrirOverlay();
    }
  }

  void _fecharOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  void _abrirOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _fecharOverlay,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 53),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: _largura,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x241E293B),
                        blurRadius: 30,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final categoria in _categorias)
                            InkWell(
                              onTap: () {
                                _fecharOverlay();
                                _selecionar(categoria);
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 43,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 14),
                                    Icon(
                                      widget.tipo.isReceita
                                          ? Icons.arrow_downward_rounded
                                          : Icons.arrow_upward_rounded,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        categoria.nome,
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (categoria.nome == _categoriaAtual)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: Icon(
                                          Icons.check_rounded,
                                          size: 18,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 4),
                          InkWell(
                            borderRadius: BorderRadius.circular(11),
                            onTap: () {
                              _fecharOverlay();
                              _abrirModalCriacao();
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Text(
                                '+ Criar novo tipo',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _selecionar(Categoria categoria) {
    setState(() => _categoriaAtual = categoria.nome);
    widget.aoSelecionar(categoria);
  }

  Future<void> _abrirModalCriacao() async {
    final novaCategoria = await mostrarModalNovaCategoria(
      context,
      tipo: widget.tipo,
      criarCategoriaUseCase: widget.criarUseCase,
    );

    if (novaCategoria == null || !mounted) return;

    setState(() {
      final index = _categorias.indexWhere((c) => c.nome == novaCategoria.nome);
      if (index == -1) {
        _categorias.add(novaCategoria);
      }
      _categoriaAtual = novaCategoria.nome;
      _mostrarChips = widget.exibirChipsAposCriacao;
    });

    widget.aoSelecionar(novaCategoria);
  }

  @override
  Widget build(BuildContext context) {
    final dicaPadrao = widget.dica ??
        (widget.tipo.isReceita
            ? 'Selecione o tipo de receita'
            : 'Selecione o tipo de despesa');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            _largura = constraints.maxWidth;
            return CompositedTransformTarget(
              link: _layerLink,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _carregando ? null : _alternarOverlay,
                child: Container(
                  height: 49,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _categoriaAtual ?? dicaPadrao,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 13,
                            fontWeight: _categoriaAtual == null
                                ? FontWeight.w400
                                : FontWeight.w500,
                            color: _categoriaAtual == null
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (_carregando)
                        const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        Icon(
                          _aberto
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 21,
                          color: AppColors.textSecondary,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (_mostrarChips) ...[
          const SizedBox(height: 13),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipo criado! Agora disponível na sua lista:',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 9),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  for (final categoria in _categorias)
                    _ChipCategoria(
                      rotulo: categoria.nome,
                      selecionado: categoria.nome == _categoriaAtual,
                      aoClicar: () => _selecionar(categoria),
                    ),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ChipCategoria extends StatelessWidget {
  final String rotulo;
  final bool selecionado;
  final VoidCallback aoClicar;

  const _ChipCategoria({
    required this.rotulo,
    required this.selecionado,
    required this.aoClicar,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: aoClicar,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 29,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selecionado ? AppColors.primary : AppColors.border,
            width: selecionado ? 1.3 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selecionado) ...[
              Icon(
                Icons.check_rounded,
                size: 13,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              rotulo,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 10.5,
                fontWeight: selecionado ? FontWeight.w600 : FontWeight.w400,
                color: selecionado ? AppColors.primary : AppColors.textBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
