// Componentes canonicos compartidos. Existen para que un mismo concepto se vea
// igual en las 3 zonas: el tier chip no puede tener un radio en el mapa y otro
// en el Radar, y una cifra de dinero no puede pintarse a mano en cada pantalla.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/tokens.dart';
import '../core/theme.dart';
import '../core/i18n.dart';
import '../models/loan_officer.dart';

String tierLabel(Tier t) => switch (t) {
  Tier.top => 'Top', Tier.mid => 'Mid', Tier.boutique => 'Boutique' };

/// Etiqueta bilingue del stage. Sin esto la UI imprime el enum crudo
/// ("preFunnel", "meetingPD"), que no es ningun idioma.
String stageLabel(Stage s) => switch (s) {
  Stage.assigned    => l10n.t('Assigned', 'Asignado'),
  Stage.preFunnel   => l10n.t('Pre-funnel', 'Pre-funnel'),
  Stage.call1       => l10n.t('Call 1 · pitch', 'Llamada 1 · pitch'),
  Stage.followUp    => l10n.t('Follow-up', 'Follow-up'),
  // call2 = la TERCERA llamada del pipeline canonico: el follow-up cuenta
  // como llamada 2 (Acta A0 §3, P22). No es un off-by-one.
  Stage.call2       => l10n.t('Call 3', 'Llamada 3'),
  Stage.meetingPD   => l10n.t('Meeting · Production Director',
                              'Reunión · Director de Producción'),
  Stage.deciding    => l10n.t('Deciding', 'Decidiendo'),
  Stage.signed      => l10n.t('Signed', 'Firmado'),
};

/// Promesas del Tamagotchi: la clave vive en los datos, el texto en la UI.
String promiseLabel(String key) => switch (key) {
  'callTuesday' => l10n.t('You agreed to call Tuesday',
                          'Quedaste de llamar el martes'),
  _ => key,
};

/// Chip de tier — radio 8 (chip), Inter 12/600, contrastes del P1B.
class TierChip extends StatelessWidget {
  final Tier tier;
  const TierChip({super.key, required this.tier});
  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tier) {
      Tier.top => (T.navy, T.white),
      Tier.mid => (T.sky, T.navy),
      Tier.boutique => (T.yellow, T.navy),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: T.sp8, vertical: T.sp4),
      decoration: BoxDecoration(color: bg,
          borderRadius: BorderRadius.circular(T.rChip)),
      child: Text(tierLabel(tier), style: TextStyle(color: fg, fontSize: 11,
          fontWeight: FontWeight.w600, letterSpacing: .8)),
    );
  }
}

/// Cifra de dinero sobre lienzo claro. Canon: el dinero es amarillo sobre navy,
/// SIEMPRE — asi que sobre blanco se sirve en su propia pildora navy en vez de
/// pintarse en rojo (que bajo 24px incumple la regla dura de contraste).
class MoneyPill extends StatelessWidget {
  final double amount, size;
  final NumberFormat? money;
  const MoneyPill({super.key, required this.amount, this.size = 16, this.money});
  @override
  Widget build(BuildContext context) {
    final f = money ?? NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: T.sp8, vertical: T.sp4),
      decoration: BoxDecoration(color: T.navy,
          borderRadius: BorderRadius.circular(999)),
      child: Text(f.format(amount), style: moneyStyle(size)),
    );
  }
}
