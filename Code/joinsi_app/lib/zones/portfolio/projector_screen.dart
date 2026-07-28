// P33 · PROYECTOR DE INGRESOS APILABLES — la pantalla que convierte "reclutar
// un LO mas" en una cifra que se siente.
//
// HONESTIDAD DELIBERADA: la base NO es lo que el portafolio produjo alguna vez,
// es lo que le FALTA por producir en sus ventanas ya abiertas. Y el chart deja
// ver el acantilado del mes 12. El argumento comercial no es "mira que numero
// tan grande" — es "mira por que el mes 12 te obliga a seguir reclutando".
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/tokens.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';
import '../../models/loan_officer.dart';

class ProjectorScreen extends StatefulWidget {
  const ProjectorScreen({super.key});
  @override
  State<ProjectorScreen> createState() => _ProjectorScreenState();
}

class _ProjectorScreenState extends State<ProjectorScreen> {
  double newLos = 2, loansMonth = 2;
  bool _dragging = false;
  late final List<LoanOfficer> _portfolio = Store.portfolio();

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    final tt = Theme.of(context).textTheme;

    // Base = lo que FALTA por entrar de los LOs ya firmados (no lo ya cobrado).
    final baseYear = _portfolio.fold<double>(0, (s, l) => s + l.remainingWindowValue());
    // Cada LO nuevo pasa por la MISMA funcion canonica de compensacion.
    final perNew = LoanOfficer.payoutFor((loansMonth * 12).floor());
    final addedYear = perNew * newLos;
    final total = baseYear + addedYear;

    return Scaffold(
      backgroundColor: T.white,
      appBar: AppBar(backgroundColor: T.navy, foregroundColor: T.white,
          title: Text(l10n.t('Income projector', 'Proyector de ingresos'),
              style: const TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(padding: const EdgeInsets.all(T.sp16), children: [
        Container(
          padding: const EdgeInsets.all(T.sp24), width: double.infinity,
          decoration: BoxDecoration(color: T.navy,
              borderRadius: BorderRadius.circular(T.rBig), boxShadow: T.shadowMd),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.t('NEXT 12 MONTHS', 'PRÓXIMOS 12 MESES'),
                style: tt.labelSmall!.copyWith(color: T.sky)),
            const SizedBox(height: T.sp8),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: total),
              duration: _dragging ? T.durFast : T.durMid, curve: T.easeBrand,
              builder: (_, v, __) => Text(money.format(v), style: moneyStyle(44))),
            const SizedBox(height: T.sp12),
            _stackBar(baseYear, addedYear),
            const SizedBox(height: T.sp8),
            Row(children: [
              _dot(T.s1d, l10n.t('Portfolio still to come',
                  'Portafolio por entrar'), money.format(baseYear)),
              const SizedBox(width: T.sp16),
              _dot(T.yellow, l10n.t('New LOs', 'LOs nuevos'),
                  money.format(addedYear)),
            ]),
          ]),
        ),
        const SizedBox(height: T.sp24),

        Text(l10n.t('IF YOU SIGN', 'SI FIRMAS'), style: tt.labelSmall),
        _slider(l10n.t('${newLos.round()} new Loan Officers',
            '${newLos.round()} Loan Officers nuevos'),
            newLos, 0, 10, 10, (v) => setState(() => newLos = v)),
        _slider(l10n.t('${loansMonth.toStringAsFixed(1)} closed loans / month each',
            '${loansMonth.toStringAsFixed(1)} closed loans / mes cada uno'),
            loansMonth, 1, 4, 6, (v) => setState(() => loansMonth = v)),

        const SizedBox(height: T.sp16),
        Container(
          padding: const EdgeInsets.all(T.sp16),
          decoration: BoxDecoration(
            color: T.red.withOpacity(.04),
            border: const Border(left: BorderSide(color: T.red, width: 4)),
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(T.rCard)),
          ),
          child: Text(l10n.t(
              'Each new Loan Officer is worth ${money.format(perNew)} across your '
              'first 12 months together: \$500 + \$500 on their first two closed '
              'loans, then \$200 per closed loan. The portfolio stacks — it does '
              'not replace. And each window closes at month 12.',
              'Cada Loan Officer nuevo vale ${money.format(perNew)} en tus primeros '
              '12 meses con él: \$500 + \$500 en sus dos primeros closed loans, luego '
              '\$200 por closed loan. El portafolio se apila — no se reemplaza. '
              'Y cada ventana se cierra en el mes 12.'),
              style: const TextStyle(fontSize: 13, height: 1.5, color: T.navy)),
        ),
        const SizedBox(height: T.sp24),

        Text(l10n.t('MONTH BY MONTH', 'MES A MES'), style: tt.labelSmall),
        const SizedBox(height: T.sp4),
        Text(l10n.t('Where your current windows run out — and what the new LOs '
                'put back on the board.',
            'Dónde se agotan tus ventanas actuales — y qué reponen los LOs nuevos.'),
            style: const TextStyle(fontSize: 12, color: T.neutralText)),
        const SizedBox(height: T.sp12),
        _monthlyChart(money),
        const SizedBox(height: T.sp32),
      ]),
    );
  }

  Widget _slider(String label, double v, double min, double max, int div,
      ValueChanged<double> onCh) => Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: T.sp12),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700,
          fontSize: 15, color: T.navy)),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: T.red, inactiveTrackColor: T.hairline,
          thumbColor: T.red, overlayColor: T.red.withOpacity(.12)),
        child: Slider(value: v, min: min, max: max, divisions: div,
            onChanged: onCh,
            onChangeStart: (_) => setState(() => _dragging = true),
            onChangeEnd: (_) => setState(() => _dragging = false)),
      ),
    ]);

  Widget _stackBar(double base, double added) {
    final total = base + added;
    if (total <= 0) {
      return Container(height: 14, decoration: BoxDecoration(
          color: T.sky.withOpacity(.25), borderRadius: BorderRadius.circular(4)));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(height: 14, child: Row(children: [
        if (base > 0) Expanded(flex: (base / total * 1000).round().clamp(1, 1000),
            child: Container(color: T.s1d)),
        if (added > 0) Expanded(flex: (added / total * 1000).round().clamp(1, 1000),
            child: Container(color: T.yellow)),
      ])),
    );
  }

  Widget _dot(Color c, String label, String v) => Row(mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(
            color: c, borderRadius: BorderRadius.circular(999))),
        const SizedBox(width: T.sp8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 11, color: T.sky)),
          Text(v, style: const TextStyle(fontSize: 13, color: T.white,
              fontWeight: FontWeight.w700)),
        ]),
      ]);

  /// Reparto mes a mes REAL, no una rampa decorativa:
  ///  - LOs firmados: aportan mientras su ventana de 12 meses siga abierta, y
  ///    dejan de aportar cuando se cierra (ese es el acantilado).
  ///  - LOs nuevos: arrancan en el mes 1 con la rampa $500 + $500 y luego $200.
  /// Chart sobre navy porque el amarillo es dinero — y sobre blanco daria 1.5:1.
  Widget _monthlyChart(NumberFormat money) {
    final base = List<double>.filled(12, 0);
    final fresh = List<double>.filled(12, 0);

    for (final l in _portfolio) {
      final monthsLeft = (12 - l.monthOf12).clamp(0, 12);
      if (monthsLeft == 0) continue;
      final perMonth = l.remainingWindowValue() / monthsLeft;
      for (var m = 0; m < monthsLeft; m++) {
        base[m] += perMonth;
      }
    }
    // Cada LO nuevo: rampa en los meses en que caen sus dos primeros closed.
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

    final peak = [
      for (var m = 0; m < 12; m++) base[m] + fresh[m]
    ].fold<double>(1, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(T.sp16),
      decoration: BoxDecoration(color: T.navy,
          borderRadius: BorderRadius.circular(T.rBig)),
      child: Column(children: [
        SizedBox(height: 160, child: Row(crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var m = 0; m < 12; m++) Expanded(child: Padding(
              // 2px de separacion entre barras: canon de viz, no base-4.
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: _dragging ? T.durFast : T.durMid, curve: T.easeBrand,
                builder: (_, k, __) => Column(mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(height: 130 * k * (fresh[m] / peak),
                      decoration: const BoxDecoration(color: T.yellow,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4)))),
                  Container(height: 130 * k * (base[m] / peak),
                      decoration: BoxDecoration(color: T.s1d,
                          borderRadius: fresh[m] <= 0
                              ? const BorderRadius.vertical(top: Radius.circular(4))
                              : BorderRadius.zero)),
                  const SizedBox(height: T.sp4),
                  Text('${m + 1}', style: const TextStyle(
                      fontSize: 11, color: T.sky)),
                ]),
              ),
            )),
          ])),
      ]),
    );
  }
}
