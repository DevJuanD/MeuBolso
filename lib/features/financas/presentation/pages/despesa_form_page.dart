import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatador_moeda.dart';
import '../../../../core/utils/icone_categoria.dart';
import '../../../categorias/domain/entities/categoria.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../../transacoes/domain/entities/transacao.dart';
import '../../../transacoes/presentation/controllers/transacoes_controller.dart';
import '../../domain/models/movimentacao.dart';
import '../widgets/app_header.dart';
import '../widgets/form_widgets.dart';

class DespesaFormPage extends StatefulWidget {
  final TransacoesController controller;
  final Transacao? despesa;

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
  String? _categoriaSelecionada;
  late DateTime _data;
  bool _mostrarChips = false;

  bool get _editando => widget.despesa != null;

  @override
  void initState() {
    super.initState();
    final despesa = widget.despesa;
    _valorController = TextEditingController(
      text: despesa == null
          ? '0,00'
          : FormatadorMoeda.formatarCampo(despesa.valorCentavos),
    );
    _descricaoController = TextEditingController(
      text: despesa == null || despesa.descricao == despesa.categoria
          ? ''
          : despesa.descricao,
    );
    _categoriaSelecionada = despesa?.categoria;
    _data = despesa?.data ?? DateTime.now();
    widget.controller.addListener(_aoMudarController);
    widget.controller.carregarCategorias();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_aoMudarController);
    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _aoMudarController() {
    if (mounted) setState(() {});
  }

  List<CategoriaFinanceira> get _opcoes {
    return widget.controller.categoriasDespesa
        .map(
          (categoria) => CategoriaFinanceira(
            nome: categoria.nome,
            icone: iconeParaCategoria(categoria.nome),
            cor: AppColors.primary,
          ),
        )
        .toList(growable: false);
  }

  Categoria? get _categoriaEntidade {
    final nome = _categoriaSelecionada;
    if (nome == null) return null;
    for (final categoria in widget.controller.categoriasDespesa) {
      if (categoria.nome == nome) return categoria;
    }
    return null;
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
    final novaCategoria = await mostrarModalNovaCategoria(
      context,
      tipo: TipoTransacao.despesa,
      aoSalvarCustomizado: (nome) =>
          widget.controller.criarCategoria(nome, TipoTransacao.despesa),
    );
    if (!mounted) return;
    if (novaCategoria == null) {
      final erro = widget.controller.mensagemErro;
      if (erro != null) _aviso(erro);
      return;
    }
    setState(() {
      _categoriaSelecionada = novaCategoria.nome;
      _mostrarChips = true;
    });
  }

  Future<void> _salvar() async {
    FocusScope.of(context).unfocus();

    final valorCentavos =
        FormatadorMoeda.converterTextoParaCentavos(_valorController.text);
    if (valorCentavos <= 0) {
      _aviso('Informe o valor da despesa.');
      return;
    }

    final categoria = _categoriaEntidade;
    if (categoria == null) {
      _aviso('Selecione o tipo de despesa.');
      return;
    }

    final sucesso = await widget.controller.salvarDespesa(
      existente: widget.despesa,
      descricao: _descricaoController.text.trim(),
      categoria: categoria,
      valorFormatado: _valorController.text,
      data: _data,
    );

    if (!mounted || sucesso) return;
    _aviso(widget.controller.mensagemErro ?? 'Não foi possível salvar a despesa.');
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
                      value: _categoriaSelecionada,
                      options: _opcoes,
                      onSelected: (categoria) {
                        setState(
                          () => _categoriaSelecionada = categoria.nome,
                        );
                      },
                      onCreate: _criarCategoria,
                    ),
                    if (_mostrarChips) ...[
                      const SizedBox(height: 13),
                      CategoryConfirmationChips(
                        categorias: _opcoes,
                        selecionada: _categoriaSelecionada ?? '',
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
                      value: FormatadorMoeda.formatarDataCurta(_data),
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
                  onPressed: widget.controller.salvando ? null : _salvar,
                  child: widget.controller.salvando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
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
