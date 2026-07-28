// P32 Dashboard de Dinero + acceso a P30 mapa (A3 lo completa).
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/tokens.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';
import '../../models/loan_officer.dart';

class PortfolioHome extends StatelessWidget {
  const PortfolioHome({super.key});
  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    final signed = Store.los().where((l) => l.stage == Stage.signed).toList();
    return ListView(padding: const EdgeInsets.all(T.sp16), children: [
      // Hero navy con odometro amarillo
      Container(
        padding: const EdgeInsets.all(T.sp24),
        decoration: BoxDecoration(color: T.navy, borderRadius: BorderRadius.circular(T.rBig), boxShadow: T.shadowMd),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.t('EARNED THIS YEAR', 'GANADO ESTE AÑO'),
              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: T.sky)),
          const SizedBox(height: T.sp8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: Store.earnedYear), duration: T.durSlow, curve: T.easeBrand,
            builder: (_, v, __) => Text(money.format(v), style: moneyStyle(48))),
          const SizedBox(height: T.sp12),
          Text('${signed.length} Loan Officers · ${signed.map((e) => e.state).toSet().length} states',
              style: const TextStyle(color: T.sky)),
        ]),
      ),
      const SizedBox(height: T.sp16),
      Row(children: [
        Expanded(child: _stat(context, l10n.t('They owe me', 'Me deben'), money.format(Store.owedMonth),
            action: ElevatedButton(onPressed: () {}, child: Text(l10n.t('COLLECT', 'COBRAR'))))),
        const SizedBox(width: T.sp12),
        Expanded(child: _stat(context, l10n.t('Projected', 'Proyectado'),
            money.format(signed.fold<double>(0, (s, l) => s + l.avgLoansMonth * 200)))),
      ]),
      const SizedBox(height: T.sp24),
      Text(l10n.t('My portfolio', 'Mi portafolio'), style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: T.sp12),
      for (final lo in signed) _loTile(context, lo, money),
    ]);
  }

  Widget _stat(BuildContext c, String label, String value, {Widget? action}) => Card(
      child: Padding(padding: const EdgeInsets.all(T.sp16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label.toUpperCase(), style: Theme.of(c).textTheme.labelSmall),
            const SizedBox(height: T.sp4),
            Text(value, style: Theme.of(c).textTheme.headlineSmall),
            if (action != null) ...[const SizedBox(height: T.sp8), action],
          ])));

  Widget _loTile(BuildContext c, LoanOfficer lo, NumberFormat money) => Padding(
      padding: const EdgeInsets.only(bottom: T.sp12),
      child: Card(child: ListTile(
        leading: CircleAvatar(backgroundColor: T.sky,
            child: Text(lo.name.split(' ').map((w) => w[0]).take(2).join(),
                style: const TextStyle(color: T.navy, fontWeight: FontWeight.w700))),
        title: Text(lo.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('${lo.city}, ${lo.state} · Month ${lo.monthOf12} of 12\n'
            '${lo.leads} leads · ${lo.preApprovals} pre-approvals · ${lo.ratified} ratified'),
        isThreeLine: true,
        trailing: Text(money.format(lo.earned),
            style: const TextStyle(color: T.red, fontWeight: FontWeight.w800, fontSize: 16)),
      )));
}
