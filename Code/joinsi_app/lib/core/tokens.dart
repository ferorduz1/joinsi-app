// JOINSI · Tokens del P1B Sistema de Marca HOMESI Oficial.
// NOTA TIPOGRAFICA: Poppins es sustituto declarado de Articulat CF (sin licencia).
import 'package:flutter/material.dart';

abstract class T {
  // Paleta oficial (prohibido cualquier color fuera de esta lista)
  static const navy = Color(0xFF001A40);      // Enriching Skies - autoridad
  static const red = Color(0xFFFF4040);       // Warm Embrace - la marca
  static const sky = Color(0xFFA6DEFF);       // Light Sky - respiro
  static const yellow = Color(0xFFF8C845);    // Latin Mornings - enfasis, dinero, el SI
  static const white = Color(0xFFFCFCFA);     // New Day - el lienzo

  // Neutros autorizados (uso restringido)
  static const competitorGray = Color(0xFFE8EAF0);
  static const neutralText = Color(0xFF6B7280);
  static const hairline = Color(0xFFE5E7EB);

  // Excepcion ratificada A0: metales SOLO para MedallaCasa
  static const bronze = Color(0xFFB0793A);
  static const silver = Color(0xFFB9C2CC);
  static const gold = Color(0xFFD9A93D);

  // Paleta viz validada - modo oscuro sobre navy elevado
  static const vizDarkSurface = Color(0xFF0A1E3F);

  // Derivados de paleta — NO son colores nuevos: mezclas navy<->sky y navy
  // translucido. Existen porque #0F2A55 a mano daba 1.21:1 y el mapa no se leia.
  static final mapLand = Color.lerp(navy, sky, .14)!;   // territorio sin LOs
  static final mapEdge = Color.lerp(navy, sky, .32)!;   // frontera de estado
  static final track = navy.withValues(alpha: .10);           // riel de progreso
  static const s1d = Color(0xFF4A86D6), s2d = Color(0xFFD64C4C),
      s3d = Color(0xFF8A73D1), s4d = Color(0xFF17906F), s5d = Color(0xFFB98418);
  // modo claro
  static const s1 = Color(0xFF1E5AA8), s2 = Color(0xFFE23B3B),
      s3 = Color(0xFF6B4EA8), s4 = Color(0xFF12876B), s5 = Color(0xFFB87A00);

  // Espaciado base-4
  static const double sp4 = 4, sp8 = 8, sp12 = 12, sp16 = 16, sp24 = 24,
      sp32 = 32, sp48 = 48, sp64 = 64;

  // Radios
  static const rChip = 8.0, rCard = 16.0, rBig = 24.0;

  // Sombras navy translucido (jamas negro)
  static final shadowSm = [BoxShadow(color: navy.withValues(alpha: .06), blurRadius: 2, offset: const Offset(0, 1))];
  static final shadowMd = [BoxShadow(color: navy.withValues(alpha: .08), blurRadius: 12, offset: const Offset(0, 4))];
  static final shadowLg = [BoxShadow(color: navy.withValues(alpha: .12), blurRadius: 32, offset: const Offset(0, 12))];

  // Movimiento de marca
  static const easeBrand = Cubic(.22, 1, .36, 1);
  static const durFast = Duration(milliseconds: 200);
  static const durMid = Duration(milliseconds: 320);
  static const durSlow = Duration(milliseconds: 1000);
}
