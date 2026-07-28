# JOINSI by HOMESI — Sprint A1
## Prompts de Producción: Stitch (UI) · Higgsfield (Video) · Voces del Simulador
**Fecha:** 2026-07-27 · **Estado:** CAMERA-READY · **Insumo de:** A2 (andamiaje Flutter) y A5 (Academia)
**Gobernado por:** Acta A0 v1.1 + P1B Sistema de Marca HOMESÍ Oficial

---

# PARTE 1 — PROMPTS STITCH (8 pantallas hero)

**Instrucciones de uso:** Stitch (stitch.withgoogle.com, tu licencia Google Pro). Pega primero el BLOQUE DE ESTILO al inicio de cada prompt, luego el prompt de pantalla. Genera en modo Mobile. Exporta las imágenes como referencia visual para Claude Code — NO exportar código de Stitch (el código lo escribe Flutter en A2).

## BLOQUE DE ESTILO (prefijo obligatorio de todos los prompts)

```
STYLE SYSTEM — apply strictly to every screen:
Mobile app, Android, 412x915. Brand: HOMESÍ "Local Hero" archetype — warm,
human, business-energy, never corporate or cold.
COLORS (only these): deep navy #001A40, brand red #FF4040, light sky #A6DEFF,
warm yellow #F8C845, warm white #FCFCFA. Support neutrals: #6B7280 text,
#E5E7EB hairlines, #E8EAF0 disabled. Money and celebration always in yellow
#F8C845 on navy. Never white text on yellow or light blue.
TYPE: Poppins Bold/ExtraBold for headlines and big money numbers, Barlow Bold
for section titles, Inter for body and data. Small uppercase labels with wide
letter-spacing as section kickers.
SHAPES: pill buttons (full round), cards radius 16, big containers radius 24,
soft navy-tinted shadows, generous whitespace, 4px spacing grid.
LOGO: white house inside a red circle (never a chevron as logo).
Header lockup: house logo + "JoinSi" wordmark, small "by HOMESÍ".
Bottom nav: 3 tabs — Academy (graduation cap), Radar (radar sweep), Portfolio
(US map pin). Active tab in red.
Photography: latino multi-ethnic professionals, warm light, faces never cropped.
No AI-symbolic imagery, no robots, no glowing brains.
```

## ST-01 · P01 Landing Hero
```
Landing screen for "JoinSi by HOMESÍ", a business app that turns bilingual
students into licensed-loan-officer recruiters. Full-bleed navy hero with a
video player frame at top (16:9, play button, dynamic large subtitles visible:
"Build your OWN portfolio"). Below: headline in Poppins ExtraBold white
"Become a SiPartner", subhead in light sky "Recruit licensed Loan Officers in
all 50 states. Get paid for every closed loan. Stack a 12-month portfolio."
Status ladder as three house-shaped medals in a row: bronze "SiPartner",
silver "SiFounder", gold "SiBroker", each with a one-line caption.
Primary pill CTA in red "Start my journey", secondary text link "I'm already
a SiPartner". Subtle chevron neighborhood pattern in background at 10% opacity.
```

## ST-02 · P10 Mapa de Aprendizaje (SiAcademy)
```
Learning path screen "SiAcademy". Vertical winding path of circular nodes on
warm white background (Duolingo-style but HOMESÍ brand): 4 video module nodes
(red circles with play icon), 3 simulator nodes (navy circles with mic,
calendar, and heartbeat icons), 1 final exam node (yellow circle with a star),
1 graduation node at top shaped like the bronze house medal. Completed nodes
show a handwritten-style yellow check mark. Progress bar at top "62% to
SiPartner". Each node has a short label: "Latino Niche LOs", "The Recruiting
Flow", "Pricing: the Hook", "The 225 bps Compensation", "Objection Simulator",
"Live Call Simulator", "Time Blocking", "Final Exam". Locked nodes in gray.
```

## ST-03 · P13 Simulador de Llamada
```
Live call simulator screen. Dark navy full screen like an ongoing phone call.
Top: circular photo of a latino loan officer "Carlos Mendoza — Loan Officer,
Houston TX", NMLS badge chip, call timer 02:34, animated voice waveform in
light sky while he speaks. Middle: a subtle transcript bubble of his last
sentence. Bottom: three response option cards the user can tap (radius 16,
white, one highlighted with red border) plus a red round mic button to answer
speaking. Small score chips at top right: "Pitch", "Objections", "Resilience"
with mini progress rings. Feels like a real call, warm and tense, not a quiz.
```

## ST-04 · P15 Modo Tamagotchi
```
Lead-care screen "My Leads Are Alive". Three lead cards on warm white, each
with LO photo, name, and a horizontal warmth bar that cools over time: hot
(yellow), cooling (light sky), lost (gray). Each card shows a countdown chip
"Call in 3h 12m" and the promise made: "You agreed to call Tuesday". One card
is pulsing with a red border because the deadline is now. Header explains in
one warm line: "A lead you forget is a lead you lose." Bottom: streak counter
"7 days keeping every promise" with a small flame in yellow.
```

## ST-05 · P20 SiRadar (fichas MQL)
```
Prospecting screen "SiRadar". Header with radar sweep micro-illustration.
Stack of MQL prospect cards: LO photo, name, NMLS ID chip, city/state, tier
chip ("Boutique" yellow / "Mid" light sky / "Top Producer" navy), heat score
ring, estimated monthly volume "2-3 loans/mo", social icons row (LinkedIn,
Instagram), and two pill buttons: red "Start pre-funnel" and outlined "View
360°". Filter chips row at top: state, tier, program, heat. A small banner:
"HOMESÍ assigned you 3 new prospects today" in light sky.
```

## ST-06 · P22 Pipeline de Nodos
```
Deal-flow screen for one prospect. Horizontal journey of connected red
numbered circles over warm white (golden-thread style): Assigned → Social
pre-funnel → Call 1: Pitch → Follow-up → Call 3 → Meeting with Production
Director → Deciding → CONTRACT SIGNED. Current node enlarged with yellow ring.
Under the journey: contextual playbook card for the current stage ("What to
say now": 3 bullet talk tracks + one battle card chip). Timeline of touches
below with dates. CTA: red pill "Log this call".
```

## ST-07 · P30 Mapa USA (SiPortfolio)
```
Portfolio map screen. Dark navy US map filling the screen, with small circular
face avatars of recruited loan officers pinned on their states, subtle glow.
Tapping a face opens a bottom sheet mini-card: photo, name, state, "$3,400
earned with this LO", pipeline chips (4 leads, 2 pre-approvals, 1 ratified,
1 closed this month), months left of the 12-month window "Month 5 of 12".
Top filter chips: by state, by tier, by program, East/West coast. Legend
bottom-left. Small counter top-right: "12 LOs · 8 states".
```

## ST-08 · P32 Dashboard de Dinero
```
Money dashboard "My Business". Navy hero card with huge odometer-style number
in yellow Poppins ExtraBold: "$18,450" labeled "Earned this year". Below, three
stat cards on warm white: "They owe me this month $2,100" (with red COLLECT
pill button), "Projected this month $3,800", "Portfolio value 12 LOs". A
stacked bar chart of monthly earnings using the validated data palette (blue
#1E5AA8, red #E23B3B, purple #6B4EA8) with thin 4px-rounded bars, showing
income stacking as new LOs join. Bottom: "Path to SiFounder" progress with
silver house medal at the end.
```

---

# PARTE 2 — PRODUCCIÓN HIGGSFIELD: VIDEOS V0–V4

**Protocolo:** cada video se ensambla como [Intro 1 wordmark] + [Intro 2 logo casa] + [cuerpo]. Los intros ya existen (Intro 1 = captura del HTML a 1920×1080; Intro 2 = animación del PNG oficial, `media_id 86a96e38-bb95-4f80-9605-a19a3b4b5f13`). Los prompts de abajo generan el CUERPO por escenas. Dirección transversal: **elenco latino colombiano multiétnico (nunca homogéneo), inglés hablado, subtítulos dinámicos grandes, la palabra "HOMESÍ" se pronuncia en cámara, luz cálida, cero estética corporativa, cero simbología AI.** Formato 16:9 1080p. Subtítulos: Poppins Bold, blanco con el "SÍ" y las cifras en `#F8C845`.

## V0 · "Become a SiPartner" (landing, ~60s, épico motivacional)

**Tono:** tráiler de oportunidad. Música creciente. Cortes rápidos, B-roll llamativo, animaciones de dinero apilándose.

| Esc | Prompt Higgsfield (video) | VO / Subtítulo |
|---|---|---|
| 1 | Cinematic aerial of US suburbs at golden hour, diverse latino families in front of new homes, warm lens flare, quick cuts of 5 different states' skylines (Houston, Miami, LA, Charlotte, Denver) | "Licensed Loan Officers are closing the American Dream in all 50 states." |
| 2 | Young bilingual latino man and woman (early 20s, multi-ethnic) on a phone call with confident smile, modern co-working space, laptop showing a US map with face pins | "HOMESÍ empowers YOU to do business with them. We name you **SiPartner**." |
| 3 | Close-up: a bronze house-shaped medal materializing over the phone screen with subtle particle animation; then the JoinSi app UI: MQL cards sliding in | "You get the official status, the best qualified latino LO prospects — hand-picked — and the technology to reach them." |
| 4 | Split screen: SiPartner talks, LO signs a contract on a tablet; then animated counter stacking: $500 + $500, then $200 tiles stacking into a 12-month wall | "When your LO closes, you get paid. First two cases: $1,000. Then every case, for 12 months. Your earnings STACK." |
| 5 | Animated ladder: bronze house → silver house ("SiFounder — recruit SiPartners") → gold house ("SiBroker — exclusive territories, network override"), each medal landing with impact | "Grow your network. Rise to SiFounder. Own territory as SiBroker." |
| 6 | The young pair walking confidently out of frame, US map behind filling with face pins, HOMESÍ logo house closes the frame | "Build a portfolio. Build a business. **We say SÍ when others say no.** JoinSi by HOMESÍ." |

## V1 · "Loan Officers del Nicho Latino" (training, ~90s, cinematográfico realista)

**Tono:** película documental íntima. Guion con personaje, no lectura corporativa.

| Esc | Prompt | Narrativa |
|---|---|---|
| 1 | Handheld cinematic: latina loan officer (40s, Houston office at dusk) reviewing a file, family photo on desk, phone buzzing in Spanish | "Meet the Latino-niche Loan Officer. Licensed. NMLS number on the wall. Most of them speak Spanish — because their clients dream in Spanish." |
| 2 | Warm scene: the LO at a kitchen table with a young latino couple, documents spread, hope in their faces, handshake | "They don't just close loans. They translate the American Dream — pay stubs, ITIN, non-traditional income — into keys in a hand." |
| 3 | B-roll montage: NMLS license close-up, community event, quinceañera backdrop, small business storefronts | "There are thousands of them across the country, serving the fastest-growing homebuyer community in America." |
| 4 | The LO looks at camera, half-smile, natural light | "And HOMESÍ exists to make them unstoppable. Your job? Find them. Bring them home." |

## V2 · "El Flow del Reclutamiento A→H" (training, ~2.5min, la película del proceso)

**Tono:** heist-movie ligero: un plan por pasos que sale bien. Personaje: "Valentina", SiPartner en Bogotá.

| Esc | Beat canónico | Prompt |
|---|---|---|
| A | Status SiPartner | Valentina (23, bogotana, multi-ethnic casting around her) receives bronze house medal animation on her phone: "You are now an official SiPartner — backed by a lender in all 50 states + DC". App shows assigned qualified prospects |
| B | Pre-funnel social | Fast cuts: LinkedIn/IG/Meta posts auto-branded HOMESÍ sliding from the app into her profiles; "We give you the material and the proven Playbook — your social presence is ready on day one" |
| C | Pitch + Pain Relievers | Valentina on a call, split-screen with LO "Carlos" in Houston; overlay chips appear as she speaks: GREAT PRICING · HUNDREDS OF LATINO PROGRAMS · DEDICATED MARKETING ECOSYSTEM · TECHNOLOGY · SPANISH SUPPORT FOR YOUR CLIENTS · DEDICATED BUSINESS PLAN — "You transmit the proven value of HOMESÍ, the platform that amplifies the LO" |
| D | Objeciones | Carlos pushes back naturally ("I've heard this before…", "What about my database?"); Valentina smiles, handles them with the Playbook; subtitle: "We know every objection. You'll be ready." |
| E | Compensación | Animated board: "Up to **225 bps** per case" — Carlos's eyebrows rise; "and that makes the LO very happy" |
| F | Cita con Producción | Calendar animation → Zoom scene: Production Director runs LIVE pricing scenarios and a compensation demo on screen; handshake energy |
| G | Firma | Carlos signs with HOMESÍ on tablet; confetti restrained; "He receives everything promised. Everything." |
| H | El dinero | Carlos closes case 1 and 2 → Valentina's phone: +$500, +$500; timeline animation: avg 2-3 loans/month × 12 months × $200 stacking; her portfolio map gains a new face pin; "New LOs stack on top of the ones you already have. Your earnings compound." |

## V3 · "Pricing — el Hook" (training, ~75s)

**Tono:** revelación con números. Caso tomado del catálogo canónico de programas (usar un programa real del portafolio de nicho; cifras exactas se validan contra la Matriz de Programas antes de rodar — regla de leer fuentes en vivo).

| Esc | Prompt | Narrativa |
|---|---|---|
| 1 | LO at desk, two rate sheets side by side, skeptical face | "Every Loan Officer asks the same first question: 'What's your pricing?' Because everything enters through pricing." |
| 2 | Animated comparison board (brand style, competitor column in cool gray): HOMESÍ column shows LO comp 225 bps AND borrower rate ~5.5% vs. competitor higher rate | "Here's the HOMESÍ answer: earning a full 225 bps compensation, the LO can STILL offer among the best pricing in the market to the borrower." |
| 3 | The borrower couple smiling at a 5.5% figure highlighted in yellow; LO nods slowly, convinced | "Best of both worlds. The LO wins. The client wins. That's the hook — and it's real." |

## V4 · "Compensación 225 bps" (training, ~75s, whiteboard cinematográfico)

| Esc | Prompt | Narrativa |
|---|---|---|
| 1 | Warm classroom scene: young latino trainer at a glass board, JoinSi app mirrored on TV | "Let's do the math every recruiter must master. LO compensation starts at **225 basis points** — that's 2.25% of the loan amount." |
| 2 | Animated calculation building step by step in brand type: $300,000 × 2.25% = **$6,750** in yellow, per case | "On a $300,000 loan? That's $6,750 to the Loan Officer. Per case." |
| 3 | Overlay chips: CORE SERVICE INCLUDED — 90 DAYS: marketing ecosystem, technology, Spanish client support, business plan | "And it includes the full HOMESÍ Core Service ecosystem for the first 90 days. When you say this number with confidence, doors open." |

**Nota de producción Higgsfield:** generar cada escena con `generate_video` (o workflow explainer si aplica), voces con `generate_audio` sobre voz masculina/femenina cálida latina-neutral en inglés, ensamblar con dubbing/explainer, subtítulos quemados según spec. Intros al frente de cada pieza.

---

# PARTE 3 — ÁRBOL DE VOCES DEL SIMULADOR DE LLAMADA (demo real)

**Personaje:** *Carlos Mendoza*, Loan Officer boutique, Houston TX, 8 años de experiencia, escéptico amable, orgulloso de su base de datos. Voz Higgsfield: masculina, 40s, acento americano con calidez latina, ritmo natural con muletillas ("look…", "I mean…"). **Diseño anti-convencional:** Carlos interrumpe, duda, se distrae ("hold on, I got another call"), y NO se convence en la primera llamada — la victoria del nodo final es agendar la reunión con el Director de Producción, no cerrar.

**Estructura:** 14 nodos, 3 variantes de toma por nodo (misma intención, distinta redacción/tono) para sensación de vida. El SiPartner responde eligiendo entre 3 tarjetas (y en post-MVP, hablando). Scoring por nodo: Pitch · Precisión de programas · Manejo de objeción (LAER) · Resiliencia.

| Nodo | Carlos dice (toma base) | Opciones del SiPartner → destino |
|---|---|---|
| N01 apertura | "Hello, this is Carlos." (variante 2: distraído; variante 3: apurado "I've got five minutes") | A: pitch directo → N02 · B: rapport primero → N02 con bonus · C: pedir permiso de tiempo → N02 con bonus |
| N02 sondeo | "HOMESÍ? Never heard of it. Another lender recruiting, right?" | A: negarlo torpemente → N03-frío · B: "Sí — but built for the latino niche, and I'll be specific" → N03 · C: hablar de comisión de una → N03-frío (penaliza: pricing antes de dolor) |
| N03 dolor | "Look, I'm doing fine. I close my two, three loans a month." | A: preguntar por sus casos perdidos del nicho → N04 (correcto) · B: presumir programas sin preguntar → N04-tibio · C: rendirse suave → FIN-perdido |
| N04 objeción 1 · DATA | "Last thing I need is another company touching my database." | LAER correcto (Listen-Acknowledge-Explore-Respond: "your database is yours, the system never touches it") → N05 · débil → N05-tibio · discutir → FIN-perdido |
| N05 hook pricing | "Okay… what's your pricing story? Because that's all that matters." | A: 225 bps + mejor rate al borrower (cifras correctas) → N06 · B: cifras vagas → N06-tibio (score de precisión baja) · C: prometer de más → N07-trampa |
| N06 interés | "Hm. 225 AND competitive rates? That doesn't add up… usually." (variante: silba) | A: explicar el modelo de márgenes sin revelar de más → N08 · B: "come see it live with our Production Director" → N08 directo (bonus: escala a la autoridad correcta) |
| N07 trampa | "So you're GUARANTEEING me 5.2% on every file?" | A: corregir con honestidad (scenario-based, not guaranteed) → N08 · B: sostener la promesa falsa → FIN-perdido (lección: never overpromise) |
| N08 objeción 2 · CAMBIO | "I've moved companies twice. Both times they promised the world." | LAER + prueba social del nicho → N09 · presionar → N09-tibio |
| N09 interrupción REAL | "Hold on— (muffled) —sorry, I got a closing call coming in. Can we do this another day?" | A: micro-cierre en 15 segundos + proponer día/hora concretos → N10 · B: "sure, call me whenever" → N11-Tamagotchi · C: seguir hablando → FIN-perdido |
| N10 agenda | "Tuesday 2pm works. What exactly happens in that meeting?" | A: pintar la reunión (pricing en vivo + demo de compensación con el Production Director) → N12 · B: vago → N12-tibio |
| N11 Tamagotchi | (SIN llamada — el nodo vive en el tiempo: Carlos "quedó de hablar el jueves". Si el SiPartner llama el día pactado → N10; si se pasa 24h, toma fría: "Who is this again?") | Enseña recontacto y disciplina de promesas |
| N12 pre-cierre | "Alright. But if the numbers aren't real, don't waste my Tuesday." | A: confirmar + resumen de valor en 2 frases + colgar profesional → FIN-ganado · B: sobre-hablar → riesgo de reabrir objeciones (N08) |
| FIN-ganado | "…You know what, you're sharp. See you Tuesday." | Score final + medalla parcial + replay con variantes |
| FIN-perdido | "I appreciate the call. Not interested. Take care." (3 variantes según el error) | Feedback específico del error + botón "intentarlo de nuevo" |

**Prompts de generación de voz (Higgsfield `generate_audio`):** un prompt por toma = 14 nodos × 3 variantes ≈ 42 clips + 6 clips de finales ≈ **48 clips**, cada uno de 4–12 segundos. Plantilla:
```
Voice: male, mid-40s, warm American-Latino accent, natural phone-call cadence,
slight room tone as if on a cell phone. Emotion: [skeptical-friendly /
distracted / intrigued / annoyed / won-over]. Read naturally with hesitations:
"[texto del nodo]"
```

**Scoring del simulador (para A5):** cada elección suma a 4 medidores (Pitch, Precisión, LAER, Resiliencia). Rutas "tibias" ganan pero con score bajo — el replay muestra la ruta óptima. Aprobación del módulo: FIN-ganado con ≥75% agregado.

---

# CIERRE A1

**Entregado:** 8 prompts Stitch listos para pegar · 5 briefs de producción por escenas para Higgsfield con protocolo de intros · árbol conversacional de 14 nodos con 48 clips de voz especificados y plantilla de generación.
**Pendiente de validación antes de rodar V3:** cifras exactas del caso de pricing contra la Matriz de Programas (lectura en vivo, nunca de memoria).
**Siguiente gate:** APROBADO A1 → abre A2 (andamiaje Flutter: navegación, tokens del P1B en código, Hive, datos semilla de 24 LOs).
