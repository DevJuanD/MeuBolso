import 'package:intl/intl.dart';

/// Utilitários de formatação monetária e de data padronizados para pt_BR.
abstract final class FormatadorMoeda {
  static final NumberFormat _moedaFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static final DateFormat _dataCurtaFormat = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final DateFormat _dataAbreviadaFormat = DateFormat("dd MMM", 'pt_BR');
  static final DateFormat _mesAnoFormat = DateFormat('MMMM yyyy', 'pt_BR');

  /// Formata centavos em moeda corrente brasileira (ex: R$ 3.250,00).
  static String formatar(int centavos, {bool comSinal = false, bool espaco = true}) {
    final negativo = centavos < 0;
    final valorEmReais = centavos.abs() / 100.0;
    final formatado = _moedaFormat.format(valorEmReais);
    // Ajusta espaçamento se necessário
    final textoBase = espaco ? formatado : formatado.replaceAll('R\$ ', 'R\$');
    if (!comSinal) {
      return negativo ? '− $textoBase' : textoBase;
    }
    return negativo ? '− $textoBase' : '+ $textoBase';
  }

  /// Formata a data no padrão dd/MM/aaaa (ex: 18/10/2026).
  static String formatarDataCurta(DateTime data) {
    return _dataCurtaFormat.format(data);
  }

  /// Formata a data abreviada (ex: 05 out.).
  static String formatarDataAbreviada(DateTime data) {
    final formatado = _dataAbreviadaFormat.format(data).toLowerCase();
    // Ex: "05 out."
    if (!formatado.endsWith('.')) {
      return '$formatado.';
    }
    return formatado;
  }

  /// Formata mês e ano por extenso (ex: Outubro 2026).
  static String formatarMesAno(DateTime data) {
    final texto = _mesAnoFormat.format(data);
    if (texto.isEmpty) return texto;
    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }

  /// Converte texto digitado pelo usuário (ex: "2.500,00" ou "2500,00") para centavos inteiros.
  static int converterTextoParaCentavos(String texto) {
    final limpo = texto
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    final valor = double.tryParse(limpo) ?? 0.0;
    return (valor * 100).round();
  }

  /// Formata centavos para exibição em campos de entrada (ex: "2.500,00" ou "0,00").
  static String formatarCampo(int centavos) {
    final valorEmReais = centavos / 100.0;
    final formatado = NumberFormat('#,##0.00', 'pt_BR').format(valorEmReais);
    return formatado;
  }
}
