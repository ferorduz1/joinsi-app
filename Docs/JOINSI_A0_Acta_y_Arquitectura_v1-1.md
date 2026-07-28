# JOINSI by HOMESI — Sprint A0
## Acta de Alineación · Árbol de la App · Design System Móvil
**Fecha:** 2026-07-27 · **Director:** Fernando Orduz · **CMO Agéntico:** Claude
**Estado:** CAMERA-READY para aprobación de gate

---

# 1. ACTA DE DECISIONES (Gate A0 — resuelto)

| # | Decisión | Resolución canónica |
|---|---|---|
| 1 | Nombre de producto | **JoinSi by HOMESI**. Identidad de tribu propia, no "app de empleados". |
| 2 | Idioma | Bilingüe ES/EN con toggle en vivo. Términos de industria SIEMPRE en inglés: Loan Officer, pre-approval, ratified, closed loan, pricing, pipeline, override. |
| 3 | Assets | **5 videos reales** (V0 landing + V1–V4 training) generados vía Higgsfield + **1 conversación de audio real** demo. Resto placeholder. Todos los videos abren con los dos intros oficiales de HOMESI. |
| 4 | Simulador de llamada | **Audio ramificado pre-generado con voz AI (Higgsfield)** para el prototipo APK. Voz generativa en vivo = post-MVP (ver §5). |
| 5 | Secuencia de construcción | Andamiaje completo → Zona 3 (Portafolio & Dinero) → Zona 2 (Motor) → Zona 1 (Academia). Todo el plan corre sin pausas. |
| 6 | Escalera de estatus | **SiPartner** (medalla casa BRONCE) → **SiFounder** (PLATA, recluta SiPartners) → **SiBroker** (ORO, territorios exclusivos + override de red). |
| 7 | Compensación canónica en la app | $500 + $500 por los dos primeros closed loans del LO reclutado; $200/caso durante 12 meses. Comp del LO: 225 bps sobre loan amount, incluye Core Service HOMESI 90 días. |
| 8 | Stack | Flutter (nativo Android, APK sideload) + data local Hive. Sin backend en prototipo. Stitch = referencia visual. Figma = eliminado del flow. |

**Intros oficiales — RECIBIDOS y canonizados:**
- **Intro 1:** `INTRO_Logo_HOMESI_Animado__2_.html` — wordmark HOMESÍ animado sobre navy con patrón neighborhood de chevrones, "Powered by Supreme Lending", tagline *"We say SÍ when others say no."* Lienzo 16:9 exacto, capturar a 1920×1080.
- **Intro 2:** `logo_oficial_transparente.png` — la casa en círculo rojo, animación de crecimiento antes de escena.
- Ambos intros abren cada uno de los 5 videos (V0–V4).

**Adenda A0-1 (2026-07-27):** el design system §4 queda subordinado al **P1B · Sistema de Marca HOMESÍ Oficial** y a la **Guía Visual** cargados a memoria de proyecto. Cambios aplicados: logo primario = casa en círculo (chevrón = ícono Growth), tipografía Poppins/Barlow/Inter/Kalam (Outfit y Playfair eliminados de la app), neutros y paleta viz validada incorporados, metales de estatus declarados como excepción pendiente de ratificación.

---

# 2. RESOLUCIÓN TÉCNICA #4 — Voz del simulador de llamadas

**Lo que Higgsfield SÍ hace (verificado en su MCP):** generar audio TTS con voces clonadas o de catálogo (`generate_audio`, `create_voice`, `list_voices`), dubbing y voice change sobre video. Es una **fábrica de audio**, no un cerebro conversacional en tiempo real.

**Lo que NO hace:** sostener una conversación viva embebida en la app (escuchar → razonar → responder con latencia < 1s). Eso requiere un servicio realtime (Gemini Live API — que tu licencia Google Pro sí habilita — o equivalente), streaming de audio bidireccional, red obligatoria y manejo de latencia. **Dificultad: 8/10** y rompe la premisa "prototipo sin backend".

**Ruta canónica del prototipo (dificultad 3/10):** *audio ramificado* = un árbol de diálogo pre-diseñado donde cada nodo es un clip de voz AI generado en Higgsfield. El LO virtual "responde" distinto según el botón/respuesta que elija el SiPartner. Con 3–4 variantes por nodo y micro-variaciones de tono, la sensación de realismo es altísima, funciona offline dentro del APK, y califica exactamente lo que quieres medir: pitch, manejo de objeciones, recontacto, tolerancia a la frustración.

**Post-MVP:** se sustituye el árbol por Gemini Live manteniendo la misma pantalla. Cero rediseño.

---

# 3. ÁRBOL COMPLETO DE LA APP (27 pantallas)

## Zona 0 — Umbral (4 pantallas)
| ID | Pantalla | Contenido |
|---|---|---|
| P00 | Splash | Logo HOMESI (chevrones arriba), transición a JoinSi |
| P01 | Landing hero | **Video V0** autoplay con subtítulos dinámicos, CTA "Conviértete en SiPartner", escalera Bronce/Plata/Oro visible |
| P02 | Onboarding 3-slides | Qué es JoinSi · Cómo ganas dinero · La escalera de estatus |
| P03 | Registro / Perfil | Nombre, foto, ciudad, idioma preferido, cuenta bancaria (mock) |

## Zona 1 — SiAcademy (8 pantallas)
| ID | Pantalla | Contenido |
|---|---|---|
| P10 | Mapa de aprendizaje | Flow visual de nodos (estilo Duolingo): 4 módulos de video + 3 simuladores + examen. Progreso con medallas parciales |
| P11 | Reproductor de módulo | Videos V1–V4 + quiz interactivo al final de cada uno |
| P12 | Simulador de Objeciones | Chat con LO virtual: objeciones reales del canon HOMESI (H-03), respuestas por selección + texto libre, scoring LAER |
| P13 | Simulador de Llamada | **Audio ramificado con voz AI.** Llamada entrante/saliente, el LO habla, el SiPartner elige respuestas habladas/tocadas. Score: pitch, precisión de programas, manejo de rechazo |
| P14 | Simulador Time Blocking | Agenda semanal drag & drop: agendar follow-ups, bloquear horas de llamadas, resolver conflictos |
| P15 | Modo Tamagotchi | 3 leads simulados viven en el tiempo: si no llamas al día pactado, se enfrían y el ícono lo muestra. Enseña disciplina de recontacto |
| P16 | Examen final + Zoom | Examen integrador → agenda de entrenamiento en vivo (mock Calendly) |
| P17 | Graduación | Ceremonia animada: medalla de bronce **SiPartner**, certificado compartible a redes |

## Zona 2 — SiRadar · Motor de Prospección (7 pantallas)
*(Nunca lo llamamos CRM. Es el Radar.)*
| ID | Pantalla | Contenido |
|---|---|---|
| P20 | Radar principal | Fichas MQL de LOs asignadas por HOMESI: foto, NMLS, volumen estimado, tier (Grande/Mediano/Boutique), redes sociales, score de calor |
| P21 | Ficha LO 360° | Dossier estilo B2B: pains, programas gancho, pricing hook, historial de toques |
| P22 | Pipeline de nodos | Flujo visual: Asignado → Pre-funnel social → 1ª llamada (pitch) → Follow-up → 3ª llamada → **Reunión con Director de Producción** → Pensando/Onboarding → **Contrato firmado** |
| P23 | Lanzador de llamada | Botón de llamada (mock dialer con número US), auto-avance de stage: contestó ✓ / no contestó → reintento programado |
| P24 | Playbook en contexto | Guiones, pain relievers, battle cards y artefactos de mitigación de riesgo según el stage actual |
| P25 | Pre-funnel social | Material listo para LinkedIn/IG/Meta + secuencia de publicación sugerida |
| P26 | Alertas & Agenda | Notificaciones tipo Tamagotchi reales: "Carlos M. quedó en hablar hoy — llámalo antes de 6pm" |

## Zona 3 — SiPortfolio · El Dinero (6 pantallas)
| ID | Pantalla | Contenido |
|---|---|---|
| P30 | Mapa USA vivo | Mapa con caritas de los LOs del portafolio por estado. Tap → mini-card. Zoom por estado. Filtros: tier, programa, costa, estado del pipeline |
| P31 | Ficha de portafolio LO | Todo del LO firmado: leads referidos, cuántos en pre-approval, ratified, closed/mes, dinero generado por esa relación, meses restantes de los 12 |
| P32 | Dashboard de dinero | Ganado en el año · Me deben este mes · Proyección del mes (basada en avg loans/month por LO) · Botón **COBRAR** → cuenta bancaria (mock) |
| P33 | Proyector de ingresos | Simulador: "si firmas este LO de 2 casos/mes → $1,000 iniciales + $400–600/mes por 12 meses". Apilamiento visual del portafolio |
| P34 | Ranking & Escalera | Leaderboard de SiPartners, progreso hacia SiFounder (plata) y SiBroker (oro), territorios disponibles |
| P35 | Mi negocio | Resumen ejecutivo: closed loans por estado/LO/costa/tier, gráficas de apilamiento de ingresos |

## Transversal (2)
| ID | Pantalla |
|---|---|
| P40 | Ajustes: toggle ES/EN en vivo, notificaciones, cuenta |
| P41 | Notificaciones push locales (motor del Tamagotchi real) |

---

# 4. DESIGN SYSTEM MÓVIL — JoinSi v1.1
### Subordinado al P1B · Sistema de Marca HOMESÍ Oficial (única fuente de verdad visual)

**Arquetipo:** *Local Hero* — People's Champion + Real & Human. La app no puede sentirse corporativa ni fría: es el vecino experto que por fin te dice que sí.
**Tagline:** *"We say **SÍ** when others say no."* — el SÍ siempre en Latin Mornings.
**Firma:** *Powered by Supreme Lending* — **solo en el lockup del logo** (splash y header). Jamás en copy de contenido.

## 4.1 Logo (canon P1B + bitácora de contradicciones resueltas)
- **Primario:** la **casa en círculo rojo** — archivo `logo_oficial_transparente.png` (512×512, alpha). En Higgsfield: `media_id 86a96e38-bb95-4f80-9605-a19a3b4b5f13`. Vector de respaldo del P1B §2.2 solo para tamaños pequeños/monocromo.
- **Secundario:** doble chevrón ↑ en squircle rojo = **ícono "Growth"** del sistema, nunca logo.
- Clear space: el alto de la casa alrededor del lockup. Mínimos: 24px símbolo, 96px lockup.
- Prohibido: deformar, rotar, sombras, degradados, contornos, redibujar a mano.

## 4.2 Color (paleta oficial — prohibido todo color fuera de esta lista)

| Nombre | HEX | Rol semántico |
|---|---|---|
| Enriching Skies | `#001A40` | Autoridad. Títulos, texto de lectura, fondos oscuros (hero, mapa) |
| Warm Embrace | `#FF4040` | La marca y lo que importa. CTAs, acentos, nodos activos. Nunca "error" genérico ni relleno decorativo masivo |
| Light Sky | `#A6DEFF` | Respiro. Fondos suaves, chips, texto sobre navy |
| Latin Mornings | `#F8C845` | Énfasis cálido, estado activo, el "SÍ", dinero/celebración |
| New Day | `#FCFCFA` | El lienzo. Fondo base |

**Neutros autorizados (uso restringido):** Competitor Gray `#E8EAF0` (solo columna competidor/status quo en battle cards) · Neutral Text `#6B7280` · Hairline `#E5E7EB`.

**Contraste — reglas duras:** texto blanco sobre amarillo o light sky PROHIBIDO. Rojo sobre New Day solo ≥24px bold. Blanco sobre rojo solo ≥18px bold. Sobre navy: New Day, Light Sky o Latin Mornings.

**Gráficas (dashboards SiPortfolio):** usar la paleta de datos validada del P1B, no los colores de marca como series. Claro: `#1E5AA8 · #E23B3B · #6B4EA8 · #12876B · #B87A00` sobre `#FCFCFA`. Oscuro (mapa navy): `#4A86D6 · #D64C4C · #8A73D1 · #17906F · #B98418` sobre `#0A1E3F`. Reglas: barras finas radio 4px ancladas a base, 2px de separación, texto nunca del color de la serie, color sigue a la entidad, prohibido doble eje Y / rainbow / 3D / donas >3 porciones.

**Excepción declarada — metales de estatus (pendiente de ratificación del Director, mismo tratamiento que el verde `--estado-liberado` de la app demo):** bronce `#B0793A`, plata `#B9C2CC`, oro `#D9A93D`, usados EXCLUSIVAMENTE en las medallas-casa SiPartner/SiFounder/SiBroker, nunca como color de marca, texto, fondo o acento. Si el Director prefiere cero excepciones, las medallas pasan a las 4 variantes de círculo del Brand Book (rojo/navy/sky/amarillo).

## 4.3 Tipografía (P1B — manda sobre cualquier canon anterior; cero Playfair, cero Outfit, paleta sand/gold anulada)

| Rol | Familia | Nota |
|---|---|---|
| Headline / display / numerales de dinero | **Poppins 700/800** | Sustituto declarado de Articulat CF (declararlo en comentario del código) |
| H2 / H3 / sub-heads | **Barlow Bold** | |
| Cuerpo y cifras | **Inter** 400–700 | Cifras en Inter Bold tabular, alineadas a la derecha |
| Notas manuscritas | **Kalam** | Condimento, no ingrediente: señales de avance ✓, anotaciones. Nunca cuerpo |

Kickers en MAYÚSCULAS tracking 0.18em (firma tipográfica del sistema). Máx 75 caracteres/línea. Nunca más de 3 tamaños por bloque. Numerales de etapa: Poppins 800, 64–96px, Latin Mornings o Rojo.

## 4.4 Espaciado, formas, sombras, movimiento
- **Espaciado base-4:** `4 · 8 · 12 · 16 · 24 · 32 · 48 · 64 · 96 · 128` — solo estos valores.
- **Radios:** 8px chips · 16px tarjetas · 24px contenedores · 999px botones (pill) y avatares.
- **Sombras siempre navy translúcido**, jamás negro: sm `0 1px 2px rgba(0,26,64,.06)` · md `0 4px 12px rgba(0,26,64,.08)` · lg `0 12px 32px rgba(0,26,64,.12)`.
- **Movimiento:** easing `cubic-bezier(.22,1,.36,1)`, 200ms rápido / 320ms medio / 1000ms ceremonial (graduación, contador de dinero). Nada rebota, nada parpadea.
- **Anillo de foco:** 3px Latin Mornings, offset 2px.

## 4.5 Iconografía (dos sistemas, nunca mezclados en un mismo bloque)
- **Primario (círculos):** Growth (chevrón↑) · Home (casa) · Opportunity (cerradura) · Latino (asterisco 6 puntas), en las 4 variantes de círculo. 32/48/64px.
- **Secundario (lineal):** set rojo de industria, trazo 2.5px redondeado, un color por ícono. 20/24/32px.
- Cada ícono lleva texto al lado — el ícono nunca comunica solo. Nunca rellenar un lineal ni contornear un círculo.

## 4.6 Componentes canónicos JoinSi (sobre los componentes P1B §7)
- **Botones:** pill, Inter Bold 16px, padding 14/28. Activo rojo/texto blanco (o amarillo/texto navy) · hover outline 2px · action navy · inactivo Competitor Gray + Neutral.
- **Tarjetas:** New Day, borde hairline, radio 16, padding 24, shadow-sm → md en interacción con -2px Y.
- **Chips de tier LO:** pill Inter 12 600 tracking 0.08em — Grande navy/blanco · Mediano Light Sky/navy · Boutique Latin Mornings/navy.
- **MoneyCounter:** odómetro Poppins 800, Latin Mornings sobre navy (9.4:1 ✓).
- **MedallaCasa:** silueta de la casa del logo en los 3 metales de estatus (§4.2 excepción).
- **NodoPipeline:** círculos rojos numerados conectados por trazo 2px punta redondeada (herencia El Hilo de Oro / battle-card).
- **FichaLO:** avatar circular + chip de tier + score de calor + íconos lineales de contacto.
- **MapaUSA:** fondo navy modo oscuro, caritas como avatares circulares, datos con paleta viz oscura.
- **TamagotchiAlert:** tarjeta con barra de enfriamiento — caliente Latin Mornings → frío Light Sky → perdido Neutral. (Sin verde/semáforo: fuera de paleta.)
- **Regla de Oro:** barra izquierda 5px roja, fondo `rgba(255,64,64,.04)`, Barlow Bold navy, etiqueta kicker roja — para los principios dentro de SiAcademy.

## 4.7 Prohibiciones heredadas del P1B
Colores fuera de la paleta (salvo neutros, viz validada y la excepción de metales declarada) · texto blanco sobre amarillo/sky · el chevrón como logo primario · redibujar el logo · sombras/degradados sobre el logo · doble eje Y · rainbow/3D · color como único portador de identidad · mezclar sistemas de íconos · espaciados fuera de base-4 · rostros recortados por encuadre · elencos colombianos homogéneos · poesía corporativa, solemnidad, relleno.

---

# 5. STACK TÉCNICO DEL PROTOTIPO

- **Flutter 3.x** → APK sideload (sin Play Store, sin cuenta developer)
- **Hive** para persistencia local (portafolio, progreso, pipeline sobreviven al cierre de la app)
- **Datos semilla:** 24 LOs ficticios distribuidos en 12 estados, 3 tiers, nombres/fotos latinas multiétnicas, pipelines en distintos stages — para que la demo se sienta habitada desde el minuto uno
- **Notificaciones locales** (flutter_local_notifications) para el Tamagotchi real
- **Assets:** videos MP4 embebidos (V0–V4), clips de audio del árbol ramificado, SVG mapa USA
- **Compilación:** Claude Code en escritorio de Fernando (ruta recomendada) o Codemagic free tier

---

# 6. INVENTARIO DE VIDEOS (brief maestro — prompts detallados en A1)

| ID | Título | Esencia canónica |
|---|---|---|
| **V0** | *Landing — Become a SiPartner* | Épico motivacional. HOMESI te empodera para hacer negocios con LOs licenciados en los 50 estados. Te nombra SiPartner, te da prospectos calificados, construyes portafolio de 12 meses por LO, escalas a SiFounder (plata) y SiBroker (oro, territorios + override). Subtítulos dinámicos grandes, B-roll llamativo, animaciones |
| **V1** | *Loan Officers del Nicho Latino* | Quiénes son, licencia NMLS, hablan español, cumplen sueños de la comunidad latina. Cinematográfico realista |
| **V2** | *El Flow del Reclutamiento A→H* | Status SiPartner → pre-funnel social → pitch con pain relievers → objeciones → compensación 225 bps → reunión con Director de Producción (pricing en vivo + demo comp) → firma → primeros 2 closed loans → el SiPartner cobra y apila portafolio |
| **V3** | *Pricing — el Hook* | Caso real del catálogo: con 225 bps de comp, el LO aún ofrece el mejor pricing del mercado (ej. 5.5% al borrower) vs competencia |
| **V4** | *Compensación 225 bps* | Cálculo sobre loan de $300K → $6,750 al LO. Incluye Core Service HOMESI 90 días |

**Dirección de arte común:** actores aspecto latino colombiano multiétnico, inglés con subtítulos, tono película realista (no corporativo), la palabra "HOMESI" se pronuncia en cámara, ambos intros oficiales de HOMESI al inicio de cada pieza.

---

# 7. RUTA DE SPRINTS (recordatorio)

A0 ✅ (este documento) → **A1** Prompts Stitch + Higgsfield → **A2** Andamiaje Flutter → **A3** Zona 3 → **A4** Zona 2 → **A5** Zona 1 → **A6** APK firmado + pulido.
