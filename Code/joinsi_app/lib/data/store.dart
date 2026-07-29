import 'package:hive_flutter/hive_flutter.dart';
import '../models/loan_officer.dart';
import 'seed_los.dart';

/// Una fila del ranking. El usuario y los rivales se unifican aqui para que la
/// pantalla no tenga dos caminos de codigo (y por tanto dos matematicas).
class RankRow {
  final String name;
  final int los, closed, states;
  final double earned;
  final bool isUser, isSiFounder, networkActive;
  final AvatarSpec avatar;
  const RankRow({required this.name, required this.los, required this.closed,
    required this.states, required this.earned, required this.avatar,
    this.isUser = false, this.isSiFounder = false, this.networkActive = true});
}

class Store {
  static late Box _box;

  /// Version del esquema semilla. Al subirla, el box se re-siembra.
  /// v4: A3-R2 — casos cobrados vs. en camino, actividad por periodo, ranking.
  static const _seedVersion = 4;

  /// Regla de negocio: HOMESI liquida comisiones al corte, cada 30 dias.
  static const payPeriodDays = 30;
  static const payPeriodNumber = 2;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('joinsi');

    if (_box.get('seedVersion') != _seedVersion || !_box.containsKey('los')) {
      await _box.put('los', [for (final lo in seedLos()) lo.toMap()]);
      await _box.put('seedVersion', _seedVersion);
    }
    // Defaults idempotentes: si falta una clave se rellena, sin pisar progreso
    // real. Antes un getter sobre clave ausente crasheaba el primer frame en un
    // dispositivo con box de un build anterior.
    const defaults = <String, Object>{'streak': 7, 'academyProgress': 0.62};
    for (final e in defaults.entries) {
      if (!_box.containsKey(e.key)) await _box.put(e.key, e.value);
    }
  }

  static List<LoanOfficer> los() {
    final raw = _box.get('los');
    if (raw is! List) return const [];
    return [for (final m in raw) if (m is Map) LoanOfficer.fromMap(m)];
  }

  static Future<void> saveLos(List<LoanOfficer> list) =>
      _box.put('los', [for (final lo in list) lo.toMap()]);

  /// Actualiza UN solo LO (carita, stage, cifras) preservando el resto.
  static Future<void> saveLo(LoanOfficer lo) {
    final list = los();
    final i = list.indexWhere((l) => l.id == lo.id);
    if (i >= 0) {
      list[i] = lo;
    } else {
      list.add(lo);
    }
    return saveLos(list);
  }

  /// Los LOs firmados = el portafolio. Unica definicion en toda la app.
  static List<LoanOfficer> portfolio() =>
      los().where((l) => l.stage == Stage.signed).toList();

  // ---------------------------------------------------------------------------
  // AGREGADOS DE DINERO. Los tres estados del canon: causado = cobrado + en
  // camino. El invariante sale POR CONSTRUCCION porque los tres se derivan del
  // mismo closedTotal/collectedCases de cada LO. Ninguno es literal en el box:
  // una cifra escrita a mano que no cuadra con la suma de las fichas es lo
  // primero que detecta un Branch Manager.
  // ---------------------------------------------------------------------------
  static double get earnedYear =>
      portfolio().fold<double>(0, (s, l) => s + l.earned);
  static double get totalCollected =>
      portfolio().fold<double>(0, (s, l) => s + l.collectedAmount);
  static double get totalPending =>
      portfolio().fold<double>(0, (s, l) => s + l.pendingAmount);
  static int get pendingCasesCount =>
      portfolio().fold<int>(0, (s, l) => s + l.pendingCases);

  static int get closedTotal =>
      portfolio().fold<int>(0, (s, l) => s + l.closedTotal);
  static int get statesCount => portfolio().map((l) => l.state).toSet().length;
  static int get activeCount => portfolio().where((l) => l.isActive).length;

  /// Lo que falta por entrar de las ventanas ya abiertas (base del proyector).
  static double get remainingWindow =>
      portfolio().fold<double>(0, (s, l) => s + l.remainingWindowValue());

  /// Lo que entra el proximo mes por ritmo de las ventanas activas. Misma
  /// derivacion que usa el proyector en su mes 1 — no pueden divergir.
  static double get monthlyInflow =>
      portfolio().fold<double>(0, (s, l) => s + l.monthlyRemaining);

  // ---------------------------------------------------------------------------
  // CICLO DE PAGO
  // ---------------------------------------------------------------------------

  /// Proximo corte: el dia 15 mas cercano hacia adelante. Se CALCULA, no se
  /// guarda, para que la demo siga teniendo sentido dentro de tres meses.
  static DateTime get nextCutDate {
    final now = DateTime.now();
    return now.day < 15
        ? DateTime(now.year, now.month, 15)
        : DateTime(now.year, now.month + 1, 15);
  }

  static int get daysToCut {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return nextCutDate.difference(today).inDays;
  }

  /// Corte anterior — marco temporal del ranking (standings, no feed en vivo).
  static DateTime get lastCutDate {
    final n = nextCutDate;
    return DateTime(n.year, n.month - 1, 15);
  }

  /// Simula el corte: marca como cobrado todo lo pendiente. Es lo que hace que
  /// "VER MI CORTE" sea funcional y no un adorno.
  static Future<void> applyCut() async {
    final list = los();
    for (final lo in list) {
      if (lo.stage == Stage.signed) lo.applyCut();
    }
    await saveLos(list);
  }

  // ---------------------------------------------------------------------------
  // RANKING (P34) — DATO SEMILLA MOCKEADO (Acta A0: sin backend).
  // El usuario se inserta ORDENADO POR SU DINERO REAL, nunca en posicion fija:
  // si su portafolio crece, sube de puesto solo y el mock se siente vivo.
  // ---------------------------------------------------------------------------
  static List<RankRow> ranking() {
    final rows = <RankRow>[
      for (final r in seedRivals())
        RankRow(name: r.name, los: r.losCount, closed: r.closedCount,
            states: r.statesCount, earned: r.earned, avatar: r.avatar,
            isSiFounder: r.isSiFounder,
            networkActive: r.networkActiveThisPeriod),
      RankRow(name: 'TU', los: portfolio().length, closed: closedTotal,
          states: statesCount, earned: earnedYear, isUser: true,
          networkActive: activeCount > 0,
          avatar: AvatarSpec.seeded('sp-user')),
    ];
    rows.sort((a, b) => b.earned.compareTo(a.earned));
    return rows;
  }

  /// Puesto del usuario (1-based) y cuanto le falta para subir uno.
  static int get userRank => ranking().indexWhere((r) => r.isUser) + 1;
  static double get deltaToNextRank {
    final rows = ranking();
    final i = rows.indexWhere((r) => r.isUser);
    return i <= 0 ? 0 : rows[i - 1].earned - rows[i].earned;
  }

  static List<Territory> get territories => seedTerritories;

  static int get streak => (_box.get('streak') as num?)?.toInt() ?? 0;
  static double get academyProgress =>
      (_box.get('academyProgress') as num?)?.toDouble() ?? 0;
}
