import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/movimentacao.dart';
import '../../domain/models/relatorio.dart';

class ReceitasDespesasChart extends StatelessWidget {
  final List<PontoGrafico> pontos;
  final double height;

  const ReceitasDespesasChart({
    super.key,
    required this.pontos,
    this.height = 178,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _BarChartPainter(pontos: pontos),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<PontoGrafico> pontos;

  _BarChartPainter({required this.pontos});

  @override
  void paint(Canvas canvas, Size size) {
    const left = 43.0;
    const right = 5.0;
    const top = 24.0;
    const bottom = 30.0;
    final plotWidth = size.width - left - right;
    final plotHeight = size.height - top - bottom;
    const maxValue = 400000.0;

    final gridPaint = Paint()
      ..color = const Color(0xFFEDF1F6)
      ..strokeWidth = 1;

    const gridValues = [400000, 200000, 0];
    const gridLabels = ['R\$ 4 mil', 'R\$ 2 mil', 'R\$ 0'];

    for (var i = 0; i < gridValues.length; i++) {
      final y = top + plotHeight - (gridValues[i] / maxValue) * plotHeight;
      canvas.drawLine(Offset(left, y), Offset(size.width - right, y), gridPaint);
      _paintText(
        canvas,
        gridLabels[i],
        Offset(left - 8, y),
        TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 9,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        alignRight: true,
        verticalCenter: true,
      );
    }

    if (pontos.isEmpty) return;

    final groupWidth = plotWidth / pontos.length;
    final barWidth = math.min(22.0, groupWidth * (pontos.length == 1 ? 0.13 : 0.16));
    const barGap = 7.0;
    final valueFontSize = pontos.length > 3 ? 8.0 : 10.0;
    final labelFontSize = pontos.length > 3 ? 7.5 : 10.0;

    for (var i = 0; i < pontos.length; i++) {
      final ponto = pontos[i];
      final center = left + groupWidth * (i + 0.5);
      final greenCenter = center - (barWidth + barGap) / 2;
      final redCenter = center + (barWidth + barGap) / 2;

      _drawBar(
        canvas,
        center: greenCenter,
        value: ponto.receitasCentavos.toDouble(),
        maxValue: maxValue,
        plotHeight: plotHeight,
        top: top,
        width: barWidth,
        color: AppColors.chartPositive,
      );
      _drawBar(
        canvas,
        center: redCenter,
        value: ponto.despesasCentavos.toDouble(),
        maxValue: maxValue,
        plotHeight: plotHeight,
        top: top,
        width: barWidth,
        color: AppColors.chartNegative,
      );

      final greenValueY = top +
          plotHeight -
          (ponto.receitasCentavos / maxValue) * plotHeight -
          7;
      final redValueY = top +
          plotHeight -
          (ponto.despesasCentavos / maxValue) * plotHeight -
          7;
      _paintText(
        canvas,
        _valorBarra(ponto.receitasCentavos),
        Offset(greenCenter, greenValueY),
        TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: valueFontSize,
          fontWeight: FontWeight.w600,
          color: AppColors.positiveDark,
        ),
        centerHorizontally: true,
        bottom: true,
      );
      _paintText(
        canvas,
        _valorBarra(ponto.despesasCentavos),
        Offset(redCenter, redValueY),
        TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: valueFontSize,
          fontWeight: FontWeight.w600,
          color: AppColors.negativeDark,
        ),
        centerHorizontally: true,
        bottom: true,
      );

      _paintText(
        canvas,
        ponto.rotulo,
        Offset(center, size.height - 10),
        TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: labelFontSize,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
        ),
        centerHorizontally: true,
      );
    }
  }

  void _drawBar(
    Canvas canvas, {
    required double center,
    required double value,
    required double maxValue,
    required double plotHeight,
    required double top,
    required double width,
    required Color color,
  }) {
    final barHeight = (value / maxValue) * plotHeight;
    final rect = Rect.fromLTWH(
      center - width / 2,
      top + plotHeight - barHeight,
      width,
      barHeight,
    );
    final path = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: const Radius.circular(5),
          topRight: const Radius.circular(5),
          bottomLeft: const Radius.circular(2),
          bottomRight: const Radius.circular(2),
        ),
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  String _valorBarra(int centavos) {
    final digitos = (centavos ~/ 100).toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digitos.length; i++) {
      if (i > 0 && (digitos.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digitos[i]);
    }
    return buffer.toString();
  }

  void _paintText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style, {
    bool centerHorizontally = false,
    bool alignRight = false,
    bool verticalCenter = false,
    bool bottom = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = offset.dx;
    var dy = offset.dy;
    if (centerHorizontally) dx -= painter.width / 2;
    if (alignRight) dx -= painter.width;
    if (verticalCenter) dy -= painter.height / 2;
    if (bottom) dy -= painter.height;
    painter.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    if (oldDelegate.pontos.length != pontos.length) return true;
    for (var i = 0; i < pontos.length; i++) {
      if (oldDelegate.pontos[i].receitasCentavos != pontos[i].receitasCentavos ||
          oldDelegate.pontos[i].despesasCentavos != pontos[i].despesasCentavos ||
          oldDelegate.pontos[i].rotulo != pontos[i].rotulo) {
        return true;
      }
    }
    return false;
  }
}

class DonutChart extends StatelessWidget {
  final List<CategoriaRelatorio> categorias;
  final int totalCentavos;
  final double size;

  const DonutChart({
    super.key,
    required this.categorias,
    required this.totalCentavos,
    this.size = 124,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutPainter(categorias: categorias),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total gasto',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 8.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBody,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formatarMoeda(totalCentavos),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: AppColors.textHeading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<CategoriaRelatorio> categorias;

  _DonutPainter({required this.categorias});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 22) / 2;
    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 19
      ..color = AppColors.primarySoft;
    canvas.drawCircle(center, radius, backgroundPaint);

    if (categorias.isEmpty) return;

    final total = categorias.fold<double>(
      0,
      (soma, categoria) => soma + categoria.percentual,
    );
    var start = -math.pi / 2;
    for (final categoria in categorias) {
      final sweep = (categoria.percentual / total) * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 19
        ..strokeCap = StrokeCap.butt
        ..color = categoria.cor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start + 0.018,
        math.max(0, sweep - 0.036),
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => true;
}

class CategoryBreakdown extends StatelessWidget {
  final List<CategoriaRelatorio> categorias;

  const CategoryBreakdown({
    super.key,
    required this.categorias,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < categorias.length; i++)
          Container(
            height: 33,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.only(bottom: 1),
            decoration: BoxDecoration(
              color: i == 0 ? AppColors.primarySoft : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: categorias[i].cor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    categorias[i].nome,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 11,
                      fontWeight: i == 0 ? FontWeight.w600 : FontWeight.w400,
                      color: i == 0
                          ? AppColors.textHeading
                          : AppColors.textBody,
                    ),
                  ),
                ),
                Text(
                  formatarMoeda(categorias[i].valorCentavos),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHeading,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 48,
                  child: Text(
                    '${categorias[i].percentual.toStringAsFixed(2).replaceAll('.', ',')}%',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
