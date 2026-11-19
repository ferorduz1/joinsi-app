# PROMPT A3-2 · Fijar la versión de Flutter del CI
**Emitido por:** CEO de producto JoinSi #3 · 2026-11-19
**Origen:** decisión D1 de `Docs/constructor/REPORTE_CONSTRUCTOR_2026-11-18.md` §5, registrada en la bitácora el 2026-11-19. No hay spec: es infraestructura, sin código de producto.

## Reglas
- **Se toca:** `.github/workflows/build-apk.yml`, `Code/joinsi_app/pubspec.yaml` (solo el bloque `environment`), `Code/joinsi_app/pubspec.lock` (solo lo que regenere `flutter pub get`) y `Code/joinsi_app/README_BUILD.md` §1.
- **No se toca:** `lib/`, `test/`, `CLAUDE.md`, `Docs/` (salvo el commit de la regla §7), la versión de JDK (sigue en 21), ninguna dependencia.
- Un commit por tema. `flutter analyze` en 0 issues y `flutter test` en verde antes de cada commit.

## Contexto
El workflow usa `channel: stable` sin versión. El último APK salió de Flutter 3.50.0 y tú pruebas con 3.47.5: lo que se instala no es lo que se prueba, y un Flutter nuevo puede romper el build sin que nadie toque el repo (ya pasó con JDK 21). Además, el APK de A4.1 es el que Fernando usará para la revisión visual de A3: tiene que salir del mismo Flutter con que corren los tests.

Decisión: **una sola fuente de la versión, en el repo.** `pubspec.yaml` declara Flutter 3.47.5 y el CI la lee de ahí. Subir de versión será cambiar esa línea, correr analyze y test, y verificar el run.

## Pasos
0. `git status`. Si hay cambios del CEO en `Docs/` o en `CLAUDE.md`, commitéalos primero tal cual (`docs: actualización del CEO de producto`).
1. `flutter --version` en el laptop. Si no es 3.47.5, para y reporta.
2. En `pubspec.yaml`, bloque `environment`, agrega debajo de `sdk:` la línea `flutter: 3.47.5` con este comentario encima: *"Única fuente de la versión de Flutter. El CI la lee de aquí (flutter-version-file). Pub solo exige el límite inferior en local: antes de commitear, `flutter --version` debe coincidir. Se sube aquí, y solo aquí, cuando se decida subir ambos."* No cambies la línea `sdk:`.
3. `flutter pub get`. En el `pubspec.lock` solo puede cambiar la sección `sdks`. Si cambia la versión de algún paquete, revierte y para.
4. `flutter analyze` (0 issues) y `flutter test` (18/18).
5. En el workflow, paso "Set up Flutter": reemplaza `channel: stable` por `flutter-version-file: Code/joinsi_app/pubspec.yaml` (ruta desde la raíz del repo, porque `with:` no usa el `working-directory`). Deja `cache: true`. Renombra el paso a *"Set up Flutter (versión fija desde pubspec.yaml)"* y actualiza su comentario. Si `subosito/flutter-action@v2` rechaza la opción, usa `flutter-version: '3.47.5'` y anótalo en el reporte.
6. Después del paso "Flutter version", agrega un paso que **falle si la versión del CI no coincide con la del `pubspec.yaml`**. Por ejemplo, leer la línea `flutter:` indentada del bloque `environment` y compararla con `frameworkVersion` de `flutter --version --machine`. Con la opción de respaldo del paso 5, este chequeo es lo que impide que las dos cifras se separen.
7. `README_BUILD.md` §1: reemplaza "Flutter 3.44 o superior" por "Flutter **3.47.5 exacto**, fijado en `pubspec.yaml`, que es lo que usa el CI", con una línea de cómo se sube (cambiar `environment.flutter`, `pub get`, analyze, test, push y verificar el run). JDK 21 queda igual.
8. Commits sugeridos: `ci: Flutter fijo 3.47.5 leído de pubspec.yaml` (workflow + pubspec + lock) y `docs(build): versión fija de Flutter`. Push a `main`.
9. Verifica **el run individual** (`gh run view <id>`, nunca la lista): el paso "Flutter version" muestra 3.47.5, el paso de verificación pasa, el build termina en `success`, y el Release `apk-latest` quedó con el APK nuevo (fecha del asset posterior al push) y responde `HTTP 200` sin credenciales.
10. Si el build falla con 3.47.5 + JDK 21: no subas Flutter ni cambies JDK por tu cuenta. El Release público se queda con el último APK verde porque se publica después del build. Reporta el error con la línea exacta del log y para.

## Reporte (máximo 12 líneas, en el chat)
Hashes · `flutter --version` local · diff del `pubspec.lock` · salida de analyze y test · id del run, duración y versión de Flutter leída en su log · tamaño del APK y fecha del asset · `git status` · desviaciones. Si encuentras algo que el CEO deba conocer más allá de esto, déjalo en `Docs/constructor/`.

Y para ahí.
