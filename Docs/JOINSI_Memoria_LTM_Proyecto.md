# JOINSI by HOMESÍ · MEMORIA DE PROYECTO (LTM) v3
**Corte:** 2026-11-18 (A3.1 cerrado) · **Escrita por:** CEO de producto y arquitecto, chat JoinSi #2, para despertar a JoinSi #3
**Reemplaza:** la LTM del 2026-07-27 (decía "Siguiente: A3") y la LTM v2 del 2026-07-29 que vivía solo en la memoria del proyecto claude.ai.
**Regla:** esta carpeta `Docs/` del repo es la fuente de verdad del canon. Desde el 2026-10-27 las conversaciones de diseño viven en el proyecto claude.ai "JoinSi · CEO de producto" (instrucciones en `Docs/proyecto_claude/`). El proyecto CEO Agéntico solo guarda un puntero.

---

## 0 · ESTADO VERIFICADO (2026-10-23, de primera mano en C:\Joinsi)

| Tema | Estado |
|---|---|
| Sprints cerrados | A0, A1, A2, A3 (con A3-R y A3-R2) y **A3.1**. A4 sin una línea de código |
| Gate A3 | El canon marca A3 ✅. **No consta un "APROBADO A3" de Fernando tras instalar el APK de A3-R2 en su celular.** Confirmarlo es la primera pregunta de JoinSi #3 |
| Repo | `ferorduz1/joinsi-app`, rama `main`, limpio y sincronizado. Último commit de producto: `4f855ed` (A3-R2). A3.1: `0b83b7a` a `a9df04e` (8 commits, sin código de producto salvo el barrido `withValues`) |
| Working tree | Limpio. `.gitattributes` normaliza todo a LF. `pubspec.lock` versionado |
| Calidad | `flutter analyze`: **sin issues** (primera vez en el proyecto). `flutter test`: 18/18 verdes (17 de `canon_test.dart`) |
| Entorno | Laptop `cl-hb0rl64`, Windows. Flutter 3.47.5, `gh` autenticado como ferorduz1. Android SDK no configurado (pendiente de Fernando: abrir Android Studio una vez). El lock exige Flutter ≥ 3.44 / Dart ≥ 3.12 |
| Pantallas | 6 de 27 completas (SiPortfolio P30–P35) + 2 stubs (academy_home, radar_home con botones `onPressed: () {}`) |
| Assets | Faltan todos: logo oficial, intros 1 y 2, videos V0–V4, ~48 clips de Carlos Mendoza, audio demo |
| CI | `.github/workflows/build-apk.yml` con **JDK 21** (con JDK 17 el build se había roto solo al subir Flutter). Cada push a `main` sube el artifact y publica el Release `apk-latest`. Último run: `44244390598`, verde en 4m27s. APK de 47 MB |
| APK y repo públicos | Link fijo sin login: https://github.com/ferorduz1/joinsi-app/releases/download/apk-latest/app-release.apk · El repo sigue **público**: el canon, la Memoria, las cifras de compensación y el APK son accesibles para cualquiera |

## 1 · QUÉ ES JOINSI

App **nativa Android (Flutter → APK sideload)**, prototipo de alta fidelidad con datos locales (Hive) y **sin backend**. Empaqueta el conocimiento de la reclutadora (María Teresa) para fabricar **reclutadores externos** de Loan Officers del nicho latino: los **SiPartners**. Aprobada por Jorge. El código es la semilla del producto real.

**Por qué existe (contexto de negocio):** el reclutamiento de LOs con un reclutador de salario fijo no rindió (EE. UU. primero, offshore después). Jorge bajó los márgenes de la división para que el LO gane más, lo que exige volumen. JoinSi convierte ese costo fijo en una fuerza distribuida de costo variable: el SiPartner cobra solo cuando su LO cierra. La forma del pago copia el bono de la reclutadora offshore (premio alto en los dos primeros cierres de cada LO, luego tarifa menor durante 12 meses).

**Economía del SiPartner (canon, protegida por `canon_test.dart`):** `payoutFor(closed)`: 0 → $0 · 1 → $500 · 2 → $1,000 · n≥2 → $1,000 + (n−2)×$200, durante 12 meses por LO. La firma no paga: paga el primer cierre.
**Escalera:** SiPartner (bronce) → SiFounder (plata: 8 LOs + 1 SiPartner reclutado) → SiBroker (oro: 100 closed + territorio exclusivo + override de red, override sin cifra definida).
**Compensación del LO:** el Acta A0 dice 225 bps ($6,750 en un loan de $300K) con Core Service 90 días. La oferta que Fernando describió en octubre de 2026 dice 275 bps completos para el LO y un fee plano de US$650 por caso cerrado para HOMESÍ. **Conflicto abierto:** ver §9.

## 2 · LAS TRES PERSONAS

- **SiPartner:** usuario de la app. Estudiante bilingüe, joven, sin experiencia hipotecaria, que nunca ha tenido un activo.
- **Prospecto:** Loan Officer licenciado (boutique o mid volume del mercado latino) que el SiPartner contacta. Nunca abre JoinSi.
- **Reclutado:** el LO firmado. Para HOMESÍ es cliente y empresario. En la app del SiPartner aparece como un activo de su portafolio. El LO nunca ve esa vista.

Narrativa completa: `Docs/JOINSI_Filosofia_y_Journey.md`.

## 3 · ZONAS Y PANTALLAS (árbol de 27 en el Acta A0 §3, IDs inmutables)

- **Zona 0 · Umbral (P00–P03):** splash, landing con V0, onboarding de 3 láminas, registro. Sprint A6.
- **SiAcademy (P10–P17):** camino tipo Duolingo, 4 videos con quiz, simulador de objeciones (LAER), simulador de llamada (árbol de audio de Carlos Mendoza), time blocking, Tamagotchi de leads, examen, graduación. Sprint A5.
- **SiRadar (P20–P26):** nunca "CRM". Fichas MQL, ficha 360°, **Funnel de Nurturing (reemplaza P22)**, lanzador de llamada, playbook contextual, pre-funnel social, alertas. Sprint A4.
- **SiPortfolio (P30–P35):** construida y rediseñada sobre Stitch. P34 y P35 son pantallas distintas y **no se vuelven a fusionar**.
- **Transversal (P40–P41):** ajustes y notificaciones.

## 4 · SEMÁNTICA DEL PORTAFOLIO (decisión de Fernando, vinculante)

1. Los LOs son un **activo financiero** del SiPartner: SiPortfolio se lee como un portafolio tipo brokerage.
2. Cada LO tiene **estado de actividad**: enviando casos o sin casos este mes. Es derivado, nunca almacenado.
3. El dinero tiene **tres estados**: causado (solo crece) = cobrado + en camino. "En camino" son casos cerrados que se pagan al corte cada 30 días (pay period 2).
4. Agregaciones por LO y por grupo (estado, tier, costa, programa).

## 5 · FUNNEL DE NURTURING DE PROSPECTOS (canon decidido, insumo de A4)

Documento completo: `Docs/JOINSI_Canon_Funnel_Nurturing_Prospectos.md`. Resumen: una pantalla con un tren de nodos por prospecto vivo (**máximo 20**). Nodos que controla el SiPartner: **A** post social · **B** DM con pitch · **C** cold call 1 · **D** cold call 2 · **E** SQL (formulario real). Nodos de solo lectura que mueve HOMESÍ: **F** reunión con el Director de Producción · **G** firma. Nurturing a **N30/N60/N90** días. Inactivar un prospecto lo devuelve a HOMESÍ y exige **SQL + nota con la razón**. El tablero mide al SiPartner solo por A–E. **El `enum Stage` de 8 etapas se retira** y pasa a ser derivado.

**Nurturing post-firma (backlog, no ejecutar sin decisión):** chat mensual, visita semanal al dashboard del LO, escalación a business plan tras 30 días sin ratificados, chat mensual de conocimiento. Check "hecho offline" + ícono de salud. Comparte componentes con el funnel.

## 6 · CANON VISUAL Y LÓGICA DE DISEÑO

- Manda el **P1B** (resumen operativo en `CLAUDE.md` §3). Logo = casa en círculo rojo. Poppins + Barlow + Inter + Kalam. Paleta de 5 colores + 3 neutros. Metales solo en `MedallaCasa` y solo en P34.
- **Lógica de diseño (autorada por Fable 5, vinculante):** héroe navy primero · una sola cifra amarilla grande por pantalla · un solo rojo accionable por pantalla · actividad en cielo, nunca se atenúa el dinero · densidad creciente hacia abajo · viz monocroma por entidad · carita en 4 escalas (36/48/56/76-80). Documento: `Docs/JOINSI_A3_Rediseno_Stitch_SiPortfolio.md`, que trae el **STYLE SYSTEM reutilizable para Stitch**.
- Los tokens Material-3 que Stitch genera (`#faf9fc`, `#bb0019`, Montserrat…) **no son canon**. Si Stitch contradice el P1B, gana el P1B.

## 7 · CÓDIGO (Code/joinsi_app)

Requiere Flutter ≥ 3.44 (Dart ≥ 3.12) y JDK 21 para compilar Android. El repo versiona solo `lib/`, `test/`, `assets/`, `pubspec.yaml`; `android/` lo genera el CI. La raíz guarda una copia legacy de A2 (`lib/`, `assets/`, `joinsi_app_A2.zip`): no se borra sin autorización.

```
lib/core/     tokens.dart (paleta, única fuente de color) · theme.dart · i18n.dart
lib/models/   loan_officer.dart: payoutFor, marginalPayoutFor, earned, collectedAmount,
              pendingAmount, activity, remainingWindowValue, monthlyRemaining, applyCut ·
              RivalSiPartner · Territory · LadderReq · enum Stage (8, a retirar en A4)
lib/data/     store.dart (_seedVersion = 4; agregados, corte, ranking) · seed_los.dart
              (7 firmados + 17 prospectos + 5 rivales + 4 territorios) · usa_map_data.dart (generado)
lib/widgets/  carita_avatar · avatar_picker · medalla_casa · common.dart
lib/zones/    portfolio/ (6 pantallas) · radar/radar_home (stub) · academy/academy_home (stub)
test/         canon_test.dart (17) · compiles_test.dart (1)
```

**Decisiones de código vinculantes:**
1. `payoutFor` es la única fuente del dinero. Ninguna pantalla replica la fórmula.
2. Cobrado y pendiente se derivan de un conteo (`collectedCases`): `causado = cobrado + en camino` se cumple por construcción.
3. `activity` se deriva de `casesThisPeriod`.
4. El ranking (P34) es dato semilla declarado, enmarcado como posiciones al corte. El usuario se inserta por su `earned` real.
5. Semilla: 7 LOs · 61 closed · 6 estados · causado $16,400 = cobrado $14,300 + en camino $2,100 · activos 5/7 · ventana restante $17,000 · proyector $27,800 · usuario #4 en el ranking.
6. Zoom del mapa: pines de tamaño constante con `FittedBox`. No regresionar.
7. Si `canon_test.dart` falla, se rompió el modelo de negocio: se reporta y se para, no se ajusta el test.

## 8 · DEUDA CONOCIDA

- `nextTouch` existe en el modelo y nadie lo lee. `promise` solo se pinta en radar_home y ningún prospecto semilla lo trae. A4 los reemplaza por el modelo de nodos.
- Caritas dibujadas con CustomPainter, no ilustradas. `AvatarSpec.photoPath` ya soporta assets si se generan.
- `RankingScreen` solo se abre desde Mi Negocio (chip de estatus); no tiene ruta propia en `shell.dart`.
- Fuente A1 en `assets/` de la raíz legacy: A3.1 la mueve a `Docs/`.
- El puente de Cowork no puede escribir en `.github/workflows/` (protegido a propósito): los cambios de CI los hace Claude Code.
- Notificaciones del sistema (P26/P41) piden permisos en `AndroidManifest` y ajuste de Gradle; como `android/` lo genera el CI, el workflow tendría que parchearlos.

## 9 · DECISIONES ABIERTAS (con default; se resuelven al despertar JoinSi #3)

1. **Gate A3:** ¿Fernando instaló y aprobó el APK de A3-R2? Default: instalar el APK que genere el push de A3.1 y dar "APROBADO A3" antes de abrir A4.
2. **Compensación del LO:** 225 bps (Acta A0) o 275 bps con fee de US$650 (oferta de octubre). Afecta el pitch de P24, V3, V4 y el árbol de Carlos (nodo N05). Default: manda la oferta de octubre, confirmada en vivo por Fernando.
3. **Repo público:** Fernando autorizó publicar el APK en un link público (A3.1). Queda abierto si el código y el canon siguen públicos. Default: pasar el repo a privado; el Release público dejaría de bajarse sin login, y el APK se distribuiría con `gh run download` o por Google Drive.
4. **Detalles del funnel (§8 del canon):** default umbrales A/B 3 días, C 5, D 5 tras C, E 7 tras D; N30/60/90 desde la asignación; al firmar G el LO pasa solo a SiPortfolio; nomenclatura A–E / F–G / N30-N60-N90.
5. **Alcance de A4:** default centro de alertas dentro de la app (notificaciones del sistema en subsprint A4-N); lanzador de llamada simulado; contenido del playbook y del pre-funnel redactado por el constructor desde A1 y marcado "pendiente de validar con María Teresa".

## 10 · RUTA

| Sprint | Entregable | Estado |
|---|---|---|
| A0–A2 | Acta, prompts, andamiaje | ✅ |
| A3 / A3-R / A3-R2 | SiPortfolio 6 pantallas sobre Stitch | ✅ código y CI · ⏳ APROBADO en celular |
| A3.1 | Higiene del repo, sin código de producto | ✅ 2026-11 |
| **A4-spec** | `Docs/specs/SPEC_A4_SiRadar.md`, escrita por el CEO de producto: orden de pantallas, modelos, tests nuevos, semilla v5. Sin código | **← SIGUIENTE** (y en paralelo, el APROBADO A3) |
| A4 | SiRadar funcional con el funnel | tras aprobar el plan |
| A4-S → A4-R | Prompts Stitch de SiRadar (Fable 5 + STYLE SYSTEM) → capa visual | tras aprobar A4 funcional |
| A4-N | Notificaciones del sistema + parche del CI | subsprint |
| A5 | SiAcademy (requiere videos y 48 clips) | pendiente |
| A6 | Umbral P00–P03, pulido, APK firmado | pendiente |

**Regla de secuencia (vinculante, de Fernando):** funcional → aprobación → Stitch → capa visual → solo entonces APK para el celular. El APK que llega al teléfono refleja lo aprobado en UI, UX y funcionalidad.

## 11 · GOBERNANZA

Gates "APROBADO A-N" explícitos de Fernando · pausa socrática de máximo 5 preguntas con default · las correcciones de Fernando son canon inmediato · cirugía sobre lo aprobado · camera-ready · cifras financieras leídas en vivo de la fuente · Fernando escribe desde el móvil por voz a texto · **el arquitecto escribe el canon y los prompts; el constructor (Claude Code) escribe código y commitea; Fernando aprueba**. Rol del chat: **CEO de producto y arquitecto**, que co-diseña con Fernando. Método completo, plantillas y ritual de relevo en `Docs/00_METODO_DE_TRABAJO.md`.

## 12 · MAPA DE DOCUMENTOS

| Archivo | Para qué |
|---|---|
| `Docs/00_METODO_DE_TRABAJO.md` | Roles, ciclo, plantillas de spec y prompt, ritual de relevo |
| `Docs/00_LEEME_ARRANQUE_ARQUITECTO.md` | Arranque del CEO de producto y arquitecto: orden de lectura, primeras acciones |
| `Docs/relevos/` | Notas de entrega entre chats (última: `RELEVO_JoinSi_02_a_03.md`) |
| `Docs/specs/` | Specs (hoy: `SPEC_A5_Simulador_de_Llamada.md` v0.1) |
| `Docs/JOINSI_Contexto_HOMESI.md` | Contexto de negocio de HOMESÍ, fechado |
| `Docs/P1B_Sistema_de_Marca_HOMESI_Oficial.md` | Sistema de marca completo |
| `Docs/proyecto_claude/` | Instrucciones y pasos para el proyecto claude.ai |
| `Docs/JOINSI_Memoria_LTM_Proyecto.md` | Este documento: estado y canon resumido |
| `Docs/JOINSI_Bitacora_de_Decisiones.md` | Qué se decidió, cuándo y en qué chat |
| `Docs/JOINSI_Filosofia_y_Journey.md` | Idea, propuesta de valor y journey de las tres personas |
| `Docs/JOINSI_A0_Acta_y_Arquitectura_v1-1.md` | Acta, árbol de 27 pantallas, design system |
| `Docs/JOINSI_A1_Prompts_Stitch_Higgsfield_Voces.md` | Prompts Stitch ST-01–ST-06, briefs V0–V4, árbol de Carlos (llega a Docs/ en A3.1) |
| `Docs/JOINSI_A3_Rediseno_Stitch_SiPortfolio.md` | Lógica de diseño Fable 5, STYLE SYSTEM, ST-07–ST-12 |
| `Docs/JOINSI_Canon_Funnel_Nurturing_Prospectos.md` | Canon del funnel que construye A4 |
| `Docs/JOINSI_Sistema_Grafismos_Video.md` | Grafismos de los videos |
| `Docs/PROMPT_A3-1_Higiene_Claude_Code.md` | Tarea lista para el constructor |
| `CLAUDE.md` (raíz) | Contrato operativo del constructor |
| `Code/joinsi_app/README_BUILD.md` | Cómo compilar y qué protege cada test |
