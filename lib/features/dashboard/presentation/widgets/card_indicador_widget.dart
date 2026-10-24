import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatador_moeda.dart';

/// Define a natureza do indicador para adequar as cores exibidas.
enum TipoIndicador { saldo, receita, despesa }

/// Cartão reutilizável de indicador financeiro da tela T02.
///
/// Adapta automaticamente as cores de acordo com o [tipo] e o sinal do
/// valor/variação (positivo ou negativo).
class CardIndicadorWidget extends StatelessWidget {
  final TipoIndicador tipo;
  final String rotulo;
  final int valorCentavos;
  final double variacaoPercentual;
  final IconData icone;
  final bool destaque;
  final VoidCallback? onTap;

  const CardIndicadorWidget({
    super.key,
    required this.tipo,
    required this.rotulo,
    required this.valorCentavos,
    required this.variacaoPercentual,
    required this.icone,
    this.destaque = false,
    this.onTap,
  });

  bool get _negativo => switch (tipo) {
        TipoIndicador.receita => false,
        TipoIndicador.despesa => true,
        TipoIndicador.saldo => valorCentavos < 0,
      };

  Color get _corAcento => _negativo ? AppColors.negative : AppColors.positive;

  Color get _corFundo =>
      _negativo ? AppColors.negativeSoft : AppColors.positiveSoft;

  bool get _variacaoCresceu => variacaoPercentual >= 0;

  @override
  Widget build(BuildContext context) {
    final textoVariacao = formatarVariacao(variacaoPercentual);
    if (destaque) {
      return _buildCartaoDestaque(textoVariacao);
    }
    return _buildCartaoCompacto(textoVariacao);
  }

  Widget _buildCartaoDestaque(String textoVariacao) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 146),
        padding: const EdgeInsets.fromLTRB(22, 20, 20, 22),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E8350FF),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    rotulo,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icone, size: 17, color: Colors.white),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                FormatadorMoeda.formatar(valorCentavos),
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 31,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  _variacaoCresceu
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '$textoVariacao em relação ao mês anterior',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartaoCompacto(String textoVariacao) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.fromLTRB(11, 10, 9, 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color(0x081E293B),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _corFundo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icone, size: 16, color: _corAcento),
              ),
              const SizedBox(height: 8),
              Text(
                rotulo,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 9.2,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBody,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  FormatadorMoeda.formatar(valorCentavos),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHeading,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                textoVariacao,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: _variacaoCresceu
                      ? AppColors.positive
                      : AppColors.negativeDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formata o percentual no padrão pt_BR com sinal (ex: "+12,5%" / "−4,7%").
  static String formatarVariacao(double valor) {
    final texto = valor.abs().toStringAsFixed(1).replaceAll('.', ',');
    final sinal = valor < 0 ? '−' : '+';
    return '$sinal$texto%';
  }
}
