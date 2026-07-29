import '../models/loan_officer.dart';

/// SEMILLA AUDITABLE. Reglas que ningun dato de aqui puede romper:
///  1. `earned` NUNCA se escribe — se deriva de payoutFor(closedTotal).
///  2. Embudo estrictamente monotono: leads > pre-approvals > ratified > closed.
///  3. El promedio declarado no puede contradecir el historial demostrado
///     (closedTotal / monthOf12) por mas de medio loan/mes.
///  4. `collectedCases` <= `closedTotal`; la diferencia entra al proximo corte.
///  5. `casesThisPeriod` > 0 => el LO aparece "enviando casos" (punto cielo).
/// Los guardarrailes de `test/canon_test.dart` fallan si algo de esto se viola.
///
/// Cifras vivas que produce esta semilla (las 6 pantallas muestran las mismas):
///   7 LOs firmados · 6 estados · 61 closed loans
///   causado $16,400 = cobrado $14,300 + en camino $2,100 (9 casos al corte)
///   activos 5 de 7 · ventana restante del portafolio $17,000
///   por estado  TX $3,400 · FL $3,400 · DC $3,000 · IL $2,800 · GA $2,400 · CA $1,400
///   por tier    Top $9,200 · Mid $7,200
///   por costa   East $8,800 · Central $6,200 · West $1,400

class _Signed {
  final String id, name, city, state, nmls, program;
  final Tier tier;
  final int closed, collected, period, m12, leads, pre, rat;
  final double avg;
  const _Signed(this.id, this.name, this.city, this.state, this.nmls, this.tier,
      this.program, this.closed, this.collected, this.period, this.m12,
      this.avg, this.leads, this.pre, this.rat);
}

// closed·collected·period·m12·avg·leads·pre·rat — verificado a mano contra
// payoutFor(): 2200+3400+3000+2800+1200+2400+1400 = 16,400 causado.
const _signed = <_Signed>[
  _Signed('lo01', 'Yulissa Ramirez', 'Dallas', 'TX', '1400731', Tier.mid,
      'FHA', 8, 6, 2, 5, 1.6, 44, 20, 11),
  _Signed('lo02', 'Andres Bello', 'Miami', 'FL', '1288104', Tier.top,
      'Conventional', 14, 12, 2, 6, 2.3, 75, 34, 19),
  _Signed('lo03', 'Natalia Pardo', 'Washington', 'DC', '1512996', Tier.top,
      'ITIN', 12, 10, 2, 8, 1.5, 68, 31, 17),
  _Signed('lo04', 'Vanessa Quintero', 'Chicago', 'IL', '1339471', Tier.top,
      'FHA', 11, 10, 1, 7, 1.6, 59, 27, 15),
  _Signed('lo05', 'Paola Restrepo', 'Houston', 'TX', '1607238', Tier.mid,
      'Non-QM', 3, 1, 2, 2, 1.5, 20, 9, 5),
  _Signed('lo06', 'Sebastian Duarte', 'Atlanta', 'GA', '1455802', Tier.mid,
      'Conventional', 9, 9, 0, 5, 1.8, 51, 23, 13),
  _Signed('lo07', 'Camilo Herrera', 'Los Angeles', 'CA', '1720655', Tier.mid,
      'VA', 4, 4, 0, 2, 2.0, 24, 11, 6),
];

/// Prospectos aun en el funnel (no firmados): pueblan SiRadar. Sin closed
/// loans y sin dinero — un prospecto no produce comisiones hasta que firma.
class _Prospect {
  final String id, name, city, state, nmls, program;
  final Tier tier;
  final Stage stage;
  final double avg;
  const _Prospect(this.id, this.name, this.city, this.state, this.nmls,
      this.tier, this.program, this.stage, this.avg);
}

const _prospects = <_Prospect>[
  _Prospect('lo08', 'Carlos Mendoza', 'Houston', 'TX', '1102938', Tier.boutique,
      'FHA', Stage.call1, 2.5),
  _Prospect('lo09', 'Marta Villegas', 'Phoenix', 'AZ', '1244517', Tier.mid,
      'ITIN', Stage.preFunnel, 1.8),
  _Prospect('lo10', 'Ricardo Salas', 'Denver', 'CO', '1398820', Tier.top,
      'Jumbo', Stage.meetingPD, 3.1),
  _Prospect('lo11', 'Lucia Moreno', 'Orlando', 'FL', '1471263', Tier.mid,
      'Conventional', Stage.followUp, 2.0),
  _Prospect('lo12', 'Javier Ocampo', 'San Antonio', 'TX', '1520074',
      Tier.boutique, 'VA', Stage.assigned, 1.4),
  _Prospect('lo13', 'Diana Castano', 'Charlotte', 'NC', '1566391', Tier.mid,
      'FHA', Stage.deciding, 2.2),
  _Prospect('lo14', 'Esteban Rojas', 'Las Vegas', 'NV', '1613458',
      Tier.boutique, 'Non-QM', Stage.assigned, 1.2),
  _Prospect('lo15', 'Carolina Nieto', 'Newark', 'NJ', '1659702', Tier.top,
      'Conventional', Stage.call2, 2.9),
  _Prospect('lo16', 'Mauricio Lara', 'Seattle', 'WA', '1701845', Tier.mid,
      'Jumbo', Stage.preFunnel, 2.1),
  _Prospect('lo17', 'Isabela Cruz', 'Tampa', 'FL', '1748219', Tier.mid,
      'ITIN', Stage.call1, 1.7),
  _Prospect('lo18', 'Gustavo Pena', 'Sacramento', 'CA', '1790364',
      Tier.boutique, 'FHA', Stage.assigned, 1.3),
  _Prospect('lo19', 'Adriana Solis', 'Atlanta', 'GA', '1834570', Tier.top,
      'Conventional', Stage.followUp, 3.0),
  _Prospect('lo20', 'Felipe Arango', 'Chicago', 'IL', '1877106', Tier.mid,
      'VA', Stage.preFunnel, 1.9),
  _Prospect('lo21', 'Sandra Bermudez', 'Miami', 'FL', '1912483', Tier.boutique,
      'ITIN', Stage.assigned, 1.5),
  _Prospect('lo22', 'Tomas Bedoya', 'Dallas', 'TX', '1955728', Tier.mid,
      'Non-QM', Stage.call1, 2.0),
  _Prospect('lo23', 'Valeria Cordoba', 'Boston', 'MA', '1998041', Tier.top,
      'Jumbo', Stage.deciding, 2.7),
  _Prospect('lo24', 'Hernan Gaitan', 'Portland', 'OR', '2031569',
      Tier.boutique, 'FHA', Stage.assigned, 1.1),
];

List<LoanOfficer> seedLos() => [
  for (final s in _signed)
    LoanOfficer(
      id: s.id, name: s.name, city: s.city, state: s.state, nmls: s.nmls,
      photoSeed: s.id, tier: s.tier, program: s.program, stage: Stage.signed,
      avgLoansMonth: s.avg, leads: s.leads, preApprovals: s.pre,
      ratified: s.rat, closedTotal: s.closed, collectedCases: s.collected,
      casesThisPeriod: s.period, monthOf12: s.m12,
    ),
  for (final p in _prospects)
    LoanOfficer(
      id: p.id, name: p.name, city: p.city, state: p.state, nmls: p.nmls,
      photoSeed: p.id, tier: p.tier, program: p.program, stage: p.stage,
      avgLoansMonth: p.avg,
    ),
];

/// Ranking de la red — DATO SEMILLA MOCKEADO (Acta A0: sin backend).
/// Se enmarca en la UI como "standings al corte del periodo anterior", nunca
/// como feed en vivo: el negocio paga cada 30 dias, asi que una tabla que no
/// se mueve es lo honesto. El usuario NO esta en esta lista: se inserta
/// ordenado por su `earned` real, para que subir de puesto dependa de su
/// portafolio de verdad y no de una posicion fija escrita a mano.
List<RivalSiPartner> seedRivals() => [
  RivalSiPartner(name: 'Marisol Gutierrez', losCount: 11, closedCount: 94,
      statesCount: 8, isSiFounder: true,
      avatar: AvatarSpec.seeded('sp-marisol')),
  RivalSiPartner(name: 'Diego Fuentes', losCount: 9, closedCount: 80,
      statesCount: 7, avatar: AvatarSpec.seeded('sp-diego')),
  RivalSiPartner(name: 'Valentina Rios', losCount: 8, closedCount: 65,
      statesCount: 5, avatar: AvatarSpec.seeded('sp-valentina')),
  RivalSiPartner(name: 'Kevin Morales', losCount: 6, closedCount: 48,
      statesCount: 4, avatar: AvatarSpec.seeded('sp-kevin')),
  RivalSiPartner(name: 'Alejandra Pena', losCount: 4, closedCount: 29,
      statesCount: 3, networkActiveThisPeriod: false,
      avatar: AvatarSpec.seeded('sp-alejandra')),
];

/// Territorios exclusivos de SiBroker. Georgia ya reclamada = escasez real,
/// que es lo que convierte la escalera en urgencia y no en decoracion.
const seedTerritories = <Territory>[
  Territory(code: 'NC', name: 'North Carolina'),
  Territory(code: 'AZ', name: 'Arizona'),
  Territory(code: 'NJ', name: 'New Jersey'),
  Territory(code: 'GA', name: 'Georgia', claimedBy: 'R. Castillo'),
];
