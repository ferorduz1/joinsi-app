// P20 SiRadar - fichas MQL (A4 completa pipeline/playbook/llamada).
import 'package:flutter/material.dart';
import '../../core/tokens.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';
import '../../models/loan_officer.dart';

class RadarHome extends StatelessWidget {
  const RadarHome({super.key});
  @override
  Widget build(BuildContext context) {
    final prospects = Store.los().where((l) => l.stage != Stage.signed).toList();
    return ListView(padding: const EdgeInsets.all(T.sp16), children: [
      Container(padding: const EdgeInsets.all(T.sp12),
          decoration: BoxDecoration(color: T.sky.withOpacity(.35), borderRadius: BorderRadius.circular(T.rCard)),
          child: Text(l10n.t('HOMESI assigned you 3 new prospects today',
              'HOMESI te asignó 3 prospectos nuevos hoy'),
              style: const TextStyle(color: T.navy, fontWeight: FontWeight.w600))),
      const SizedBox(height: T.sp16),
      for (final lo in prospects) _card(context, lo),
    ]);
  }

  Widget _card(BuildContext c, LoanOfficer lo) {
    final tierLabel = ['Boutique', 'Mid', 'Top Producer'][lo.tier.index];
    final tierColor = [T.yellow, T.sky, T.navy][lo.tier.index];
    final tierText = lo.tier == Tier.top ? T.white : T.navy;
    return Padding(padding: const EdgeInsets.only(bottom: T.sp12), child: Card(
      child: Padding(padding: const EdgeInsets.all(T.sp16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(radius: 24, backgroundColor: T.competitorGray,
                child: Text(lo.name.split(' ').map((w) => w[0]).take(2).join(),
                    style: const TextStyle(color: T.navy, fontWeight: FontWeight.w700))),
            const SizedBox(width: T.sp12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(lo.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: T.navy)),
              Text('${lo.city}, ${lo.state} · ${lo.nmls}',
                  style: const TextStyle(color: T.neutralText, fontSize: 13)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: tierColor, borderRadius: BorderRadius.circular(T.rChip)),
                child: Text(tierLabel, style: TextStyle(color: tierText, fontSize: 12, fontWeight: FontWeight.w600))),
          ]),
          const SizedBox(height: T.sp12),
          Text('~${lo.avgLoansMonth.toStringAsFixed(1)} loans/mo · '
              '${l10n.t("Stage", "Etapa")}: ${lo.stage.name}',
              style: const TextStyle(color: T.neutralText)),
          const SizedBox(height: T.sp12),
          Row(children: [
            ElevatedButton(onPressed: () {}, child: Text(l10n.t('Start pre-funnel', 'Iniciar pre-funnel'))),
            const SizedBox(width: T.sp8),
            OutlinedButton(onPressed: () {},
                style: OutlinedButton.styleFrom(shape: const StadiumBorder(),
                    side: const BorderSide(color: T.red, width: 2), foregroundColor: T.red),
                child: const Text('360°')),
          ]),
        ]))));
  }
}
