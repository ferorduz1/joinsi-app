# JOINSI by HOMESI — MEMORIA DE PROYECTO (LTM)
## Para pegar en memoria de proyecto y abrir chat nuevo sin pérdida de fidelidad
**Corte:** 2026-07-27 · **Estado:** A0 ✅ · A1 ✅ · A2 ✅ · Siguiente: **A3**

---

## 1 · QUÉ ES ESTE PIPELINE

**JoinSi by HOMESI:** app **nativa Android (Flutter → APK sideload)**, prototipo de alta fidelidad con funcionalidad aparente y datos locales (Hive, sin backend). Empaqueta el conocimiento de la reclutadora (María Teresa) para crear **reclutadores externos virales** de Loan Officers del nicho latino. Aprobada por Jorge; no requiere venderse internamente. El prototipo es la semilla del producto real (el código Flutter no se bota).

**Modelo de negocio del usuario de la app:** recibe MQLs de LOs desde HOMESI → prospecta (pre-funnel social + llamadas + playbook) → el LO firma → cuando el LO cierra sus 2 primeros closed loans el reclutador cobra **$500+$500**, luego **$200/caso durante 12 meses**. Portafolio apilable.
**Escalera de estatus:** **SiPartner** (medalla casa BRONCE) → **SiFounder** (PLATA, recluta SiPartners) → **SiBroker** (ORO, territorios exclusivos + override de red).
**Comp del LO reclutado:** hasta **225 bps** sobre loan amount ($6,750 en loan de $300K), incluye Core Service HOMESI 90 días. Hook de venta = pricing (con 225 bps el LO aún ofrece ~5.5% al borrower — cifras de V3 se validan contra Matriz de Programas EN VIVO antes de rodar).

## 2 · LAS 3 ZONAS (27 pantallas, árbol completo en Acta A0 v1.1)

- **SiAcademy** (P10–P17): mapa de aprendizaje tipo Duolingo, 4 videos + quiz, Simulador de Objeciones (LAER, canon H-03), **Simulador de Llamada** (audio ramificado, ver §4), Simulador Time Blocking, **Modo Tamagotchi** (leads que se enfrían si no cumples promesas de recontacto), examen + Zoom, graduación con medalla bronce.
- **SiRadar** (P20–P26): NUNCA llamarlo CRM. Fichas MQL (foto, NMLS, tier Boutique/Mid/Top, score de calor, redes), ficha 360°, pipeline de nodos rojos conectados (Assigned → Pre-funnel → Call 1 Pitch → Follow-up → Call 3 → **Meeting with Production Director** → Deciding → SIGNED), lanzador de llamada con auto-avance de stage, playbook contextual por etapa, pre-funnel social, alertas Tamagotchi reales.
- **SiPortfolio** (P30–P35): mapa USA navy con caritas por estado (filtros: estado/tier/programa/costa), ficha de portafolio (leads/pre-approvals/ratified/closed, mes N de 12, ganado con ese LO), dashboard de dinero (odómetro amarillo, "me deben", proyectado, botón COBRAR), proyector de ingresos apilables, ranking y escalera a SiFounder/SiBroker.

## 3 · CANON VISUAL (subordinado al P1B — ya en memoria de proyecto)

- **Manda el P1B Sistema de Marca HOMESÍ Oficial + Guía Visual.** Logo primario = **casa en círculo rojo** (`logo_oficial_transparente.png`, Higgsfield media_id `86a96e38-bb95-4f80-9605-a19a3b4b5f13`); chevrón = ícono "Growth", nunca logo. "Powered by Supreme Lending" SOLO en el lockup, jamás en copy.
- **Tipografía:** Poppins 700/800 (sustituto declarado de Articulat CF) + Barlow Bold + Inter + Kalam condimento. **Cero Playfair, cero Outfit, paleta sand/gold anulada.**
- **Paleta:** navy #001A40 · red #FF4040 · sky #A6DEFF · yellow #F8C845 · white #FCFCFA + neutros (#6B7280, #E5E7EB, #E8EAF0 solo competidor/disabled). Dinero siempre amarillo sobre navy. Prohibido blanco sobre amarillo/sky. Viz con paleta validada claro/oscuro del P1B.
- **Excepción ratificada (APROBADO A0):** metales bronce #B0793A / plata #B9C2CC / oro #D9A93D SOLO para MedallaCasa.
- **Intros de video canonizados:** Intro 1 = `INTRO_Logo_HOMESI_Animado__2_.html` (wordmark, tagline "We say SÍ when others say no", capturar 1920×1080) · Intro 2 = animación del logo casa. Ambos abren V0–V4.
- Elenco videos: latino colombiano multiétnico (nunca homogéneo), inglés hablado, subtítulos grandes con "SÍ" y cifras en amarillo, "HOMESÍ" se pronuncia en cámara, cero estética corporativa/AI.

## 4 · SIMULADOR DE LLAMADA (decisión técnica cerrada)

Higgsfield NO hace conversación viva en tiempo real (es fábrica de audio TTS/video). Prototipo = **árbol de audio ramificado**: personaje "Carlos Mendoza" (LO boutique Houston, escéptico amable, protege su database), **14 nodos × 3 variantes ≈ 48 clips** generados con `generate_audio`. Diseño anti-convencional: interrumpe, recibe otra llamada (N09), nodo-trampa de overpromising (N07), nodo Tamagotchi vivo (N11), y la victoria es AGENDAR la reunión con el Director de Producción, no cerrar. Scoring: Pitch · Precisión · LAER · Resiliencia; aprueba con FIN-ganado ≥75%. Post-MVP: se enchufa Gemini Live (Google Pro) sobre la misma pantalla. Árbol completo en el archivo A1.

## 5 · STACK Y ESTADO DEL CÓDIGO (A2 entregado)

`joinsi_app_A2.zip` — proyecto Flutter compilable:
- `lib/core/tokens.dart` (P1B completo) · `theme.dart` (tipografía y componentes) · `i18n.dart` (toggle ES/EN vivo; términos de industria SIEMPRE en inglés: Loan Officer, pre-approval, ratified, pricing, pipeline, NMLS, bps, SiPartner/Founder/Broker)
- `lib/models/loan_officer.dart` (tiers, stages, proyección canónica $1,000 + $200×resto) · `lib/data/seed_los.dart` (**24 LOs semilla, 12 estados, 3 tiers**) · `store.dart` (Hive persistente: LOs, $18,450 año, $2,100 me deben, racha 7, progreso 62%)
- `lib/shell.dart` (nav 3 zonas, lockup, arranca en SiPortfolio) + 3 pantallas home funcionales (dashboard dinero con odómetro animado, fichas MQL con tiers, mapa de aprendizaje con progreso)
- `README_BUILD.md`: compilación vía **Claude Code de escritorio** ("instala Flutter y compila `flutter build apk --release`") → APK sideload sin Play Store. **No existe cuenta ni MCP de Flutter; Stitch tampoco tiene MCP** (web con Gmail, pegar prompts a mano).

## 6 · SPRINTS RESTANTES

| Sprint | Entregable |
|---|---|
| **A3** ← siguiente | SiPortfolio completo: **mapa USA SVG interactivo con caritas**, ficha portafolio 360°, proyector de apilamiento, gráfica de barras con paleta viz. Primera build "wow" |
| A4 | SiRadar completo: pipeline de nodos, lanzador de llamada con auto-stage, playbook contextual, pre-funnel, alertas Tamagotchi (flutter_local_notifications) |
| A5 | SiAcademy completa: player de videos V0–V4, simulador de objeciones, árbol de llamada con los 48 clips, time blocking, Tamagotchi, graduación |
| A6 | Onboarding (P00–P03 con video V0), pulido, gamificación transversal, APK firmado |
| Paralelo | Fernando ejecuta prompts A1 en Stitch (referencias) y Higgsfield (videos + 48 voces) |

## 7 · GOBERNANZA (idéntica al pipeline Playbook)

Gates "APROBADO A-N" · pausa socrática máx 5 preguntas con default · correcciones = canon inmediato · cirugía sobre lo aprobado (nunca redibujar) · camera-ready siempre · voz de tutor sabio en textos de la app (nunca corporativo — arquetipo Local Hero) · cifras financieras leídas en vivo, nunca de memoria · mobile-first voz-a-texto de Fernando.

## 8 · ARCHIVOS DEL PIPELINE (subir todos a memoria de proyecto)

1. `JOINSI_A0_Acta_y_Arquitectura_v1-1.md` (acta + árbol 27 pantallas + design system)
2. `JOINSI_A1_Prompts_Stitch_Higgsfield_Voces.md` (8 prompts Stitch + briefs V0–V4 + árbol Carlos)
3. `joinsi_app_A2.zip` (código Flutter)
4. Este documento (LTM)

**Prompt de apertura del nuevo chat:** "Retoma el pipeline JoinSi con la Memoria LTM y las actas A0/A1 de memoria de proyecto. Ejecuta A3."
