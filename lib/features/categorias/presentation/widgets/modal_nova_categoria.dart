import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/exceptions/falhas_categoria.dart';
import '../../domain/usecases/criar_categoria_usecase.dart';

/// Modal para criação de uma nova categoria financeira customizada.
class ModalNovaCategoria extends StatefulWidget {
  final TipoTransacao tipo;
  final String? valorInicial;
  final CriarCategoriaUseCase? criarCategoriaUseCase;
  final Future<Categoria?> Function(String nome)? aoSalvarCustomizado;

  const ModalNovaCategoria({
    super.key,
    required this.tipo,
    this.valorInicial,
    this.criarCategoriaUseCase,
    this.aoSalvarCustomizado,
  });

  @override
  State<ModalNovaCategoria> createState() => _ModalNovaCategoriaState();
}

class _ModalNovaCategoriaState extends State<ModalNovaCategoria> {
  late final TextEditingController _controller;
  String? _mensagemErro;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.valorInicial ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submeter() async {
    final nomeInformado = _controller.text.trim();
    if (nomeInformado.isEmpty) {
      setState(() {
        _mensagemErro = const NomeCategoriaInvalidoException().mensagem;
      });
      return;
    }

    setState(() {
      _salvando = true;
      _mensagemErro = null;
    });

    try {
      Categoria? resultado;
      if (widget.criarCategoriaUseCase != null) {
        resultado = await widget.criarCategoriaUseCase!(
          nome: nomeInformado,
          tipo: widget.tipo,
        );
      } else if (widget.aoSalvarCustomizado != null) {
        resultado = await widget.aoSalvarCustomizado!(nomeInformado);
      } else {
        final nomeFormatado = '${nomeInformado[0].toUpperCase()}${nomeInformado.substring(1)}';
        resultado = Categoria(
          id: 'cat_${widget.tipo.name}_${DateTime.now().microsecondsSinceEpoch}',
          nome: nomeFormatado,
          tipo: widget.tipo,
          isPadrao: false,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop(resultado);
    } on FalhaCategoria catch (falha) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = falha.mensagem;
        _salvando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = 'Não foi possível cadastrar a categoria. Tente novamente.';
        _salvando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquemaCores = tema.colorScheme;
    final isReceita = widget.tipo.isReceita;

    final titulo = isReceita ? 'Novo tipo de receita' : 'Novo tipo de despesa';
    final descricao = isReceita
        ? 'Dê um nome para identificar suas entradas.'
        : 'Dê um nome para identificar seus gastos.';

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.textHeading,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              descricao,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Nome da categoria',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textHeading,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 49,
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: (_) {
                  if (_mensagemErro != null) {
                    setState(() => _mensagemErro = null);
                  }
                },
                onSubmitted: (_) => _submeter(),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Nome da categoria',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  errorText: _mensagemErro != null ? '' : null,
                ),
              ),
            ),
            if (_mensagemErro != null) ...[
              const SizedBox(height: 6),
              Text(
                _mensagemErro!,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: esquemaCores.error,
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _salvando ? null : _submeter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: _salvando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Salvar tipo',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Exibe o diálogo para cadastro de nova categoria financeira.
Future<Categoria?> mostrarModalNovaCategoria(
  BuildContext context, {
  required TipoTransacao tipo,
  String? valorInicial,
  CriarCategoriaUseCase? criarCategoriaUseCase,
  Future<Categoria?> Function(String nome)? aoSalvarCustomizado,
}) {
  return showDialog<Categoria>(
    context: context,
    barrierColor: const Color(0x99667085),
    builder: (dialogContext) {
      return ModalNovaCategoria(
        tipo: tipo,
        valorInicial: valorInicial,
        criarCategoriaUseCase: criarCategoriaUseCase,
        aoSalvarCustomizado: aoSalvarCustomizado,
      );
    },
  );
}
