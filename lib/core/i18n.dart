// Bilingue ES/EN con toggle en vivo. Terminos de industria SIEMPRE en ingles:
// Loan Officer, pre-approval, ratified, closed loan, pricing, pipeline,
// override, NMLS, bps, SiPartner, SiFounder, SiBroker.
import 'package:flutter/material.dart';

class L10n extends ChangeNotifier {
  bool es = true;
  void toggle() { es = !es; notifyListeners(); }
  String t(String en, String esTxt) => es ? esTxt : en;
}

final l10n = L10n();
