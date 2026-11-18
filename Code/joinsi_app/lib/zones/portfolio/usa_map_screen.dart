// P30 · MAPA USA VIVO — el corazon de SiPortfolio y la unica pantalla full-navy
// de la app. Mapa navy (modo oscuro P1B) con las CARITAS de cada Loan Officer
// pineadas sobre su estado real. Tap en carita -> mini-card blanca flotante.
// Tap en estado -> ficha del estado. Pinch/drag libres; las caritas mantienen
// tamaño constante al hacer zoom.
//
// SOBRE LA REFERENCIA DE STITCH: el HTML alucino el mapa (imagen remota con
// texto ajeno y caritas posicionadas con porcentajes arbitrarios). De el se
// honra SOLO la composicion: fila de filtros sobre navy, chip de leyenda
// flotante, mini-card blanca sobre el mapa y barra de stats al pie. La
// geometria real es AlbersUSA (kStatePolygons/kStateCentroids) pintada por
// _UsaPainter.
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show mapEquals;
import '../../core/tokens.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';
import '../../data/usa_map_data.dart';
import '../../models/loan_officer.dart';
import '../../widgets/carita_avatar.dart';
import '../../widgets/avatar_picker.dart';
import '../../widgets/common.dart';
import 'lo_portfolio_screen.dart';

class UsaMapScreen extends StatefulWidget {
  const UsaMapScreen({super.key});
  @override
  State<UsaMapScreen> createState() => _UsaMapScreenState();
}

class _UsaMapScreenState extends State<UsaMapScreen> {
  final _tc = TransformationController();
  List<LoanOfficer> _all = [];
  Tier? _tier;
  String? _program, _coast;
  bool _onlySigned = true;     // el mapa es de PORTAFOLIO: firmados por defecto
  bool _onlyActive = false;    // "enviando casos" — el pulso del periodo
  String? _selectedState;
  String? _tappedId;           // por ID, no por instancia: el objeto se recarga
  double _zoom = 1;

  @override
  void initState() {
    super.initState();
    _all = Store.los();
    _tc.addListener(_onZoom);
  }

  @override
  void dispose() {
    _tc.removeListener(_onZoom);
    _tc.dispose();
    super.dispose();
  }

  void _onZoom() {
    final z = _tc.value.getMaxScaleOnAxis();
    if ((z - _zoom).abs() > 0.02) setState(() => _zoom = z);
  }

  void _reload() {
    if (mounted) setState(() => _all = Store.los());
  }

  /// Resuelto por ID contra la lista viva Y contra los filtros: si el LO deja
  /// de pasar el filtro, su mini-card no puede quedarse flotando sobre un mapa
  /// que ya no lo contiene.
  LoanOfficer? get _tapped {
    if (_tappedId == null) return null;
    for (final l in _all) {
      if (l.id == _tappedId) return _passes(l) ? l : null;
    }
    return null;
  }

  bool _passes(LoanOfficer l) {
    if (_onlySigned && l.stage != Stage.signed) return false;
    if (_onlyActive && !l.isActive) return false;
    if (_tier != null && l.tier != _tier) return false;
    if (_program != null && l.program != _program) return false;
    if (_coast != null && l.coast != _coast) return false;
    return true;
  }

  List<LoanOfficer> get _filtered => _all.where(_passes).toList();

  /// Cuantos LOs quedarian si ademas se activara este filtro. Sirve para que
  /// ningun chip lleve a un mapa vacio a ciegas.
  int _countIf({Tier? tier, String? coast, String? program,
      bool? signed, bool? active}) =>
      _all.where((l) {
        final s = signed ?? _onlySigned;
        final a = active ?? _onlyActive;
        if (s && l.stage != Stage.signed) return false;
        if (a && !l.isActive) return false;
        if ((tier ?? _tier) != null && l.tier != (tier ?? _tier)) return false;
        if ((coast ?? _coast) != null && l.coast != (coast ?? _coast)) return false;
        if ((program ?? _program) != null &&
            l.program != (program ?? _program)) return false;
        return true;
      }).length;

  Map<String, List<LoanOfficer>> get _byState {
    final m = <String, List<LoanOfficer>>{};
    for (final lo in _filtered) {
      (m[lo.state] ??= []).add(lo);
    }
    return m;
  }

  bool get _anyFilter => _tier != null || _program != null || _coast != null ||
      _onlyActive || !_onlySigned;

  void _clearFilters() => setState(() {
    _tier = null; _program = null; _coast = null;
    _onlySigned = true; _onlyActive = false;
  });

  @override
  Widget build(BuildContext context) {
    final byState = _byState;
    final list = _filtered;
    final tapped = _tapped;
    return Scaffold(
      backgroundColor: T.navy,
      appBar: AppBar(
        backgroundColor: T.navy, foregroundColor: T.white, elevation: 0,
        title: Text(l10n.t('My USA map', 'Mi mapa USA'),
            style: headlineOnNavy(20)),
        actions: [
          IconButton(
            tooltip: l10n.t('Reset view', 'Reiniciar vista'),
            onPressed: () => setState(() {
              _tc.value = Matrix4.identity();
              _selectedState = null; _tappedId = null;
            }),
            icon: const Icon(Icons.refresh, color: T.sky)),
        ],
      ),
      body: Column(children: [
        _filterBar(),
        Expanded(child: Stack(children: [
          Positioned.fill(child: _map(byState)),
          if (list.isEmpty) Positioned.fill(child: _emptyState()),
          if (list.isNotEmpty) _legendKey(),
          if (tapped != null)
            Positioned(left: T.sp16, right: T.sp16, bottom: T.sp16,
                child: _miniCard(tapped)),
          if (tapped == null && _selectedState != null)
            Positioned(left: T.sp16, right: T.sp16, bottom: T.sp16,
                child: _stateCard(_selectedState!, byState[_selectedState] ?? [])),
        ])),
        _totals(list),
      ]),
    );
  }

  // ---------------------------------------------------------------- filtros
  /// Fila horizontal scrolleable sobre navy. Activo = relleno amarillo con
  /// texto navy; inactivo = contorno cielo con texto cielo. Ningun chip lleva
  /// rojo: el unico accionable rojo de la pantalla es el link "Abrir 360°".
  Widget _filterBar() => Container(
    color: T.navy,
    padding: const EdgeInsets.fromLTRB(T.sp16, 0, T.sp16, T.sp12),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        if (_anyFilter) ...[
          _clearChip(),
          const SizedBox(width: T.sp8),
        ],
        _chip(l10n.t('Signed only', 'Solo firmados'), _onlySigned,
            () => setState(() => _onlySigned = !_onlySigned),
            // Como todos los demas: el conteo es el de ACTIVARSE, y null si ya
            // esta activo. Antes mostraba "24" al lado de un pie que decia 7.
            count: _onlySigned ? null : _countIf(signed: true)),
        const SizedBox(width: T.sp8),
        _chip(l10n.t('Sending cases', 'Enviando casos'), _onlyActive,
            () => setState(() => _onlyActive = !_onlyActive),
            count: _onlyActive ? null : _countIf(active: true)),
        const SizedBox(width: T.sp8),
        for (final t in Tier.values)
          Padding(padding: const EdgeInsets.only(right: T.sp8),
            child: _chip(tierLabel(t), _tier == t,
                () => setState(() => _tier = _tier == t ? null : t),
                count: _tier == t ? null : _countIf(tier: t))),
        for (final c in ['West', 'Central', 'East'])
          Padding(padding: const EdgeInsets.only(right: T.sp8),
            child: _chip(c, _coast == c,
                () => setState(() => _coast = _coast == c ? null : c),
                count: _coast == c ? null : _countIf(coast: c))),
        for (final p in kPrograms)
          Padding(padding: const EdgeInsets.only(right: T.sp8),
            child: _chip(p, _program == p,
                () => setState(() => _program = _program == p ? null : p),
                count: _program == p ? null : _countIf(program: p))),
      ]),
    ),
  );

  Widget _chip(String label, bool on, VoidCallback onTap, {int? count}) {
    final dead = !on && count == 0;   // llevaria a un mapa vacio
    final fg = on ? T.navy : (dead ? T.sky.withValues(alpha: .40) : T.sky);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: T.durFast, curve: T.easeBrand,
        padding: const EdgeInsets.symmetric(horizontal: T.sp16, vertical: T.sp8),
        decoration: BoxDecoration(
          color: on ? T.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(T.rChip),
          border: Border.all(width: 1,
              color: on ? T.yellow : T.sky.withValues(alpha: dead ? .20 : .45)),
        ),
        child: Text(count == null ? label : '$label · $count',
            style: dataStyle(12, w: FontWeight.w700, color: fg)),
      ),
    );
  }

  /// LIMPIAR: no es un filtro, es la salida. Contorno blanco para no competir
  /// con los chips cielo — y sin rojo, que aqui esta reservado al 360°.
  Widget _clearChip() => GestureDetector(
    onTap: _clearFilters,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: T.sp12, vertical: T.sp8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(T.rChip),
        border: Border.all(color: T.white, width: 1)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.close, size: 12, color: T.white),
        const SizedBox(width: T.sp4),
        Text(l10n.t('CLEAR', 'LIMPIAR'),
            style: dataStyle(12, w: FontWeight.w700, color: T.white)
                .copyWith(letterSpacing: .8)),
      ]),
    ),
  );

  // -------------------------------------------------------------------- mapa
  Widget _map(Map<String, List<LoanOfficer>> byState) => LayoutBuilder(
    builder: (context, box) {
      // Escala para encajar el lienzo 975x610 dentro del area disponible.
      final s = math.min(box.maxWidth / kUsaMapW, box.maxHeight / kUsaMapH);
      final w = kUsaMapW * s, h = kUsaMapH * s;
      return InteractiveViewer(
        transformationController: _tc,
        minScale: 1, maxScale: 6, boundaryMargin: const EdgeInsets.all(T.sp48),
        child: Center(
          child: SizedBox(
            width: w, height: h,
            child: Stack(clipBehavior: Clip.none, children: [
              Positioned.fill(child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (d) {
                  final code = _hitState(Offset(d.localPosition.dx / s,
                      d.localPosition.dy / s));
                  setState(() { _selectedState = code; _tappedId = null; });
                },
                child: CustomPaint(
                  painter: _UsaPainter(
                    scale: s,
                    counts: {for (final e in byState.entries) e.key: e.value.length},
                    selected: _selectedState),
                ),
              )),
              for (final entry in byState.entries)
                ..._pins(entry.key, entry.value, s),
            ]),
          ),
        ),
      );
    },
  );

  /// Caritas en abanico alrededor del centroide del estado (para que 4 LOs en
  /// TX no se pisen). Contra-escaladas: al hacer zoom el mapa crece, la carita
  /// no — y el abanico se aprieta para seguir cabiendo dentro del estado.
  List<Widget> _pins(String state, List<LoanOfficer> los, double s) {
    final c = kStateCentroids[state];
    if (c == null) return const <Widget>[];
    final n = los.length;
    // Radio en unidades de PANTALLA (por eso se divide por el zoom): con el pin
    // real de 44px, 15+2.5n dejaba 40px entre vecinos y se solapaban.
    final radius = n == 1 ? 0.0 : (20.0 + n * 3.0) / _zoom;
    final out = <Widget>[];
    for (var i = 0; i < n; i++) {
      final a = -math.pi / 2 + (2 * math.pi * i / n);
      final dx = c[0] * s + (n == 1 ? 0.0 : radius * math.cos(a));
      final dy = c[1] * s + (n == 1 ? 0.0 : radius * math.sin(a));
      out.add(_pin(state, los[i], dx, dy));
    }
    return out;
  }

  static const double _pinSize = 36;
  /// La carita CON aro mide 36 + sp8 = 44: ese es el tamaño natural del pin.
  static const double _pinBox = _pinSize + T.sp8;

  /// Carita enmarcada: anillo cielo con halo si el LO esta enviando casos,
  /// anillo gris y carita atenuada si lleva el mes dormido. La atenuacion vive
  /// SIEMPRE en la carita — nunca en el badge ni en una cifra de dinero.
  Widget _framedFace(LoanOfficer lo, double size) => Container(
    width: size + T.sp8, height: size + T.sp8,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle, color: T.white,
      border: Border.all(color: lo.isActive ? T.sky : T.neutralText, width: 2),
      boxShadow: lo.isActive
          ? [BoxShadow(color: T.sky.withValues(alpha: .40),
              blurRadius: 15, spreadRadius: 4)]
          : T.shadowSm,
    ),
    child: Opacity(
      opacity: lo.isActive ? 1 : .6,
      child: CaritaAvatar(spec: lo.avatar, size: size)),
  );

  /// Badge de closed loans: circulo amarillo con la cifra en navy. Es el unico
  /// numero que el mapa canta sin abrir nada.
  Widget _closedBadge(int n) => Container(
    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: T.sp4),
    decoration: BoxDecoration(color: T.yellow,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: T.navy, width: 1)),
    child: Text('$n', style: dataStyle(11, w: FontWeight.w800, color: T.navy)),
  );

  Widget _pin(String state, LoanOfficer lo, double dx, double dy) {
    final isTapped = _tappedId == lo.id;
    final k = 1 / _zoom;                       // tamaño constante en pantalla
    final box = _pinBox * k;                   // caja en unidades del lienzo
    return Positioned(
      left: dx - box / 2, top: dy - box / 2,
      width: box, height: box,
      // FittedBox, no Transform.scale a secas: Positioned con width/height
      // entrega constraints TIGHT y RenderProxyBox las propaga intactas, asi
      // que la carita se encogia a `box` Y ADEMAS el Transform la encogia otra
      // vez -> el pin salia a 36/zoom px. FittedBox mide al hijo SIN
      // constraints (44) y lo escala a la caja: constante en pantalla, de
      // verdad. Bonus: su hit-test respeta los bounds.
      child: FittedBox(
        fit: BoxFit.contain,
        child: Transform.scale(
          scale: isTapped ? 1.35 : 1.0,
          child: Tooltip(
            message: '${lo.name} · ${lo.city}, ${lo.state}'
                '${lo.closedTotal > 0 ? ' · ${lo.closedTotal} closed loans' : ''}',
            child: GestureDetector(
              onTap: () => setState(() {
                _tappedId = isTapped ? null : lo.id;
                _selectedState = state;
              }),
              child: Stack(clipBehavior: Clip.none, children: [
                _framedFace(lo, _pinSize),
                if (lo.closedTotal > 0)
                  Positioned(right: -4, bottom: -4,
                      child: _closedBadge(lo.closedTotal)),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  String? _hitState(Offset p) {
    for (final e in kStatePolygons.entries) {
      for (final ring in e.value) {
        if (_pointInRing(p, ring)) return e.key;
      }
    }
    return null;
  }

  bool _pointInRing(Offset p, List<double> flat) {
    var inside = false;
    final n = flat.length ~/ 2;
    for (var i = 0, j = n - 1; i < n; j = i++) {
      final xi = flat[i * 2], yi = flat[i * 2 + 1];
      final xj = flat[j * 2], yj = flat[j * 2 + 1];
      if ((yi > p.dy) != (yj > p.dy) &&
          p.dx < (xj - xi) * (p.dy - yi) / (yj - yi) + xi) {
        inside = !inside;
      }
    }
    return inside;
  }

  // ------------------------------------------------------------- clave/vacio
  /// Clave de lectura del mapa. Sin esto el badge amarillo y el halo cielo son
  /// decoracion; con esto son datos. Dos lineas, cielo 11, sobre navy
  /// translucido — exactamente la composicion aprobada.
  Widget _legendKey() => Positioned(
    left: T.sp16, top: T.sp8,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: T.sp12, vertical: T.sp8),
      decoration: BoxDecoration(
        color: T.vizDarkSurface.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(T.rChip),
        border: Border.all(color: T.sky.withValues(alpha: .30))),
      child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(
              color: T.yellow, borderRadius: BorderRadius.circular(999),
              border: Border.all(color: T.navy, width: 1))),
          const SizedBox(width: T.sp4),
          Text(l10n.t('badge = closed loans', 'badge = closed loans'),
              style: dataStyle(11, w: FontWeight.w500, color: T.sky, height: 1.2)),
        ]),
        const SizedBox(height: T.sp4),
        Row(mainAxisSize: MainAxisSize.min, children: [
          const ActivityDot(size: 6),
          const SizedBox(width: T.sp8),
          Text(l10n.t('sky glow = sending cases this month',
                       'brillo cielo = enviando casos este mes'),
              style: dataStyle(11, w: FontWeight.w500, color: T.sky, height: 1.2)),
        ]),
      ]),
    ),
  );

  Widget _emptyState() => Container(
    color: T.navy.withValues(alpha: .82),
    alignment: Alignment.center,
    padding: const EdgeInsets.all(T.sp32),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(l10n.t('Nothing out here with those filters.',
          'Nada por aquí con esos filtros.'),
          textAlign: TextAlign.center, style: headlineOnNavy(18)),
      const SizedBox(height: T.sp8),
      Text(l10n.t('Drop one and the map comes back.',
          'Quita uno y el mapa vuelve.'),
          textAlign: TextAlign.center,
          style: dataStyle(13, color: T.sky)),
      const SizedBox(height: T.sp24),
      RedPill(label: l10n.t('CLEAR FILTERS', 'LIMPIAR FILTROS'),
          onPressed: _clearFilters, expand: false),
    ]),
  );

  // ------------------------------------------------------------------ cards
  /// Mini-card blanca flotante sobre el mapa (radio 16). Es el unico lienzo
  /// claro de la pantalla: aqui el dinero va en pildora navy, no en amarillo
  /// suelto, y el 360° es el unico rojo.
  Widget _miniCard(LoanOfficer lo) => WhiteCard(
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: () => showAvatarPicker(context, lo, onSaved: _reload),
        child: Stack(clipBehavior: Clip.none, children: [
          _framedFace(lo, 56),
          Positioned(right: -2, bottom: -2, child: Container(
            padding: const EdgeInsets.all(T.sp4),
            decoration: const BoxDecoration(color: T.navy, shape: BoxShape.circle),
            child: const Icon(Icons.edit, size: 12, color: T.white))),
        ]),
      ),
      const SizedBox(width: T.sp16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, children: [
            Text(lo.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: dataStyle(16, w: FontWeight.w800, height: 1.2)),
            const SizedBox(height: 2),
            Text('${lo.city}, ${lo.state} · NMLS ${lo.nmls}',
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: dataStyle(12, color: T.neutralText, height: 1.2)),
          ])),
          const SizedBox(width: T.sp8),
          GestureDetector(
            onTap: () => setState(() => _tappedId = null),
            child: const Padding(padding: EdgeInsets.only(left: T.sp4),
                child: Icon(Icons.close, size: 16, color: T.neutralText))),
        ]),
        const SizedBox(height: T.sp8),
        Wrap(spacing: T.sp8, runSpacing: T.sp4, children: [
          TierChip(tier: lo.tier),
          DataChip(lo.program),
          ActivityChip(active: lo.isActive),
        ]),
        const SizedBox(height: T.sp8),
        Text('${lo.leads} leads · ${lo.preApprovals} pre-approvals · '
             '${lo.ratified} ratified · ${lo.closedTotal} closed',
            style: dataStyle(11, color: T.neutralText, height: 1.3)),
        const SizedBox(height: T.sp12),
        Row(children: [
          MoneyPill(amount: lo.earned, size: 14),
          const SizedBox(width: T.sp8),
          Text(l10n.t('month ${lo.monthOf12}/12', 'mes ${lo.monthOf12}/12'),
              style: dataStyle(11, color: T.neutralText)),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => LoPortfolioScreen(loId: lo.id)))
                    .then((_) => _reload()),
            child: Text(l10n.t('Open 360°', 'Abrir 360°'),
                style: dataStyle(12, w: FontWeight.w800, color: T.red)),
          ),
        ]),
      ])),
    ]),
  );

  Widget _stateCard(String code, List<LoanOfficer> los) => WhiteCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Text(code, style: sectionTitleStyle()),
        const SizedBox(width: T.sp8),
        Expanded(child: Text('${los.length} Loan Officers',
            style: dataStyle(12, color: T.neutralText))),
        if (los.isNotEmpty)
          MoneyPill(amount: los.fold<double>(0, (s, l) => s + l.earned), size: 14),
        GestureDetector(
          onTap: () => setState(() => _selectedState = null),
          child: const Padding(padding: EdgeInsets.only(left: T.sp8),
              child: Icon(Icons.close, size: 16, color: T.neutralText))),
      ]),
      const SizedBox(height: T.sp8),
      if (los.isEmpty)
        Text(l10n.t('No Loan Officers here yet — territory available.',
            'Aún no hay Loan Officers aquí — territorio disponible.'),
            style: dataStyle(13, color: T.neutralText))
      else
        SizedBox(height: 84, child: ListView.separated(
          scrollDirection: Axis.horizontal, itemCount: los.length,
          separatorBuilder: (_, __) => const SizedBox(width: T.sp16),
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => setState(() => _tappedId = los[i].id),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CaritaAvatar(spec: los[i].avatar, size: 48),
              const SizedBox(height: T.sp4),
              SizedBox(width: 64, child: Text(los[i].name.split(' ').first,
                  textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                  style: dataStyle(11, w: FontWeight.w700))),
            ]),
          ),
        )),
    ]),
  );

  // ----------------------------------------------------------------- totales
  /// Barra fijada al pie, navy ligeramente mas claro. Las cuatro cifras se
  /// derivan de lo que el mapa esta mostrando AHORA: con el filtro por defecto
  /// (solo firmados) coinciden exactamente con Store.activeCount /
  /// Store.statesCount / Store.closedTotal / Store.earnedYear, y al filtrar
  /// siguen contando el mapa que el usuario tiene delante — un pie que dice 61
  /// closed loans sobre un mapa con 2 caritas es lo primero que delata la demo.
  Widget _totals(List<LoanOfficer> list) {
    final active = list.where((l) => l.isActive).length;
    final states = list.map((e) => e.state).toSet().length;
    final closed = list.fold<int>(0, (s, l) => s + l.closedTotal);
    final earned = list.fold<double>(0, (s, l) => s + l.earned);
    return Container(
      width: double.infinity,
      color: T.vizDarkSurface,
      padding: EdgeInsets.fromLTRB(T.sp16, T.sp12, T.sp16,
          T.sp12 + MediaQuery.of(context).padding.bottom),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _statCell(
          kicker: l10n.t('$active of ${list.length} active',
                         '$active de ${list.length} activos'),
          value: '$states',
          unit: l10n.t('states', 'estados'))),
        const SizedBox(width: T.sp16),
        Expanded(child: _statCell(
          kicker: '$closed closed loans',
          value: money0.format(earned),
          unit: l10n.t('earned', 'ganado'),
          money: true)),
      ]),
    );
  }

  Widget _statCell({required String kicker, required String value,
      required String unit, bool money = false}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Kicker(kicker, onNavy: true),
      const SizedBox(height: T.sp4),
      FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
        child: Row(crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic, children: [
          // Sin SizedBox de por medio: un widget sin baseline dentro de una Row
          // alineada por baseline cae al tope de la caja y descuadra la linea.
          Text(value, style: money ? moneyStyle(18) : headlineOnNavy(18)),
          Padding(padding: const EdgeInsets.only(left: T.sp4),
              child: Text(unit,
                  style: dataStyle(12, w: FontWeight.w600, color: T.sky))),
        ])),
    ]);
}

/// Pinta los 51 estados. Densidad de portafolio = tono del relleno (secuencial
/// de la paleta viz oscura, nunca rainbow). Seleccion = trazo amarillo — el rojo
/// es marca/CTA, no geografia, y al 35% sobre navy no se leia (1.46:1).
class _UsaPainter extends CustomPainter {
  final double scale;
  final Map<String, int> counts;
  final String? selected;
  _UsaPainter({required this.scale, required this.counts, this.selected});

  @override
  void paint(Canvas canvas, Size size) {
    final maxCount = counts.values.fold<int>(1, (a, b) => a > b ? a : b);
    final stroke = Paint()..color = T.mapEdge..style = PaintingStyle.stroke
      ..strokeWidth = 1..strokeJoin = StrokeJoin.round;
    final selStroke = Paint()..color = T.yellow..style = PaintingStyle.stroke
      ..strokeWidth = 2..strokeJoin = StrokeJoin.round;

    Path? selPath;
    for (final e in kStatePolygons.entries) {
      final n = counts[e.key] ?? 0;
      final path = Path();
      for (final ring in e.value) {
        for (var i = 0; i < ring.length; i += 2) {
          final x = ring[i] * scale, y = ring[i + 1] * scale;
          i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
        }
        path.close();
      }
      final fill = n == 0
          ? T.mapLand
          : Color.lerp(T.mapLand, T.s1d, (n / maxCount).clamp(0.35, 1.0))!;
      canvas.drawPath(path, Paint()..color = fill);
      canvas.drawPath(path, stroke);
      if (e.key == selected) selPath = path;
    }
    // El seleccionado se traza al final para que no lo tape ningun vecino.
    if (selPath != null) canvas.drawPath(selPath, selStroke);
  }

  @override
  bool shouldRepaint(_UsaPainter old) =>
      old.scale != scale || old.selected != selected ||
      !mapEquals(old.counts, counts);
}
