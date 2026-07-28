// Modelo del LO prospecto/portafolio. Persistido como Map en Hive (sin codegen
// para mantener el prototipo simple; migrar a TypeAdapter en producto real).
enum Tier { boutique, mid, top }
enum Stage { assigned, preFunnel, call1, followUp, call2, meetingPD, deciding, signed }

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
  double earned;            // USD ganados con este LO
  DateTime? nextTouch;      // motor Tamagotchi
  String? promise;          // "quedaste de llamar el martes"
  AvatarSpec avatar;

  LoanOfficer({required this.id, required this.name, required this.city,
    required this.state, required this.nmls, required this.photoSeed,
    required this.tier, this.stage = Stage.assigned, this.avgLoansMonth = 2,
    String? program, this.leads = 0, this.preApprovals = 0, this.ratified = 0,
    this.closedTotal = 0, this.monthOf12 = 0, this.earned = 0,
    this.nextTouch, this.promise, AvatarSpec? avatar})
      : program = program ?? kPrograms[id.hashCode.abs() % kPrograms.length],
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

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'city': city,
    'state': state, 'nmls': nmls, 'photoSeed': photoSeed, 'tier': tier.index,
    'stage': stage.index, 'avg': avgLoansMonth, 'program': program,
    'leads': leads, 'pre': preApprovals, 'rat': ratified, 'closed': closedTotal,
    'm12': monthOf12, 'earned': earned,
    'next': nextTouch?.millisecondsSinceEpoch, 'promise': promise,
    'avFace': avatar.face, 'avShape': avatar.shape, 'avColor': avatar.color,
    'avPhoto': avatar.photoPath};

  // Defensivo a proposito: el Hive del dispositivo puede traer mapas sembrados
  // por un build anterior sin 'program' ni 'avFace'. Un cast duro ahi = crash en
  // el primer frame, en el celular del director.
  static int _i(Object? v, [int d = 0]) => v is num ? v.toInt() : d;
  static double _d(Object? v, [double d = 0]) => v is num ? v.toDouble() : d;

  static LoanOfficer fromMap(Map m) {
    final id = m['id'] as String? ?? 'lo?';
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
      closedTotal: _i(m['closed']), monthOf12: _i(m['m12']),
      earned: _d(m['earned']),
      nextTouch: m['next'] == null
          ? null : DateTime.fromMillisecondsSinceEpoch(_i(m['next'])),
      promise: m['promise'] as String?,
      avatar: m['avFace'] == null ? null : AvatarSpec(face: _i(m['avFace']),
        shape: _i(m['avShape']), color: _i(m['avColor']),
        photoPath: m['avPhoto'] as String?),
    );
  }
}
