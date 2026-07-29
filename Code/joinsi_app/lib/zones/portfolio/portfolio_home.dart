// P32 Dashboard de Dinero · la home de SiPortfolio y puerta de entrada a
// P30 (mapa USA), P31 (ficha 360), P33 (proyector) y P35 (mi negocio).
//
// Lectura de la pantalla, de arriba abajo: cuanto he GANADO (heroe navy),
// cuanto esta EN CAMINO y cuanto ya esta COBRADO (las dos tarjetas parejas),
// por donde entro (mapa), a donde voy (proyector / mi negocio) y quien lo
// produce (la lista completa del portafolio). Ninguna cifra se escribe a mano:
// todas salen de Store o de un LoanOfficer.
import 'package:flutter/material.dart';
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
    final signed = Store.portfolio();
    final active = Store.activeCount;
    final asleep = signed.length - active;
    final states = Store.statesCount;

    return ListView(
      // Densidad creciente: heroe aireado arriba, listas apretadas abajo.
      padding: const EdgeInsets.fromLTRB(T.sp16, T.sp16, T.sp16, T.sp32),
      children: [
        _hero(active, signed.length, states),
        const SizedBox(height: T.sp24),
        _moneyCards(),
        const SizedBox(height: T.sp16),
        _mapCard(signed, states, active),
        const SizedBox(height: T.sp12),
        _navTiles(),
        const SizedBox(height: T.sp24),
        SectionTitle(
          l10n.t('My portfolio', 'Mi portafolio'),
          sub: l10n.t('$active active · $asleep with no cases this month',
              '$active activos · $asleep sin casos este mes'),
        ),
        const SizedBox(height: T.sp12),
        if (signed.isEmpty)
          WhiteCard(child: Text(
            l10n.t('No signed Loan Officers yet. SiRadar is where they start.',
                'Aún no hay Loan Officers firmados. SiRadar es donde empiezan.'),
            style: dataStyle(13, color: T.neutralText)))
        else
          for (final lo in signed) _loCard(lo),
      ]);
  }

  // ---------------------------------------------------------------------------
  // HEROE — la unica cifra amarilla grande de la pantalla.
  // ---------------------------------------------------------------------------
  Widget _hero(int active, int total, int states) => HeroNavy(
    child: Column(children: [
      Kicker(l10n.t('EARNED THIS YEAR', 'GANADO ESTE AÑO'), onNavy: true),
      const SizedBox(height: T.sp8),
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: Store.earnedYear),
        duration: T.durSlow, curve: T.easeBrand,
        builder: (_, v, __) => FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(money0.format(v), style: moneyStyle(48)))),
      const SizedBox(height: T.sp12),
      Row(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, children: [
        const ActivityDot(size: 6),
        const SizedBox(width: T.sp8),
        Flexible(child: Text(
          l10n.t('$active of $total Loan Officers sending cases · $states states',
              '$active de $total Loan Officers enviando casos · $states estados'),
          textAlign: TextAlign.center,
          style: dataStyle(13, w: FontWeight.w500, color: T.sky))),
      ]),
    ]));

  // ---------------------------------------------------------------------------
  // EN CAMINO / COBRADO — el HTML las deja de alturas distintas; aqui van
  // parejas con IntrinsicHeight + stretch. El reparto 6/5 (no 50/50) existe
  // porque el lado izquierdo carga el CTA y "VER MI CORTE" a 18px bold —minimo
  // de contraste blanco sobre rojo del P1B— no cabe en media pantalla exacta.
  // ---------------------------------------------------------------------------
  Widget _moneyCards() {
    final pending = Store.totalPending;
    final progress = ((Store.payPeriodDays - Store.daysToCut) /
        Store.payPeriodDays).clamp(0.0, 1.0).toDouble();

    return IntrinsicHeight(child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 6, child: WhiteCard(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, children: [
              Kicker(l10n.t('ON THE WAY', 'EN CAMINO')),
              const SizedBox(height: T.sp4),
              Text(money0.format(pending), style: moneyOnLight(28)),
              const SizedBox(height: T.sp4),
              Text(l10n.t(
                  '${Store.pendingCasesCount} closed loans · not paid yet',
                  '${Store.pendingCasesCount} casos cerrados · aún no cobrados'),
                  style: dataStyle(11, color: T.neutralText, height: 1.3)),
              const SizedBox(height: T.sp12),
              // Riel del ciclo de pago: cuanto del periodo de 30 dias ya corrio.
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(value: progress, minHeight: 6,
                    backgroundColor: T.hairline,
                    valueColor: const AlwaysStoppedAnimation(T.sky))),
              const SizedBox(height: T.sp8),
              Text(l10n.t(
                  'lands in the ${cutLabel(Store.nextCutDate)} cut · '
                      '${Store.daysToCut} days to go',
                  'entra en el corte del ${cutLabel(Store.nextCutDate)} · '
                      'faltan ${Store.daysToCut} días'),
                  style: dataStyle(11, w: FontWeight.w600, height: 1.3)),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: T.sp16),
              child: SizedBox(width: double.infinity, child: ElevatedButton(
                // Unico rojo accionable de la pantalla. Padding reducido: el
                // tamano de letra es innegociable, el padding no.
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: T.sp8, vertical: T.sp12)),
                onPressed: pending <= 0 ? null : _showCut,
                child: FittedBox(fit: BoxFit.scaleDown, child: Text(
                    l10n.t('SEE MY CUT', 'VER MI CORTE'), maxLines: 1)),
              ))),
          ]))),
        const SizedBox(width: T.sp12),
        Expanded(flex: 5, child: WhiteCard(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Kicker(l10n.t('COLLECTED', 'COBRADO')),
            const SizedBox(height: T.sp4),
            Text(money0.format(Store.totalCollected), style: moneyOnLight(28)),
            const SizedBox(height: T.sp4),
            Text(l10n.t(
                'already in your account · payouts every '
                    '${Store.payPeriodDays} days',
                'ya en tu cuenta · pagos cada ${Store.payPeriodDays} días'),
                style: dataStyle(11, color: T.neutralText, height: 1.3)),
          ]))),
      ]));
  }

  /// El corte es FUNCIONAL: pasa lo pendiente a cobrado via Store.applyCut().
  /// Por eso el dialogo dice con cuanto dinero y cuantos casos, antes de tocar
  /// nada — es plata del SiPartner, no una animacion.
  Future<void> _showCut() async {
    final amount = Store.totalPending;
    final cases = Store.pendingCasesCount;
    final cut = cutLabel(Store.nextCutDate);
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(context: context, builder: (ctx) =>
      AlertDialog(
        backgroundColor: T.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(T.rBig)),
        title: Text(l10n.t('Cut of $cut', 'Corte del $cut'),
            style: dataStyle(18, w: FontWeight.w800)),
        content: Text(l10n.t(
            '$cases closed loans are on the way, worth '
                '${money0.format(amount)}. Running the cut moves them to '
                'collected and the money goes to the account on file. HOMESI '
                'settles every ${Store.payPeriodDays} days — no invoice, no '
                'chasing anybody.',
            '$cases casos cerrados están en camino por '
                '${money0.format(amount)}. Aplicar el corte los pasa a cobrado '
                'y el dinero sale a tu cuenta registrada. HOMESI liquida cada '
                '${Store.payPeriodDays} días — sin factura, sin perseguir a '
                'nadie.'),
            style: dataStyle(14, w: FontWeight.w400, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.t('Later', 'Después'),
                  style: dataStyle(14, w: FontWeight.w600,
                      color: T.neutralText))),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.t('RUN THE CUT', 'APLICAR CORTE'))),
        ],
      ));

    if (ok != true) return;
    await Store.applyCut();
    _refresh();
    messenger.showSnackBar(SnackBar(
      backgroundColor: T.navy,
      content: Text(l10n.t(
          '${money0.format(amount)} on its way. Go sign the next one.',
          '${money0.format(amount)} van en camino. Ve y firma el siguiente.'),
          style: dataStyle(14, w: FontWeight.w600, color: T.white))));
  }

  // ---------------------------------------------------------------------------
  // PUERTA AL MAPA — abanico de 3 caritas superpuestas + chevron amarillo.
  // ---------------------------------------------------------------------------
  Widget _mapCard(List<LoanOfficer> signed, int states, int active) {
    final fan = signed.take(3).toList();
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => const UsaMapScreen())).then((_) => _refresh()),
      child: Container(
        padding: const EdgeInsets.all(T.sp16),
        decoration: BoxDecoration(color: T.navy,
            borderRadius: BorderRadius.circular(T.rCard),
            boxShadow: T.shadowMd),
        child: Row(children: [
          // 2 solapes de 24 + el ancho real de la carita con aro (40+sp8=48).
          SizedBox(
            width: fan.isEmpty ? 0.0 : (fan.length - 1) * 24.0 + 48,
            height: 48,
            child: Stack(clipBehavior: Clip.none, children: [
              for (var i = 0; i < fan.length; i++)
                Positioned(left: i * 24.0, child: CaritaAvatar(
                    spec: fan[i].avatar, size: 40, ring: true)),
            ])),
          const SizedBox(width: T.sp12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(l10n.t('My USA map', 'Mi mapa USA'),
                style: headlineOnNavy(16)),
            const SizedBox(height: 2),
            Text(l10n.t('$states states · $active sending cases',
                '$states estados · $active enviando casos'),
                style: dataStyle(12, color: T.sky)),
          ])),
          const Icon(Icons.chevron_right, size: 24, color: T.yellow),
        ]),
      ));
  }

  Widget _navTiles() => IntrinsicHeight(child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(child: _navTile(Icons.trending_up,
          l10n.t('Income projector', 'Proyector de ingresos'),
          () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const ProjectorScreen()))
              .then((_) => _refresh()))),
      const SizedBox(width: T.sp12),
      Expanded(child: _navTile(Icons.bar_chart_rounded,
          l10n.t('My business', 'Mi negocio'),
          () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const MyBusinessScreen()))
              .then((_) => _refresh()))),
    ]));

  Widget _navTile(IconData icon, String label, VoidCallback onTap) =>
    WhiteCard(onTap: onTap, child: Row(children: [
      Container(
        width: 32, height: 32, alignment: Alignment.center,
        decoration: BoxDecoration(
            color: T.red.withOpacity(.10), shape: BoxShape.circle),
        child: Icon(icon, color: T.red, size: 18)),
      const SizedBox(width: T.sp12),
      Expanded(child: Text(label,
          style: dataStyle(13, w: FontWeight.w700, height: 1.25))),
    ]));

  // ---------------------------------------------------------------------------
  // LISTA DEL PORTAFOLIO — TODOS los LOs firmados, no los 3 del mockup, y con
  // el embudo en TODAS las filas: media pantalla con chips y media sin ellos se
  // lee como un bug, no como jerarquia.
  // ---------------------------------------------------------------------------
  Widget _loCard(LoanOfficer lo) => Padding(
    padding: const EdgeInsets.only(bottom: T.sp12),
    child: WhiteCard(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => LoPortfolioScreen(loId: lo.id)))
          .then((_) => _refresh()),
      child: Row(children: [
        _face(lo),
        const SizedBox(width: T.sp12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(lo.name, style: dataStyle(14, w: FontWeight.w700),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text('${lo.city}, ${lo.state} · '
              '${l10n.t('month', 'mes')} ${lo.monthOf12}/12',
              style: dataStyle(12, color: T.neutralText),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: T.sp8),
          _funnel(lo),
        ])),
        const SizedBox(width: T.sp8),
        // Ancho fijo: sin el, la linea gris de cobrado/en camino le come el
        // espacio al nombre en los LOs de ciudad larga.
        SizedBox(width: 92, child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            MoneyPill(amount: lo.earned, size: 14),
            const SizedBox(height: T.sp4),
            Text(l10n.t(
                'collected ${money0.format(lo.collectedAmount)} · '
                    'on the way ${money0.format(lo.pendingAmount)}',
                'cobrado ${money0.format(lo.collectedAmount)} · '
                    'en camino ${money0.format(lo.pendingAmount)}'),
                textAlign: TextAlign.right,
                style: dataStyle(10, color: T.neutralText, height: 1.3)),
          ])),
      ])));

  /// Carita 48 con punto de actividad. La atenuacion por LO dormido va aqui
  /// —nunca en la cifra de dinero, que es cierta este el LO activo o no.
  Widget _face(LoanOfficer lo) => SizedBox(
    width: 48, height: 48,
    child: Stack(clipBehavior: Clip.none, children: [
      Opacity(opacity: lo.isActive ? 1 : .5,
          child: CaritaAvatar(spec: lo.avatar, size: 48)),
      if (lo.isActive) Positioned(right: -2, bottom: -2, child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(color: T.white, shape: BoxShape.circle),
        child: const ActivityDot(size: 10))),
    ]));

  /// Embudo comprimido a 4 numeros. El detalle con etiquetas vive en la
  /// ficha 360; aqui solo tiene que dejar comparar una fila con la de arriba.
  Widget _funnel(LoanOfficer lo) => Tooltip(
    message: l10n.t('leads · pre-approvals · ratified · closed loans',
        'leads · pre-approvals · ratified · closed loans'),
    child: Row(children: [
      for (final n in [lo.leads, lo.preApprovals, lo.ratified, lo.closedTotal])
        Padding(
          padding: const EdgeInsets.only(right: T.sp4),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: T.sp8, vertical: 2),
            decoration: BoxDecoration(color: T.competitorGray,
                borderRadius: BorderRadius.circular(T.rChip)),
            child: Text('$n', style: dataStyle(10, w: FontWeight.w600,
                color: T.neutralText)))),
    ]));
}
