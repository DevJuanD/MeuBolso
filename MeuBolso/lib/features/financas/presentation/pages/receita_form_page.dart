import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/dados_demonstracao.dart';
import '../../domain/models/movimentacao.dart';
import '../controllers/financas_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/form_widgets.dart';

class ReceitaFormPage extends StatefulWidget {
  final FinancasController controller;
  final Movimentacao? receita;

  const ReceitaFormPage({
    super.key,
    required this.controller,
    this.receita,
  });

  @override
  State<ReceitaFormPage> createState() => _ReceitaFormPageState();
}

class _ReceitaFormPageState extends State<ReceitaFormPage> {
  late final TextEditingController _valorController;
  late final TextEditingController _descricaoController;
  String? _categoria;
  DateTime _data = DateTime(2026, 10, 18);
  bool _mostrarChips = false;

  bool get _editando => widget.receita != null;

  @override
  void initState() {
    super.initState();
    final receita = widget.receita;
    _valorController = TextEditingController(
      text: receita == null ? '0,00' : formatarCampoValor(receita.valorCentavos),
    );
    _descricaoController = TextEditingController(
      text: receita == null || receita.descricao == receita.categoria
          ? ''
          : receita.descricao,
    );
    _categoria = receita?.categoria;
    _data = receita?.data ?? DateTime(2026, 10, 18);
    _mostrarChips = receita != null &&
        !DadosDemonstracao.categoriasReceita
            .any((c) => c.nome == receita.categoria);
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
      titulo: 'Novo tipo de receita',
      descricao: 'Dê um nome para identificar suas entradas.',
      valorInicial: 'Consultoria',
    );
    if (nome == null || nome.isEmpty) return;
    widget.controller.adicionarCategoriaReceita(nome);
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
      _aviso('Informe o valor recebido.');
      return;
    }
    if (_categoria == null || _categoria!.isEmpty) {
      _aviso('Selecione o tipo de receita.');
      return;
    }

    if (_editando) {
      widget.controller.editarReceita(
        widget.receita!,
        descricao: _descricaoController.text.trim(),
        categoria: _categoria!,
        valorCentavos: valor,
        data: _data,
      );
    } else {
      widget.controller.adicionarReceita(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),
              BackTitle(
                title: _editando ? 'Editar receita' : 'Adicionar receita',
                subtitle: _editando
                    ? 'Atualize os dados da receita'
                    : 'Registre o dinheiro que entrou',
              ),
              ValueInputCard(
                label: 'Valor recebido',
                controller: _valorController,
              ),
              const SizedBox(height: 20),
              const FormLabel('Tipo de receita'),
              AppDropdownField(
                hint: 'Selecione o tipo de receita',
                value: _categoria,
                options: widget.controller.categoriasReceita,
                onSelected: (categoria) {
                  setState(() => _categoria = categoria.nome);
                },
                onCreate: _criarCategoria,
              ),
              if (_mostrarChips) ...[
                const SizedBox(height: 13),
                CategoryConfirmationChips(
                  categorias: widget.controller.categoriasReceita,
                  selecionada: _categoria ?? '',
                ),
              ],
              const SizedBox(height: 20),
              const FormLabel('Descrição (opcional)'),
              AppTextField(
                controller: _descricaoController,
                hint: 'Ex.: salário do mês',
              ),
              const SizedBox(height: 19),
              const FormLabel('Data do recebimento'),
              DateField(
                value: formatarDataCurta(_data),
                onTap: _selecionarData,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: Text(
                    _editando ? 'SALVAR ALTERAÇÕES' : 'Salvar receita',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
