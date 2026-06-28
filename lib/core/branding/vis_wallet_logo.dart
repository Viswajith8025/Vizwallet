import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';

/// Geometric logo: rounded wallet card with stylized "V".
/// Works at 24px (notification) through 96px (splash).
class VisWalletLogo extends StatelessWidget {
  const VisWalletLogo({
    super.key,
    this.size = 48,
    this.showShadow = false,
  });

  final double size;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BrandColors.primary,
            BrandColors.secondary,
          ],
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: BrandColors.primary.withValues(alpha: 0.35),
                  blurRadius: size * 0.25,
                  offset: Offset(0, size * 0.08),
                ),
              ]
            : null,
      ),
      child: CustomPaint(
        painter: _VisLogoPainter(),
      ),
    );
  }
}

class _VisLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Wallet fold line
    final foldPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = w * 0.04
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.15, h * 0.32),
      Offset(w * 0.85, h * 0.32),
      foldPaint,
    );

    // Stylized V
    final vPath = Path()
      ..moveTo(w * 0.28, h * 0.42)
      ..lineTo(w * 0.5, h * 0.72)
      ..lineTo(w * 0.72, h * 0.42);
    final vPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = w * 0.1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(vPath, vPaint);

    // Accent dot — growth indicator
    canvas.drawCircle(
      Offset(w * 0.72, h * 0.28),
      w * 0.06,
      Paint()..color = BrandColors.accent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Wordmark: "Viz" bold + "wallet" regular
class VisWalletWordmark extends StatelessWidget {
  const VisWalletWordmark({
    super.key,
    this.fontSize = 28,
    this.color,
  });

  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          height: 1.1,
          color: c,
        ),
        children: [
          TextSpan(
            text: 'Viz',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: 'wallet',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: c.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
