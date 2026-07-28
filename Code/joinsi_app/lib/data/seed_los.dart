// 24 LOs semilla, 12 estados, 3 tiers, nombres latinos multi-etnicos.
//
// REGLAS DE LA SEMILLA (un Branch Manager audita esto en dos segundos):
//  1. El embudo es MONOTONO: leads > pre-approvals > ratified > closed.
//     Un embudo que se ensancha destruye la credibilidad de la demo entera.
//  2. `closedTotal` se DERIVA de avgLoansMonth x monthOf12 — el promedio
//     declarado nunca contradice el historial demostrado.
//  3. `earned` se calcula con LoanOfficer.payoutFor(), jamas un literal.
import '../models/loan_officer.dart';

List<LoanOfficer> seedLos() {
  // id, name, city, state, tier, avgLoansMonth, stage, monthOf12, program
  final rows = <List<dynamic>>[
    ['lo01','Carlos Mendoza','Houston','TX',Tier.boutique,1.5,Stage.call1,0,'ITIN'],
    ['lo02','Yulissa Ramirez','Dallas','TX',Tier.mid,1.8,Stage.signed,4,'FHA'],
    ['lo03','Andres Bello','Miami','FL',Tier.top,2.3,Stage.signed,6,'Conventional'],
    ['lo04','Maria Fernanda Cruz','Orlando','FL',Tier.boutique,1.2,Stage.preFunnel,0,'FHA'],
    ['lo05','Jhon Pineda','Charlotte','NC',Tier.mid,1.9,Stage.meetingPD,0,'Conventional'],
    ['lo06','Katherine Sosa','Raleigh','NC',Tier.boutique,1.4,Stage.assigned,0,'ITIN'],
    ['lo07','Luis Estrada','Los Angeles','CA',Tier.top,2.6,Stage.deciding,0,'Jumbo'],
    ['lo08','Paola Gutierrez','Riverside','CA',Tier.mid,2.0,Stage.signed,2,'FHA'],
    ['lo09','Miguel Anaya','Phoenix','AZ',Tier.boutique,1.5,Stage.followUp,0,'ITIN'],
    ['lo10','Daniela Rojas','Tucson','AZ',Tier.boutique,1.1,Stage.assigned,0,'FHA'],
    ['lo11','Sebastian Lara','Atlanta','GA',Tier.mid,1.8,Stage.signed,5,'Conventional'],
    ['lo12','Ingrid Palacios','Denver','CO',Tier.boutique,1.4,Stage.call1,0,'VA'],
    ['lo13','Oscar Villamil','Aurora','CO',Tier.mid,1.7,Stage.preFunnel,0,'Conventional'],
    ['lo14','Vanessa Quintero','Chicago','IL',Tier.top,1.6,Stage.signed,7,'Non-QM'],
    ['lo15','Freddy Cardona','Newark','NJ',Tier.boutique,1.3,Stage.assigned,0,'ITIN'],
    ['lo16','Lorena Ibarra','Elizabeth','NJ',Tier.mid,1.9,Stage.call2,0,'FHA'],
    ['lo17','Ricardo Nino','Las Vegas','NV',Tier.boutique,1.5,Stage.followUp,0,'Conventional'],
    ['lo18','Julieth Moreno','Reno','NV',Tier.boutique,1.2,Stage.assigned,0,'FHA'],
    ['lo19','Esteban Duque','Seattle','WA',Tier.mid,1.7,Stage.preFunnel,0,'Jumbo'],
    ['lo20','Natalia Pardo','Washington','DC',Tier.top,1.5,Stage.signed,8,'Conventional'],
    ['lo21','Hernan Salazar','Arlington','VA',Tier.mid,2.0,Stage.meetingPD,0,'VA'],
    ['lo22','Adriana Celis','Richmond','VA',Tier.boutique,1.4,Stage.call1,0,'ITIN'],
    ['lo23','Camilo Rueda','San Antonio','TX',Tier.mid,1.5,Stage.signed,2,'FHA'],
    ['lo24','Sara Manrique','El Paso','TX',Tier.boutique,1.3,Stage.assigned,0,'ITIN'],
  ];
  final now = DateTime.now();
  final out = <LoanOfficer>[];
  for (var i = 0; i < rows.length; i++) {
    final r = rows[i];
    final stage = r[6] as Stage;
    final avg = r[5] as double;
    final m12 = r[7] as int;
    final signed = stage == Stage.signed;

    // Historial coherente con el promedio declarado.
    final closed = signed ? (avg * m12).round() : 0;
    // Embudo monotono: cada etapa mas ancha que la siguiente.
    final ratified = signed ? (closed * 1.3).round() + 1 : 0;
    final preApprovals = signed ? (ratified * 1.8).round() : 0;
    final leads = signed ? (preApprovals * 2.2).round() : 0;

    out.add(LoanOfficer(
      id: r[0] as String, name: r[1] as String, city: r[2] as String,
      state: r[3] as String, nmls: 'NMLS ${1400000 + i * 731}',
      photoSeed: r[0] as String, tier: r[4] as Tier, avgLoansMonth: avg,
      stage: stage, program: r[8] as String,
      closedTotal: closed, monthOf12: m12,
      earned: LoanOfficer.payoutFor(closed),
      leads: leads, preApprovals: preApprovals, ratified: ratified,
      nextTouch: stage == Stage.followUp || stage == Stage.call1
          ? now.add(Duration(hours: 3 + i)) : null,
      // Clave de promesa, no texto: la traduccion vive en la capa de UI.
      promise: stage == Stage.followUp ? 'callTuesday' : null,
    ));
  }
  return out;
}
