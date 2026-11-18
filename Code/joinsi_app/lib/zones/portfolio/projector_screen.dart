// P33 · PROYECTOR DE INGRESOS APILABLES — la pantalla que convierte "reclutar
// un LO mas" en una cifra que se siente.
//
// HONESTIDAD DELIBERADA: la base NO es lo que el portafolio produjo alguna vez,
// es lo que le FALTA por producir en sus ventanas ya abiertas (Store
// .remainingWindow). Sumar lo ya cobrado seria contar dos veces. Y el chart deja
// ver el acantilado del mes 12. El argumento comercial no es "mira que numero
// tan grande" — es "mira por que el mes 12 te obliga a seguir reclutando".
//
// Ninguna cifra se escribe a mano: el valor de un LO nuevo sale de
// LoanOfficer.payoutFor(), el del portafolio de remainingWindowValue().
import 'package:flutter/material.dart';
import '../../core/tokens.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';
import '../../models/loan_officer.dart';
import '../../widgets/common.dart';

class ProjectorScreen extends StatefulWidget {
  const ProjectorScreen({super.key});
  @override
  State<ProjectorScreen> createState() => _ProjectorScreenState();
}

class _ProjectorScreenState extends State<ProjectorScreen> {
  // Semilla de la demo: 2 LOs nuevos x 2.0 closed loans/mes cada uno
  // => payoutFor(24) = $5,400 por LO => $10,800 + $17,000 de portafolio.
  double newLos = 2, loansMonth = 2;
  bool _dragging = false;

  /// Se lee UNA vez: el portafolio no cambia mientras se arrastra un slider, y
  /// releerlo en cada frame de arrastre golpea Hive 60 veces por segundo.
  late final List<LoanOfficer> _portfolio = Store.portfolio();

  /// Base del proyector: lo que FALTA por entrar de las ventanas ya abiertas.
  /// NUNCA lo ya cobrado — sumarlo seria contar dos veces el mismo dolar.
  late final double _baseYear = Store.remainingWindow;

  @override
  Widget build(BuildContext context) {
    final baseYear = _baseYear;
    // Cada LO nuevo pasa por la MISMA funcion canonica de compensacion.
    final perNew = LoanOfficer.payoutFor((loansMonth * 12).floor());
    final addedYear = perNew * newLos;
    final total = baseYear + addedYear;

    return Scaffold(
      backgroundColor: T.white,
      appBar: AppBar(
        backgroundColor: T.navy, foregroundColor: T.white, elevation: 0,
        title: Text(l10n.t('Income projector', 'Proyector de ingresos'),
            style: headlineOnNavy(20)),
      ),
      body: ListView(
        // Densidad creciente: heroe aireado arriba, panel de datos abajo.
        padding: const EdgeInsets.fromLTRB(T.sp16, T.sp16, T.sp16, T.sp32),
        children: [
          _hero(baseYear, addedYear, total),
          const SizedBox(height: T.sp24),

          SectionTitle(l10n.t('IF YOU SIGN', 'SI FIRMAS')),
          const SizedBox(height: T.sp12),
          WhiteCard(child: Column(
            // stretch: sin esto los Slider se encogen a su ancho preferido y
            // dejan de leerse como el control de toda la tarjeta.
            crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _slider(
              l10n.t('${newLos.round()} new Loan Officers',
                  '${newLos.round()} Loan Officers nuevos'),
              newLos, 0, 10, 10, (v) => setState(() => newLos = v)),
            const SizedBox(height: T.sp8),
            _slider(
              l10n.t('${loansMonth.toStringAsFixed(1)} closed loans / month each',
                  '${loansMonth.toStringAsFixed(1)} closed loans / mes cada uno'),
              loansMonth, 1, 4, 6, (v) => setState(() => loansMonth = v)),
          ])),
          const SizedBox(height: T.sp16),

          GoldenRuleCallout(
            kicker: l10n.t('What a new LO is worth', 'Cuánto vale un LO nuevo'),
            body: l10n.t(
                'Each new Loan Officer is worth ${money0.format(perNew)} across '
                'your first 12 months together: \$500 + \$500 on their first two '
                'closed loans, then \$200 per closed loan. The portfolio stacks — '
                'it does not replace. And each window closes at month 12.',
                'Cada Loan Officer nuevo vale ${money0.format(perNew)} en tus '
                'primeros 12 meses con él: \$500 + \$500 en sus dos primeros '
                'closed loans, luego \$200 por closed loan. El portafolio se '
                'apila — no se reemplaza. Y cada ventana se cierra en el mes 12.'),
          ),
          const SizedBox(height: T.sp24),

          SectionTitle(
            l10n.t('MONTH BY MONTH', 'MES A MES'),
            sub: l10n.t(
                'Where your current windows run out — and what the new LOs put '
                'back on the board.',
                'Dónde se agotan tus ventanas actuales — y qué reponen los LOs '
                'nuevos.'),
          ),
          const SizedBox(height: T.sp12),
          _monthlyChart(),
        ]),
    );
  }

  // ===========================================================================
  // HEROE — la UNICA cifra amarilla grande de la pantalla. Debajo, la barra
  // apilada dice de donde sale: steel = ventanas ya abiertas, amarillo = lo que
  // aparece solo si firmas.
  // ===========================================================================
  Widget _hero(double base, double added, double total) => HeroNavy(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Kicker(l10n.t('NEXT 12 MONTHS', 'PRÓXIMOS 12 MESES'), onNavy: true),
      const SizedBox(height: T.sp8),
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: total),
        duration: _dragging ? T.durFast : T.durMid, curve: T.easeBrand,
        builder: (_, v, __) => FittedBox(
            fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
            child: Text(money0.format(v), style: moneyStyle(44)))),
      const SizedBox(height: T.sp16),
      _stackBar(base, added),
      const SizedBox(height: T.sp16),
      _legendRow(T.s1d, l10n.t('Portfolio still to come',
          'Portafolio por entrar'), base),
      const SizedBox(height: T.sp8),
      _legendRow(T.yellow, l10n.t('New LOs', 'LOs nuevos'), added),
    ]));

  /// Barra apilada delgada: la proporcion entre lo que ya tienes y lo que
  /// depende de ti. 8px — es un dato, no un grafico.
  Widget _stackBar(double base, double added) {
    final total = base + added;
    if (total <= 0) {
      return Container(height: 8, decoration: BoxDecoration(
          color: T.sky.withValues(alpha: .25),
          borderRadius: BorderRadius.circular(999)));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(height: 8, child: Row(children: [
        if (base > 0) Expanded(
            flex: (base / total * 1000).round().clamp(1, 1000),
            child: Container(color: T.s1d)),
        if (added > 0) Expanded(
            flex: (added / total * 1000).round().clamp(1, 1000),
            child: Container(color: T.yellow)),
      ])));
  }

  /// Leyenda: punto de color + etiqueta cielo a la izquierda, cifra blanca a la
  /// derecha. El dinero de apoyo va en blanco bold — el amarillo grande es uno
  /// solo por pantalla y ya lo gasto el heroe.
  Widget _legendRow(Color c, String label, double value) => Row(children: [
    Container(width: 8, height: 8, decoration: BoxDecoration(
        color: c, borderRadius: BorderRadius.circular(999))),
    const SizedBox(width: T.sp8),
    Expanded(child: Text(label, style: dataStyle(11, color: T.sky))),
    const SizedBox(width: T.sp8),
    Text(money0.format(value),
        style: dataStyle(13, w: FontWeight.w700, color: T.white)),
  ]);

  // ===========================================================================
  // SLIDERS — unico accionable de la pantalla. Son rojos los dos porque son el
  // MISMO componente repetido (un solo gesto: "mueve la proyeccion"), no dos
  // acciones distintas compitiendo por el ojo.
  // ===========================================================================
  Widget _slider(String label, double v, double min, double max, int div,
      ValueChanged<double> onCh) => Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: dataStyle(15, w: FontWeight.w700)),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4,
          activeTrackColor: T.red, inactiveTrackColor: T.hairline,
          thumbColor: T.red, overlayColor: T.red.withValues(alpha: .12),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10)),
        child: Slider(value: v, min: min, max: max, divisions: div,
            onChanged: onCh,
            onChangeStart: (_) => setState(() => _dragging = true),
            onChangeEnd: (_) => setState(() => _dragging = false)),
      ),
    ]);

  // ===========================================================================
  // CHART MES A MES — CALCULADO, no decorativo:
  //  · Portafolio (steel): cada LO firmado reparte su remainingWindowValue()
  //    entre sus meses restantes y DEJA de aportar cuando su ventana de 12
  //    meses se cierra. Por eso el decaimiento es escalonado y no lineal: es el
  //    acantilado real, LO por LO.
  //  · LOs nuevos (amarillo): entran con la rampa canonica — el diferencial de
  //    payoutFor() mes a mes, o sea $500, $500 y luego $200 por closed loan.
  // Chart sobre navy porque el amarillo es dinero — sobre blanco daria 1.5:1.
  // ===========================================================================
  Widget _monthlyChart() {
    final base = List<double>.filled(12, 0);
    final fresh = List<double>.filled(12, 0);

    for (final l in _portfolio) {
      final monthsLeft = (12 - l.monthOf12).clamp(0, 12);
      if (monthsLeft == 0) continue;
      final perMonth = l.monthlyRemaining;   // remainingWindowValue / monthsLeft
      for (var m = 0; m < monthsLeft; m++) {
        base[m] += perMonth;
      }
    }

    final n = newLos.round();
    if (n > 0) {
      var cumulative = 0.0;
      for (var m = 0; m < 12; m++) {
        final closedByEnd = (loansMonth * (m + 1)).floor();
        final payTotal = LoanOfficer.payoutFor(closedByEnd);
        fresh[m] = (payTotal - cumulative) * n;
        cumulative = payTotal;
      }
    }

    final peak = [for (var m = 0; m < 12; m++) base[m] + fresh[m]]
        .fold<double>(1, (a, b) => a > b ? a : b);
    // maxBar < barsH a proposito: deja aire sobre la barra mas alta y evita que
    // el redondeo en coma flotante desborde el SizedBox por una decima de pixel.
    const barsH = 176.0, maxBar = 166.0;

    return Container(
      padding: const EdgeInsets.all(T.sp16),
      decoration: BoxDecoration(color: T.navy,
          borderRadius: BorderRadius.circular(T.rBig), boxShadow: T.shadowMd),
      child: Column(children: [
        SizedBox(
          height: barsH,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            for (var m = 0; m < 12; m++) Expanded(child: Padding(
              // 1.5px por lado: separacion de viz, no espaciado de layout.
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: T.durSlow, curve: T.easeBrand,
                builder: (_, k, __) => Column(mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      height: maxBar * k * (fresh[m] / peak),
                      decoration: const BoxDecoration(color: T.yellow,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4)))),
                    Container(
                      height: maxBar * k * (base[m] / peak),
                      decoration: BoxDecoration(color: T.s1d,
                          borderRadius: fresh[m] <= 0
                              ? const BorderRadius.vertical(
                                  top: Radius.circular(4))
                              : BorderRadius.zero)),
                  ]),
              ),
            )),
          ])),
        const SizedBox(height: T.sp8),
        Container(height: 1, color: T.sky.withValues(alpha: .25)),
        const SizedBox(height: T.sp8),
        Row(children: [
          for (var m = 0; m < 12; m++) Expanded(child: Text('${m + 1}',
              textAlign: TextAlign.center, style: dataStyle(11, color: T.sky))),
        ]),
      ]),
    );
  }
}
