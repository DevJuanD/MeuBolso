import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/icone_categoria.dart';

/// Bottom Sheet com grid interativo para seleção visual de ícones.
class ModalSeletorIcone extends StatefulWidget {
  final String iconeSelecionado;
  final ValueChanged<String> aoSelecionar;

  const ModalSeletorIcone({
    super.key,
    required this.iconeSelecionado,
    required this.aoSelecionar,
  });

  @override
  State<ModalSeletorIcone> createState() => _ModalSeletorIconeState();
}

class _ModalSeletorIconeState extends State<ModalSeletorIcone> {
  late String _iconeAtual;

  @override
  void initState() {
    super.initState();
    _iconeAtual = widget.iconeSelecionado;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(26),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Escolher ícone',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                color: AppColors.textHeading,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Selecione a representação visual da categoria',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 10.5,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: poolDeIcones.length,
                itemBuilder: (context, index) {
                  final item = poolDeIcones[index];
                  final chave = item['chave'] as String;
                  final icone = item['icone'] as IconData;
                  final rotulo = item['rotulo'] as String;
                  final selecionado = chave == _iconeAtual;

                  return InkWell(
                    onTap: () {
                      setState(() => _iconeAtual = chave);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: selecionado
                                ? AppColors.primarySoft
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: selecionado
                                ? Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Icon(
                            icone,
                            size: 20,
                            color:
                                selecionado ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          rotulo,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 8.5,
                            fontWeight: selecionado
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selecionado
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_iconeAtual);
                },
                child: Text(
                  'Selecionar',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
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

/// Exibe o bottom sheet de seleção de ícones e retorna a chave escolhida.
Future<String?> mostrarSeletorIcone(
  BuildContext context, {
  required String iconeAtual,
}) async {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return ModalSeletorIcone(
        iconeSelecionado: iconeAtual,
        aoSelecionar: (chave) => Navigator.of(sheetContext).pop(chave),
      );
    },
  );
}
