// P32 Dashboard de Dinero · puerta de entrada a P30 (mapa USA), P31 (ficha 360),
// P33 (proyector) y P35 (mi negocio).
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/tokens.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';
import '../../models/loan_officer.dart';
import '../../widgets/carita_avatar.dart';
import '../../widgets/common.dart';
import 'usa_map_screen.dart';
import 'lo_portfolio_screen.dart';
import 'projector_screen.dart';
import 'my_business_screen.dart';

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});
  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  void _refresh() { if (mounted) setState(() {}); }

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    final signed = Store.portfolio();
    final states = signed.map((e) => e.state).toSet().length;
    // Lo que entra este mes = primer mes de la ventana restante de cada LO.
    // Sale de remainingWindowValue(), la MISMA fuente que usa el proyector: si
    // se calculara aparte, las dos pantallas divergirian por el redondeo — y un
    // LO en el mes 12/12 seguiria "entrando" dinero aqui mientras su ficha ya
    // dice \$0.
    final thisMonth = signed.fold<double>(0, (s, l) {
      final monthsLeft = (12 - l.monthOf12).clamp(0, 12);
      return monthsLeft == 0 ? s : s + l.remainingWindowValue() / monthsLeft;
    });

    return ListView(padding: const EdgeInsets.all(T.sp16), children: [
      // Hero navy con odometro amarillo
      Container(
        padding: const EdgeInsets.all(T.sp24),
        decoration: BoxDecoration(color: T.navy,
            borderRadius: BorderRadius.circular(T.rBig), boxShadow: T.shadowMd),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.t('EARNED THIS YEAR', 'GANADO ESTE AÑO'),
              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: T.sky)),
          const SizedBox(height: T.sp8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: Store.earnedYear),
            duration: T.durSlow, curve: T.easeBrand,
            builder: (_, v, __) => Text(money.format(v), style: moneyStyle(48))),
          const SizedBox(height: T.sp12),
          Text(l10n.t('${signed.length} Loan Officers · $states states',
              '${signed.length} Loan Officers · $states estados'),
              style: const TextStyle(color: T.sky)),
        ]),
      ),
      const SizedBox(height: T.sp16),
      Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: _stat(context, l10n.t('They owe me', 'Me deben'),
            money.format(Store.owedMonth),
            action: ElevatedButton(
                onPressed: () => _collect(money),
                child: Text(l10n.t('COLLECT', 'COBRAR'))))),
        const SizedBox(width: T.sp12),
        Expanded(child: _stat(context,
            l10n.t('Landing this month', 'Este mes entran'),
            money.format(thisMonth))),
      ]),
      const SizedBox(height: T.sp16),

      // Puerta al mapa: la pantalla "wow" de A3
      _mapCard(context, signed, states),
      const SizedBox(height: T.sp12),
      Row(children: [
        Expanded(child: _navTile(context, Icons.trending_up,
            l10n.t('Income projector', 'Proyector de ingresos'),
            () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const ProjectorScreen())).then((_) => _refresh()))),
        const SizedBox(width: T.sp12),
        Expanded(child: _navTile(context, Icons.insights_outlined,
            l10n.t('My business', 'Mi negocio'),
            () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const MyBusinessScreen())).then((_) => _refresh()))),
      ]),

      const SizedBox(height: T.sp24),
      Text(l10n.t('My portfolio', 'Mi portafolio'),
          style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: T.sp12),
      for (final lo in signed) _loTile(context, lo, money),
    ]);
  }

  void _collect(NumberFormat money) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: T.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(T.rBig)),
      title: Text(l10n.t('Send to your account', 'Enviar a tu cuenta'),
          style: const TextStyle(fontWeight: FontWeight.w800, color: T.navy)),
      content: Text(l10n.t(
          '${money.format(Store.owedMonth)} is ready. It lands in the account on '
          'file within 2 business days — no invoice, no chasing anybody.',
          '${money.format(Store.owedMonth)} están listos. Caen en tu cuenta '
          'registrada en 2 días hábiles — sin factura, sin perseguir a nadie.'),
          style: const TextStyle(fontSize: 14, height: 1.5, color: T.navy)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.t('Later', 'Después'),
                style: const TextStyle(color: T.neutralText))),
        ElevatedButton(onPressed: () {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: T.navy,
            content: Text(l10n.t('On its way. Go sign the next one.',
                'Va en camino. Ve y firma el siguiente.'),
                style: const TextStyle(color: T.white))));
        }, child: Text(l10n.t('SEND IT', 'ENVIAR'))),
      ],
    ));
  }

  Widget _mapCard(BuildContext c, List<LoanOfficer> signed, int states) =>
    GestureDetector(
      onTap: () => Navigator.push(c, MaterialPageRoute(
          builder: (_) => const UsaMapScreen())).then((_) => _refresh()),
      child: Container(
        padding: const EdgeInsets.all(T.sp16),
        decoration: BoxDecoration(color: T.navy,
            borderRadius: BorderRadius.circular(T.rCard), boxShadow: T.shadowSm),
        child: Row(children: [
          SizedBox(
            // 4 solapes de 24 + el ancho real del pin (40+sp8=48) = 144.
            width: 144, height: 48,
            child: Stack(clipBehavior: Clip.none, children: [
              for (var i = 0; i < signed.length.clamp(0, 5); i++)
                Positioned(left: i * 24.0, child:
                    CaritaAvatar(spec: signed[i].avatar, size: 40, ring: true)),
            ]),
          ),
          const SizedBox(width: T.sp12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(l10n.t('My USA map', 'Mi mapa USA'), style: const TextStyle(
                color: T.white, fontWeight: FontWeight.w800, fontSize: 16)),
            Text(l10n.t('$states states · tap a face',
                '$states estados · toca una carita'),
                style: const TextStyle(color: T.sky, fontSize: 12)),
          ])),
          const Icon(Icons.arrow_forward_ios, size: 16, color: T.yellow),
        ]),
      ),
    );

  Widget _navTile(BuildContext c, IconData icon, String label, VoidCallback onTap) =>
    Card(child: InkWell(
      borderRadius: BorderRadius.circular(T.rCard), onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(T.sp16),
        child: Row(children: [
          Icon(icon, color: T.red, size: 24),
          const SizedBox(width: T.sp8),
          Expanded(child: Text(label, style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 13, color: T.navy))),
        ])),
    ));

  Widget _stat(BuildContext c, String label, String value, {Widget? action}) => Card(
      child: Padding(padding: const EdgeInsets.all(T.sp16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(label.toUpperCase(), style: Theme.of(c).textTheme.labelSmall),
            const SizedBox(height: T.sp4),
            Text(value, style: moneyOnLight(24)),
            if (action != null) ...[const SizedBox(height: T.sp12), action],
          ])));

  Widget _loTile(BuildContext c, LoanOfficer lo, NumberFormat money) => Padding(
      padding: const EdgeInsets.only(bottom: T.sp12),
      child: Card(child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: T.sp16, vertical: T.sp8),
        onTap: () => Navigator.push(c, MaterialPageRoute(
            builder: (_) => LoPortfolioScreen(loId: lo.id))).then((_) => _refresh()),
        leading: CaritaAvatar(spec: lo.avatar, size: 48),
        title: Text(lo.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        // Embudo comprimido a proposito: con el MoneyPill en el trailing quedan
        // ~145px de ancho y la version larga envolvia a 5 lineas. El detalle
        // vive en la ficha 360°.
        subtitle: Text(
            '${lo.city}, ${lo.state} · ${l10n.t('month', 'mes')} ${lo.monthOf12}/12\n'
            '${lo.leads}/${lo.preApprovals}/${lo.ratified}/${lo.closedTotal} '
            'lead→closed'),
        isThreeLine: true,
        trailing: MoneyPill(amount: lo.earned, size: 15, money: money),
      )));
}
