// CaritaAvatar — la identidad visual de cada LO en TODA la app (mapa, fichas,
// listas). 8 expresiones x 4 formas x 5 combos de paleta oficial, o foto real.
// Canon P1B: solo colores de la paleta; sombras navy; nada fuera de sistema.
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/tokens.dart';
import '../core/i18n.dart';
import '../models/loan_officer.dart';

/// Combos (fondo, rasgos) — todos con contraste valido del P1B.
const kAvatarCombos = <List<Color>>[
  [T.yellow, T.navy],   // Latin Mornings / navy
  [T.sky, T.navy],      // Light Sky / navy
  [T.red, T.white],     // Warm Embrace / New Day
  [T.navy, T.sky],      // navy / sky
  [T.white, T.navy],    // New Day / navy (lleva borde hairline)
];

/// Nombres para lectores de pantalla y tooltips del selector (bilingues).
List<String> faceNames() => [
  l10n.t('Smile', 'Sonrisa'), l10n.t('Glasses', 'Gafas'),
  l10n.t('Moustache', 'Bigote'), l10n.t('Wink', 'Guiño'),
  l10n.t('Happy', 'Feliz'), l10n.t('Cap', 'Gorra'),
  l10n.t('Beard', 'Barba'), l10n.t('Cool', 'Cool'),
];
List<String> shapeNames() => [
  l10n.t('Circle', 'Círculo'), 'Squircle',
  l10n.t('Hexagon', 'Hexágono'), l10n.t('Diamond', 'Diamante'),
];

class CaritaAvatar extends StatelessWidget {
  final AvatarSpec spec;
  final double size;
  final bool ring;          // aro blanco para leerse sobre el mapa navy
  const CaritaAvatar({super.key, required this.spec, this.size = 40, this.ring = false});

  @override
  Widget build(BuildContext context) {
    Widget core;
    final photo = spec.photoPath;
    if (photo != null) {
      core = ClipPath(
        clipper: _ShapeClipper(spec.shape),
        child: Image.file(File(photo), width: size, height: size, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => CustomPaint(size: Size.square(size),
                painter: _CaritaPainter(spec))),
      );
    } else {
      core = CustomPaint(size: Size.square(size), painter: _CaritaPainter(spec));
    }
    if (!ring) return SizedBox.square(dimension: size, child: core);
    return Container(
      width: size + T.sp8, height: size + T.sp8, alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: T.white,
          boxShadow: T.shadowSm),
      child: SizedBox.square(dimension: size, child: core),
    );
  }
}

Path shapePath(int shape, Size s) {
  final r = Rect.fromLTWH(0, 0, s.width, s.height);
  switch (shape) {
    case 1: // squircle
      return Path()..addRRect(RRect.fromRectAndRadius(r, Radius.circular(s.width * .3)));
    case 2: // hexagono
      final p = Path();
      final c = s.center(Offset.zero);
      final rad = s.width / 2;
      for (var i = 0; i < 6; i++) {
        final a = math.pi / 180 * (60.0 * i - 90);
        final pt = Offset(c.dx + rad * math.cos(a), c.dy + rad * math.sin(a));
        i == 0 ? p.moveTo(pt.dx, pt.dy) : p.lineTo(pt.dx, pt.dy);
      }
      return p..close();
    case 3: // diamante (cuadrado rotado con esquinas suaves)
      final c = s.center(Offset.zero);
      final rad = s.width / 2;
      final p = Path()
        ..moveTo(c.dx, c.dy - rad)..lineTo(c.dx + rad, c.dy)
        ..lineTo(c.dx, c.dy + rad)..lineTo(c.dx - rad, c.dy)..close();
      return p;
    default: // circulo
      return Path()..addOval(r);
  }
}

class _ShapeClipper extends CustomClipper<Path> {
  final int shape;
  _ShapeClipper(this.shape);
  @override
  Path getClip(Size size) => shapePath(shape, size);
  @override
  bool shouldReclip(_ShapeClipper old) => old.shape != shape;
}

class _CaritaPainter extends CustomPainter {
  final AvatarSpec spec;
  _CaritaPainter(this.spec);

  @override
  void paint(Canvas canvas, Size size) {
    final combo = kAvatarCombos[spec.color % kAvatarCombos.length];
    final bg = combo[0], fg = combo[1];
    final path = shapePath(spec.shape, size);
    canvas.drawPath(path, Paint()..color = bg);
    if (bg == T.white) {
      canvas.drawPath(path, Paint()..color = T.hairline
        ..style = PaintingStyle.stroke..strokeWidth = size.width * .04);
    }
    canvas.save();
    canvas.clipPath(path);

    final w = size.width, h = size.height;
    final stroke = Paint()..color = fg..style = PaintingStyle.stroke
      ..strokeWidth = w * .06..strokeCap = StrokeCap.round;
    final fill = Paint()..color = fg;

    void eyes({double dy = 0, bool wink = false, bool happyArcs = false}) {
      final y = h * (.42 + dy);
      if (happyArcs) {
        // ojitos felices ∪ invertida
        canvas.drawArc(Rect.fromCircle(center: Offset(w * .35, y), radius: w * .07),
            math.pi, math.pi, false, stroke);
        canvas.drawArc(Rect.fromCircle(center: Offset(w * .65, y), radius: w * .07),
            math.pi, math.pi, false, stroke);
        return;
      }
      canvas.drawCircle(Offset(w * .35, y), w * .055, fill);
      if (wink) {
        canvas.drawLine(Offset(w * .58, y), Offset(w * .72, y), stroke);
      } else {
        canvas.drawCircle(Offset(w * .65, y), w * .055, fill);
      }
    }

    void smile({double width = .32, double dy = 0}) {
      canvas.drawArc(
          Rect.fromCenter(center: Offset(w * .5, h * (.58 + dy)),
              width: w * width * 2, height: h * .3),
          math.pi * .15, math.pi * .7, false, stroke);
    }

    switch (spec.face % 8) {
      case 0: // Sonrisa clasica
        eyes(); smile();
        break;
      case 1: // Gafas
        canvas.drawCircle(Offset(w * .35, h * .42), w * .13, stroke);
        canvas.drawCircle(Offset(w * .65, h * .42), w * .13, stroke);
        canvas.drawLine(Offset(w * .48, h * .42), Offset(w * .52, h * .42), stroke);
        smile(width: .26, dy: .04);
        break;
      case 2: // Bigote
        eyes();
        final m = Path()
          ..moveTo(w * .5, h * .60)
          ..quadraticBezierTo(w * .36, h * .52, w * .26, h * .62)
          ..quadraticBezierTo(w * .38, h * .68, w * .5, h * .62)
          ..quadraticBezierTo(w * .62, h * .68, w * .74, h * .62)
          ..quadraticBezierTo(w * .64, h * .52, w * .5, h * .60);
        canvas.drawPath(m, fill);
        smile(width: .18, dy: .12);
        break;
      case 3: // Guiño
        eyes(wink: true); smile();
        break;
      case 4: // Feliz (ojos arco + sonrisa grande)
        eyes(happyArcs: true); smile(width: .36, dy: .02);
        break;
      case 5: // Gorra
        final cap = Path()
          ..moveTo(w * .18, h * .34)
          ..quadraticBezierTo(w * .5, h * .02, w * .82, h * .34)
          ..lineTo(w * .95, h * .36)..lineTo(w * .95, h * .42)
          ..lineTo(w * .18, h * .40)..close();
        canvas.drawPath(cap, fill);
        eyes(dy: .10); smile(dy: .08, width: .26);
        break;
      case 6: // Barba
        final beard = Path()
          ..moveTo(w * .22, h * .52)
          ..quadraticBezierTo(w * .22, h * .92, w * .5, h * .92)
          ..quadraticBezierTo(w * .78, h * .92, w * .78, h * .52)
          ..quadraticBezierTo(w * .5, h * .66, w * .22, h * .52);
        canvas.drawPath(beard, fill);
        // boca clara dentro de la barba
        canvas.drawArc(
            Rect.fromCenter(center: Offset(w * .5, h * .68), width: w * .3, height: h * .16),
            math.pi * .15, math.pi * .7, false,
            Paint()..color = bg..style = PaintingStyle.stroke
              ..strokeWidth = w * .05..strokeCap = StrokeCap.round);
        eyes(dy: -.04);
        break;
      case 7: // Cool (lentes de sol)
        final glass = Path()
          ..addRRect(RRect.fromRectAndRadius(
              Rect.fromLTWH(w * .20, h * .34, w * .24, h * .14), Radius.circular(w * .05)))
          ..addRRect(RRect.fromRectAndRadius(
              Rect.fromLTWH(w * .56, h * .34, w * .24, h * .14), Radius.circular(w * .05)));
        canvas.drawPath(glass, fill);
        canvas.drawLine(Offset(w * .44, h * .38), Offset(w * .56, h * .38), stroke);
        smile(width: .24, dy: .06);
        break;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CaritaPainter old) =>
      old.spec.face != spec.face || old.spec.shape != spec.shape ||
      old.spec.color != spec.color;
}
