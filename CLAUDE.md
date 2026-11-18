# JoinSi by HOMESÍ — canon operativo

> **Lee esto completo antes de tocar una sola línea.** Este archivo no es documentación
> descriptiva: es el contrato del proyecto. Lo que aquí está marcado como CANON ya fue
> decidido y aprobado por el Director (Fernando Orduz). **No se reinterpreta, no se
> "mejora", no se propone alternativa** salvo que él lo pida explícitamente.

---

## 0 · LO PRIMERO QUE DEBES HACER AL DESPERTAR

**Pídele a Fernando los assets de marca antes de construir cualquier pantalla que los use.**
Él los va a entregar perfeccionados. No están en el repo y **no deben inventarse ni sustituirse
por placeholders tratados como definitivos**:

- `logo_oficial_transparente.png` — la casa en círculo rojo, 512×512 con alpha → va en `Code/joinsi_app/assets/brand/`
- Intro 1: `INTRO_Logo_HOMESI_Animado__2_.html` — wordmark animado, capturar a 1920×1080
- Intro 2: animación del logo casa
- Videos V0–V4 (sprint A5) y los ~48 clips de audio del árbol de llamada (sprint A5)

Si falta el logo, la app corre igual con un ícono de respaldo — eso es tolerable para
desarrollar, **no para una demo**. Pídelos, no los improvises.

---

## 1 · QUÉ ES ESTE PRODUCTO

**JoinSi by HOMESÍ** es una app **nativa Android (Flutter → APK sideload)**: un prototipo de
alta fidelidad, con funcionalidad aparente y datos locales, **sin backend**.

**Su propósito:** empaqueta el conocimiento de la reclutadora (María Teresa) para fabricar
**reclutadores externos virales** de Loan Officers del nicho latino. El prototipo es la semilla
del producto real — **el código Flutter no se bota.**

**El modelo de negocio del usuario de la app** (esto es lo que la app tiene que hacer *sentir*):
recibe MQLs de Loan Officers desde HOMESÍ → prospecta (pre-funnel social + llamadas + playbook)
→ el LO firma → cuando ese LO cierra sus dos primeros closed loans, el reclutador cobra
**$500 + $500**, y después **$200 por caso durante 12 meses**. El portafolio se apila.

**Aprobado por Jorge. No requiere venderse internamente.** No hay que justificar el producto:
hay que construirlo.

---

## 2 · CANON — DECISIONES CERRADAS (Acta A0, gate resuelto)

| # | Decisión | Resolución canónica |
|---|---|---|
| 1 | Nombre | **JoinSi by HOMESÍ**. Identidad de tribu propia. **Nunca** "app de empleados" |
| 2 | Idioma | Bilingüe ES/EN con toggle en vivo. **Los términos de industria SIEMPRE en inglés**: Loan Officer, pre-approval, ratified, closed loan, pricing, pipeline, override, NMLS, bps |
| 3 | Assets | 5 videos reales (V0 landing + V1–V4 training) + 1 audio demo. Resto placeholder. Todos los videos abren con los dos intros oficiales |
| 4 | Simulador de llamada | **Audio ramificado pre-generado con voz AI.** Conversación viva (Gemini Live) es **post-MVP** — decisión cerrada, no reabrir |
| 5 | Secuencia | Andamiaje → Zona 3 (Portafolio) → Zona 2 (Radar) → Zona 1 (Academia) |
| 6 | Escalera de estatus | **SiPartner** (medalla casa BRONCE) → **SiFounder** (PLATA, recluta SiPartners) → **SiBroker** (ORO, territorios exclusivos + override de red) |
| 7 | Compensación | **$500 + $500** por los dos primeros closed loans del LO reclutado; **$200/caso durante 12 meses**. Comp del LO: **225 bps** sobre loan amount, incluye Core Service HOMESÍ 90 días |
| 8 | Stack | Flutter (Android nativo, APK sideload) + Hive local. **Sin backend en el prototipo.** Stitch = referencia visual. Figma = eliminado del flow |

### Reglas de nombres — no negociables
- **SiRadar NUNCA se llama CRM.** Es el Radar.
- Las tres zonas son **SiAcademy**, **SiRadar**, **SiPortfolio**.
- *"Powered by Supreme Lending"* aparece **solo en el lockup del logo** (splash y header). **Jamás** en copy de contenido.
- Tagline: *"We say **SÍ** when others say no."* — el SÍ siempre en amarillo Latin Mornings.

---

## 3 · CANON VISUAL — subordinado al P1B Sistema de Marca HOMESÍ

**Toda decisión visual se define en `lib/core/tokens.dart`. Nada de colores, tamaños ni
tipografías sueltas en los widgets.** El guardarraíl de tests falla a propósito si aparece un
`Color(0x...)` fuera de `tokens.dart`.

### Paleta (prohibido cualquier color fuera de esta lista)

| Nombre | HEX | Rol |
|---|---|---|
| Enriching Skies | `#001A40` | Autoridad: títulos, texto, fondos oscuros |
| Warm Embrace | `#FF4040` | La marca y lo que importa: CTAs, acentos, nodos activos |
| Light Sky | `#A6DEFF` | Respiro: fondos suaves, chips, texto sobre navy |
| Latin Mornings | `#F8C845` | El "SÍ", dinero, celebración, estado activo |
| New Day | `#FCFCFA` | El lienzo |

Neutros autorizados, uso restringido: `#E8EAF0` (solo columna competidor/disabled) · `#6B7280` (texto) · `#E5E7EB` (hairline).

**Excepción ratificada (APROBADO A0):** metales de estatus bronce `#B0793A`, plata `#B9C2CC`,
oro `#D9A93D` — **exclusivamente** en las medallas-casa SiPartner/SiFounder/SiBroker. Nunca como
color de marca, texto, fondo ni acento.

**Gráficas:** usar la paleta de datos validada, **no** los colores de marca como series.
Claro `#1E5AA8 · #E23B3B · #6B4EA8 · #12876B · #B87A00` · Oscuro `#4A86D6 · #D64C4C · #8A73D1 · #17906F · #B98418`.

### Tipografía
Poppins 700/800 (headlines y numerales de dinero; sustituto declarado de Articulat CF) ·
Barlow Bold (H2/H3) · Inter 400–700 (cuerpo y cifras, tabular alineadas a la derecha) ·
Kalam (notas manuscritas — **condimento, no ingrediente**).
**Cero Playfair. Cero Outfit. Paleta sand/gold anulada.**

### Prohibiciones duras
- Texto **blanco sobre amarillo o light sky** — prohibido. Rojo sobre New Day solo ≥24px bold. Blanco sobre rojo solo ≥18px bold.
- El **chevrón NO es el logo** — es el ícono "Growth". El logo primario es la casa en círculo rojo.
- Prohibido redibujar, deformar, rotar o poner sombras/degradados sobre el logo.
- Espaciados **solo** base-4: `4 · 8 · 12 · 16 · 24 · 32 · 48 · 64 · 96 · 128`.
- Radios: 8 chips · 16 tarjetas · 24 contenedores · 999 (pill) botones y avatares.
- Sombras **siempre navy translúcido**, jamás negro.
- Movimiento: easing `cubic-bezier(.22,1,.36,1)`, 200/320/1000ms. **Nada rebota, nada parpadea.**
- Prohibido: doble eje Y, rainbow, 3D, donas >3 porciones, mezclar los dos sistemas de íconos, rostros recortados por encuadre, poesía corporativa, solemnidad, relleno.

**Arquetipo de voz:** *Local Hero* — el vecino experto que por fin te dice que sí.
La app **no puede sentirse corporativa ni fría**. Voz de tutor sabio en todos los textos.

---

## 4 · ESTADO ACTUAL Y RUTA

| Sprint | Entregable | Estado |
|---|---|---|
| A0 | Acta, árbol de 27 pantallas, design system | ✅ |
| A1 | Prompts Stitch + briefs de video + árbol de voces | ✅ |
| A2 | Andamiaje Flutter | ✅ |
| A3 | **SiPortfolio completo** (6 pantallas + Ranking) | ✅ código, rediseñado en A3-R2 sobre el Stitch aprobado · ⏳ falta el `APROBADO A3` de Fernando con el APK del link público (§6) |
| A3.1 | Higiene del repo: LF con `.gitattributes`, `withValues`, `pubspec.lock` versionado, docs del CEO, APK público, JDK 21 | ✅ commits `0b83b7a` a `a9df04e` · `flutter analyze` sin issues · 18/18 tests · run `44244390598` verde |
| **A4** | **SiRadar** con el **Funnel de Nurturing** (`Docs/JOINSI_Canon_Funnel_Nurturing_Prospectos.md`, **reemplaza el pipeline de 8 etapas y el `enum Stage`**): nodos A–E / F–G / N30-N60-N90, máximo 20 prospectos vivos, inactivar exige SQL + nota, lanzador de llamada, playbook contextual, pre-funnel social, centro de alertas | ← **SIGUIENTE**: el CEO de producto escribe `Docs/specs/SPEC_A4_SiRadar.md` y Fernando la aprueba. **No construyas A4 antes** |
| A5 | SiAcademy: player V0–V4, simulador de objeciones, árbol de llamada (48 clips), time blocking, Tamagotchi, graduación | pendiente |
| A6 | Onboarding P00–P03, pulido, gamificación transversal, APK firmado | pendiente |

El árbol completo de las 27 pantallas está en `Docs/JOINSI_A0_Acta_y_Arquitectura_v1-1.md` §3.
**No inventes pantallas ni cambies IDs.**

---

## 5 · ESTRUCTURA DEL REPO

El código vivo está en **`Code/joinsi_app/`**. En la raíz hay una copia **legacy** de `lib/` y
`assets/` de la fase A2, más `joinsi_app_A2.zip`: es el estado anterior, no basura.
**No la borres sin autorización del Director.**

**Este repo versiona SOLO `lib/`, `test/`, `assets/` y `pubspec.yaml`.**
No existen carpetas `android/` ni `ios/` y **eso es intencional**: el workflow de GitHub Actions
las genera con `flutter create` en cada build. Que no estén **no es un error y no hay que
arreglarlo**.

`lib/data/usa_map_data.dart` es **generado** (proyección AlbersUSA de `us-atlas@3`, dominio
público, simplificada con Ramer–Douglas–Peucker a ~2.275 puntos). No editar a mano.

**Reset de datos:** la semilla está versionada en `Store._seedVersion`. Subir esa constante
resiembra el box en la próxima apertura — no hay que desinstalar la app.

---

## 6 · VERIFICACIÓN OBLIGATORIA ANTES DE DAR ALGO POR TERMINADO

```bash
cd Code/joinsi_app
flutter analyze       # BLOQUEANTE
flutter test
```

> **`flutter analyze` es bloqueante y no es opcional.** `flutter test` solo construye el test y
> lo que este importa: puedes tener el guardarraíl del canon en verde y la app rota.
> `test/compiles_test.dart` importa todas las librerías de `lib/` justamente para cerrar ese hueco,
> pero **analyze sigue siendo obligatorio.**

`test/canon_test.dart` **falla a propósito** si alguien:
- rompe la regla de compensación ($500 + $500, luego $200),
- invierte el embudo de la semilla,
- deja un LO declarando un promedio que su historial no respalda,
- mete un `Color(0x...)` fuera de `lib/core/tokens.dart`.

**Si ese test falla, lo que se rompió es el modelo de negocio, no el código.** Repórtalo así y
para. No lo "ajustes" para que pase.

Build del APK: `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk`.
Requiere **Flutter ≥ 3.44 (Dart ≥ 3.12)**, que es lo que exige el `pubspec.lock` versionado (el laptop usa Flutter 3.47.5). El CI compila Android con **JDK 21**: Flutter 3.47 ya no compila con JDK 17.

**APK para el celular:** cada push a `main` publica el build en un Release de tag fijo `apk-latest`. El link no cambia y se baja sin login:
https://github.com/ferorduz1/joinsi-app/releases/download/apk-latest/app-release.apk
El repo es público: cualquiera con el link puede bajar el APK.

---

## 7 · GOBERNANZA — cómo se trabaja aquí

- **Roles.** El CEO de producto y arquitecto (chat JoinSi #N, proyecto claude.ai "JoinSi · CEO de producto") escribe `Docs/`, este archivo y las tareas en `Docs/prompts/`. El constructor (Claude Code) ejecuta esas tareas, escribe el código y commitea. **No edites `Docs/` ni este archivo salvo que una tarea lo ordene.** Método completo: `Docs/00_METODO_DE_TRABAJO.md`.
- **Commit de los documentos del CEO.** Al empezar cualquier tarea, si `git status` muestra cambios en `Docs/` o en este archivo que tú no hiciste, commitéalos primero tal cual, sin editarlos, con el mensaje `docs: actualización del CEO de producto`.
- **Gates.** Cada sprint cierra con un `APROBADO A-N` explícito del Director. Sin eso, no se avanza al siguiente.
- **Pausa socrática: máximo 5 preguntas, cada una con un default propuesto.** No interrogatorios.
- **Las correcciones del Director son canon inmediato**, sin discusión ni re-litigio.
- **Cirugía sobre lo aprobado, nunca redibujar.** Si algo ya fue aprobado, se opera puntualmente; no se rehace "mejor".
- **Camera-ready siempre.** Nada a medias presentado como entregable.
- **Las cifras financieras se leen en vivo de la fuente, nunca de memoria.**
- El Director trabaja **mobile-first, por voz a texto**: espera mensajes cortos, a veces con erratas. Interpreta la intención, no la ortografía.

---

## 8 · FUENTES DE VERDAD (léelas, no las resumas de memoria)

| Archivo | Qué contiene |
|---|---|
| `Docs/JOINSI_A0_Acta_y_Arquitectura_v1-1.md` | Acta de decisiones + árbol de 27 pantallas + design system completo |
| `Docs/JOINSI_Memoria_LTM_Proyecto.md` | Memoria larga: modelo de negocio, zonas, estado por sprint |
| `Docs/JOINSI_Sistema_Grafismos_Video.md` | Sistema de grafismos para las piezas de video |
| `Docs/00_METODO_DE_TRABAJO.md` | Roles, ciclo de co-diseño → spec → prompt → construcción → gate, plantillas y ritual de relevo |
| `Docs/00_LEEME_ARRANQUE_ARQUITECTO.md` | Arranque del CEO de producto y arquitecto |
| `Docs/specs/` | Specs de cada funcionalidad (BORRADOR · EN DISCUSIÓN · APROBADA). **Solo construyes specs APROBADAS** |
| `Docs/prompts/` | Tus tareas. Se ejecutan con "Lee y ejecuta Docs/prompts/…" |
| `Docs/relevos/` | Notas de entrega entre chats del CEO |
| `Docs/JOINSI_Contexto_HOMESI.md` | Contexto de negocio de HOMESÍ con fecha por dato |
| `Docs/P1B_Sistema_de_Marca_HOMESI_Oficial.md` | Sistema de marca completo (fuente visual) |
| `Docs/JOINSI_Bitacora_de_Decisiones.md` | Qué se decidió, cuándo y por qué |
| `Docs/JOINSI_Filosofia_y_Journey.md` | Idea, propuesta de valor y journey de SiPartner, prospecto y reclutado |
| `Docs/JOINSI_Canon_Funnel_Nurturing_Prospectos.md` | Canon del funnel que construye A4 |
| `Docs/JOINSI_A3_Rediseno_Stitch_SiPortfolio.md` | Lógica de diseño (Fable 5), STYLE SYSTEM para Stitch y prompts ST-07–ST-12 |
| `Docs/JOINSI_A1_Prompts_Stitch_Higgsfield_Voces.md` | Prompts Stitch, briefs V0–V4, árbol de voces de "Carlos Mendoza" |
| `Code/joinsi_app/README_BUILD.md` | Cómo compilar el APK y qué protege cada test |

**Ante cualquier conflicto entre este archivo y los documentos de `Docs/`, mandan los documentos
de `Docs/` — y ante la duda, se le pregunta al Director. Nunca se resuelve inventando.**
