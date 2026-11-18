// MedallaCasa — silueta de la casa del logo sobre disco metalico.
// Excepcion ratificada A0: bronce/plata/oro SOLO aqui, nunca como color de
// marca, texto, fondo o acento.
import 'package:flutter/material.dart';
import '../core/tokens.dart';

class MedallaCasa extends StatelessWidget {
  final Color metal;
  final double size;
  const MedallaCasa({super.key, required this.metal, this.size = 56});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _MedalPainter(metal));
}

class _MedalPainter extends CustomPainter {
  final Color metal;
  _MedalPainter(this.metal);

  @override
  void paint(Canvas canvas, Size s) {
    final c = s.center(Offset.zero);
    final r = s.width / 2;
    canvas.drawCircle(c, r, Paint()..color = metal);
    canvas.drawCircle(c, r * .88, Paint()
      ..color = T.navy.withValues(alpha: .22)
      ..style = PaintingStyle.stroke..strokeWidth = s.width * .035);

    // Casa: techo triangular + cuerpo, en navy sobre el metal.
    final w = s.width;
    final house = Path()
      ..moveTo(c.dx, c.dy - r * .42)                 // cumbrera
      ..lineTo(c.dx + r * .46, c.dy - r * .02)       // alero derecho
      ..lineTo(c.dx + r * .30, c.dy - r * .02)
      ..lineTo(c.dx + r * .30, c.dy + r * .44)       // muro derecho
      ..lineTo(c.dx - r * .30, c.dy + r * .44)
      ..lineTo(c.dx - r * .30, c.dy - r * .02)
      ..lineTo(c.dx - r * .46, c.dy - r * .02)
      ..close();
    canvas.drawPath(house, Paint()..color = T.navy);

    // Puerta calada
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(c.dx, c.dy + r * .26),
            width: w * .12, height: w * .18),
        Radius.circular(w * .03)),
      Paint()..color = metal);
  }

  @override
  bool shouldRepaint(_MedalPainter old) => old.metal != metal;
}
