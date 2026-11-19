# JoinSi by HOMESI — build del APK (sprint A3)

Prototipo Flutter nativo Android, sin backend. Datos locales en Hive.
Se instala por **sideload**: no requiere cuenta de Play Store.

---

## 1 · Requisitos (una sola vez)

- **Flutter 3.47.5 exacto**, fijado en `pubspec.yaml` (`environment.flutter`), que es lo que
  usa el CI. Verifica con `flutter --version`: debe decir 3.47.5.
  Para subir de versión: cambiar `environment.flutter` en `pubspec.yaml`, `flutter pub get`,
  `flutter analyze`, `flutter test`, push y verificar que el run del CI termine en verde.
- Android SDK + **JDK 21** (Flutter 3.47 ya no compila Android con JDK 17). `flutter doctor` te dice qué falta.

> **Sin Android SDK local también hay APK:** cada push a `main` lo compila GitHub Actions y lo publica en un link fijo, descargable desde el celular sin login:
> https://github.com/ferorduz1/joinsi-app/releases/download/apk-latest/app-release.apk

## 2 · Generar el andamiaje Android

Este repo contiene **solo** `lib/`, `test/`, `assets/` y `pubspec.yaml` — el
código que importa. Las carpetas nativas se generan en tu máquina:

```bash
cd joinsi_app
cp -r lib /tmp/joinsi_lib_backup          # flutter create puede pisar main.dart
flutter create --platforms=android --project-name joinsi --org com.homesi .
cp -r /tmp/joinsi_lib_backup/. lib/       # restaura el código tal cual
flutter pub get
```

## 3 · Assets de marca

Deja el logo oficial en `assets/brand/logo_oficial_transparente.png`.
Si falta, el lockup del header cae a un ícono de respaldo y la app igual corre.
Los videos V0–V4 y los 48 clips del árbol de llamada llegan en A5.

## 4 · Verificar antes de compilar

```bash
flutter analyze       # BLOQUEANTE: `flutter test` NO compila la UI
flutter test          # guardarraíl del canon: compensación, semilla y paleta
```

> `flutter test` solo construye el test y lo que este importa. Sin
> `flutter analyze` en verde puedes tener el guardarraíl del canon pasando y la
> app rota. `test/compiles_test.dart` importa todas las librerías de `lib/`
> justamente para cerrar ese hueco.

`test/canon_test.dart` falla a propósito si alguien rompe la regla de
compensación ($500+$500 y luego $200), invierte el embudo de la semilla, deja un
LO declarando un promedio que su historial no respalda, o mete un `Color(0x...)`
fuera de `lib/core/tokens.dart`.

## 5 · Compilar e instalar

```bash
flutter build apk --release
```

El APK queda en `build/app/outputs/flutter-apk/app-release.apk`.
Pásalo al teléfono y ábrelo (hay que permitir "instalar apps de esta fuente").

Para probar en caliente con el teléfono conectado por USB: `flutter run --release`.

---

## Qué trae A3 (zona SiPortfolio)

| Pantalla | Archivo | Qué hace |
|---|---|---|
| P30 Mapa USA | `zones/portfolio/usa_map_screen.dart` | Mapa AlbersUSA interactivo, caritas por LO, pinch/zoom con pines de tamaño constante, filtros con conteo, clave de lectura, estado vacío |
| P31 Ficha 360° | `lo_portfolio_screen.dart` | Embudo, ventana de 12 meses, run-rate demostrado vs declarado |
| P32 Dashboard | `portfolio_home.dart` | Odómetro, COBRAR funcional, accesos a mapa/proyector/negocio |
| P33 Proyector | `projector_screen.dart` | Apilamiento y acantilado del mes 12 |
| P34 Ranking & Escalera | `ranking_screen.dart` | Escalera SiPartner → SiFounder → SiBroker con medallas, ranking al corte, territorios (se abre desde Mi negocio) |
| P35 Mi negocio | `my_business_screen.dart` | Resumen ejecutivo: ganado por estado, tier y costa; LOs activos |
| Caritas | `widgets/carita_avatar.dart`, `avatar_picker.dart` | 8 expresiones × 4 formas × 5 combos, o foto real de la galería |

**Reset de datos:** la semilla está versionada (`Store._seedVersion`). Al subir
esa constante, la próxima apertura vuelve a sembrar el box — no hay que
desinstalar la app.

**Dato de mapa:** `lib/data/usa_map_data.dart` es generado — proyección AlbersUSA
de `us-atlas@3` (dominio público), simplificada con Ramer–Douglas–Peucker a
~2.275 puntos. Alaska y Hawái vienen en los insets propios de la proyección.
