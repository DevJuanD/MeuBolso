import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/icone_categoria.dart';
import '../../../categorias/domain/entities/categoria.dart';
import '../widgets/modal_seletor_icone.dart';

/// Modal de criação ou edição de categoria com suporte a escolha de ícone.
class ModalFormCategoria extends StatefulWidget {
  final Categoria? categoriaExistente;
  final Future<Categoria?> Function(String nome, String iconeId)
      aoSalvar;

  const ModalFormCategoria({
    super.key,
    this.categoriaExistente,
    required this.aoSalvar,
  });

  @override
  State<ModalFormCategoria> createState() => _ModalFormCategoriaState();
}

class _ModalFormCategoriaState extends State<ModalFormCategoria> {
  late final TextEditingController _nomeController;
  String _iconeId = 'default';
  String? _mensagemErro;
  bool _salvando = false;

  bool get _editando => widget.categoriaExistente != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(
      text: widget.categoriaExistente?.nome ?? '',
    );
    _iconeId = widget.categoriaExistente?.iconeId ?? 'default';
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _abrirSeletorIcone() async {
    final chaveEscolhida = await mostrarSeletorIcone(
      context,
      iconeAtual: _iconeId,
    );
    if (chaveEscolhida != null && mounted) {
      setState(() => _iconeId = chaveEscolhida);
    }
  }

  Future<void> _submeter() async {
    final nome = _nomeController.text.trim();
    if (nome.isEmpty) {
      setState(() {
        _mensagemErro = 'O nome da categoria não pode ser vazio.';
      });
      return;
    }

    setState(() {
      _salvando = true;
      _mensagemErro = null;
    });

    try {
      final resultado = await widget.aoSalvar(nome, _iconeId);
      if (!mounted) return;
      if (resultado == null) {
        setState(() {
          _salvando = false;
          _mensagemErro = 'Não foi possível salvar a categoria.';
        });
        return;
      }
      Navigator.of(context).pop(resultado);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _salvando = false;
        _mensagemErro = 'Não foi possível salvar a categoria. Tente novamente.';
      });
    }
  }

  IconData get _iconeAtual =>
      iconesPorCategoria[_iconeId] ?? Icons.more_horiz_rounded;

  @override
  Widget build(BuildContext context) {
    final titulo = _editando ? 'Editar categoria' : 'Nova categoria';
    final descricao = _editando
        ? 'Atualize o nome e o ícone da categoria.'
        : 'Dê um nome e escolha um ícone para a nova categoria.';

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
                controller: _nomeController,
                autofocus: !_editando,
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
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'Ícone',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textHeading,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _abrirSeletorIcone,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 49,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(
                        _iconeAtual,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _iconeId == 'default' ? 'Ícone padrão' : _iconeId,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
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
                    : Text(
                        _editando ? 'SALVAR ALTERAÇÕES' : 'Salvar categoria',
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
                onPressed: _salvando ? null : () => Navigator.of(context).pop(),
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

/// Exibe o modal de criação/edição de categoria e retorna a categoria salva.
Future<Categoria?> mostrarModalFormCategoria(
  BuildContext context, {
  Categoria? categoriaExistente,
  required Future<Categoria?> Function(String nome, String iconeId) aoSalvar,
}) {
  return showDialog<Categoria>(
    context: context,
    barrierColor: const Color(0x99667085),
    builder: (dialogContext) {
      return ModalFormCategoria(
        categoriaExistente: categoriaExistente,
        aoSalvar: aoSalvar,
      );
    },
  );
}
