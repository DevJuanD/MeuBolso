import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Marca do MeuBolso reconstruída a partir dos vetores do documento original.
class MeuBolsoLogo extends StatelessWidget {
  final double scale;
  final bool showWordmark;

  const MeuBolsoLogo({
    super.key,
    this.scale = 1,
    this.showWordmark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(31.25 * scale, 20.75 * scale),
          painter: _LogoMarkPainter(),
        ),
        if (showWordmark)
          Transform.translate(
            offset: Offset(-0.5 * scale, -1.2 * scale),
            child: Text(
              'MeuBolso',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: AppColors.primary,
                fontSize: 19.45 * scale,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.65 * scale,
                height: 1,
              ),
            ),
          ),
      ],
    );
  }
}

class _LogoMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 31.25;
    final scaleY = size.height / 20.75;
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(6.10 * scaleX, 20.50 * scaleY)
      ..lineTo(0.00, 20.50 * scaleY)
      ..lineTo(0.00, 13.00 * scaleY)
      ..lineTo(10.30 * scaleX, 0.00)
      ..lineTo(16.60 * scaleX, 0.00)
      ..lineTo(16.60 * scaleX, 6.10 * scaleY)
      ..lineTo(12.90 * scaleX, 6.10 * scaleY)
      ..lineTo(6.10 * scaleX, 14.70 * scaleY)
      ..close();

    final path2 = Path()
      ..moveTo(16.80 * scaleX, 20.50 * scaleY)
      ..lineTo(11.00 * scaleX, 20.50 * scaleY)
      ..lineTo(11.00 * scaleX, 15.20 * scaleY)
      ..lineTo(22.50 * scaleX, 0.00)
      ..lineTo(31.20 * scaleX, 0.00)
      ..lineTo(31.20 * scaleX, 6.60 * scaleY)
      ..lineTo(28.10 * scaleX, 10.00 * scaleY)
      ..lineTo(31.20 * scaleX, 13.20 * scaleY)
      ..lineTo(31.20 * scaleX, 20.80 * scaleY)
      ..lineTo(22.00 * scaleX, 20.80 * scaleY)
      ..lineTo(22.00 * scaleX, 14.20 * scaleY)
      ..close();

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
