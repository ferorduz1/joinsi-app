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
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: const StadiumBorder(),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700))),
    cardTheme: CardThemeData(color: T.white, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(T.rCard),
            side: const BorderSide(color: T.hairline)),
        margin: EdgeInsets.zero),
  );
}
// Cifra de dinero: Poppins 800 amarillo sobre navy (9.4:1)
TextStyle moneyStyle(double size) => GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: size, letterSpacing: -0.5, color: T.yellow);
