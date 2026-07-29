// P34 · RANKING Y ESCALERA — standings de la red JoinSi AL CORTE + escalera de
// estatus SiPartner → SiFounder → SiBroker.
//
// Unica pantalla de toda la app donde se permiten los metales (T.bronze /
// T.silver / T.gold), y SOLO dentro de MedallaCasa: excepcion ratificada A0.
// Fuera de la medalla, la paleta es la de siempre (navy / cielo / amarillo).
//
// Encuadre honesto: esto NO es un feed en vivo. El negocio liquida cada 30 dias,
// asi que la tabla se enmarca como "corte del <fecha>" y no lleva "actualizado
// hace X" ni badges LIVE. Ninguna cifra en dolares se escribe a mano: todas
// salen de RankRow.earned / Store.
import 'package:flutter/material.dart';
import '../../core/tokens.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';
import '../../models/loan_officer.dart';
import '../../widgets/carita_avatar.dart';
import '../../widgets/common.dart';
import '../../widgets/medalla_casa.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});
  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  /// SiPartners reclutados por el usuario. Sin backend (Acta A0) la app todavia
  /// no rastrea reclutamiento, asi que el dato vive en UN solo sitio: el chip de
  /// requisito, el callout de lo que falta y el riel de progreso leen de aqui y
  /// por tanto no pueden contradecirse entre si.
  int get _recruits => 0;

  int get _losSigned => Store.portfolio().length;
  int get _missingLos => (LadderReq.siFounderLos - _losSigned).clamp(0, 999);
  int get _missingRecruits =>
      (LadderReq.siFounderRecruits - _recruits).clamp(0, 999);

  bool get _siFounderReached => _missingLos == 0 && _missingRecruits == 0;
  bool get _siBrokerReached => Store.closedTotal >= LadderReq.siBrokerClosed;

  /// Avance sobre el riel completo (bronce → plata → oro). Cada tramo vale la
  /// mitad. Hacia plata se promedian los DOS requisitos: mostrar solo el de LOs
  /// pintaria casi lleno un peldano que aun le falta el reclutamiento.
  double get _ladderProgress {
    final loF = (_losSigned / LadderReq.siFounderLos).clamp(0.0, 1.0);
    final reF = (_recruits / LadderReq.siFounderRecruits).clamp(0.0, 1.0);
    final silver = (loF + reF) / 2;
    if (silver < 1) return silver * .5;
    final goldF =
        (Store.closedTotal / LadderReq.siBrokerClosed).clamp(0.0, 1.0);
    return .5 + goldF * .5;
  }

  String get _levelLabel => _siBrokerReached
      ? l10n.t('GOLD', 'ORO')
      : _siFounderReached
          ? l10n.t('SILVER', 'PLATA')
          : l10n.t('BRONZE', 'BRONCE');

  @override
  Widget build(BuildContext context) {
    final rows = Store.ranking();
    final userRank = Store.userRank;

    return Scaffold(
      backgroundColor: T.white,
      appBar: AppBar(
        backgroundColor: T.navy,
        foregroundColor: T.white,
        title: Text(l10n.t('Ranking & ladder', 'Ranking y escalera'),
            style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(padding: const EdgeInsets.all(T.sp16), children: [
        _hero(),
        const SizedBox(height: T.sp16),

        // UNICO boton rojo de la pantalla. No es un adorno: abre la ruta.
        RedPill(
            label: l10n.t('START MY PATH TO SiFOUNDER',
                'EMPEZAR MI RUTA A SiFOUNDER'),
            onPressed: _showRuta),
        const SizedBox(height: T.sp32),

        SectionTitle(
          l10n.t('JOINSI NETWORK RANKING · ${cutLabel(Store.lastCutDate)} CUT',
              'RANKING RED JOINSI · CORTE DEL ${cutLabel(Store.lastCutDate)}'),
          sub: l10n.t(
              'the ranking refreshes on every pay cut · every '
                  '${Store.payPeriodDays} days',
              'el ranking se actualiza en cada corte de pago · cada '
                  '${Store.payPeriodDays} días'),
        ),
        const SizedBox(height: T.sp12),
        for (var i = 0; i < rows.length; i++) ...[
          // El empujon va JUSTO encima de la fila del usuario: leer el delta y
          // ver su propia fila en el mismo golpe de vista es lo que convierte
          // el ranking en una accion. Si va primero, no hay nadie arriba.
          if (rows[i].isUser && userRank > 1) _deltaCallout(userRank),
          _rankRow(rows[i], i + 1),
          const SizedBox(height: T.sp12),
        ],

        const SizedBox(height: T.sp16),
        SectionTitle(
          l10n.t('AVAILABLE SiBROKER TERRITORIES',
              'TERRITORIOS SiBROKER DISPONIBLES'),
          sub: l10n.t('states with no SiBroker assigned · claimed on reaching gold',
              'estados sin SiBroker asignado · se reclaman al llegar al oro'),
        ),
        const SizedBox(height: T.sp12),
        _territories(),
        const SizedBox(height: T.sp32),
      ]),
    );
  }

  // ===========================================================================
  // HEROE — ESCALERA DE ESTATUS
  // ===========================================================================

  Widget _hero() => HeroNavy(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Kicker(l10n.t('STATUS LADDER', 'ESCALERA DE ESTATUS'),
                    onNavy: true)),
            _skyChip(l10n.t('CURRENT LEVEL: $_levelLabel',
                'NIVEL ACTUAL: $_levelLabel')),
          ]),
          const SizedBox(height: T.sp24),
          _ladder(),
          const SizedBox(height: T.sp24),
          _faltaCallout(),
        ]),
      );

  /// Tres medallas conectadas por un riel de progreso CIELO. Nunca amarillo:
  /// el amarillo de esta app es dinero, y un peldano no es dinero.
  Widget _ladder() => LayoutBuilder(builder: (_, c) {
        const medal = 64.0;
        final third = c.maxWidth / 3;
        final inset = third / 2;               // centro de la primera columna
        final railW = c.maxWidth - inset * 2;  // de centro bronce a centro oro
        return Stack(clipBehavior: Clip.none, children: [
          Positioned(
            left: inset, top: medal / 2 - 3, width: railW,
            child: Container(height: 6,
                decoration: BoxDecoration(color: T.sky.withOpacity(.18),
                    borderRadius: BorderRadius.circular(999))),
          ),
          Positioned(
            left: inset, top: medal / 2 - 3,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: railW * _ladderProgress),
              duration: T.durSlow, curve: T.easeBrand,
              builder: (_, w, __) => Container(height: 6, width: w,
                  decoration: BoxDecoration(color: T.sky,
                      borderRadius: BorderRadius.circular(999))),
            ),
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _rung(
              metal: T.bronze, size: medal, name: 'SiPartner',
              reached: true, locked: false,
            )),
            Expanded(child: _rung(
              metal: T.silver, size: medal, name: 'SiFounder',
              reached: _siFounderReached, locked: false,
              chips: [
                _reqChip('$_losSigned/${LadderReq.siFounderLos} LOs',
                    on: _missingLos == 0),
                _reqChip(
                    '$_recruits/${LadderReq.siFounderRecruits} SiPartner',
                    on: _missingRecruits == 0),
              ],
            )),
            Expanded(child: _rung(
              metal: T.gold, size: medal, name: 'SiBroker',
              reached: _siBrokerReached, locked: !_siBrokerReached,
              chips: [
                _reqChip(
                    '${Store.closedTotal}/${LadderReq.siBrokerClosed} closed',
                    on: _siBrokerReached),
              ],
            )),
          ]),
        ]);
      });

  Widget _rung({required Color metal, required double size, required String name,
      required bool reached, required bool locked,
      List<Widget> chips = const []}) {
    // La atenuacion vive en la MEDALLA (igual que en las caritas), nunca en un
    // dato. Bloqueado = mas apagado que "en progreso", y lleva candado.
    final opacity = reached ? 1.0 : (locked ? .32 : .55);
    return Column(children: [
      SizedBox.square(
        dimension: size,
        child: Stack(alignment: Alignment.center, children: [
          Opacity(opacity: opacity, child: MedallaCasa(metal: metal, size: size)),
          if (locked) Icon(Icons.lock, size: size * .34, color: T.sky),
        ]),
      ),
      const SizedBox(height: T.sp8),
      if (reached) ...[
        _skyChip(l10n.t('REACHED', 'ALCANZADO')),
        const SizedBox(height: T.sp8),
      ],
      Text(name, textAlign: TextAlign.center,
          style: headlineOnNavy(13).copyWith(
              color: reached ? T.white : T.white.withOpacity(.72))),
      if (chips.isNotEmpty) ...[
        const SizedBox(height: T.sp8),
        for (final ch in chips) Padding(
            padding: const EdgeInsets.only(bottom: T.sp4), child: ch),
      ],
    ]);
  }

  /// Chip de estado sobre navy: cielo al 18% con borde y texto cielo.
  Widget _skyChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: T.sp8, vertical: T.sp4),
        decoration: BoxDecoration(
            color: T.sky.withOpacity(.18),
            border: Border.all(color: T.sky.withOpacity(.45)),
            borderRadius: BorderRadius.circular(999)),
        child: Text(text, style: dataStyle(10, w: FontWeight.w700, color: T.sky)
            .copyWith(letterSpacing: .6)),
      );

  /// Chip de requisito: el punto lleno = requisito cumplido.
  Widget _reqChip(String text, {required bool on}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: T.sp8, vertical: T.sp4),
        decoration: BoxDecoration(
            border: Border.all(color: T.sky.withOpacity(.30)),
            borderRadius: BorderRadius.circular(T.rChip)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: on ? T.sky : T.sky.withOpacity(.30))),
          const SizedBox(width: T.sp4),
          Flexible(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: dataStyle(10, w: FontWeight.w700, color: T.sky))),
        ]),
      );

  /// Lo que falta para el siguiente peldano, redactado con los datos reales.
  Widget _faltaCallout() {
    final base = dataStyle(12, w: FontWeight.w500, color: T.sky, height: 1.4);
    final strong = base.copyWith(color: T.white, fontWeight: FontWeight.w700);
    final spans = <TextSpan>[];

    if (!_siFounderReached) {
      spans.add(TextSpan(text: l10n.t('You need ', 'Te falta ')));
      if (_missingLos > 0) {
        spans.add(TextSpan(
            text: _missingLos == 1 ? '1 LO' : '$_missingLos LOs', style: strong));
      }
      if (_missingLos > 0 && _missingRecruits > 0) {
        spans.add(TextSpan(text: l10n.t(' and ', ' y ')));
      }
      if (_missingRecruits > 0) {
        spans.add(TextSpan(
            text: l10n.t(
                '$_missingRecruits recruited SiPartner',
                '$_missingRecruits SiPartner reclutado'),
            style: strong));
      }
      spans.add(TextSpan(
          text: l10n.t(' to reach the ', ' para alcanzar el rango ')));
      spans.add(TextSpan(text: l10n.t('Silver', 'Plata'), style: strong));
      spans.add(TextSpan(text: l10n.t(' rank.', '.')));
    } else if (!_siBrokerReached) {
      final left = LadderReq.siBrokerClosed - Store.closedTotal;
      spans.add(TextSpan(text: l10n.t('You need ', 'Te faltan ')));
      spans.add(TextSpan(text: '$left closed loans', style: strong));
      spans.add(TextSpan(
          text: l10n.t(' to reach the ', ' para alcanzar el rango ')));
      spans.add(TextSpan(text: l10n.t('Gold', 'Oro'), style: strong));
      spans.add(TextSpan(text: l10n.t(' rank.', '.')));
    } else {
      spans.add(TextSpan(
          text: l10n.t('You hold every rung of the ladder. Claim your territory.',
              'Tienes todos los peldaños de la escalera. Reclama tu territorio.'),
          style: strong));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(T.sp12),
      decoration: BoxDecoration(
          color: T.sky.withOpacity(.08),
          border: Border.all(color: T.sky.withOpacity(.20)),
          borderRadius: BorderRadius.circular(T.rChip)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.info_outline, size: 18, color: T.sky),
        const SizedBox(width: T.sp8),
        Expanded(child: Text.rich(TextSpan(style: base, children: spans))),
      ]),
    );
  }

  /// El boton rojo abre la ruta concreta — con las cifras reales del usuario.
  void _showRuta() {
    final left = (LadderReq.siBrokerClosed - Store.closedTotal).clamp(0, 999);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: T.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(T.rBig)),
        title: Text(l10n.t('Your path to SiFounder', 'Tu ruta a SiFounder'),
            style: const TextStyle(fontWeight: FontWeight.w800, color: T.navy)),
        content: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
          _paso('1', l10n.t(
              'Sign $_missingLos more Loan Officer(s): you are at $_losSigned '
                  'of ${LadderReq.siFounderLos}.',
              'Firma $_missingLos Loan Officer(s) más: vas en $_losSigned '
                  'de ${LadderReq.siFounderLos}.')),
          _paso('2', l10n.t(
              'Recruit $_missingRecruits SiPartner into the network — that is '
                  'the rung nobody skips.',
              'Recluta $_missingRecruits SiPartner a la red — ese es el peldaño '
                  'que nadie se salta.')),
          _paso('3', l10n.t(
              'Then SiBroker: $left closed loans away, and the territory is '
                  'yours before somebody else claims it.',
              'Después SiBroker: a $left closed loans, y el territorio es tuyo '
                  'antes de que alguien más lo reclame.')),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.t('Later', 'Después'),
                  style: const TextStyle(color: T.neutralText))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: T.navy,
                content: Text(l10n.t(
                    'Path started. Your next Loan Officer is waiting in SiRadar.',
                    'Ruta iniciada. Tu próximo Loan Officer te espera en SiRadar.'),
                    style: const TextStyle(color: T.white))));
            },
            child: Text(l10n.t('LET\'S GO', 'VAMOS')),
          ),
        ],
      ),
    );
  }

  Widget _paso(String n, String text) => Padding(
        padding: const EdgeInsets.only(bottom: T.sp12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 22, height: 22, alignment: Alignment.center,
            decoration: const BoxDecoration(color: T.navy, shape: BoxShape.circle),
            child: Text(n, style: dataStyle(11, w: FontWeight.w800, color: T.white)),
          ),
          const SizedBox(width: T.sp8),
          Expanded(child: Text(text,
              style: dataStyle(13, w: FontWeight.w400, height: 1.5))),
        ]),
      );

  // ===========================================================================
  // RANKING
  // ===========================================================================

  Widget _rankRow(RankRow r, int pos) {
    final name = r.isUser ? l10n.t('YOU', 'TÚ') : r.name;
    final sub = l10n.t(
        '${r.los} LOs · ${r.closed} closed · ${r.states} states',
        '${r.los} LOs · ${r.closed} closed · ${r.states} estados');

    final content = Row(children: [
      SizedBox(width: 20, child: Text('$pos', textAlign: TextAlign.center,
          style: dataStyle(20, w: FontWeight.w800,
              color: r.isUser ? T.navy : T.neutralText))),
      const SizedBox(width: T.sp8),
      SizedBox.square(
        dimension: 52,
        child: Stack(clipBehavior: Clip.none, children: [
          // La red dormida se atenua AQUI, en la carita — nunca en el dinero.
          Positioned(left: 0, top: 2, child: Opacity(
              opacity: r.networkActive ? 1.0 : .45,
              child: CaritaAvatar(spec: r.avatar, size: 48))),
          // Los metales solo aparecen dentro de MedallaCasa (excepcion A0).
          if (r.isSiFounder) const Positioned(
              left: 34, bottom: 0, child: MedallaCasa(metal: T.silver, size: 18)),
          if (r.networkActive) const Positioned(
              right: 0, top: 0, child: ActivityDot(size: 9)),
        ]),
      ),
      const SizedBox(width: T.sp8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Flexible(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: dataStyle(15, w: FontWeight.w700, color: T.navy))),
          if (r.isUser) ...[
            const SizedBox(width: T.sp8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: T.sp8, vertical: 2),
              decoration: BoxDecoration(color: T.yellow,
                  borderRadius: BorderRadius.circular(T.rChip)),
              child: Text(l10n.t('YOU', 'TÚ'), style: dataStyle(10,
                  w: FontWeight.w800, color: T.navy).copyWith(letterSpacing: .8)),
            ),
          ],
        ]),
        const SizedBox(height: 2),
        Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: dataStyle(11, color: T.neutralText)),
      ])),
      const SizedBox(width: T.sp8),
      // Toda cifra de dinero va navy+amarillo, incluida la de una red dormida.
      MoneyPill(amount: r.earned, size: 14),
    ]);

    if (!r.isUser) return WhiteCard(child: content);
    return Container(
      padding: const EdgeInsets.all(T.sp16),
      decoration: BoxDecoration(
          color: T.sky.withOpacity(.22),
          border: Border.all(color: T.navy),
          borderRadius: BorderRadius.circular(T.rCard),
          boxShadow: T.shadowMd),
      child: content,
    );
  }

  Widget _deltaCallout(int userRank) => Padding(
        padding: const EdgeInsets.only(bottom: T.sp8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.arrow_upward, size: 16, color: T.navy),
          const SizedBox(width: T.sp4),
          Flexible(child: Text.rich(
            TextSpan(
              style: dataStyle(12, w: FontWeight.w700, color: T.navy),
              children: [
                TextSpan(text: l10n.t('At ', 'A ')),
                TextSpan(text: money0.format(Store.deltaToNextRank),
                    style: moneyOnLight(13)),
                TextSpan(text: l10n.t(
                    ' from spot ${userRank - 1} — one new LO moves you up',
                    ' del puesto ${userRank - 1} — un LO nuevo te sube')),
              ],
            ),
            textAlign: TextAlign.center,
          )),
        ]),
      );

  // ===========================================================================
  // TERRITORIOS
  // ===========================================================================

  Widget _territories() {
    final list = Store.territories;
    return SizedBox(
      height: 176,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(width: T.sp12),
        itemBuilder: (_, i) => _territoryCard(list[i]),
      ),
    );
  }

  Widget _territoryCard(Territory t) {
    final free = t.isAvailable;
    return SizedBox(
      width: 156,
      child: WhiteCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 60,
              child: Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: 56, height: 56, alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: free ? T.sky.withOpacity(.25) : T.competitorGray,
                      border: Border.all(
                          color: free ? T.navy.withOpacity(.20) : T.hairline)),
                  child: Text(t.code, style: headlineOnNavy(18).copyWith(
                      color: free ? T.navy : T.neutralText)),
                ),
                // Oro solo dentro de MedallaCasa: el territorio ya es de un
                // SiBroker, y esa es exactamente la escasez que da urgencia.
                if (!free) const Positioned(
                    right: 0, bottom: 0,
                    child: MedallaCasa(metal: T.gold, size: 22)),
              ]),
            ),
            const SizedBox(height: T.sp8),
            Text(t.name, textAlign: TextAlign.center, maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: dataStyle(13, w: FontWeight.w700,
                    color: free ? T.navy : T.neutralText)),
            const SizedBox(height: T.sp8),
            if (free)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: T.sp8, vertical: T.sp4),
                decoration: BoxDecoration(color: T.navy,
                    borderRadius: BorderRadius.circular(999)),
                child: Text(l10n.t('AVAILABLE', 'DISPONIBLE'),
                    style: dataStyle(10, w: FontWeight.w700, color: T.sky)
                        .copyWith(letterSpacing: .6)),
              )
            else
              Text(
                  l10n.t('claimed by ${t.claimedBy} · SiBroker',
                      'reclamado por ${t.claimedBy} · SiBroker'),
                  textAlign: TextAlign.center, maxLines: 2,
                  style: dataStyle(10, color: T.neutralText, height: 1.3)),
          ],
        ),
      ),
    );
  }
}
