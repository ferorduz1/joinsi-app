// 24 LOs semilla, 12 estados, 3 tiers, nombres latinos multi-etnicos.
// photoSeed alimenta avatares placeholder deterministas (iniciales + color).
import '../models/loan_officer.dart';

List<LoanOfficer> seedLos() {
  final rows = <List<dynamic>>[
    // id, name, city, state, tier, avgLoans, stage, closed, earned, m12
    ['lo01','Carlos Mendoza','Houston','TX',Tier.boutique,2.0,Stage.call1,0,0.0,0],
    ['lo02','Yulissa Ramirez','Dallas','TX',Tier.mid,3.0,Stage.signed,7,2400.0,4],
    ['lo03','Andres Bello','Miami','FL',Tier.top,5.0,Stage.signed,14,4400.0,6],
    ['lo04','Maria Fernanda Cruz','Orlando','FL',Tier.boutique,1.5,Stage.preFunnel,0,0.0,0],
    ['lo05','Jhon Pineda','Charlotte','NC',Tier.mid,2.5,Stage.meetingPD,0,0.0,0],
    ['lo06','Katherine Sosa','Raleigh','NC',Tier.boutique,2.0,Stage.assigned,0,0.0,0],
    ['lo07','Luis Estrada','Los Angeles','CA',Tier.top,6.0,Stage.deciding,0,0.0,0],
    ['lo08','Paola Gutierrez','Riverside','CA',Tier.mid,3.0,Stage.signed,4,1600.0,2],
    ['lo09','Miguel Anaya','Phoenix','AZ',Tier.boutique,2.0,Stage.followUp,0,0.0,0],
    ['lo10','Daniela Rojas','Tucson','AZ',Tier.boutique,1.5,Stage.assigned,0,0.0,0],
    ['lo11','Sebastian Lara','Atlanta','GA',Tier.mid,3.5,Stage.signed,9,2800.0,5],
    ['lo12','Ingrid Palacios','Denver','CO',Tier.boutique,2.0,Stage.call1,0,0.0,0],
    ['lo13','Oscar Villamil','Aurora','CO',Tier.mid,2.5,Stage.preFunnel,0,0.0,0],
    ['lo14','Vanessa Quintero','Chicago','IL',Tier.top,4.5,Stage.signed,11,3600.0,7],
    ['lo15','Freddy Cardona','Newark','NJ',Tier.boutique,2.0,Stage.assigned,0,0.0,0],
    ['lo16','Lorena Ibarra','Elizabeth','NJ',Tier.mid,3.0,Stage.call2,0,0.0,0],
    ['lo17','Ricardo Nino','Las Vegas','NV',Tier.boutique,2.0,Stage.followUp,0,0.0,0],
    ['lo18','Julieth Moreno','Reno','NV',Tier.boutique,1.5,Stage.assigned,0,0.0,0],
    ['lo19','Esteban Duque','Seattle','WA',Tier.mid,2.5,Stage.preFunnel,0,0.0,0],
    ['lo20','Natalia Pardo','Washington','DC',Tier.top,5.0,Stage.signed,12,3800.0,8],
    ['lo21','Hernan Salazar','Arlington','VA',Tier.mid,3.0,Stage.meetingPD,0,0.0,0],
    ['lo22','Adriana Celis','Richmond','VA',Tier.boutique,2.0,Stage.call1,0,0.0,0],
    ['lo23','Camilo Rueda','San Antonio','TX',Tier.mid,2.5,Stage.signed,3,1400.0,2],
    ['lo24','Sara Manrique','El Paso','TX',Tier.boutique,2.0,Stage.assigned,0,0.0,0],
  ];
  final now = DateTime.now();
  return [
    for (final r in rows)
      LoanOfficer(id: r[0], name: r[1], city: r[2], state: r[3],
        nmls: 'NMLS ${1400000 + rows.indexOf(r) * 731}', photoSeed: r[0],
        tier: r[4], avgLoansMonth: r[5], stage: r[6], closedTotal: r[7],
        earned: r[8], monthOf12: r[9],
        leads: r[6] == Stage.signed ? 4 : 0,
        preApprovals: r[6] == Stage.signed ? 2 : 0,
        ratified: r[6] == Stage.signed ? 1 : 0,
        nextTouch: r[6] == Stage.followUp || r[6] == Stage.call1
            ? now.add(Duration(hours: 3 + rows.indexOf(r))) : null,
        promise: r[6] == Stage.followUp ? 'You agreed to call Tuesday' : null),
  ];
}
