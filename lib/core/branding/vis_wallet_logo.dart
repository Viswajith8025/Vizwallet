import 'package:flutter/material.dart';

/// Premium Viswallet mark — wallet card + integrated V + growth flow.
///
/// Scales cleanly from 24px (notification) through 128px (splash).
class VisWalletLogo extends StatelessWidget {
  const VisWalletLogo({
    super.key,
    this.size = 48,
    this.showShadow = false,
    this.variant = VisWalletLogoVariant.auto,
  });

  final double size;
  final bool showShadow;
  final VisWalletLogoVariant variant;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final resolved = variant == VisWalletLogoVariant.auto
        ? (brightness == Brightness.dark
            ? VisWalletLogoVariant.dark
            : VisWalletLogoVariant.brand)
        : variant;

    final colors = _LogoPalette.fromVariant(resolved);
    final radius = size * 0.22;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: colors.glow.withValues(alpha: 0.5),
                  blurRadius: size * 0.34,
                  offset: Offset(0, size * 0.12),
                ),
              ]
            : null,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors.background,
            stops: colors.backgroundStops,
          ),
          border: Border.all(
            color: colors.border,
            width: size < 36 ? 1 : 1.25,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.55, -0.65),
                    radius: 0.95,
                    colors: [
                      colors.shine.withValues(alpha: 0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              CustomPaint(
                painter: _VisLogoPainter(colors: colors, size: size),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum VisWalletLogoVariant { auto, dark, brand, monoDark, monoLight }

class _LogoPalette {
  const _LogoPalette({
    required this.background,
    required this.backgroundStops,
    required this.mark,
    required this.markSoft,
    required this.chip,
    required this.fold,
    required this.growth,
    required this.accent,
    required this.glow,
    required this.border,
    required this.shine,
  });

  final List<Color> background;
  final List<double>? backgroundStops;
  final Color mark;
  final Color markSoft;
  final Color chip;
  final Color fold;
  final Color growth;
  final Color accent;
  final Color glow;
  final Color border;
  final Color shine;

  factory _LogoPalette.fromVariant(VisWalletLogoVariant variant) {
    return switch (variant) {
      VisWalletLogoVariant.dark => const _LogoPalette(
          background: [
            Color(0xFF7C5CBF),
            Color(0xFF5B3FA6),
            Color(0xFF2E1F5C),
          ],
          backgroundStops: [0.0, 0.52, 1.0],
          mark: Color(0xFFE8DEFF),
          markSoft: Color(0xFFC4B5FD),
          chip: Color(0x40C4B5FD),
          fold: Color(0x55C4B5FD),
          growth: Color(0xFFB794F6),
          accent: Color(0xFFFFD166),
          glow: Color(0xFF7C5CBF),
          border: Color(0x559B6DFF),
          shine: Color(0xFFC4B5FD),
        ),
      VisWalletLogoVariant.brand => const _LogoPalette(
          background: [
            Color(0xFF8B6FD4),
            Color(0xFF5B3FA6),
            Color(0xFF3D2A6B),
          ],
          backgroundStops: [0.0, 0.55, 1.0],
          mark: Color(0xFFF3EEFF),
          markSoft: Color(0xFFD8C4FF),
          chip: Color(0x45D8C4FF),
          fold: Color(0x55D8C4FF),
          growth: Color(0xFFA78BFA),
          accent: Color(0xFFFFD166),
          glow: Color(0xFF6B4BBF),
          border: Color(0x4D9B6DFF),
          shine: Color(0xFFE9D5FF),
        ),
      VisWalletLogoVariant.monoDark => const _LogoPalette(
          background: [Color(0xFF1A1A22), Color(0xFF121218)],
          backgroundStops: null,
          mark: Color(0xFFC4B5FD),
          markSoft: Color(0xFF9B6DFF),
          chip: Color(0x2EC4B5FD),
          fold: Color(0x3DC4B5FD),
          growth: Color(0x809B6DFF),
          accent: Color(0xFF9B6DFF),
          glow: Color(0xFF1A1A22),
          border: Color(0x33C4B5FD),
          shine: Color(0xFF9B6DFF),
        ),
      VisWalletLogoVariant.monoLight => const _LogoPalette(
          background: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
          backgroundStops: null,
          mark: Color(0xFF4C2D8A),
          markSoft: Color(0xFF6B4BBF),
          chip: Color(0x286B4BBF),
          fold: Color(0x386B4BBF),
          growth: Color(0x8C7C5CBF),
          accent: Color(0xFF5B3FA6),
          glow: Color(0xFFEDE9FE),
          border: Color(0x335B3FA6),
          shine: Color(0xFFC4B5FD),
        ),
      VisWalletLogoVariant.auto => _LogoPalette.fromVariant(
          VisWalletLogoVariant.brand,
        ),
    };
  }
}

class _VisLogoPainter extends CustomPainter {
  const _VisLogoPainter({required this.colors, required this.size});

  final _LogoPalette colors;
  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final w = canvasSize.width;
    final h = canvasSize.height;
    final compact = size < 40;

    final chipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.17, h * 0.21, w * 0.11, h * 0.086),
      Radius.circular(w * 0.02),
    );
    canvas.drawRRect(chipRect, Paint()..color = colors.chip);

    canvas.drawLine(
      Offset(w * 0.19, h * 0.33),
      Offset(w * 0.81, h * 0.33),
      Paint()
        ..color = colors.fold
        ..strokeWidth = w * 0.02
        ..strokeCap = StrokeCap.round,
    );

    final vPath = Path()
      ..moveTo(w * 0.305, h * 0.38)
      ..lineTo(w * 0.5, h * 0.68)
      ..lineTo(w * 0.695, h * 0.38);
    canvas.drawPath(
      vPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.mark, colors.markSoft],
        ).createShader(Rect.fromLTWH(0, 0, w, h))
        ..strokeWidth = compact ? w * 0.095 : w * 0.086
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final growthPath = Path()
      ..moveTo(w * 0.695, h * 0.38)
      ..cubicTo(
        w * 0.73,
        h * 0.30,
        w * 0.77,
        h * 0.255,
        w * 0.766,
        h * 0.258,
      );
    canvas.drawPath(
      growthPath,
      Paint()
        ..color = colors.growth
        ..strokeWidth = w * 0.055
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    final accentCenter = Offset(w * 0.766, h * 0.258);
    final accentRadius = compact ? w * 0.042 : w * 0.035;
    canvas.drawCircle(
      accentCenter,
      accentRadius * 1.7,
      Paint()..color = colors.accent.withValues(alpha: 0.35),
    );
    canvas.drawCircle(
      accentCenter,
      accentRadius,
      Paint()..color = colors.accent,
    );
  }

  @override
  bool shouldRepaint(covariant _VisLogoPainter oldDelegate) =>
      oldDelegate.colors != colors || oldDelegate.size != size;
}

/// Wordmark: Viswallet (single brand name).
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
    final theme = Theme.of(context);
    final primary = color ?? theme.colorScheme.onSurface;

    return Text(
      'Viswallet',
      style: TextStyle(
        fontSize: fontSize,
        height: 1.05,
        letterSpacing: fontSize * -0.03,
        fontWeight: FontWeight.w800,
        color: primary,
      ),
    );
  }
}

/// Icon + wordmark lockup for splash and auth screens.
class VisWalletBrandLockup extends StatelessWidget {
  const VisWalletBrandLockup({
    super.key,
    this.logoSize = 80,
    this.wordmarkSize = 30,
    this.axis = Axis.vertical,
    this.showShadow = true,
  });

  final double logoSize;
  final double wordmarkSize;
  final Axis axis;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final logo = VisWalletLogo(
      size: logoSize,
      showShadow: showShadow,
      variant: VisWalletLogoVariant.brand,
    );
    final wordmark = VisWalletWordmark(fontSize: wordmarkSize);

    if (axis == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          logo,
          SizedBox(width: logoSize * 0.28),
          wordmark,
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logo,
        SizedBox(height: logoSize * 0.28),
        wordmark,
      ],
    );
  }
}
