import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

ThemeData joinSiTheme() {
  final base = ThemeData(useMaterial3: true, scaffoldBackgroundColor: T.white,
      colorScheme: ColorScheme.fromSeed(seedColor: T.red, primary: T.red,
          secondary: T.yellow, surface: T.white, onSurface: T.navy));
  return base.copyWith(
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 48, height: 1.05, letterSpacing: -0.5, color: T.navy),
      headlineMedium: GoogleFonts.barlow(fontWeight: FontWeight.w700, fontSize: 36, height: 1.15, color: T.navy),
      headlineSmall: GoogleFonts.barlow(fontWeight: FontWeight.w700, fontSize: 24, height: 1.25, color: T.navy),
      titleMedium: GoogleFonts.barlow(fontSize: 18, height: 1.35, color: T.navy),
      bodyLarge: GoogleFonts.inter(fontSize: 16, height: 1.6, color: T.navy),
      bodyMedium: GoogleFonts.inter(fontSize: 14, height: 1.55, color: T.neutralText),
      labelSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2.16, color: T.neutralText),
      labelLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
        backgroundColor: T.red, foregroundColor: T.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: const StadiumBorder(),
        // Blanco sobre rojo SOLO >=18px bold (regla dura de contraste P1B)
        textStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700))),
    cardTheme: CardThemeData(color: T.white, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(T.rCard),
            side: const BorderSide(color: T.hairline)),
        margin: EdgeInsets.zero),
  );
}
// Cifra de dinero: Poppins 800 amarillo sobre navy (9.4:1)
TextStyle moneyStyle(double size) => GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: size, letterSpacing: -0.5, color: T.yellow);

// ---------------------------------------------------------------------------
// ESTILOS CANONICOS COMPARTIDOS. Toda la app pasa por aqui: un TextStyle
// ad-hoc en una pantalla es como la app empezo a divergir la vez pasada.
// Las familias se resuelven con google_fonts — NUNCA con fontFamily: 'Inter'
// a pelo, porque esa fuente no esta declarada como asset y caeria al default.
// ---------------------------------------------------------------------------

/// Titulo de seccion: Barlow Bold 22, en MAYUSCULAS sobre lienzo claro.
TextStyle sectionTitleStyle({Color color = T.navy}) => GoogleFonts.barlowCondensed(
    fontWeight: FontWeight.w700, fontSize: 22, height: 1.27, color: color);

/// Kicker: label pequeno en MAYUSCULAS con tracking amplio (firma del sistema).
/// Sobre navy va cielo; sobre blanco, gris neutro.
TextStyle kickerStyle({bool onNavy = false}) => GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w700, height: 1.33,
    letterSpacing: 1.2, color: onNavy ? T.sky : T.neutralText);

/// Datos y cuerpo. `dim` = texto secundario gris.
TextStyle dataStyle(double size, {FontWeight w = FontWeight.w500,
    Color? color, double height = 1.4}) => GoogleFonts.inter(
    fontSize: size, fontWeight: w, height: height, color: color ?? T.navy);

/// Titular corto sobre navy (nombres, headlines de tarjeta).
TextStyle headlineOnNavy(double size) => GoogleFonts.poppins(
    fontWeight: FontWeight.w800, fontSize: size, height: 1.2, color: T.white);
// Cifra de dinero sobre lienzo claro: Poppins 800 navy (15.9:1).
// TODA cifra de dinero pasa por moneyStyle o moneyOnLight — nunca un TextStyle
// ad-hoc, y nunca rojo bajo 24px (regla dura de contraste).
TextStyle moneyOnLight(double size) => GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: size, letterSpacing: -0.5, color: T.navy);
