// P35 · MI NEGOCIO — resumen ejecutivo privado del SiPartner.
//
// Lectura de arriba abajo: que tengo HOY (heroe navy, 2x2), de donde sale ese
// dinero (por estado, por tier, por costa) y quien lo produce (las caritas).
// La escalera de estatus y las medallas metalicas YA NO viven aqui: se mudaron
// a P34 Ranking. Esta pantalla solo deja un chip plano que lleva alla — el
// metal es ceremonia de una sola pantalla, y repetirlo lo abarata.
//
// Ninguna cifra se escribe a mano: todas se AGRUPAN desde Store.portfolio()
// con `earned`, `state`, `tier` y `coast` de cada LoanOfficer.
import 'package:flutter/material.dart';
import '../../core/tokens.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';
import '../../models/loan_officer.dart';
import '../../widgets/carita_avatar.dart';
import '../../widgets/common.dart';
import 'lo_portfolio_screen.dart';
import 'ranking_screen.dart';

class MyBusinessScreen extends StatefulWidget {
  const MyBusinessScreen({super.key});
  @override
  State<MyBusinessScreen> createState() => _MyBusinessScreenState();
}

class _MyBusinessScreenState extends State<MyBusinessScreen> {
  void _refresh() { if (mounted) setState(() {}); }

  /// Agrupa el CAUSADO del portafolio por la dimension que se le pida y lo
  /// devuelve ordenado de mayor a menor. Una sola funcion para las tres
  /// tarjetas: si manana cambia la economia, cambia en un solo sitio.
  List<MapEntry<String, double>> _agg(
      List<LoanOfficer> los, String Function(LoanOfficer) key) {
    final m = <String, double>{};
    for (final l in los) {
      m[key(l)] = (m[key(l)] ?? 0) + l.earned;
    }
    return m.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  Widget build(BuildContext context) {
    final signed = Store.portfolio();

    return Scaffold(
      backgroundColor: T.white,
      appBar: AppBar(
        backgroundColor: T.navy, foregroundColor: T.white,
        title: Text(l10n.t('My business', 'Mi negocio'),
            style: headlineOnNavy(20)),
      ),
      body: ListView(
        // Densidad creciente: heroe aireado, luego tarjetas, luego la grilla.
        padding: const EdgeInsets.fromLTRB(T.sp16, T.sp16, T.sp16, T.sp32),
        children: [
          _hero(signed),
          const SizedBox(height: T.sp24),
          _barCard(l10n.t('EARNED BY STATE', 'GANADO POR ESTADO'),
              _agg(signed, (l) => l.state), labelWidth: 40),
          const SizedBox(height: T.sp16),
          _barCard(l10n.t('EARNED BY TIER', 'GANADO POR TIER'),
              _agg(signed, (l) => tierLabel(l.tier)), labelWidth: 64),
          const SizedBox(height: T.sp16),
          _barCard(l10n.t('EARNED BY COAST', 'GANADO POR COSTA'),
              _agg(signed, (l) => l.coast), labelWidth: 64),
          const SizedBox(height: T.sp16),
          _losCard(signed),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEROE — el negocio entero en cuatro numeros. UNA sola cifra amarilla
  // (GANADO); closed loans, activos y estados van en blanco bold porque no son
  // dinero y el amarillo esta reservado a la caja.
  // ---------------------------------------------------------------------------
  Widget _hero(List<LoanOfficer> signed) => HeroNavy(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Kicker(l10n.t('MY BUSINESS AT A GLANCE', 'MI NEGOCIO EN UNA MIRADA'),
          onNavy: true),
      const SizedBox(height: T.sp16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _heroCell(
            l10n.t('EARNED', 'GANADO'),
            Text(money0.format(Store.earnedYear), style: moneyStyle(32)))),
          const SizedBox(width: T.sp12),
          Expanded(child: _heroCell(
            'CLOSED LOANS',
            Text('${Store.closedTotal}', style: headlineOnNavy(24)))),
        ]),
      const SizedBox(height: T.sp16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _heroCell(
            l10n.t('ACTIVE', 'ACTIVOS'),
            Row(mainAxisSize: MainAxisSize.min, children: [
              const ActivityDot(size: 8),
              const SizedBox(width: T.sp8),
              // Sin Flexible: este Row vive dentro de un FittedBox, que
              // entrega ancho ilimitado — un hijo con flex ahi revienta.
              Text(l10n.t('${Store.activeCount} of ${signed.length}',
                          '${Store.activeCount} de ${signed.length}'),
                  style: headlineOnNavy(24)),
            ]))),
          const SizedBox(width: T.sp12),
          Expanded(child: _heroCell(
            l10n.t('STATES', 'ESTADOS'),
            Text('${Store.statesCount}', style: headlineOnNavy(24)))),
        ]),
      const SizedBox(height: T.sp24),
      _ladderChip(),
    ]));

  Widget _heroCell(String label, Widget value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Kicker(label, onNavy: true),
      const SizedBox(height: T.sp4),
      FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
          child: value),
    ]);

  /// Puerta a P34. Casa PLANA en blanco — la casa con metal (MedallaCasa) es
  /// patrimonio exclusivo del Ranking. El fondo no es un color nuevo: es navy
  /// mezclado con cielo, la misma tecnica de los derivados de tokens.dart.
  Widget _ladderChip() => InkWell(
    borderRadius: BorderRadius.circular(T.rChip),
    onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => const RankingScreen())).then((_) => _refresh()),
    child: Container(
      padding: const EdgeInsets.symmetric(
          horizontal: T.sp12, vertical: T.sp8),
      decoration: BoxDecoration(
        color: Color.lerp(T.navy, T.sky, .12),
        border: Border.all(color: T.sky),
        borderRadius: BorderRadius.circular(T.rChip),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.home, size: 16, color: T.white),
        const SizedBox(width: T.sp8),
        Flexible(child: Text(
            l10n.t('SiPartner · ranking and ladder →',
                   'SiPartner · ranking y escalera →'),
            style: dataStyle(12, w: FontWeight.w600, color: T.sky))),
      ]),
    ));

  // ---------------------------------------------------------------------------
  // TARJETAS DE BARRAS — una sola metrica (dinero causado) = una sola familia
  // de color (cielo). El color sigue a la metrica, nunca al puesto en el
  // ranking: si FL adelanta a TX, ninguna barra debe cambiar de color.
  // ---------------------------------------------------------------------------
  Widget _barCard(String title, List<MapEntry<String, double>> rows,
      {double labelWidth = 56}) {
    // Guardarrail del NaN: con el portafolio vacio no hay `first` que tomar y
    // el maximo seria una division por cero al calcular la fraccion.
    final max = rows.isEmpty ? 0.0 : rows.first.value;
    return WhiteCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title),
        const SizedBox(height: T.sp8),
        if (rows.isEmpty)
          Text(l10n.t('No signed Loan Officers yet.',
                      'Aún no hay Loan Officers firmados.'),
              style: dataStyle(13, color: T.neutralText))
        else
          for (final e in rows) BarRow(
            label: e.key, value: e.value, max: max,
            valueText: money0.format(e.value), labelWidth: labelWidth),
      ]));
  }

  // ---------------------------------------------------------------------------
  // MIS LOAN OFFICERS — la grilla de caritas. La atenuacion por inactividad va
  // SOLO en la carita: el nombre y el dinero nunca se apagan.
  // ---------------------------------------------------------------------------
  Widget _losCard(List<LoanOfficer> signed) => WhiteCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionTitle(l10n.t('MY LOAN OFFICERS', 'MIS LOAN OFFICERS'),
          sub: l10n.t('sky dot = sending cases this month',
                      'punto cielo = enviando casos este mes')),
      const SizedBox(height: T.sp16),
      if (signed.isEmpty)
        Text(l10n.t('SiRadar is where they start.',
                    'SiRadar es donde empiezan.'),
            style: dataStyle(13, color: T.neutralText))
      else
        // Grilla de 3 columnas armada a mano con Expanded: un GridView con
        // aspect ratio fijo recorta el pie "sin casos este mes" de los
        // dormidos, que son justo las celdas mas altas.
        for (var i = 0; i < signed.length; i += 3) Padding(
          padding: const EdgeInsets.only(bottom: T.sp16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (var j = i; j < i + 3; j++) Expanded(
              child: j < signed.length
                  ? _loTile(signed[j])
                  : const SizedBox.shrink()),
          ]),
        ),
    ]));

  Widget _loTile(LoanOfficer lo) => InkWell(
    borderRadius: BorderRadius.circular(T.rChip),
    onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => LoPortfolioScreen(loId: lo.id))).then((_) => _refresh()),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: T.sp4),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: 52, height: 52,
          child: Stack(children: [
            Center(child: Opacity(
                opacity: lo.isActive ? 1.0 : .45,
                child: CaritaAvatar(spec: lo.avatar, size: 48))),
            // Punto cielo pegado al borde del marco: el pulso del LO.
            if (lo.isActive) const Positioned(
                top: 0, right: 0, child: ActivityDot(size: 10)),
          ]),
        ),
        const SizedBox(height: T.sp4),
        Text(lo.name.split(' ').first,
            textAlign: TextAlign.center, maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: dataStyle(11, w: FontWeight.w700, color: T.navy)),
        if (!lo.isActive) Text(
            l10n.t('no cases this month', 'sin casos este mes'),
            textAlign: TextAlign.center,
            style: dataStyle(10, color: T.neutralText, height: 1.2)),
      ]),
    ));
}
