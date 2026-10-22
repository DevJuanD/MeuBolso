import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../categorias/presentation/widgets/modal_nova_categoria.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../domain/models/movimentacao.dart';

export '../../../categorias/presentation/widgets/modal_nova_categoria.dart';
export '../../../categorias/presentation/widgets/seletor_categoria_widget.dart';

class FormLabel extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding;

  const FormLabel(
    this.text, {
    super.key,
    this.padding = const EdgeInsets.only(bottom: 9),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textHeading,
        ),
      ),
    );
  }
}

class ValueInputCard extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const ValueInputCard({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2ECFF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            cursorColor: AppColors.primary,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
              color: AppColors.primary,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              filled: false,
              prefixText: 'R\$ ',
              prefixStyle: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    this.hint,
    required this.controller,
    this.suffix,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 49,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

class AppDropdownField extends StatefulWidget {
  final String hint;
  final String? value;
  final List<CategoriaFinanceira> options;
  final ValueChanged<CategoriaFinanceira> onSelected;
  final VoidCallback onCreate;
  final String createLabel;

  const AppDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.options,
    required this.onSelected,
    required this.onCreate,
    this.createLabel = 'Criar novo tipo',
  });

  @override
  State<AppDropdownField> createState() => _AppDropdownFieldState();
}

class _AppDropdownFieldState extends State<AppDropdownField> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  double _width = 300;

  bool get _aberto => _entry != null;

  void _alternar() {
    if (_aberto) {
      _fechar();
    } else {
      _abrir();
    }
  }

  void _fechar() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() {});
  }

  void _abrir() {
    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _fechar,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              offset: const Offset(0, 53),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: _width,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final categoria in widget.options)
                        _MenuRow(
                          icon: categoria.icone,
                          label: categoria.nome,
                          onTap: () {
                            widget.onSelected(categoria);
                            _fechar();
                          },
                        ),
                      const SizedBox(height: 2),
                      InkWell(
                        borderRadius: BorderRadius.circular(11),
                        onTap: () {
                          _fechar();
                          widget.onCreate();
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
                            '+ ${widget.createLabel}',
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
          ],
        );
      },
    );
    Overlay.of(context).insert(_entry!);
    setState(() {});
  }

  @override
  void dispose() {
    _entry?.remove();
    _entry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        return CompositedTransformTarget(
          link: _link,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _alternar,
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
                      widget.value ?? widget.hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        fontWeight: widget.value == null
                            ? FontWeight.w400
                            : FontWeight.w500,
                        color: widget.value == null
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
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
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 43,
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryConfirmationChips extends StatelessWidget {
  final List<CategoriaFinanceira> categorias;
  final String selecionada;

  const CategoryConfirmationChips({
    super.key,
    required this.categorias,
    required this.selecionada,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
            for (final categoria in categorias)
              _Chip(
                label: categoria.nome,
                selected: categoria.nome == selecionada,
              ),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;

  const _Chip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 1.3 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected) ...[
            Icon(
              Icons.check_rounded,
              size: 13,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 10.5,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.primary : AppColors.textBody,
            ),
          ),
        ],
      ),
    );
  }
}

class DateField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const DateField({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
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
            Text(
              value,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> mostrarDialogoCategoria(
  BuildContext context, {
  required String titulo,
  required String descricao,
  required String valorInicial,
}) async {
  final tipo = titulo.toLowerCase().contains('receita')
      ? TipoTransacao.receita
      : TipoTransacao.despesa;

  final categoria = await mostrarModalNovaCategoria(
    context,
    tipo: tipo,
    valorInicial: valorInicial,
  );

  return categoria?.nome;
}

Future<bool> mostrarDialogoExcluirReceita(BuildContext context) async {
  final resultado = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0x99667085),
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 26),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Excluir receita?',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHeading,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tem certeza de que deseja excluir esta receita?',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 47,
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.border),
                          foregroundColor: AppColors.textHeading,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 47,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: const Text(
                          'Excluir',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return resultado ?? false;
}

Future<bool> mostrarDialogoExcluirDespesa(BuildContext context) async {
  final resultado = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Fechar',
    barrierColor: const Color(0x99667085),
    transitionDuration: const Duration(milliseconds: 170),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return Align(
        alignment: const Alignment(0, -0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Excluir despesa?',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHeading,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tem certeza de que deseja excluir esta despesa? Essa ação não poderá ser desfeita.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text(
                        'EXCLUIR',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: const Text(
                        'CANCELAR',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: child,
        ),
      );
    },
  );
  return resultado ?? false;
}

String formatarValorCampo(int centavos) => formatarCampoValor(centavos);
