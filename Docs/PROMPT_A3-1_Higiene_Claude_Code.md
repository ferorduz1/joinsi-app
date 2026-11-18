# PROMPT A3.1 · Higiene del repo · para Claude Code (constructor)
**Emitido por:** arquitecto JoinSi #2 · 2026-10-23 · **Carpeta:** `C:\Joinsi`
**Cómo se usa:** Fernando abre Claude Code en `C:\Joinsi` y escribe: *"Lee y ejecuta Docs/PROMPT_A3-1_Higiene_Claude_Code.md"*.

---

## Reglas de esta tarea

- **Sin código de producto.** Lo único que toca `lib/` es el barrido mecánico del paso 4. **No inicies A4.**
- **Un commit por tema**, en el orden de abajo. Antes de cada commit corre `flutter analyze` y `flutter test` desde `Code/joinsi_app`.
- **No edites** los documentos nuevos de `Docs/` ni `CLAUDE.md`: los escribió el arquitecto. Tu trabajo es commitearlos tal cual.
- **No toques** `build-apk_NUEVO.yml`, la carpeta legacy de la raíz (`lib/`, `assets/` salvo el paso 5, `joinsi_app_A2.zip`), ni `ARRANQUE_LAPTOP_NUEVO.md`.
- Si `canon_test.dart` falla en cualquier momento, se rompió el modelo de negocio: **reporta y para**.
- Esta tarea es la excepción a la regla de `CLAUDE.md` §7 que pide commitear primero los documentos del CEO: aquí manda el orden de los pasos de abajo (los documentos entran en el paso 3, ya normalizados).
- Reporta la verdad cruda, con la salida textual de los comandos.

## Contexto que necesitas

El repo guarda los archivos con LF, pero varias copias de trabajo en Windows tienen CRLF, y no hay `.gitattributes` ni `core.autocrlf`. Por eso `git diff` de `compiles_test.dart` muestra ~199 líneas cuando el cambio real son 7. El arquitecto dejó escritos en el working tree: `CLAUDE.md` (editado), `Docs/JOINSI_Memoria_LTM_Proyecto.md` (reemplazado, v3) y cinco documentos nuevos en `Docs/`.

---

## Paso 1 · Normalizar finales de línea (commit 1)

Crea `.gitattributes` en la raíz con este contenido exacto:

```
* text=auto eol=lf
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.webp binary
*.zip binary
*.lnk binary
*.apk binary
*.mp4 binary
*.mp3 binary
*.wav binary
*.ttf binary
*.otf binary
```

Luego:

```
git add .gitattributes
git add --renormalize .
git reset -- CLAUDE.md Docs Code/joinsi_app/test/compiles_test.dart
git diff --cached --ignore-cr-at-eol --stat
```

La última salida **debe mostrar solo `.gitattributes`** (el arquitecto lo simuló sobre una copia del repo el 2026-10-23 y así fue). Si aparece cualquier otro archivo con cambios de contenido, para y repórtalo.
Commit: `chore: .gitattributes y normalizar finales de línea a LF`

## Paso 2 · Test de compatibilidad y lockfile (commit 2)

```
git add Code/joinsi_app/test/compiles_test.dart Code/joinsi_app/pubspec.lock
git diff --cached -w --stat
```

`compiles_test.dart` debe mostrar alrededor de 7 líneas añadidas (el import de `flutter/widgets.dart`, `TestWidgetsFlutterBinding.ensureInitialized()` y sus comentarios).
Commit: `test: compatibilidad con Flutter 3.47 y versionar pubspec.lock`

## Paso 3 · Documentos del arquitecto (commit 3)

```
git add CLAUDE.md Docs
git status
```

Verifica que entre **todo** `Docs/`, incluidas las subcarpetas `specs/`, `relevos/` y `proyecto_claude/`, y `CLAUDE.md`. Son unos 15 archivos del CEO de producto (método, arranque, LTM v3, bitácora, filosofía, contexto HOMESÍ, P1B, canon del funnel, diseño A3, spec del simulador, relevo, instrucciones del proyecto y este prompt), más la normalización de `Docs/JOINSI_A0_Acta_y_Arquitectura_v1-1.md` y `Docs/JOINSI_Sistema_Grafismos_Video.md`.
Commit: `docs: canon y método del CEO de producto para JoinSi #3`

## Paso 4 · Barrido de withOpacity (commit 4)

En `Code/joinsi_app/lib/`, reemplaza cada `.withOpacity(x)` por `.withValues(alpha: x)`. Es un cambio mecánico y visualmente idéntico. No toques nada más en esos archivos.
`flutter analyze` debe quedar en **0 issues** y `flutter test` en verde.
Commit: `refactor: withOpacity a withValues(alpha:) sin cambio visual`

## Paso 5 · Mover la fuente A1 a Docs (commit 5)

```
git mv assets/JOINSI_A1_Prompts_Stitch_Higgsfield_Voces.md Docs/
```

`CLAUDE.md` §8 ya apunta a `Docs/` (lo actualizó el arquitecto). Verifica que no quede ninguna otra referencia a la ruta vieja con `git grep "assets/JOINSI_A1"`.
Commit: `docs: mover A1 a Docs/`

## Paso 6 · Push y build

```
git push
gh run list --workflow "Build JoinSi APK" --limit 1
gh run watch <id_del_run> --exit-status
```

Cuando el run termine en verde, baja el APK **fuera del repo**:

```
gh run download <id_del_run> -n joinsi-app-release -D <Escritorio de Fernando>/JoinSi_APK
```

(Usa la sintaxis de tu shell para la ruta del Escritorio: `$env:USERPROFILE\Desktop` en PowerShell, `$USERPROFILE/Desktop` en Git Bash.)

Este APK contiene A3-R2 más la higiene. Fernando lo instala en su celular para dar el **APROBADO A3**.

## Paso 7 · Reporte (máximo 12 líneas)

1. Los 5 hashes con su mensaje.
2. Salida textual final de `flutter analyze` y `flutter test`.
3. `git status` (debe estar limpio).
4. Id del run de GitHub Actions, estado y duración.
5. Ruta exacta del APK descargado.
6. Cualquier desviación de este prompt y por qué.

**Y para ahí.** A4 no arranca hasta que el arquitecto entregue el plan y Fernando lo apruebe.
