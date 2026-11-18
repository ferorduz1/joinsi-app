# REPORTE DEL CONSTRUCTOR · 2026-11-18
**De:** Claude Code en `C:\Joinsi` (constructor) · **Para:** CEO de producto y arquitecto, JoinSi #3 en adelante
**Pedido por:** Fernando, para que el arquitecto vea lo que el puente de Cowork no ve.
**Estado del repo al escribir esto:** `main` en `f7b598b`, sincronizado con `origin/main`, árbol limpio.

> Esta carpeta `Docs/constructor/` es nueva. La creé para no editar ningún documento tuyo. Si prefieres otro lugar o integrar esto al método (§2 de `00_METODO_DE_TRABAJO.md`), decídelo tú; yo no la referencio desde ningún otro archivo.

---

## 1 · Lo que no sabes y tienes que registrar

**Fernando dio el "APROBADO A3" el 2026-11-18, en el chat de Claude Code.** Su frase textual, en el mismo mensaje en que ordenó A3.1: *"A,B,C todas si. Aprobado A3, arrancar ejecuta a3.1"*.

Contexto honesto para que lo valores tú:
- Lo dijo **antes** de que existiera el APK público. El build que lo publicó terminó minutos después.
- No me consta que haya instalado ningún APK antes de aprobar. Puede tener el de julio.
- El código que aprobó es A3-R2 sin cambios de producto. Lo único que tocó `lib/` desde julio es el barrido `withOpacity` → `withValues(alpha:)`, con diferencia de alpha menor a 1/255.

`CLAUDE.md` §4 todavía dice "⏳ falta el APROBADO A3". La bitácora y la LTM son tuyas: decide si lo registras como gate cerrado o si le pides validarlo con el APK nuevo.

---

## 2 · Lo que tu puente no ve (evidencia directa)

Tu `device_bash` no tiene Flutter ni `gh`. Esto es lo que yo sí veo, verificado hoy:

| Qué | Valor | Cómo lo verifiqué |
|---|---|---|
| `flutter analyze` | `No issues found!` | Corrido antes de cada commit de A3.1 |
| `flutter test` | `+18: All tests passed!` (17 de `canon_test`, 1 de `compiles_test`) | Ídem. La suite pasó 10 de 10 corridas seguidas |
| Flutter local | 3.47.5 · Dart 3.13.4 · en `C:\flutter` | `flutter --version` |
| **Flutter del CI** | **3.50.0** | Log del run `44244390598` |
| Último build | run `44244390598`, `success`, 4 min 27 s, commit `a9df04e` | `gh run view` del run individual, no de la lista |
| APK público | `apk-latest`, 49.712.177 bytes, responde `HTTP 200` sin credenciales | `gh release view` + `curl` sin login |
| `gh` | autenticado como `ferorduz1` | `gh auth status` |
| Android SDK local | **no existe**. Android Studio está instalado pero su asistente nunca corrió | `flutter doctor -v` |

**Riesgo nuevo: el APK no sale del Flutter con el que se prueba.** El workflow usa `channel: stable` sin versión fija, así que cada build trae el Flutter vigente ese día. Así se rompió el build el 18-nov (Flutter nuevo exigió JDK 21) y puede volver a pasar sin que nadie toque el repo. Ver la decisión D1 en §5.

---

## 3 · Lo que hice desde la migración

| Commit | Qué | Por qué |
|---|---|---|
| `0b83b7a` | docs del CEO, tal cual | Regla §7. Fernando pidió "commit ahora mismo" **antes** de que yo leyera el prompt A3.1, por eso entró con el mensaje de §7 y no con el del paso 3 |
| `5bcc2f3` | `compiles_test.dart` estable | Ver §4 |
| `10be77b` | `.gitattributes`, LF | A3.1 paso 1. El índice ya era LF: el renormalize no cambió nada más |
| `10dd1b2` | `pubspec.lock` versionado | A3.1 paso 2, decisión b de Fernando |
| `9ab6638` | `withOpacity` → `withValues(alpha:)` | A3.1 paso 4, decisión a. 32 ocurrencias en **10** archivos (no 12) |
| `5c77fe3` | A1 movido a `Docs/` con `git mv` | A3.1 paso 5 |
| `3ae738c` | APK público `apk-latest` | Decisión c de Fernando. **Tu prompt A3.1 decía no tocar `build-apk_NUEVO.yml`**; Fernando lo autorizó en el mismo mensaje, así que lo hice en commit aparte. Lo moví encima del workflow vigente para que no corran dos builds por push |
| `a9df04e` | JDK 17 → 21 en el CI | El build de `5bcc2f3` falló: `NoSuchMethodError: List.removeLast()`, que es API de Java 21, en el lint de `image_picker_android` |
| `f7b598b` | tus cambios del 18-nov, tal cual | Regla §7 |

**Autores en el historial.** Hay dos correos: `Fernando <forduz1@gmail.com>` (5 commits, laptop viejo) y `Fernando <ferorduz1@gmail.com>` (9 commits, laptop nuevo). Es la misma persona: en el laptop nuevo dejé el correo de su cuenta real de GitHub. **No es contaminación.** Si quieres un solo correo, es decisión de Fernando.

---

## 4 · Una lección técnica que no debe perderse

`compiles_test.dart` falló de forma intermitente (1 de cada 8 corridas). Causa: los estilos de `theme.dart` llaman a `google_fonts`, que descarga la fuente por HTTP **sin esperar el resultado**. El test bloquea la red, la descarga falla después de que el test terminó, y el rojo dependía del reloj. Lo resolví referenciando las funciones de estilo sin llamarlas.

**Regla para cualquier test futuro, incluidos los de A4:** ningún test puede ejecutar funciones de `theme.dart` ni construir widgets que las usen, salvo que se mockee `google_fonts`. Si la spec de A4 pide tests de widgets (no solo de modelo), tiene que decir cómo se cargan las fuentes, o esos tests nacen intermitentes.

---

## 5 · Decisiones que te tocan (cada una con mi default)

| # | Decisión | Default del constructor |
|---|---|---|
| **D1** | Fijar la versión de Flutter del CI | **Sí, a la misma del laptop (3.47.5)**, con `flutter-version` en el workflow, y subir ambas a la vez cuando se decida. Así lo que pruebo es lo que se instala. El cambio es en `.github/workflows/`, que tu puente no puede escribir: dame la orden en un prompt |
| **D2** | ¿Esta carpeta `Docs/constructor/` se queda? | Sí, como el lugar donde el constructor te deja reportes largos. Los reportes cortos siguen en el chat |
| **D3** | Gate A3 | Ver §1. Es tuyo y de Fernando |

Los insumos para la spec de A4 están en `INSUMOS_A4_para_la_spec.md`, en esta misma carpeta.

---

## 6 · Pendientes que no son míos

- **Fernando:** abrir Android Studio una vez (asistente Standard, más *Android SDK Command-line Tools* en SDK Manager) y correr `flutter doctor --android-licenses`. Sin eso no hay `flutter run` en vivo, y A4 se desarrollaría a ciegas, con un APK de CI cada 5 minutos por cambio.
- **Fernando:** el logo `logo_oficial_transparente.png`. No bloquea A4 funcional; bloquea cualquier demo.
- **Arquitecto:** la spec `Docs/specs/SPEC_A4_SiRadar.md`. Yo no construyo nada de A4 hasta que esté `APROBADA`.
