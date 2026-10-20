import 'package:flutter/material.dart';

enum TipoMovimentacao {
  receita,
  despesa;

  bool get isReceita => this == TipoMovimentacao.receita;
}

class Movimentacao {
  final int id;
  final String descricao;
  final String categoria;
  final int valorCentavos;
  final DateTime data;
  final TipoMovimentacao tipo;

  const Movimentacao({
    required this.id,
    required this.descricao,
    required this.categoria,
    required this.valorCentavos,
    required this.data,
    required this.tipo,
  });

  double get valor => valorCentavos / 100;

  Movimentacao copyWith({
    String? descricao,
    String? categoria,
    int? valorCentavos,
    DateTime? data,
    TipoMovimentacao? tipo,
  }) {
    return Movimentacao(
      id: id,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      valorCentavos: valorCentavos ?? this.valorCentavos,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
    );
  }
}

class CategoriaFinanceira {
  final String nome;
  final IconData icone;
  final Color cor;

  const CategoriaFinanceira({
    required this.nome,
    required this.icone,
    required this.cor,
  });
}

class CategoriaRelatorio {
  final String nome;
  final int valorCentavos;
  final double percentual;
  final Color cor;

  const CategoriaRelatorio({
    required this.nome,
    required this.valorCentavos,
    required this.percentual,
    required this.cor,
  });
}

String formatarMoeda(int centavos, {bool comSinal = false, bool espaco = true}) {
  final negativo = centavos < 0;
  final absoluto = centavos.abs();
  final reais = absoluto ~/ 100;
  final centavosRestantes = (absoluto % 100).toString().padLeft(2, '0');
  final inteiro = _agruparMilhares(reais.toString());
  final sinal = comSinal ? (negativo ? '− ' : '+ ') : (negativo ? '− ' : '');
  return '${sinal}R\$${espaco ? ' ' : ''}$inteiro,$centavosRestantes';
}

String _agruparMilhares(String valor) {
  final buffer = StringBuffer();
  for (var i = 0; i < valor.length; i++) {
    if (i > 0 && (valor.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(valor[i]);
  }
  return buffer.toString();
}

String formatarDataCurta(DateTime data) {
  final dia = data.day.toString().padLeft(2, '0');
  final mes = data.month.toString().padLeft(2, '0');
  return '$dia/$mes/${data.year}';
}

String formatarDataAbreviada(DateTime data) {
  final dia = data.day.toString().padLeft(2, '0');
  final meses = [
    'jan.',
    'fev.',
    'mar.',
    'abr.',
    'mai.',
    'jun.',
    'jul.',
    'ago.',
    'set.',
    'out.',
    'nov.',
    'dez.',
  ];
  return '$dia ${meses[data.month - 1]}';
}

String formatarMesAno(DateTime data) {
  const meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];
  return '${meses[data.month - 1]} ${data.year}';
}

String formatarMesCurto(DateTime data) {
  const meses = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];
  return '${meses[data.month - 1]} ${data.year}';
}

int parseValorParaCentavos(String texto) {
  final limpo = texto
      .replaceAll('R\$', '')
      .replaceAll(' ', '')
      .replaceAll('.', '')
      .replaceAll(',', '.')
      .trim();
  final valor = double.tryParse(limpo) ?? 0;
  return (valor * 100).round();
}

String formatarCampoValor(int centavos) {
  final reais = centavos ~/ 100;
  final resto = (centavos % 100).toString().padLeft(2, '0');
  return '$reais,$resto';
}

final DateTime dataReferencia = DateTime(2026, 10, 18);

