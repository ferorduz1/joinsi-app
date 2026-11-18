// P31 · FICHA DE PORTAFOLIO 360° — todo lo que ese Loan Officer significa para
// tu negocio: dinero causado, cobrado y en camino, mes N de 12, embudo de
// produccion y como te paga la casa. Capa visual reconstruida contra la
// referencia A3-R2 aprobada (Stitch · Loan Officer Detail).
import 'package:flutter/material.dart';
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

  /// Resolucion por INDICE, nunca `firstWhere` sin `orElse`: si el LO fue
  /// removido del portafolio la ficha muestra estado vacio en vez de crashear.
  void _reload() {
    final list = Store.los();
    final i = list.indexWhere((l) => l.id == widget.loId);
    if (mounted) setState(() => lo = i >= 0 ? list[i] : null);
  }

  @override
  Widget build(BuildContext context) {
    final l = lo;
    if (l == null) return _empty();

    final remaining = (12 - l.monthOf12).clamp(0, 12);
    // El pill y su rotulo salen del MISMO par de derivaciones del modelo
    // (remainingWindowValue / monthlyRemaining, donde la segunda es la primera
    // dividida por los meses restantes). Antes el rotulo anunciaba el run-rate
    // y quien multiplicara no llegaba al pill: hasta 14% de brecha.
    final futureCash = l.remainingWindowValue();
    final perMonth = l.monthlyRemaining;

    return Scaffold(
      backgroundColor: T.white,
      appBar: AppBar(
        backgroundColor: T.navy, foregroundColor: T.white,
        elevation: 0, centerTitle: true,
        title: Text(l.name, style: headlineOnNavy(20)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(T.sp16, T.sp24, T.sp16, T.sp32),
        children: [
          _hero(l),
          const SizedBox(height: T.sp24),
          _moneyStrip(l),
          const SizedBox(height: T.sp24),

          // ---------------- VENTANA DE 12 MESES ----------------
          Kicker(l10n.t('12-month window', 'Ventana de 12 meses')),
          const SizedBox(height: T.sp12),
          WindowTrack(monthOf12: l.monthOf12),
          const SizedBox(height: T.sp12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Text(
              l10n.t('Month ${l.monthOf12} of 12 · $remaining months left',
                     'Mes ${l.monthOf12} de 12 · faltan $remaining meses'),
              style: dataStyle(13, w: FontWeight.w600))),
            const SizedBox(width: T.sp8),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              MoneyPill(amount: futureCash, size: 13),
              const SizedBox(height: T.sp4),
              SizedBox(width: 150, child: Text(
                l10n.t('still to come · ${money0.format(perMonth)}/mo '
                       'across $remaining months',
                       'por venir · ${money0.format(perMonth)}/mes '
                       'durante $remaining meses'),
                textAlign: TextAlign.right,
                style: dataStyle(10, w: FontWeight.w500,
                    color: T.neutralText, height: 1.3))),
            ]),
          ]),
          const SizedBox(height: T.sp24),

          // ---------------- EMBUDO DE PRODUCCION ----------------
          Kicker(l10n.t('Production funnel', 'Embudo de producción')),
          const SizedBox(height: T.sp12),
          _funnel(l),
          const SizedBox(height: T.sp24),

          // ---------------- COMO TE PAGAN ----------------
          GoldenRuleCallout(
            kicker: l10n.t('How you get paid', 'Cómo te pagan'),
            body: l10n.t(
              '\$500 + \$500 on this LO\'s first two closed loans, then \$200 '
              'per closed loan for 12 months. Every closed loan is paid at the '
              'cut: payouts every ${Store.payPeriodDays} days. Your portfolio '
              'stacks: every LO you sign adds a new monthly stream.',
              '\$500 + \$500 en los dos primeros closed loans de este LO, luego '
              '\$200 por cada closed loan durante 12 meses. Cada caso cerrado '
              'se cobra al corte: pagos cada ${Store.payPeriodDays} días. Tu '
              'portafolio se apila: cada LO que firmas suma un flujo mensual '
              'nuevo.'),
          ),
          const SizedBox(height: T.sp24),

          // ---------------- KPIs ----------------
          // IntrinsicHeight: sin el, `stretch` dentro de un ListView pide alto
          // infinito y revienta en layout. Con el, las 3 tarjetas igualan alto.
          IntrinsicHeight(child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(child: _kpi('Tier', tierLabel(l.tier))),
              const SizedBox(width: T.sp12),
              Expanded(child: _kpi(l10n.t('Program', 'Programa'), l.program)),
              const SizedBox(width: T.sp12),
              Expanded(child: _kpi(l10n.t('Run-rate', 'Ritmo real'),
                  l.demonstratedRate.toStringAsFixed(1),
                  suffix: l10n.t('/mo', '/mes'))),
            ])),
        ],
      ),
    );
  }

  // ===========================================================================
  // HEROE — zona ceremonial: identidad + el UNICO numero amarillo grande.
  // ===========================================================================
  Widget _hero(LoanOfficer l) => HeroNavy(
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _avatarFrame(l),
      const SizedBox(width: T.sp16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: T.sp12, runSpacing: T.sp4,
            crossAxisAlignment: WrapCrossAlignment.center, children: [
              Text('${l.city}, ${l.state}',
                  style: dataStyle(13, w: FontWeight.w600, color: T.sky)),
              Text(l.nmls, style: dataStyle(11, color: T.sky)),
            ]),
          const SizedBox(height: T.sp12),
          ActivityChip(active: l.isActive),
          const SizedBox(height: T.sp16),
          FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
              child: Text(money0.format(l.earned), style: moneyStyle(32))),
          const SizedBox(height: T.sp4),
          Text(l10n.t('earned with this relationship',
                      'ganado con esta relación').toUpperCase(),
              style: dataStyle(10, w: FontWeight.w600, color: T.sky)
                  .copyWith(letterSpacing: .8)),
        ])),
    ]),
  );

  /// Marco squircle con anillo cielo + badge rojo de edicion. `CaritaAvatar`
  /// trae aro CIRCULAR blanco; aqui la referencia pide squircle sobre navy, asi
  /// que el marco se compone fuera y la carita entra sin aro.
  Widget _avatarFrame(LoanOfficer l) => GestureDetector(
    onTap: () => showAvatarPicker(context, l, onSaved: _reload),
    child: Stack(clipBehavior: Clip.none, children: [
      Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(T.rBig),
          border: Border.all(color: T.sky, width: 2),
          boxShadow: [BoxShadow(color: T.sky.withValues(alpha: .35),
              blurRadius: 16, spreadRadius: 1)],
        ),
        child: CaritaAvatar(spec: l.avatar, size: 80),
      ),
      Positioned(top: -6, right: -6, child: Container(
        padding: const EdgeInsets.all(T.sp4),
        decoration: BoxDecoration(color: T.red, shape: BoxShape.circle,
            border: Border.all(color: T.navy, width: 2)),
        child: const Icon(Icons.edit, size: 12, color: T.white),
      )),
    ]),
  );

  // ===========================================================================
  // TIRA DE ESTADO DEL DINERO — cobrado | en camino. Ambas en navy bold: el
  // amarillo grande es exclusivo del heroe.
  // ===========================================================================
  Widget _moneyStrip(LoanOfficer l) => WhiteCard(
    child: IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.only(right: T.sp16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Kicker(l10n.t('Collected', 'Cobrado')),
            const SizedBox(height: T.sp4),
            FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
                child: Text(money0.format(l.collectedAmount),
                    style: moneyOnLight(24))),
          ]))),
        Container(width: 1, color: T.hairline,
            margin: const EdgeInsets.symmetric(vertical: T.sp4)),
        Expanded(child: Padding(
          padding: const EdgeInsets.only(left: T.sp16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Kicker(l10n.t('On the way', 'En camino')),
            const SizedBox(height: T.sp4),
            FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
                child: Text(money0.format(l.pendingAmount),
                    style: moneyOnLight(24))),
            const SizedBox(height: T.sp4),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(padding: EdgeInsets.only(top: 1),
                  child: Icon(Icons.schedule, size: 12, color: T.neutralText)),
              const SizedBox(width: T.sp4),
              Expanded(child: Text(_cutCaption(l),
                  style: dataStyle(10, w: FontWeight.w500,
                      color: T.neutralText, height: 1.3))),
            ]),
          ]))),
      ]),
    ),
  );

  String _cutCaption(LoanOfficer l) {
    final n = l.pendingCases;
    final cut = cutLabel(Store.nextCutDate);
    if (n == 0) {
      return l10n.t('nothing waiting for the $cut cut',
                    'nada esperando el corte del $cut');
    }
    return l10n.t('$n closed loans · enters the $cut cut',
                  '$n casos cerrados · entra en el corte del $cut');
  }

  // ===========================================================================
  // EMBUDO — UNA entidad = UNA familia de color (cielo) con opacidad
  // decreciente. Cuatro colores aqui seria arcoiris: el color sigue a la
  // entidad, no a la etapa.
  // ===========================================================================
  Widget _funnel(LoanOfficer l) {
    final steps = <(String, int, double)>[
      // Opacidad decreciente, pero con piso en .55: por debajo de eso el cielo
      // sobre blanco deja de distinguirse del riel hairline y "closed loans"
      // —la fila que mas importa— se volveria la mas ilegible del embudo.
      ('Leads', l.leads, 1.0),
      ('Pre-approvals', l.preApprovals, .85),
      ('Ratified', l.ratified, .70),
      ('Closed loans', l.closedTotal, .55),
    ];
    final maxV = steps.fold<int>(1, (a, s) => s.$2 > a ? s.$2 : a);
    return WhiteCard(
      padding: const EdgeInsets.symmetric(
          horizontal: T.sp16, vertical: T.sp8),
      child: Column(children: [
        for (var i = 0; i < steps.length; i++)
          _FunnelBar(label: steps[i].$1, value: steps[i].$2.toDouble(),
              max: maxV.toDouble(), valueText: '${steps[i].$2}',
              opacity: steps[i].$3, delay: Duration(milliseconds: 40 * i)),
      ]),
    );
  }

  Widget _kpi(String label, String value, {String? suffix}) => WhiteCard(
    padding: const EdgeInsets.symmetric(
        horizontal: T.sp8, vertical: T.sp12),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Kicker(label),
      const SizedBox(height: T.sp4),
      FittedBox(fit: BoxFit.scaleDown, child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(value, style: dataStyle(16, w: FontWeight.w800)),
          if (suffix != null) Text(suffix,
              style: dataStyle(11, w: FontWeight.w500, color: T.neutralText)),
        ])),
    ]),
  );

  Widget _empty() => Scaffold(
    backgroundColor: T.white,
    appBar: AppBar(backgroundColor: T.navy, foregroundColor: T.white,
        elevation: 0, centerTitle: true,
        title: Text('Loan Officer', style: headlineOnNavy(20))),
    body: Center(child: Padding(
      padding: const EdgeInsets.all(T.sp32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.person_off_outlined, size: 40, color: T.neutralText),
        const SizedBox(height: T.sp16),
        Text(l10n.t('This Loan Officer is no longer in your portfolio.',
                    'Este Loan Officer ya no está en tu portafolio.'),
            textAlign: TextAlign.center,
            style: dataStyle(14, color: T.neutralText)),
      ]))),
  );
}

/// Fila del embudo: misma anatomia que `BarRow` (etiqueta · riel · valor) pero
/// con opacidad por etapa y barra animada anclada a la izquierda. Vive aqui —
/// no en `common.dart` — porque el degradado de opacidad es semantica exclusiva
/// del embudo de UN LO; el `BarRow` compartido sigue siendo color plano.
class _FunnelBar extends StatelessWidget {
  final String label, valueText;
  final double value, max, opacity;
  final Duration delay;
  const _FunnelBar({required this.label, required this.value,
    required this.max, required this.valueText, required this.opacity,
    this.delay = Duration.zero});

  @override
  Widget build(BuildContext context) {
    final frac = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: T.sp8),
      child: Row(children: [
        SizedBox(width: 92, child: Text(label,
            style: dataStyle(13, w: FontWeight.w600))),
        const SizedBox(width: T.sp8),
        Expanded(child: LayoutBuilder(builder: (_, c) => Container(
          height: 18, alignment: Alignment.centerLeft,
          decoration: BoxDecoration(color: T.hairline,
              borderRadius: BorderRadius.circular(999)),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: c.maxWidth * frac),
            duration: T.durMid + delay, curve: T.easeBrand,
            builder: (_, w, __) => Container(
              height: 18, width: w.clamp(4.0, c.maxWidth),
              decoration: BoxDecoration(color: T.sky.withValues(alpha: opacity),
                  borderRadius: BorderRadius.circular(999)),
            ),
          ),
        ))),
        const SizedBox(width: T.sp8),
        SizedBox(width: 34, child: Text(valueText, textAlign: TextAlign.right,
            style: dataStyle(17, w: FontWeight.w800))),
      ]));
  }
}
