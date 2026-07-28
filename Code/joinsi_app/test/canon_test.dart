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
