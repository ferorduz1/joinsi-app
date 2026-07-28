// P30 · MAPA USA VIVO — el corazon de SiPortfolio.
// Mapa navy (modo oscuro P1B) con las CARITAS de cada Loan Officer sobre su
// estado. Tap en carita -> mini-card. Tap en estado -> lista del estado.
// Pinch/drag libres; las caritas mantienen tamaño constante al hacer zoom.
// Filtros: signed · tier · coast · program, cada uno con su conteo.
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show mapEquals;
import 'package:intl/intl.dart';
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
    if (_tier != null && l.tier != _tier) return false;
    if (_program != null && l.program != _program) return false;
    if (_coast != null && l.coast != _coast) return false;
    return true;
  }

  List<LoanOfficer> get _filtered => _all.where(_passes).toList();

  /// Cuantos LOs quedarian si ademas se activara este filtro. Sirve para que
  /// ningun chip lleve a un mapa vacio a ciegas.
  int _countIf({Tier? tier, String? coast, String? program, bool? signed}) =>
      _all.where((l) {
        final s = signed ?? _onlySigned;
        if (s && l.stage != Stage.signed) return false;
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

  bool get _anyFilter =>
      _tier != null || _program != null || _coast != null || !_onlySigned;

  void _clearFilters() => setState(() {
    _tier = null; _program = null; _coast = null; _onlySigned = true;
  });

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    final byState = _byState;
    final list = _filtered;
    final tapped = _tapped;
    return Scaffold(
      backgroundColor: T.navy,
      appBar: AppBar(
        backgroundColor: T.navy, foregroundColor: T.white, elevation: 0,
        title: Text(l10n.t('My USA map', 'Mi mapa USA'),
            style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: l10n.t('Reset view', 'Reiniciar vista'),
            onPressed: () => setState(() {
              _tc.value = Matrix4.identity();
              _selectedState = null; _tappedId = null;
            }),
            icon: const Icon(Icons.zoom_out_map, color: T.sky)),
        ],
      ),
      body: Column(children: [
        _filterBar(),
        Expanded(child: Stack(children: [
          Positioned.fill(child: _map(byState)),
          if (list.isEmpty) Positioned.fill(child: _emptyState()),
          _legendKey(),
          if (tapped != null)
            Positioned(left: T.sp16, right: T.sp16, bottom: T.sp16,
                child: _miniCard(tapped, money)),
          if (tapped == null && _selectedState != null)
            Positioned(left: T.sp16, right: T.sp16, bottom: T.sp16,
                child: _stateCard(_selectedState!, byState[_selectedState] ?? [], money)),
        ])),
        _totals(list, money),
      ]),
    );
  }

  // ---------------------------------------------------------------- filtros
  Widget _filterBar() => Container(
    color: T.navy,
    padding: const EdgeInsets.fromLTRB(T.sp12, 0, T.sp12, T.sp8),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        if (_anyFilter) ...[
          _chip(l10n.t('CLEAR', 'LIMPIAR'), false, _clearFilters, accent: true),
          const SizedBox(width: T.sp16),
        ],
        _chip(l10n.t('Signed only', 'Solo firmados'), _onlySigned,
            () => setState(() => _onlySigned = !_onlySigned),
            // Como todos los demas: el conteo es el de ACTIVARSE, y null si ya
            // esta activo. Antes mostraba "24" al lado de un pie que decia 7.
            count: _onlySigned ? null : _countIf(signed: true)),
        const SizedBox(width: T.sp16),
        for (final t in Tier.values)
          Padding(padding: const EdgeInsets.only(right: T.sp8),
            child: _chip(_tierLabel(t), _tier == t,
                () => setState(() => _tier = _tier == t ? null : t),
                count: _tier == t ? null : _countIf(tier: t))),
        const SizedBox(width: T.sp8),
        for (final c in ['West', 'Central', 'East'])
          Padding(padding: const EdgeInsets.only(right: T.sp8),
            child: _chip(c, _coast == c,
                () => setState(() => _coast = _coast == c ? null : c),
                count: _coast == c ? null : _countIf(coast: c))),
        const SizedBox(width: T.sp8),
        for (final p in kPrograms)
          Padding(padding: const EdgeInsets.only(right: T.sp8),
            child: _chip(p, _program == p,
                () => setState(() => _program = _program == p ? null : p),
                count: _program == p ? null : _countIf(program: p))),
      ]),
    ),
  );

  Widget _chip(String label, bool on, VoidCallback onTap,
      {int? count, bool accent = false}) {
    final dim = count == 0 && !on;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: T.durFast, curve: T.easeBrand,
        padding: const EdgeInsets.symmetric(horizontal: T.sp16, vertical: T.sp8),
        decoration: BoxDecoration(
          color: on ? T.yellow : (accent ? T.red : Colors.transparent),
          borderRadius: BorderRadius.circular(T.rChip),
          border: Border.all(width: 1,
              color: on ? T.yellow : (accent ? T.red : T.sky.withOpacity(.45))),
        ),
        child: Text(count == null ? label : '$label · $count',
            style: TextStyle(
              color: on ? T.navy : (accent ? T.white : T.sky),
              fontWeight: FontWeight.w700, fontSize: 12)
                .apply(color: dim ? T.sky.withOpacity(.4) : null)),
      ),
    );
  }

  String _tierLabel(Tier t) => tierLabel(t);

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
              CaritaAvatar(spec: lo.avatar, size: _pinSize, ring: true),
              if (lo.closedTotal > 0)
                Positioned(right: -4, bottom: -4, child: Container(
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: T.sp4),
                  decoration: BoxDecoration(color: T.yellow,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: T.navy, width: 1)),
                  child: Text('${lo.closedTotal}', style: const TextStyle(
                      color: T.navy, fontWeight: FontWeight.w800, fontSize: 11)),
                )),
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
  /// Clave de lectura de una linea. Sin esto el 70% del mapa no es interpretable.
  Widget _legendKey() => Positioned(
    left: T.sp16, top: T.sp8,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: T.sp12, vertical: T.sp8),
      decoration: BoxDecoration(color: T.vizDarkSurface.withOpacity(.92),
          borderRadius: BorderRadius.circular(T.rChip)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(
            color: T.s1d, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: T.sp4),
        Text(l10n.t('portfolio density', 'densidad de portafolio'),
            style: const TextStyle(color: T.sky, fontSize: 11)),
        const SizedBox(width: T.sp12),
        Container(width: 12, height: 12, decoration: BoxDecoration(
            color: T.yellow, borderRadius: BorderRadius.circular(999),
            border: Border.all(color: T.navy, width: 1))),
        const SizedBox(width: T.sp4),
        Text('closed loans', style: const TextStyle(color: T.sky, fontSize: 11)),
      ]),
    ),
  );

  Widget _emptyState() => IgnorePointer(
    ignoring: false,
    child: Container(
      color: T.navy.withOpacity(.82),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(T.sp32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(l10n.t('Nothing out here with those filters.',
            'Nada por aquí con esos filtros.'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: T.white, fontWeight: FontWeight.w800,
                fontSize: 18)),
        const SizedBox(height: T.sp8),
        Text(l10n.t('Drop one and the map comes back.',
            'Quita uno y el mapa vuelve.'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: T.sky, fontSize: 13)),
        const SizedBox(height: T.sp24),
        ElevatedButton(onPressed: _clearFilters,
            child: Text(l10n.t('CLEAR FILTERS', 'LIMPIAR FILTROS'))),
      ]),
    ),
  );

  // ------------------------------------------------------------------ cards
  Widget _miniCard(LoanOfficer lo, NumberFormat money) => Card(
    child: Padding(
      padding: const EdgeInsets.all(T.sp16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          onTap: () => showAvatarPicker(context, lo, onSaved: _reload),
          child: Stack(clipBehavior: Clip.none, children: [
            CaritaAvatar(spec: lo.avatar, size: 56),
            Positioned(right: -4, bottom: -4, child: Container(
              padding: const EdgeInsets.all(T.sp4),
              decoration: const BoxDecoration(color: T.red, shape: BoxShape.circle),
              child: const Icon(Icons.edit, size: 12, color: T.white))),
          ]),
        ),
        const SizedBox(width: T.sp16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(lo.name, style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 16, color: T.navy)),
          Text('${lo.city}, ${lo.state} · ${lo.nmls}',
              style: const TextStyle(fontSize: 12, color: T.neutralText)),
          const SizedBox(height: T.sp8),
          Row(children: [
            TierChip(tier: lo.tier),
            const SizedBox(width: T.sp8),
            Text(lo.program, style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: T.navy)),
          ]),
          const SizedBox(height: T.sp8),
          Text('${lo.leads} leads · ${lo.preApprovals} pre-approvals · '
               '${lo.ratified} ratified · ${lo.closedTotal} closed',
              style: const TextStyle(fontSize: 11, color: T.neutralText)),
        ])),
        const SizedBox(width: T.sp8),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          IconButton(
            visualDensity: VisualDensity.compact, padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.close, size: 16, color: T.neutralText),
            onPressed: () => setState(() => _tappedId = null)),
          const SizedBox(height: T.sp4),
          MoneyPill(amount: lo.earned, size: 16, money: money),
          Text(l10n.t('month ${lo.monthOf12}/12', 'mes ${lo.monthOf12}/12'),
              style: const TextStyle(fontSize: 11, color: T.neutralText)),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => LoPortfolioScreen(loId: lo.id))).then((_) => _reload()),
            style: TextButton.styleFrom(padding: EdgeInsets.zero,
                minimumSize: const Size(0, 32)),
            child: Text(l10n.t('Open 360°', 'Abrir 360°'),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ]),
      ]),
    ),
  );

  Widget _stateCard(String code, List<LoanOfficer> los, NumberFormat money) => Card(
    child: Padding(
      padding: const EdgeInsets.all(T.sp16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Text(code, style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 22, color: T.navy)),
          const SizedBox(width: T.sp8),
          Expanded(child: Text('${los.length} Loan Officers',
              style: const TextStyle(fontSize: 12, color: T.neutralText))),
          if (los.isNotEmpty)
            MoneyPill(amount: los.fold<double>(0, (s, l) => s + l.earned),
                size: 14, money: money),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close, size: 16, color: T.neutralText),
            onPressed: () => setState(() => _selectedState = null)),
        ]),
        if (los.isEmpty)
          Text(l10n.t('No Loan Officers here yet — territory available.',
              'Aún no hay Loan Officers aquí — territorio disponible.'),
              style: const TextStyle(fontSize: 13, color: T.neutralText))
        else
          SizedBox(height: 80, child: ListView.separated(
            scrollDirection: Axis.horizontal, itemCount: los.length,
            separatorBuilder: (_, __) => const SizedBox(width: T.sp16),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => setState(() => _tappedId = los[i].id),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                CaritaAvatar(spec: los[i].avatar, size: 48),
                const SizedBox(height: T.sp4),
                SizedBox(width: 64, child: Text(los[i].name.split(' ').first,
                    textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                        color: T.navy))),
              ]),
            ),
          )),
      ]),
    ),
  );

  // ----------------------------------------------------------------- totales
  Widget _totals(List<LoanOfficer> list, NumberFormat money) => Container(
    color: T.vizDarkSurface,
    padding: const EdgeInsets.symmetric(horizontal: T.sp16, vertical: T.sp12),
    child: Row(children: [
      _stat('${list.length}', 'Loan Officers'),
      _stat('${list.map((e) => e.state).toSet().length}',
          l10n.t('states', 'estados')),
      _stat('${list.fold<int>(0, (s, l) => s + l.closedTotal)}', 'closed loans'),
      _stat(money.format(list.fold<double>(0, (s, l) => s + l.earned)),
          l10n.t('earned', 'ganado'), money: true),
    ]),
  );

  Widget _stat(String v, String label, {bool money = false}) => Expanded(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(v, style: money
          ? moneyStyle(18)
          : const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: T.white)),
      Text(label, style: const TextStyle(fontSize: 11, color: T.sky)),
    ]),
  );
}

/// Pinta los 51 estados. Densidad de portafolio = tono del relleno (secuencial
/// de la paleta viz oscura, nunca rainbow). Seleccion = trazo amarillo — el rojo
/// es marca/CTA, no geografia, y al 35% sobre navy no se leia.
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
