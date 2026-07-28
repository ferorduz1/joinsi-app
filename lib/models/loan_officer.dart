// Modelo del LO prospecto/portafolio. Persistido como Map en Hive (sin codegen
// para mantener el prototipo simple; migrar a TypeAdapter en producto real).
enum Tier { boutique, mid, top }
enum Stage { assigned, preFunnel, call1, followUp, call2, meetingPD, deciding, signed }

class LoanOfficer {
  final String id, name, city, state, nmls, photoSeed;
  final Tier tier;
  Stage stage;
  final double avgLoansMonth;
  int leads, preApprovals, ratified, closedTotal, monthOf12;
  double earned;            // USD ganados con este LO
  DateTime? nextTouch;      // motor Tamagotchi
  String? promise;          // "quedaste de llamar el martes"

  LoanOfficer({required this.id, required this.name, required this.city,
    required this.state, required this.nmls, required this.photoSeed,
    required this.tier, this.stage = Stage.assigned, this.avgLoansMonth = 2,
    this.leads = 0, this.preApprovals = 0, this.ratified = 0,
    this.closedTotal = 0, this.monthOf12 = 0, this.earned = 0,
    this.nextTouch, this.promise});

  // Proyeccion canonica: $500+$500 primeros 2 closed; $200/caso por 12 meses
  double projectedFirstYear() => 1000 + (avgLoansMonth * 12 - 2).clamp(0, 999) * 200;

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'city': city,
    'state': state, 'nmls': nmls, 'photoSeed': photoSeed, 'tier': tier.index,
    'stage': stage.index, 'avg': avgLoansMonth, 'leads': leads,
    'pre': preApprovals, 'rat': ratified, 'closed': closedTotal,
    'm12': monthOf12, 'earned': earned,
    'next': nextTouch?.millisecondsSinceEpoch, 'promise': promise};

  static LoanOfficer fromMap(Map m) => LoanOfficer(id: m['id'], name: m['name'],
    city: m['city'], state: m['state'], nmls: m['nmls'], photoSeed: m['photoSeed'],
    tier: Tier.values[m['tier']], stage: Stage.values[m['stage']],
    avgLoansMonth: (m['avg'] as num).toDouble(), leads: m['leads'],
    preApprovals: m['pre'], ratified: m['rat'], closedTotal: m['closed'],
    monthOf12: m['m12'], earned: (m['earned'] as num).toDouble(),
    nextTouch: m['next'] == null ? null : DateTime.fromMillisecondsSinceEpoch(m['next']),
    promise: m['promise']);
}
