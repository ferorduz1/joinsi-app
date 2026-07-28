import 'package:hive_flutter/hive_flutter.dart';
import '../models/loan_officer.dart';
import 'seed_los.dart';

class Store {
  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('joinsi');
    if (!_box.containsKey('seeded')) {
      await _box.put('los', [for (final lo in seedLos()) lo.toMap()]);
      await _box.put('seeded', true);
      await _box.put('earnedYear', 18450.0);
      await _box.put('owedMonth', 2100.0);
      await _box.put('streak', 7);
      await _box.put('academyProgress', 0.62);
    }
  }

  static List<LoanOfficer> los() =>
      [for (final m in (_box.get('los') as List)) LoanOfficer.fromMap(m as Map)];

  static Future<void> saveLos(List<LoanOfficer> list) =>
      _box.put('los', [for (final lo in list) lo.toMap()]);

  static double get earnedYear => _box.get('earnedYear');
  static double get owedMonth => _box.get('owedMonth');
  static int get streak => _box.get('streak');
  static double get academyProgress => _box.get('academyProgress');
}
