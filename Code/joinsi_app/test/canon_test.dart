// GUARDARRAIL DEL CANON. Corre con: flutter test
// Existe para que el canon deje de depender de que alguien se acuerde.
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:joinsi/models/loan_officer.dart';
import 'package:joinsi/data/seed_los.dart';

void main() {
  group('Compensacion canonica (A0 #7)', () {
    test('\$500 + \$500 en los dos primeros closed loans, luego \$200', () {
      expect(LoanOfficer.payoutFor(0), 0);
      expect(LoanOfficer.payoutFor(1), 500);
      expect(LoanOfficer.payoutFor(2), 1000);
      expect(LoanOfficer.payoutFor(3), 1200);
      expect(LoanOfficer.payoutFor(12), 3000);
    });

    test('cada LO semilla tiene earned == payoutFor(closedTotal)', () {
      for (final lo in seedLos()) {
        expect(lo.earned, LoanOfficer.payoutFor(lo.closedTotal),
            reason: '${lo.name} tiene un earned que no sale de la formula');
      }
    });

    test('la ventana restante nunca es negativa ni infinita', () {
      for (final lo in seedLos()) {
        final v = lo.remainingWindowValue();
        expect(v, greaterThanOrEqualTo(0));
        expect(v.isFinite, isTrue);
      }
    });
  });

  group('Tres estados del dinero (canon Fernando 2026-07-28)', () {
    test('el caso n-esimo vale 500, 500, luego 200', () {
      expect(LoanOfficer.marginalPayoutFor(0), 0);
      expect(LoanOfficer.marginalPayoutFor(1), 500);
      expect(LoanOfficer.marginalPayoutFor(2), 500);
      expect(LoanOfficer.marginalPayoutFor(3), 200);
      expect(LoanOfficer.marginalPayoutFor(12), 200);
    });

    test('INVARIANTE: causado == cobrado + en camino, en cada LO', () {
      for (final lo in seedLos()) {
        expect(lo.collectedAmount + lo.pendingAmount, lo.earned,
            reason: '${lo.name}: los tres estados del dinero deben cuadrar');
      }
    });

    test('nunca hay mas casos cobrados que cerrados', () {
      for (final lo in seedLos()) {
        expect(lo.collectedCases, lessThanOrEqualTo(lo.closedTotal),
            reason: lo.name);
        expect(lo.pendingCases, greaterThanOrEqualTo(0), reason: lo.name);
      }
    });

    test('un LO esta activo si y solo si cerro casos en el periodo', () {
      for (final lo in seedLos()) {
        expect(lo.isActive, lo.casesThisPeriod > 0, reason: lo.name);
      }
    });

    test('la semilla da las cifras que muestran las 6 pantallas', () {
      final p = seedLos().where((l) => l.stage == Stage.signed).toList();
      double sum(double Function(LoanOfficer) f) =>
          p.fold<double>(0, (s, l) => s + f(l));
      expect(p, hasLength(7));
      expect(p.fold<int>(0, (s, l) => s + l.closedTotal), 61);
      expect(p.map((l) => l.state).toSet(), hasLength(6));
      expect(sum((l) => l.earned), 16400);
      expect(sum((l) => l.collectedAmount), 14300);
      expect(sum((l) => l.pendingAmount), 2100);
      expect(p.fold<int>(0, (s, l) => s + l.pendingCases), 9);
      expect(p.where((l) => l.isActive).length, 5);
      // Base del proyector: lo que FALTA por entrar, jamas lo ya cobrado.
      expect(sum((l) => l.remainingWindowValue()), 17000);
    });

    test('applyCut deja el pendiente en cero sin tocar el causado', () {
      final lo = seedLos().firstWhere((l) => l.pendingCases > 0);
      final before = lo.earned;
      lo.applyCut();
      expect(lo.pendingAmount, 0);
      expect(lo.collectedAmount, before);
      expect(lo.earned, before, reason: 'cobrar no puede cambiar lo causado');
    });
  });

  group('Ranking mockeado (P34)', () {
    test('el dinero del rival se DERIVA, nunca se escribe a mano', () {
      for (final r in seedRivals()) {
        expect(r.earned, 200.0 * r.closedCount + 600.0 * r.losCount,
            reason: r.name);
      }
    });

    test('las cifras del ranking son las aprobadas en el diseno', () {
      final byName = {for (final r in seedRivals()) r.name: r.earned};
      expect(byName['Marisol Gutierrez'], 25400);
      expect(byName['Diego Fuentes'], 21400);
      expect(byName['Valentina Rios'], 17800);
      expect(byName['Kevin Morales'], 13200);
      expect(byName['Alejandra Pena'], 8200);
    });

    test('hay territorios libres y al menos uno reclamado (escasez real)', () {
      expect(seedTerritories.where((t) => t.isAvailable), hasLength(3));
      expect(seedTerritories.where((t) => !t.isAvailable), hasLength(1));
    });
  });

  group('Semilla creible', () {
    test('el embudo es monotono: leads > pre-approvals > ratified > closed', () {
      for (final lo in seedLos().where((l) => l.stage == Stage.signed)) {
        expect(lo.leads, greaterThan(lo.preApprovals), reason: lo.name);
        expect(lo.preApprovals, greaterThan(lo.ratified), reason: lo.name);
        expect(lo.ratified, greaterThan(lo.closedTotal), reason: lo.name);
      }
    });

    test('el promedio declarado no contradice el historial demostrado', () {
      for (final lo in seedLos().where((l) => l.stage == Stage.signed)) {
        // Tolerancia de medio loan/mes por el redondeo de closedTotal.
        expect((lo.demonstratedRate - lo.avgLoansMonth).abs(), lessThan(0.5),
            reason: '${lo.name}: declara ${lo.avgLoansMonth}/mo pero demuestra '
                '${lo.demonstratedRate.toStringAsFixed(2)}/mo');
      }
    });

    test('las caritas usan las 4 formas y los 5 combos de color', () {
      final los = seedLos();
      expect(los.map((l) => l.avatar.shape).toSet().length, 4);
      expect(los.map((l) => l.avatar.color).toSet().length, 5);
      expect(los.map((l) => l.avatar.face).toSet().length, greaterThanOrEqualTo(6));
    });

    test('cada LO cae en un estado del mapa y tiene costa', () {
      for (final lo in seedLos()) {
        expect(kCoastOf.containsKey(lo.state), isTrue, reason: lo.state);
      }
    });
  });

  group('Paleta P1B', () {
    test('ningun Color(0x...) hardcodeado fuera de tokens.dart', () {
      final offenders = <String>[];
      final re = RegExp(r'Color\(0x[0-9a-fA-F]{8}\)');
      for (final f in Directory('lib').listSync(recursive: true)) {
        if (f is! File || !f.path.endsWith('.dart')) continue;
        // normaliza separadores: en Windows llega 'lib\\core\\tokens.dart'
        if (f.path.replaceAll(r'\', '/').endsWith('core/tokens.dart')) continue;
        for (final m in re.allMatches(f.readAsStringSync())) {
          offenders.add('${f.path}: ${m.group(0)}');
        }
      }
      expect(offenders, isEmpty,
          reason: 'Todo color vive en tokens.dart:\n${offenders.join('\n')}');
    });
  });
}
