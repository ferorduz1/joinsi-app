// Componentes canonicos compartidos. Existen para que un mismo concepto se vea
// igual en las 6 pantallas: el tier chip no puede tener un radio en el mapa y
// otro en el Radar, y una cifra de dinero no puede pintarse a mano en cada
// pantalla. Destilan la referencia visual de Stitch (A3-R2) al sistema P1B.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/tokens.dart';
import '../core/theme.dart';
import '../core/i18n.dart';
import '../models/loan_officer.dart';

final money0 = NumberFormat.currency(symbol: r'$', decimalDigits: 0);

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

/// Promesas de recontacto: la clave vive en los datos, el texto en la UI.
String promiseLabel(String key) => switch (key) {
  'callTuesday' => l10n.t('You agreed to call Tuesday',
                          'Quedaste de llamar el martes'),
  _ => key,
};

/// Mes abreviado para las fechas de corte ("15 ago" / "Aug 15").
const _mesEs = ['ene','feb','mar','abr','may','jun','jul','ago','sep','oct','nov','dic'];
const _mesEn = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
String cutLabel(DateTime d) => l10n.t(
    '${_mesEn[d.month - 1]} ${d.day}', '${d.day} ${_mesEs[d.month - 1]}');

// =============================================================================
// PRIMITIVAS DE COMPOSICION — el ritmo del sistema: heroe navy arriba, blanco
// de trabajo abajo, densidad creciente hacia el pie de la pantalla.
// =============================================================================

/// Kicker: label en MAYUSCULAS con tracking amplio. Firma tipografica del
/// sistema. Sobre navy va en cielo; sobre blanco, en gris neutro.
class Kicker extends StatelessWidget {
  final String text;
  final bool onNavy;
  const Kicker(this.text, {super.key, this.onNavy = false});
  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: kickerStyle(onNavy: onNavy));
}

/// Titulo de seccion: Barlow Condensed Bold 22 en mayusculas, con subtitulo
/// opcional de una linea.
class SectionTitle extends StatelessWidget {
  final String text;
  final String? sub;
  const SectionTitle(this.text, {super.key, this.sub});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(text.toUpperCase(), style: sectionTitleStyle()),
      if (sub != null) Padding(
        padding: const EdgeInsets.only(top: T.sp4),
        child: Text(sub!, style: dataStyle(12, color: T.neutralText))),
    ]);
}

/// Contenedor heroe: navy, radio 24, padding 24, sombra navy. SIEMPRE primero
/// en el arbol de la pantalla — es la zona ceremonial del dinero.
class HeroNavy extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const HeroNavy({super.key, required this.child,
    this.padding = const EdgeInsets.all(T.sp24)});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(color: T.navy,
        borderRadius: BorderRadius.circular(T.rBig), boxShadow: T.shadowLg),
    child: child);
}

/// Tarjeta de trabajo: blanco, radio 16, hairline + sombra suave.
class WhiteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  const WhiteCard({super.key, required this.child,
    this.padding = const EdgeInsets.all(T.sp16), this.onTap});
  @override
  Widget build(BuildContext context) {
    final box = Container(
      padding: padding,
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(T.rCard),
          border: Border.all(color: T.hairline),
          boxShadow: T.shadowMd),
      child: child);
    if (onTap == null) return box;
    return InkWell(borderRadius: BorderRadius.circular(T.rCard),
        onTap: onTap, child: box);
  }
}

/// Punto de actividad: cielo solido con halo = el LO esta enviando casos.
/// Cielo es el color de lo vivo; el amarillo queda reservado al dinero.
class ActivityDot extends StatelessWidget {
  final double size;
  const ActivityDot({super.key, this.size = 8});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(color: T.sky, shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: T.sky.withValues(alpha: .6),
            blurRadius: size, spreadRadius: size / 4)]));
}

/// Chip de actividad: punto + texto, contorno del mismo color.
class ActivityChip extends StatelessWidget {
  final bool active;
  const ActivityChip({super.key, required this.active});
  @override
  Widget build(BuildContext context) {
    final txt = active
        ? l10n.t('Sending cases', 'Enviando casos')
        : l10n.t('No cases this month', 'Sin casos este mes');
    final c = active ? T.sky : T.neutralText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: T.sp8, vertical: T.sp4),
      decoration: BoxDecoration(border: Border.all(color: c),
          borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (active) const ActivityDot(size: 6) else Container(width: 6,
            height: 6, decoration: BoxDecoration(color: c,
                shape: BoxShape.circle)),
        const SizedBox(width: T.sp4),
        Text(txt.toUpperCase(), style: dataStyle(11, w: FontWeight.w700,
            color: c).copyWith(letterSpacing: .6)),
      ]));
  }
}

/// Chip de tier — radio 8 (chip), Inter 11/600, contrastes del P1B.
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
      child: Text(tierLabel(tier), style: dataStyle(11, w: FontWeight.w600,
          color: fg).copyWith(letterSpacing: .8)),
    );
  }
}

/// Chip neutro de dato (programa, NMLS…) — radio 8, hairline.
class DataChip extends StatelessWidget {
  final String text;
  const DataChip(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: T.sp8, vertical: T.sp4),
    decoration: BoxDecoration(border: Border.all(color: T.hairline),
        color: T.white, borderRadius: BorderRadius.circular(T.rChip)),
    child: Text(text, style: dataStyle(11, w: FontWeight.w600,
        color: T.neutralText)));
}

/// Cifra de dinero sobre lienzo claro. Canon: el dinero es amarillo sobre navy,
/// SIEMPRE — asi que sobre blanco se sirve en su propia pildora navy en vez de
/// pintarse en rojo (que bajo 24px incumple la regla dura de contraste).
/// Se usa igual para entidades inactivas: la atenuacion va en la carita, nunca
/// en el dinero — una cifra apagada se lee como cifra menos cierta.
class MoneyPill extends StatelessWidget {
  final double amount, size;
  final NumberFormat? money;
  const MoneyPill({super.key, required this.amount, this.size = 14, this.money});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: T.sp12, vertical: T.sp4),
    decoration: BoxDecoration(color: T.navy,
        borderRadius: BorderRadius.circular(999)),
    child: Text((money ?? money0).format(amount), style: moneyStyle(size)));
}

/// Boton primario rojo, pill. Regla dura: UNO solo por pantalla; el texto
/// blanco sobre rojo nunca baja de 18px bold (contraste P1B, ya en el theme).
class RedPill extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool expand;
  const RedPill({super.key, required this.label, this.onPressed,
    this.expand = true});
  @override
  Widget build(BuildContext context) {
    final b = ElevatedButton(onPressed: onPressed, child: Text(label));
    return expand ? SizedBox(width: double.infinity, child: b) : b;
  }
}

/// Callout "Regla de Oro": barra roja de 4px a la izquierda sobre rojo al 4%.
/// Vehiculo canonico de las reglas del negocio dentro de la app.
class GoldenRuleCallout extends StatelessWidget {
  final String kicker, body;
  const GoldenRuleCallout({super.key, required this.kicker, required this.body});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(T.sp16),
    decoration: BoxDecoration(
      color: T.red.withValues(alpha: .04),
      border: const Border(left: BorderSide(color: T.red, width: 4)),
      borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(T.rChip)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(kicker.toUpperCase(), style: kickerStyle().copyWith(color: T.red)),
      const SizedBox(height: T.sp8),
      Text(body, style: dataStyle(13, w: FontWeight.w400, height: 1.5)),
    ]));
}

/// Fila de barra horizontal monocroma: etiqueta · riel · valor.
/// Viz de una sola familia por entidad (cielo), nunca arcoiris.
class BarRow extends StatelessWidget {
  final String label;
  final double value, max;
  final String valueText;
  final double labelWidth;
  const BarRow({super.key, required this.label, required this.value,
    required this.max, required this.valueText, this.labelWidth = 56});
  @override
  Widget build(BuildContext context) {
    final frac = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: T.sp8),
      child: Row(children: [
        SizedBox(width: labelWidth, child: Text(label,
            style: dataStyle(13, w: FontWeight.w600))),
        const SizedBox(width: T.sp8),
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(value: frac, minHeight: 12,
              backgroundColor: T.hairline,
              valueColor: const AlwaysStoppedAnimation(T.sky)))),
        const SizedBox(width: T.sp8),
        Text(valueText, style: dataStyle(13, w: FontWeight.w700)),
      ]));
  }
}

/// Riel segmentado de 12 meses: amarillo hasta el mes actual, gris el resto.
class WindowTrack extends StatelessWidget {
  final int monthOf12;
  const WindowTrack({super.key, required this.monthOf12});
  @override
  Widget build(BuildContext context) => Row(children: [
    for (var i = 0; i < 12; i++) ...[
      Expanded(child: Container(height: 6,
          decoration: BoxDecoration(
              color: i < monthOf12 ? T.yellow : T.hairline,
              borderRadius: BorderRadius.circular(999)))),
      if (i < 11) const SizedBox(width: T.sp4),
    ]
  ]);
}
