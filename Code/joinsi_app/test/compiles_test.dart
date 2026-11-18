// GUARDARRAIL DE COMPILACION.
// `flutter test` solo construye el test y lo que este importa: canon_test.dart
// podia pasar en verde con la UI entera rota. Este archivo importa TODAS las
// librerias de lib/, asi que el analizador y el compilador de tests recorren el
// arbol completo. Si algo no compila, `flutter test` se cae aqui.
//
// Al agregar un archivo nuevo a lib/, agregalo tambien a esta lista.
// Flutter 3.47 dejo de re-exportar widgets.dart desde flutter_test: sin este
// import, los `const SizedBox()` de abajo no resuelven y el test no carga.
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:joinsi/main.dart' show JoinSiApp;  // 'show': evita chocar con el main() del test
import 'package:joinsi/shell.dart';
import 'package:joinsi/core/tokens.dart';
import 'package:joinsi/core/theme.dart';
import 'package:joinsi/core/i18n.dart';
import 'package:joinsi/models/loan_officer.dart';
import 'package:joinsi/data/store.dart';
import 'package:joinsi/data/seed_los.dart';
import 'package:joinsi/data/usa_map_data.dart';
import 'package:joinsi/widgets/carita_avatar.dart';
import 'package:joinsi/widgets/avatar_picker.dart';
import 'package:joinsi/widgets/medalla_casa.dart';
import 'package:joinsi/widgets/common.dart';
import 'package:joinsi/zones/academy/academy_home.dart';
import 'package:joinsi/zones/radar/radar_home.dart';
import 'package:joinsi/zones/portfolio/portfolio_home.dart';
import 'package:joinsi/zones/portfolio/usa_map_screen.dart';
import 'package:joinsi/zones/portfolio/lo_portfolio_screen.dart';
import 'package:joinsi/zones/portfolio/projector_screen.dart';
import 'package:joinsi/zones/portfolio/my_business_screen.dart';
import 'package:joinsi/zones/portfolio/ranking_screen.dart';

void main() {
  test('todo lib/ compila y sus tipos publicos existen', () {
    // Tocar un simbolo de cada libreria evita que el tree-shaking del analizador
    // marque los imports como no usados.
    //
    // Los estilos de theme.dart se REFERENCIAN, no se llaman: llamarlos dispara
    // google_fonts, que descarga la fuente por HTTP sin esperar el resultado.
    // El test bloquea la red, la descarga falla despues de que el test termino,
    // y el rojo sale o no segun el reloj (1 de cada 8 corridas, nov-2026).
    expect(const JoinSiApp(), isNotNull);
    expect(const Shell(), isNotNull);
    expect(T.navy, isNotNull);
    expect(joinSiTheme, isNotNull);
    expect(moneyStyle, isNotNull);
    expect(moneyOnLight, isNotNull);
    expect(l10n, isNotNull);
    expect(Tier.values.length, 3);
    expect(Stage.values.length, 8);
    expect(kPrograms, isNotEmpty);
    expect(kCoastOf, isNotEmpty);
    expect(seedLos(), hasLength(24));
    expect(Store.portfolio, isNotNull);
    expect(kStatePolygons.length, 51);
    expect(kStateCentroids.length, 51);
    expect(kUsaMapW, 975);
    expect(kUsaMapH, 610);
    expect(kAvatarCombos, hasLength(5));
    expect(const CaritaAvatar(spec: AvatarSpec(face: 0, shape: 0, color: 0)),
        isNotNull);
    expect(showAvatarPicker, isNotNull);
    expect(const MedallaCasa(metal: T.bronze), isNotNull);
    expect(const TierChip(tier: Tier.top), isNotNull);
    expect(const MoneyPill(amount: 0), isNotNull);
    expect(tierLabel(Tier.top), 'Top');
    expect(stageLabel(Stage.signed), isNotEmpty);
    expect(promiseLabel('callTuesday'), isNotEmpty);
    expect(const AcademyHome(), isNotNull);
    expect(const RadarHome(), isNotNull);
    expect(const PortfolioHome(), isNotNull);
    expect(const UsaMapScreen(), isNotNull);
    expect(const LoPortfolioScreen(loId: 'lo01'), isNotNull);
    expect(const ProjectorScreen(), isNotNull);
    expect(const MyBusinessScreen(), isNotNull);
    expect(const RankingScreen(), isNotNull);
    // Primitivas de composicion nuevas de A3-R2: si alguna desaparece, media
    // app deja de compilar y este test lo dice antes que el build de release.
    expect(const HeroNavy(child: SizedBox()), isNotNull);
    expect(const WhiteCard(child: SizedBox()), isNotNull);
    expect(const Kicker('X'), isNotNull);
    expect(const SectionTitle('X'), isNotNull);
    expect(const ActivityDot(), isNotNull);
    expect(const ActivityChip(active: true), isNotNull);
    expect(const DataChip('X'), isNotNull);
    expect(const RedPill(label: 'X'), isNotNull);
    expect(const GoldenRuleCallout(kicker: 'K', body: 'B'), isNotNull);
    expect(const WindowTrack(monthOf12: 5), isNotNull);
    expect(const BarRow(label: 'X', value: 1, max: 2, valueText: 'y'),
        isNotNull);
    expect(sectionTitleStyle, isNotNull);
    expect(kickerStyle, isNotNull);
    expect(dataStyle, isNotNull);
    expect(headlineOnNavy, isNotNull);
    expect(seedRivals(), hasLength(5));
    expect(seedTerritories, hasLength(4));
    expect(Store.ranking, isNotNull);
    expect(LadderReq.siFounderLos, 8);
    expect(Activity.values.length, 2);
    expect(cutLabel(DateTime(2026, 8, 15)), isNotEmpty);
  });
}
