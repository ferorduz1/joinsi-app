import 'package:hive_flutter/hive_flutter.dart';
import '../models/loan_officer.dart';
import 'seed_los.dart';

class Store {
  static late Box _box;

  /// Version del esquema semilla. Al subirla, el box se re-siembra: A3 cambio
  /// la regla del embudo y el calculo de `earned`, y los datos viejos ya no
  /// cumplen el canon.
  static const _seedVersion = 3;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('joinsi');

    if (_box.get('seedVersion') != _seedVersion || !_box.containsKey('los')) {
      await _box.put('los', [for (final lo in seedLos()) lo.toMap()]);
      await _box.put('seedVersion', _seedVersion);
    }
    // Defaults idempotentes: si falta una clave se rellena, sin pisar progreso
    // real del usuario. Antes un getter sobre clave ausente crasheaba el
    // primer frame en un dispositivo con box de un build anterior.
    const defaults = <String, Object>{
      'owedMonth': 2100.0, 'streak': 7, 'academyProgress': 0.62,
    };
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

  /// GANADO: se CALCULA del portafolio, nunca es un literal en el box.
  /// Un numero de dinero hardcodeado que no cuadra con la suma de las fichas
  /// es lo primero que un Branch Manager detecta.
  static double get earnedYear =>
      portfolio().fold<double>(0, (s, l) => s + l.earned);

  /// UNICA cifra de dinero que sigue siendo literal, y a proposito: representa
  /// lo liquidado por HOMESI y aun no desembolsado — un dato que en el producto
  /// real llega del backend de comisiones, no se deriva del portafolio local.
  static double get owedMonth => (_box.get('owedMonth') as num?)?.toDouble() ?? 0;
  static int get streak => (_box.get('streak') as num?)?.toInt() ?? 0;
  static double get academyProgress =>
      (_box.get('academyProgress') as num?)?.toDouble() ?? 0;
}
