// Modelo del LO prospecto/portafolio. Persistido como Map en Hive (sin codegen
// para mantener el prototipo simple; migrar a TypeAdapter en producto real).
enum Tier { boutique, mid, top }
enum Stage { assigned, preFunnel, call1, followUp, call2, meetingPD, deciding, signed }

/// Estado de actividad del LO firmado. DERIVADO de casesThisPeriod — nunca se
/// almacena como campo independiente (dos verdades = una mentira).
enum Activity { enviandoCasos, sinCasosEsteMes }

/// Programas gancho del catalogo (terminos de industria SIEMPRE en ingles).
const kPrograms = ['Conventional', 'FHA', 'VA', 'ITIN', 'Non-QM', 'Jumbo'];

/// Costa para filtros del mapa: East / Central / West.
const kCoastOf = {
  'WA': 'West', 'OR': 'West', 'CA': 'West', 'NV': 'West', 'AZ': 'West',
  'ID': 'West', 'UT': 'West', 'AK': 'West', 'HI': 'West', 'MT': 'West',
  'WY': 'West', 'NM': 'West',
  'CO': 'Central', 'TX': 'Central', 'OK': 'Central', 'KS': 'Central',
  'NE': 'Central', 'SD': 'Central', 'ND': 'Central', 'MN': 'Central',
  'IA': 'Central', 'MO': 'Central', 'AR': 'Central', 'LA': 'Central',
  'WI': 'Central', 'IL': 'Central', 'MS': 'Central', 'AL': 'Central',
  'TN': 'Central', 'KY': 'Central', 'IN': 'Central', 'MI': 'Central', 'OH': 'Central',
  'FL': 'East', 'GA': 'East', 'SC': 'East', 'NC': 'East', 'VA': 'East',
  'WV': 'East', 'DC': 'East', 'MD': 'East', 'DE': 'East', 'NJ': 'East',
  'PA': 'East', 'NY': 'East', 'CT': 'East', 'RI': 'East', 'MA': 'East',
  'VT': 'East', 'NH': 'East', 'ME': 'East',
};

/// Carita asignable: identifica al MISMO LO en mapa, fichas y listas.
/// face: expresion pintada (0-7) · shape: 0 circulo, 1 squircle, 2 hexagono,
/// 3 diamante · color: combo de paleta (0-4) · photoPath: si existe, manda.
class AvatarSpec {
  final int face, shape, color;
  final String? photoPath;
  const AvatarSpec({required this.face, required this.shape,
    required this.color, this.photoPath});

  AvatarSpec copyWith({int? face, int? shape, int? color, String? photoPath,
      bool clearPhoto = false}) =>
    AvatarSpec(face: face ?? this.face, shape: shape ?? this.shape,
      color: color ?? this.color,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath));

  /// Carita por defecto determinista a partir del id: el mapa nace habitado y
  /// cada LO se distingue del de al lado.
  /// Hash Jenkins one-at-a-time CON avalancha — es lo que hace falta aqui: los
  /// ids son casi identicos (lo01..lo24) y un hash multiplicativo simple deja
  /// los bits altos pegados, colapsando la semilla en 2 formas y 2 colores.
  /// Con avalancha salen las 4 formas, los 5 combos y 22 caritas unicas de 24.
  static AvatarSpec seeded(String id) {
    var h = 0;
    for (final c in id.codeUnits) {
      h = (h + c) & 0xFFFFFFFF;
      h = (h + (h << 10)) & 0xFFFFFFFF;
      h ^= h >> 6;
    }
    h = (h + (h << 3)) & 0xFFFFFFFF;
    h ^= h >> 11;
    h = (h + (h << 15)) & 0xFFFFFFFF;
    return AvatarSpec(face: h % 8, shape: (h >> 8) % 4, color: (h >> 16) % 5);
  }
}

class LoanOfficer {
  final String id, name, city, state, nmls, photoSeed;
  final Tier tier;
  Stage stage;
  final double avgLoansMonth;
  final String program;
  int leads, preApprovals, ratified, closedTotal, monthOf12;

  /// Cuantos de los `closedTotal` YA fueron pagados al SiPartner. El resto esta
  /// "en camino": cerrado pero pendiente del corte (pagos cada 30 dias).
  /// Guardar el CONTEO y no el dinero es lo que hace imposible que cobrado y
  /// pendiente dejen de sumar el causado — el invariante sale por construccion.
  int collectedCases;

  /// Casos cerrados dentro del periodo de pago vigente. Unico insumo de
  /// `activity`; si es 0, el LO esta dormido y la carita se atenua.
  int casesThisPeriod;

  DateTime? nextTouch;      // motor de recontacto
  String? promise;          // "quedaste de llamar el martes"
  AvatarSpec avatar;

  LoanOfficer({required this.id, required this.name, required this.city,
    required this.state, required this.nmls, required this.photoSeed,
    required this.tier, this.stage = Stage.assigned, this.avgLoansMonth = 2,
    String? program, this.leads = 0, this.preApprovals = 0, this.ratified = 0,
    this.closedTotal = 0, this.monthOf12 = 0, int? collectedCases,
    this.casesThisPeriod = 0, this.nextTouch, this.promise, AvatarSpec? avatar})
      : program = program ?? kPrograms[id.hashCode.abs() % kPrograms.length],
        collectedCases = collectedCases ?? closedTotal,
        avatar = avatar ?? AvatarSpec.seeded(id);

  String get coast => kCoastOf[state] ?? 'Central';

  // ---------------------------------------------------------------------------
  // FUENTE UNICA DE VERDAD DEL DINERO. Toda cifra de compensacion de la app sale
  // de aqui — ninguna pantalla replica la formula.
  // Canon A0 #7: $500 + $500 por los DOS PRIMEROS closed loans del LO, luego
  // $200 por cada closed loan durante 12 meses.
  // ---------------------------------------------------------------------------
  static double payoutFor(int closed) {
    if (closed <= 0) return 0;
    if (closed == 1) return 500;
    return 1000 + (closed - 2) * 200;
  }

  /// Cuanto vale el caso n-esimo por si solo ($500, $500, luego $200).
  /// Necesario para valorar caso a caso lo pendiente de corte sin re-derivar
  /// la formula a mano en ninguna pantalla.
  static double marginalPayoutFor(int n) =>
      n <= 0 ? 0 : payoutFor(n) - payoutFor(n - 1);

  /// CAUSADO: todo lo que este LO ha generado. Solo crece.
  double get earned => payoutFor(closedTotal);

  /// COBRADO: ya desembolsado al SiPartner.
  double get collectedAmount => payoutFor(collectedCases.clamp(0, closedTotal));

  /// EN CAMINO: cerrado pero aun no cobrado — entra en el proximo corte.
  /// Invariante garantizado: collectedAmount + pendingAmount == earned.
  double get pendingAmount => earned - collectedAmount;

  /// Cuantos casos cerrados esperan el corte.
  int get pendingCases => (closedTotal - collectedCases).clamp(0, closedTotal);

  /// Derivado, nunca almacenado: el pulso del LO este periodo.
  Activity get activity =>
      casesThisPeriod > 0 ? Activity.enviandoCasos : Activity.sinCasosEsteMes;
  bool get isActive => activity == Activity.enviandoCasos;

  /// Run-rate demostrado: lo que este LO REALMENTE cierra por mes.
  /// Se muestra al lado del declarado — un CEO no proyecta con el declarado.
  double get demonstratedRate =>
      monthOf12 > 0 ? closedTotal / monthOf12 : avgLoansMonth;

  /// Lo que rendiria un LO nuevo en sus 12 meses completos (proyector).
  double projectedFirstYear() => payoutFor((avgLoansMonth * 12).floor());

  /// Lo que FALTA por entrar en la ventana restante de este LO ya firmado.
  /// Respeta la rampa: un LO recien firmado si cobra los $500+$500.
  double remainingWindowValue() {
    final monthsLeft = (12 - monthOf12).clamp(0, 12);
    final future = (demonstratedRate * monthsLeft).floor();
    return payoutFor(closedTotal + future) - payoutFor(closedTotal);
  }

  /// Reparto mensual de lo que falta — alimenta el subtitulo de la ficha 360
  /// y el mes-1 del dashboard. UNA sola derivacion para ambos.
  double get monthlyRemaining {
    final monthsLeft = (12 - monthOf12).clamp(0, 12);
    return monthsLeft == 0 ? 0 : remainingWindowValue() / monthsLeft;
  }

  /// Marca como cobrados los casos pendientes (simula el corte de pago).
  void applyCut() => collectedCases = closedTotal;

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'city': city,
    'state': state, 'nmls': nmls, 'photoSeed': photoSeed, 'tier': tier.index,
    'stage': stage.index, 'avg': avgLoansMonth, 'program': program,
    'leads': leads, 'pre': preApprovals, 'rat': ratified, 'closed': closedTotal,
    'm12': monthOf12, 'collected': collectedCases, 'period': casesThisPeriod,
    'next': nextTouch?.millisecondsSinceEpoch, 'promise': promise,
    'avFace': avatar.face, 'avShape': avatar.shape, 'avColor': avatar.color,
    'avPhoto': avatar.photoPath};

  // Defensivo a proposito: el Hive del dispositivo puede traer mapas sembrados
  // por un build anterior sin 'program' ni 'collected'. Un cast duro ahi =
  // crash en el primer frame, en el celular del director.
  static int _i(Object? v, [int d = 0]) => v is num ? v.toInt() : d;
  static double _d(Object? v, [double d = 0]) => v is num ? v.toDouble() : d;

  static LoanOfficer fromMap(Map m) {
    final id = m['id'] as String? ?? 'lo?';
    final closed = _i(m['closed']);
    return LoanOfficer(
      id: id,
      name: m['name'] as String? ?? '',
      city: m['city'] as String? ?? '',
      state: m['state'] as String? ?? '',
      nmls: m['nmls'] as String? ?? '',
      photoSeed: m['photoSeed'] as String? ?? id,
      tier: Tier.values[_i(m['tier']).clamp(0, Tier.values.length - 1)],
      stage: Stage.values[_i(m['stage']).clamp(0, Stage.values.length - 1)],
      avgLoansMonth: _d(m['avg'], 2),
      program: m['program'] as String?,          // null en data vieja: default
      leads: _i(m['leads']), preApprovals: _i(m['pre']), ratified: _i(m['rat']),
      closedTotal: closed, monthOf12: _i(m['m12']),
      // Data vieja no traia 'collected': asumir todo cobrado es el default que
      // no inventa dinero pendiente que el usuario nunca vera llegar.
      collectedCases: m['collected'] == null ? closed : _i(m['collected']),
      casesThisPeriod: _i(m['period']),
      nextTouch: m['next'] == null
          ? null : DateTime.fromMillisecondsSinceEpoch(_i(m['next'])),
      promise: m['promise'] as String?,
      avatar: m['avFace'] == null ? null : AvatarSpec(face: _i(m['avFace']),
        shape: _i(m['avShape']), color: _i(m['avColor']),
        photoPath: m['avPhoto'] as String?),
    );
  }
}

// =============================================================================
// P34 RANKING & ESCALERA — entidades semilla MOCKEADAS.
// El Acta A0 fija Flutter + Hive local SIN backend: no existe una red real de
// SiPartners. Estas entidades son ficcion declarada, de la misma categoria que
// el dialer mock y la cuenta bancaria mock. Se enmarcan como "standings al
// corte", nunca como feed en vivo.
// =============================================================================

/// Otro SiPartner de la red. El dinero se DERIVA con la misma economia canonica
/// que el portafolio propio — jamas se hardcodea el total en dolares.
class RivalSiPartner {
  final String name;
  final int losCount, closedCount, statesCount;
  final bool isSiFounder, networkActiveThisPeriod;
  final AvatarSpec avatar;

  const RivalSiPartner({required this.name, required this.losCount,
    required this.closedCount, required this.statesCount,
    this.isSiFounder = false, this.networkActiveThisPeriod = true,
    required this.avatar});

  /// Equivalente a sumar payoutFor por cada LO cuando todos tienen >=2 closed:
  /// $1,000 de rampa por LO + $200 por caso pasado el segundo.
  /// = 200*closed + 600*los. Misma formula, agregada.
  double get earned => 200.0 * closedCount + 600.0 * losCount;
}

/// Territorio exclusivo de SiBroker. `claimedBy == null` => disponible.
class Territory {
  final String code, name;
  final String? claimedBy;
  const Territory({required this.code, required this.name, this.claimedBy});
  bool get isAvailable => claimedBy == null;
}

/// Requisitos canonicos de la escalera de estatus (Acta A0 #6).
class LadderReq {
  static const siFounderLos = 8;
  static const siFounderRecruits = 1;
  static const siBrokerClosed = 100;
}
