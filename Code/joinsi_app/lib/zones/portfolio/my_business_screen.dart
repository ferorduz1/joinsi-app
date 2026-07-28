// P35 · MI NEGOCIO — resumen ejecutivo del SiPartner: ganado por estado, tier y
// costa + escalera de estatus (P34 embebido).
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/tokens.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';
import '../../models/loan_officer.dart';
import '../../widgets/carita_avatar.dart';
import '../../widgets/common.dart';
import '../../widgets/medalla_casa.dart';
import 'lo_portfolio_screen.dart';

class MyBusinessScreen extends StatefulWidget {
  const MyBusinessScreen({super.key});
  @override
  State<MyBusinessScreen> createState() => _MyBusinessScreenState();
}

class _MyBusinessScreenState extends State<MyBusinessScreen> {
  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    final tt = Theme.of(context).textTheme;
    final signed = Store.portfolio();
    final totalClosed = signed.fold<int>(0, (s, l) => s + l.closedTotal);
    final totalEarned = signed.fold<double>(0, (s, l) => s + l.earned);

    Map<String, double> agg(String Function(LoanOfficer) key) {
      final m = <String, double>{};
      for (final l in signed) {
        m[key(l)] = (m[key(l)] ?? 0) + l.earned;
      }
      return m;
    }

    return Scaffold(
      backgroundColor: T.white,
      appBar: AppBar(backgroundColor: T.navy, foregroundColor: T.white,
          title: Text(l10n.t('My business', 'Mi negocio'),
              style: const TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(padding: const EdgeInsets.all(T.sp16), children: [
        // Escalera de estatus
        Container(
          padding: const EdgeInsets.all(T.sp24),
          decoration: BoxDecoration(color: T.navy,
              borderRadius: BorderRadius.circular(T.rBig), boxShadow: T.shadowMd),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.t('STATUS LADDER', 'ESCALERA DE ESTATUS'),
                style: tt.labelSmall!.copyWith(color: T.sky)),
            const SizedBox(height: T.sp16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _rung(T.bronze, 'SiPartner', true, l10n.t('reached', 'alcanzado')),
              _rung(T.silver, 'SiFounder', signed.length >= 8,
                  '${signed.length}/8 LOs'),
              _rung(T.gold, 'SiBroker', totalClosed >= 100,
                  '$totalClosed/100 closed'),
            ]),
          ]),
        ),
        const SizedBox(height: T.sp24),

        Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: _kpi(context, 'Closed loans', '$totalClosed')),
          const SizedBox(width: T.sp12),
          Expanded(child: _kpi(context, l10n.t('States', 'Estados'),
              '${signed.map((e) => e.state).toSet().length}')),
          const SizedBox(width: T.sp12),
          Expanded(child: _kpi(context, l10n.t('Earned', 'Ganado'),
              money.format(totalEarned), isMoney: true)),
        ]),
        const SizedBox(height: T.sp24),

        Text(l10n.t('EARNED BY STATE', 'GANADO POR ESTADO'), style: tt.labelSmall),
        const SizedBox(height: T.sp12),
        _bars(agg((l) => l.state), money),
        const SizedBox(height: T.sp24),

        Text(l10n.t('EARNED BY TIER', 'GANADO POR TIER'), style: tt.labelSmall),
        const SizedBox(height: T.sp12),
        _bars(agg((l) => tierLabel(l.tier)), money),
        const SizedBox(height: T.sp24),

        Text(l10n.t('EARNED BY COAST', 'GANADO POR COSTA'), style: tt.labelSmall),
        const SizedBox(height: T.sp12),
        _bars(agg((l) => l.coast), money),
        const SizedBox(height: T.sp24),

        Text(l10n.t('MY LOAN OFFICERS', 'MIS LOAN OFFICERS'), style: tt.labelSmall),
        const SizedBox(height: T.sp12),
        Wrap(spacing: T.sp16, runSpacing: T.sp16, children: [
          for (final lo in signed) GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => LoPortfolioScreen(loId: lo.id)))
                .then((_) { if (mounted) setState(() {}); }),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CaritaAvatar(spec: lo.avatar, size: 48),
              const SizedBox(height: T.sp4),
              SizedBox(width: 64, child: Text(lo.name.split(' ').first,
                  textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      color: T.navy))),
            ]),
          ),
        ]),
        const SizedBox(height: T.sp32),
      ]),
    );
  }

  Widget _rung(Color metal, String name, bool on, String sub) =>
    Column(children: [
      Opacity(opacity: on ? 1 : .38, child: MedallaCasa(metal: metal, size: 56)),
      const SizedBox(height: T.sp8),
      Text(name, style: TextStyle(color: on ? T.white : T.sky,
          fontWeight: FontWeight.w800, fontSize: 13)),
      Text(sub, style: const TextStyle(color: T.sky, fontSize: 11)),
    ]);

  Widget _kpi(BuildContext c, String label, String v, {bool isMoney = false}) => Card(
    child: Padding(padding: const EdgeInsets.all(T.sp12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(), style: Theme.of(c).textTheme.labelSmall),
        const SizedBox(height: T.sp4),
        Text(v, style: isMoney ? moneyOnLight(16) : const TextStyle(
            fontWeight: FontWeight.w800, fontSize: 16, color: T.navy)),
      ])),
  );

  /// Una sola metrica (dinero ganado) = UNA sola serie. Antes cada barra tomaba
  /// un color distinto segun su posicion tras ordenar: TX cambiaba de color en
  /// cuanto FL lo superara. El color debe seguir a la entidad, no al ranking.
  Widget _bars(Map<String, double> data, NumberFormat money) {
    if (data.isEmpty) {
      return Text(l10n.t('No signed Loan Officers yet.',
          'Aún no hay Loan Officers firmados.'),
          style: const TextStyle(fontSize: 13, color: T.neutralText));
    }
    final entries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxV = entries.first.value <= 0 ? 1.0 : entries.first.value;
    return Column(children: [
      for (var i = 0; i < entries.length; i++) Padding(
        padding: const EdgeInsets.only(bottom: T.sp8),
        child: Row(children: [
          SizedBox(width: 80, child: Text(entries[i].key, style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: T.navy))),
          Expanded(child: LayoutBuilder(builder: (_, c) => Align(
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: c.maxWidth * (entries[i].value / maxV)),
              duration: T.durMid + Duration(milliseconds: 40 * i),
              curve: T.easeBrand,
              builder: (_, w, __) => Container(height: 16,
                  width: w.clamp(2.0, c.maxWidth),
                  decoration: BoxDecoration(color: T.s1,
                      borderRadius: BorderRadius.circular(4))),
            ),
          ))),
          const SizedBox(width: T.sp8),
          SizedBox(width: 64, child: Text(money.format(entries[i].value),
              textAlign: TextAlign.right, style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: T.navy))),
        ]),
      ),
    ]);
  }
}
