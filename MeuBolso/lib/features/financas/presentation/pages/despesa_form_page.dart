import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/dados_demonstracao.dart';
import '../../domain/models/movimentacao.dart';
import '../controllers/financas_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/form_widgets.dart';

class DespesaFormPage extends StatefulWidget {
  final FinancasController controller;
  final Movimentacao? despesa;

  const DespesaFormPage({
    super.key,
    required this.controller,
    this.despesa,
  });

  @override
  State<DespesaFormPage> createState() => _DespesaFormPageState();
}

class _DespesaFormPageState extends State<DespesaFormPage> {
  late final TextEditingController _valorController;
  late final TextEditingController _descricaoController;
  String? _categoria;
  DateTime _data = DateTime(2026, 10, 18);
  bool _mostrarChips = false;

  bool get _editando => widget.despesa != null;

  @override
  void initState() {
    super.initState();
    final despesa = widget.despesa;
    _valorController = TextEditingController(
      text: despesa == null ? '0,00' : formatarCampoValor(despesa.valorCentavos),
    );
    _descricaoController = TextEditingController(
      text: despesa == null || despesa.descricao == despesa.categoria
          ? ''
          : despesa.descricao,
    );
    _categoria = despesa?.categoria;
    _data = despesa?.data ?? DateTime(2026, 10, 18);
    _mostrarChips = despesa != null &&
        !DadosDemonstracao.categoriasDespesa
            .any((c) => c.nome == despesa.categoria);
  }

  @override
  void dispose() {
    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (selecionada != null && mounted) {
      setState(() => _data = selecionada);
    }
  }

  Future<void> _criarCategoria() async {
    final nome = await mostrarDialogoCategoria(
      context,
      titulo: 'Novo tipo de despesa',
      descricao: 'Dê um nome para identificar seus gastos.',
      valorInicial: 'Educação',
    );
    if (nome == null || nome.isEmpty) return;
    widget.controller.adicionarCategoriaDespesa(nome);
    if (!mounted) return;
    setState(() {
      _categoria = nome;
      _mostrarChips = true;
    });
  }

  void _salvar() {
    FocusScope.of(context).unfocus();
    final valor = parseValorParaCentavos(_valorController.text);
    if (valor <= 0) {
      _aviso('Informe o valor da despesa.');
      return;
    }
    if (_categoria == null || _categoria!.isEmpty) {
      _aviso('Selecione o tipo de despesa.');
      return;
    }

    if (_editando) {
      widget.controller.editarDespesa(
        widget.despesa!,
        descricao: _descricaoController.text.trim(),
        categoria: _categoria!,
        valorCentavos: valor,
        data: _data,
      );
    } else {
      widget.controller.adicionarDespesa(
        descricao: _descricaoController.text.trim(),
        categoria: _categoria!,
        valorCentavos: valor,
        data: _data,
      );
    }
    Navigator.of(context).pop();
  }

  void _aviso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppHeader(),
                    BackTitle(
                      title: _editando ? 'Editar despesa' : 'Adicionar despesa',
                      subtitle: _editando
                          ? 'Atualize os dados da despesa'
                          : 'Registre um gasto',
                    ),
                    ValueInputCard(
                      label: 'Valor da despesa',
                      controller: _valorController,
                    ),
                    const SizedBox(height: 20),
                    const FormLabel('Tipo de despesa'),
                    AppDropdownField(
                      hint: 'Selecione o tipo de despesa',
                      value: _categoria,
                      options: widget.controller.categoriasDespesa,
                      onSelected: (categoria) {
                        setState(() => _categoria = categoria.nome);
                      },
                      onCreate: _criarCategoria,
                    ),
                    if (_mostrarChips) ...[
                      const SizedBox(height: 13),
                      CategoryConfirmationChips(
                        categorias: widget.controller.categoriasDespesa,
                        selecionada: _categoria ?? '',
                      ),
                    ],
                    const SizedBox(height: 20),
                    const FormLabel('Descrição (opcional)'),
                    AppTextField(
                      controller: _descricaoController,
                      hint: 'Ex.: compra no supermercado',
                    ),
                    const SizedBox(height: 19),
                    const FormLabel('Data da despesa'),
                    DateField(
                      value: formatarDataCurta(_data),
                      onTap: _selecionarData,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 5, 18, 14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: Text(
                    _editando ? 'SALVAR ALTERAÇÕES' : 'Salvar despesa',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
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
