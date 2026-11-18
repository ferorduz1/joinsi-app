# JOINSI · Bitácora de decisiones
**Propósito:** registrar qué se decidió, cuándo, en qué chat y por qué, para que ningún agente re-litigue lo cerrado ni repita un error ya corregido.
**Corte:** 2026-10-23 · Las entradas nuevas se agregan al final, con fecha y chat de origen.

---

## Los chats del proyecto

| Chat | Rol | Qué produjo |
|---|---|---|
| **JoinSi #1** ("1- JoinSi", proyecto claude.ai CEO Agéntico) | Arquitecto | A0, A1, A2 |
| **JoinSi #2** (Cowork en el mismo proyecto) | Arquitecto y constructor a la vez | A3, A3-R, A3-R2, canon del funnel, CI, este paquete de arranque |
| Claude Code (laptop viejo, luego `cl-hb0rl64`) | Constructor | CLAUDE.md, ARRANQUE_LAPTOP_NUEVO.md, migración, arreglos de tests |
| Chat auditor (2026-10-23) | Auditoría | Diagnóstico del rol de arquitecto vacante, propuesta A3.1, 5 preguntas |
| **JoinSi #3** | Arquitecto | Arranca con `Docs/00_LEEME_ARRANQUE_ARQUITECTO.md` |

---

## Abril de 2026 · Contexto de negocio (proyecto CEO Agéntico)

- El reclutamiento de LOs con un reclutador de salario fijo no rindió: primero un reclutador estadounidense (cerca de un LO por mes), luego una reclutadora offshore.
- Jorge diseñó un modelo de márgenes mínimos para la división y alta compensación para el LO reclutado. Ese modelo necesita volumen de reclutados.
- El bono de la reclutadora offshore paga alto en los dos primeros cierres de cada LO y menos durante 12 meses. **JoinSi copia esa forma de pago** para el SiPartner.

## 2026-07-27 · JoinSi #1 · Acta A0 (gate resuelto)

1. Nombre: JoinSi by HOMESÍ, identidad de tribu, nunca "app de empleados".
2. Bilingüe ES/EN con toggle; términos de industria siempre en inglés.
3. Assets: 5 videos (V0–V4) y 1 audio demo; el resto placeholder.
4. Simulador de llamada: audio ramificado pregenerado. Conversación viva (Gemini Live) es post-MVP. **Cerrado.**
5. Secuencia: andamiaje → Zona 3 → Zona 2 → Zona 1.
6. Escalera SiPartner (bronce) → SiFounder (plata) → SiBroker (oro).
7. Pago al SiPartner $500 + $500 + $200/caso por 12 meses. Comp del LO 225 bps con Core Service 90 días.
8. Stack Flutter + Hive, sin backend. Stitch como referencia visual; Figma fuera.
- **Adenda A0-1:** el design system se subordina al P1B (logo casa en círculo, Poppins/Barlow/Inter/Kalam).
- A1 entregó 8 prompts de Stitch, 5 briefs de video y el árbol de Carlos Mendoza (14 nodos, ~48 clips). A2 entregó el andamiaje Flutter.

## 2026-07-28 · JoinSi #2 · A3 y su corrección

- A3 construyó SiPortfolio y pasó **tres revisiones adversariales con Opus**; la tercera encontró el defecto que las dos primeras aprobaron. **Regla: ningún sprint cierra sin la tercera pasada.**
- Fernando abrió el primer APK y rechazó el UX: se había construido la UI sin pasar por Stitch, aunque A1 definía Stitch como insumo de A2. **Adenda A1-2:** se reinicia el diseño de SiPortfolio desde Stitch.
- Fernando pidió que la lógica de los prompts de Stitch la escribiera **Fable 5**. Resultado: lógica de diseño de "una cifra amarilla, un rojo accionable, héroe navy" y el STYLE SYSTEM.
- **A3-R (semántica del portafolio, decisión de Fernando):** los LOs son un activo financiero del SiPartner; estado de actividad enviando casos o dormido; dinero en tres estados (causado = cobrado + en camino), corte cada 30 días, pay period 2; agregaciones por LO y por grupo; toda la app de clase mundial en UI, UX y funcionalidad Android.
- **A3-R2:** al releer el Acta A0 apareció que P34 Ranking & Escalera se había perdido al fusionarse con P35. Fernando eligió restaurarla como sexta pantalla (ST-12). **Regla: releer el árbol del Acta contra lo construido antes de cerrar un sprint. P34 y P35 no se fusionan.**
- **Tamagotchi:** Fernando aclaró que es un símil del cuidado continuo de una mascota. Se capturó como nurturing post-firma de LOs reclutados (4 nodos, check "hecho offline", ícono de salud). **Backlog: no se ejecuta sin decisión.**
- **Funnel de prospectos:** Fernando redefinió el recorrido por contacto (A post, B DM, C llamada 1, D llamada 2, E SQL; F reunión y G firma fuera de control; nurturing 30/60/90; máximo 20 vivos; inactivar exige SQL y nota) y ordenó: **"Reemplaza por esta lógica"**. El pipeline de 8 etapas del Acta (P22) queda sustituido.
- **Regla de secuencia (Fernando):** sprint funcional → aprobación → Stitch → capa visual → solo entonces APK. El APK que llega al celular coincide con lo aprobado.
- **Google AI Studio vs. Flutter:** AI Studio genera Kotlin/Compose de un solo módulo y sin capa de datos; sería una bifurcación, no un atajo. **Flutter ratificado.** Firebase Studio genera Flutter y queda anotado como acelerador posible.

## 2026-07-29 · JoinSi #2 · Rebuild A3-R2 y CI

- Fernando aprobó las 6 pantallas en Stitch y entregó los HTML. El rebuild extendió el modelo (conteo `collectedCases`, `activity` derivado, rivales y territorios semilla) y reconstruyó las 6 pantallas contra los HTML.
- El código se escribió en la carpeta del repo vía el puente de Cowork y Fernando hizo el push (`4f855ed`). GitHub Actions compiló en verde (run #2, 4m35s, artifact de 22.2 MB).
- **Lección:** la lectura de la página general de Actions vía WebFetch quedó cacheada y reportó "en curso" durante tres chequeos cuando el build ya había terminado. **Regla: verificar el run individual, no la lista.**
- Se preparó `build-apk_NUEVO.yml` (Release público `apk-latest`, descarga sin login). El puente no puede escribir en `.github/workflows/` por diseño de seguridad: quedó en la raíz, inactivo, esperando decisión de Fernando.
- La página del repo mostraba **Public**.

## 2026-08-18 a 2026-09-28 · Claude Code

- Incidente: una sesión apuntó al repo de JoinSi creyendo ser otro proyecto (PULSO/Pitchlens). Se auditó y no dejó rastro.
- `CLAUDE.md` en la raíz como contrato operativo (2026-08-20).
- Migración al laptop nuevo con `ARRANQUE_LAPTOP_NUEVO.md` (2026-09-28). El repo sale de OneDrive. Flutter 3.47.5; dos arreglos en `compiles_test.dart` para esa versión que **no se commitearon**.

## 2026-10-21 · JoinSi #2 · Filosofía y journey

- Se describió la idea, la propuesta de valor y el journey de SiPartner, prospecto y reclutado (`Docs/JOINSI_Filosofia_y_Journey.md`).
- **Conflicto detectado:** el Acta usa 225 bps para el LO; la oferta que Fernando describió en octubre dice 275 bps completos para el LO y US$650 de fee plano por caso para HOMESÍ. Afecta V3, V4, el pitch y el nodo N05 de Carlos. **Abierto.**

## 2026-10-23 · Auditoría y arranque de JoinSi #3

- Estado verificado en `C:\Joinsi`: 5 commits, 18/18 tests, 32 avisos `withOpacity`, 6 de 27 pantallas, faltan todos los assets.
- El chat auditor diagnosticó que desde julio JoinSi solo tenía constructor: **se reabre el rol de arquitecto** (JoinSi #3) con Claude Code como constructor.
- Se descubrió que el canon de julio (funnel A–E, máximo 20 prospectos, tres estados del dinero, A3-R2) vivía solo en la memoria del proyecto claude.ai y no en el repo. **Se migró a `Docs/`.** La memoria del proyecto queda como puntero.
- Se emitió A3.1 (higiene del repo, sin código de producto) con la normalización de finales de línea en el orden correcto (el repo guarda LF y las copias de trabajo en Windows tienen CRLF). El arquitecto simuló el paso 1 sobre una copia del repo antes de emitirlo.
- Se detectó que el artifact de julio vence cerca del 27-oct (retención de 90 días). El push de A3.1 genera uno nuevo.
- Quedan cinco decisiones abiertas con default (`Docs/JOINSI_Memoria_LTM_Proyecto.md` §9).

## 2026-10-27 · JoinSi #2 · Simulador de llamada con voz grabada

- Fernando confirmó que el simulador funciona por selección múltiple: Carlos habla con clips pregrabados y el usuario escoge una de tres tarjetas. La tarjeta decide el camino; por eso la conversación siempre es coherente.
- **Decisión de Fernando:** en el prototipo el usuario ya vive la llamada simulada completa. Al escoger una tarjeta se abre el micrófono, el usuario la lee en voz alta y su voz queda grabada en el celular. Se mide localmente velocidad, pausas y demora; el análisis de fluidez y empatía con IA queda para cuando exista backend. **Enmienda:** el micrófono entra al prototipo para grabar, no para entender.
- Spec: `Docs/specs/SPEC_A5_Simulador_de_Llamada.md` (v0.1, concepto aprobado, detalles en discusión).

## 2026-10-27 · JoinSi #2 · Método de trabajo y proyecto propio

- Fernando preguntó si existía una dinámica para seguir diseñando con un CEO del proyecto JoinSi, cambiar de chat sin perder contexto y producir memoria, specs, bitácora e instrucciones a Claude Code. Existía en parte (arranque, LTM, bitácora, prompts), faltaban el rol de co-diseño, el ritual de relevo, la escritura inmediata y un espacio propio.
- **Decisión de Fernando ("Dale, aprobado"):** se crea un proyecto claude.ai aparte, **"JoinSi · CEO de producto"**. Motivo: el proyecto CEO Agéntico está al 98% de conocimiento, sus instrucciones son de la división completa y su búsqueda mezcla temas. El canon no se mueve: sigue en `Docs/`.
- Se emitieron: `Docs/00_METODO_DE_TRABAJO.md`, `Docs/00_LEEME_ARRANQUE_ARQUITECTO.md` v2 (rol de CEO de producto y arquitecto), `Docs/JOINSI_Contexto_HOMESI.md`, copia del P1B, `Docs/relevos/RELEVO_JoinSi_02_a_03.md` e instrucciones del proyecto en `Docs/proyecto_claude/`.
- `CLAUDE.md` gana una regla: el constructor commitea primero, sin editarlos, los cambios del CEO en `Docs/` que encuentre al empezar cualquier tarea.

## 2026-11-18 · A3.1 cerrado por Claude Code

- 8 commits: docs del CEO, test estable en Flutter 3.47, `.gitattributes` a LF, `pubspec.lock` versionado, `withOpacity` a `withValues`, A1 movido a `Docs/`, APK público y JDK 21. `flutter analyze` quedó sin issues por primera vez; 18/18 tests.
- **Decisión de Fernando (reportada por Claude Code):** activar el Release público `apk-latest`. El APK se baja desde el celular sin login. Riesgo aceptado: el repo es público y cualquiera con el link puede bajar el APK. Sigue abierto si el código y el canon deben pasar a privado.
- Hallazgo: el CI se rompió solo porque Flutter 3.47 exige JDK 21. Se subió a 21. **Lección:** el CI usa Flutter `stable` sin fijar versión; cualquier salto de Flutter puede romper el build sin tocar código.
- Desviaciones aceptadas del prompt A3.1: el orden de commits cambió porque varios pasos ya estaban hechos desde antes, y no se reescribió historial ya publicado.
- El CEO actualizó `CLAUDE.md`, `README_BUILD.md` (versiones reales y P34 separada de P35) y la LTM.

