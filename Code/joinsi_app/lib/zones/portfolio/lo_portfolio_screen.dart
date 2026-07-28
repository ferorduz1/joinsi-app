// P31 · FICHA DE PORTAFOLIO 360° — todo lo que ese Loan Officer significa para
// tu negocio: embudo de produccion, mes N de 12, dinero ganado y por ganar.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/tokens.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';
import '../../models/loan_officer.dart';
import '../../widgets/carita_avatar.dart';
import '../../widgets/avatar_picker.dart';
import '../../widgets/common.dart';

class LoPortfolioScreen extends StatefulWidget {
  final String loId;
  const LoPortfolioScreen({super.key, required this.loId});
  @override
  State<LoPortfolioScreen> createState() => _LoPortfolioScreenState();
}

class _LoPortfolioScreenState extends State<LoPortfolioScreen> {
  LoanOfficer? lo;

  @override
  void initState() { super.initState(); _reload(); }

  void _reload() {
    final list = Store.los();
    final i = list.indexWhere((l) => l.id == widget.loId);
    if (mounted) setState(() => lo = i >= 0 ? list[i] : null);
  }

  @override
  Widget build(BuildContext context) {
    final l = lo;
    if (l == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: T.navy, foregroundColor: T.white),
        body: Center(child: Text(l10n.t('This Loan Officer is no longer in your '
            'portfolio.', 'Este Loan Officer ya no está en tu portafolio.'),
            style: const TextStyle(color: T.neutralText))),
      );
    }
    final money = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    final tt = Theme.of(context).textTheme;
    final remaining = (12 - l.monthOf12).clamp(0, 12);
    final futureCash = l.remainingWindowValue();

    return Scaffold(
      backgroundColor: T.white,
      appBar: AppBar(backgroundColor: T.navy, foregroundColor: T.white,
          title: Text(l.name, style: const TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(padding: const EdgeInsets.all(T.sp16), children: [
        // Hero navy con la carita grande
        Container(
          padding: const EdgeInsets.all(T.sp24),
          decoration: BoxDecoration(color: T.navy,
              borderRadius: BorderRadius.circular(T.rBig), boxShadow: T.shadowMd),
          child: Row(children: [
            GestureDetector(
              onTap: () => showAvatarPicker(context, l, onSaved: _reload),
              child: Stack(clipBehavior: Clip.none, children: [
                CaritaAvatar(spec: l.avatar, size: 76, ring: true),
                Positioned(right: -4, bottom: -4, child: Container(
                  padding: const EdgeInsets.all(T.sp4),
                  decoration: const BoxDecoration(color: T.red, shape: BoxShape.circle),
                  child: const Icon(Icons.edit, size: 12, color: T.white))),
              ]),
            ),
            const SizedBox(width: T.sp16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text('${l.city}, ${l.state}',
                  style: const TextStyle(color: T.sky, fontSize: 13)),
              Text(l.nmls, style: const TextStyle(color: T.sky, fontSize: 11)),
              const SizedBox(height: T.sp8),
              Text(money.format(l.earned), style: moneyStyle(30)),
              Text(l10n.t('earned with this relationship',
                  'ganado con esta relación'),
                  style: const TextStyle(color: T.sky, fontSize: 11)),
            ])),
          ]),
        ),
        const SizedBox(height: T.sp24),

        // Mes N de 12
        Text(l10n.t('12-MONTH WINDOW', 'VENTANA DE 12 MESES'), style: tt.labelSmall),
        const SizedBox(height: T.sp8),
        _monthsBar(l.monthOf12),
        const SizedBox(height: T.sp8),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(l10n.t(
              'Month ${l.monthOf12} of 12 · $remaining months left',
              'Mes ${l.monthOf12} de 12 · faltan $remaining meses'),
              style: const TextStyle(fontSize: 13, color: T.navy,
                  fontWeight: FontWeight.w600))),
          MoneyPill(amount: futureCash, size: 14, money: money),
        ]),
        const SizedBox(height: T.sp4),
        // El rotulo se DERIVA de la misma cifra del pill. Antes anunciaba el
        // run-rate y quien multiplicara no llegaba al pill (hasta 14% de
        // brecha por el floor de closed loans). El run-rate sigue visible en su
        // propio KPI, donde no arrastra dinero.
        Text(l10n.t(
            'still to come · ${money.format(remaining > 0 ? futureCash / remaining : 0)}/mo '
                'across $remaining months',
            'por venir · ${money.format(remaining > 0 ? futureCash / remaining : 0)}/mes '
                'durante $remaining meses'),
            style: const TextStyle(fontSize: 12, color: T.neutralText)),
        const SizedBox(height: T.sp24),

        // Embudo de produccion del LO
        Text(l10n.t('PRODUCTION FUNNEL', 'EMBUDO DE PRODUCCIÓN'), style: tt.labelSmall),
        const SizedBox(height: T.sp12),
        _funnel(l),
        const SizedBox(height: T.sp24),

        // Como se paga
        Container(
          padding: const EdgeInsets.all(T.sp16),
          decoration: BoxDecoration(
            color: T.red.withOpacity(.04),
            border: const Border(left: BorderSide(color: T.red, width: 4)),
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(T.rCard)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.t('HOW YOU GET PAID', 'CÓMO TE PAGAN'),
                style: tt.labelSmall!.copyWith(color: T.red)),
            const SizedBox(height: T.sp8),
            Text(l10n.t(
                '\$500 + \$500 on this LO\'s first two closed loans, then \$200 per '
                'closed loan for 12 months. Your portfolio stacks: every LO you sign '
                'adds a new monthly stream.',
                '\$500 + \$500 en los dos primeros closed loans de este LO, luego '
                '\$200 por cada closed loan durante 12 meses. Tu portafolio se apila: '
                'cada LO que firmas suma un flujo mensual nuevo.'),
                style: const TextStyle(fontSize: 13, height: 1.5, color: T.navy)),
          ]),
        ),
        const SizedBox(height: T.sp24),

        Row(children: [
          Expanded(child: _kpi(context, 'Tier', tierLabel(l.tier))),
          const SizedBox(width: T.sp12),
          Expanded(child: _kpi(context, l10n.t('Program', 'Programa'), l.program)),
          const SizedBox(width: T.sp12),
          Expanded(child: _kpi(context, l10n.t('Run-rate', 'Ritmo real'),
              '${l.demonstratedRate.toStringAsFixed(1)}/mo')),
        ]),
        const SizedBox(height: T.sp32),
      ]),
    );
  }

  Widget _monthsBar(int m) => Row(children: [
    for (var i = 1; i <= 12; i++) Expanded(child: Container(
      height: 12, margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: i <= m ? T.yellow : T.track,
        borderRadius: BorderRadius.circular(4)),
    )),
  ]);

  /// Barras finas ancladas a base. UNA sola entidad = UNA sola serie con
  /// opacidad decreciente. Cuatro colores aqui seria rainbow: el color sigue a
  /// la entidad, no a la etapa.
  Widget _funnel(LoanOfficer l) {
    final steps = <(String, int, double)>[
      ('Leads', l.leads, 1.0),
      ('Pre-approvals', l.preApprovals, .75),
      ('Ratified', l.ratified, .55),
      ('Closed loans', l.closedTotal, .40),
    ];
    final maxV = steps.fold<int>(1, (a, s) => s.$2 > a ? s.$2 : a);
    return Column(children: [
      for (var i = 0; i < steps.length; i++) Padding(
        padding: const EdgeInsets.only(bottom: T.sp8),
        child: Row(children: [
          SizedBox(width: 96, child: Text(steps[i].$1, style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: T.navy))),
          Expanded(child: LayoutBuilder(builder: (_, c) => Align(
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: c.maxWidth * (steps[i].$2 / maxV)),
              duration: T.durMid + Duration(milliseconds: 40 * i),
              curve: T.easeBrand,
              builder: (_, w, __) => Container(
                height: 16, width: w.clamp(2.0, c.maxWidth),
                decoration: BoxDecoration(color: T.s1.withOpacity(steps[i].$3),
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ))),
          SizedBox(width: 32, child: Text('${steps[i].$2}', textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                  color: T.navy))),
        ]),
      ),
    ]);
  }

  Widget _kpi(BuildContext c, String label, String v) => Card(
    child: Padding(padding: const EdgeInsets.all(T.sp12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(), style: Theme.of(c).textTheme.labelSmall),
        const SizedBox(height: T.sp4),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w800,
            fontSize: 15, color: T.navy)),
      ])),
  );
}
