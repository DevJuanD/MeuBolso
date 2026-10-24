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

class ReceitaFormPage extends StatefulWidget {
  final TransacoesController controller;
  final Transacao? receita;

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
  String? _categoriaSelecionada;
  late DateTime _data;
  bool _mostrarChips = false;

  bool get _editando => widget.receita != null;

  @override
  void initState() {
    super.initState();
    final receita = widget.receita;
    _valorController = TextEditingController(
      text: receita == null
          ? '0,00'
          : FormatadorMoeda.formatarCampo(receita.valorCentavos),
    );
    _descricaoController = TextEditingController(
      text: receita == null || receita.descricao == receita.categoria
          ? ''
          : receita.descricao,
    );
    _categoriaSelecionada = receita?.categoria;
    _data = receita?.data ?? DateTime.now();
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
    return widget.controller.categoriasReceita
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
    for (final categoria in widget.controller.categoriasReceita) {
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
      tipo: TipoTransacao.receita,
      aoSalvarCustomizado: (nome) =>
          widget.controller.criarCategoria(nome, TipoTransacao.receita),
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
      _aviso('Informe o valor recebido.');
      return;
    }

    final categoria = _categoriaEntidade;
    if (categoria == null) {
      _aviso('Selecione o tipo de receita.');
      return;
    }

    final sucesso = await widget.controller.salvarReceita(
      existente: widget.receita,
      descricao: _descricaoController.text.trim(),
      categoria: categoria,
      valorFormatado: _valorController.text,
      data: _data,
    );

    if (!mounted || sucesso) return;
    _aviso(widget.controller.mensagemErro ?? 'Não foi possível salvar a receita.');
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
                value: _categoriaSelecionada,
                options: _opcoes,
                onSelected: (categoria) {
                  setState(() => _categoriaSelecionada = categoria.nome);
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
                hint: 'Ex.: salário do mês',
              ),
              const SizedBox(height: 19),
              const FormLabel('Data do recebimento'),
              DateField(
                value: FormatadorMoeda.formatarDataCurta(_data),
                onTap: _selecionarData,
              ),
              const SizedBox(height: 22),
              SizedBox(
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
