# JOINSI by HOMESI — Sprint A3 · Rediseño Stitch SiPortfolio
**Fecha:** 2026-07-28 · **Estado:** VIGENTE — revisión A3-R2 (incorpora A3-R: tres estados del dinero + actividad del LO; y A3-R2: restauración de P34 Ranking & Escalera como 6ª pantalla con prompt ST-12) · **Autor de la lógica de diseño:** modelo Fable 5 (por instrucción del fundador)
**Gobernado por:** Acta A0 v1.1 + P1B Sistema de Marca HOMESÍ Oficial
**Estado de construcción:** ejecutado. El código A3-R2 está en el commit `4f855ed` y compiló en verde en GitHub Actions (run #2, 2026-07-29). Este documento sigue vigente como fuente de la lógica de diseño y del STYLE SYSTEM que se reutiliza para diseñar A4 en Stitch. Copia al repo: 2026-10-23.

**Contexto de gobernanza (Adenda A1-2):** A2/A3 se construyeron en Flutter sin ejecutar antes los prompts Stitch, pese a que A1 define la salida de Stitch como insumo de A2. El fundador rechazó el UX del primer APK. Corrección canónica: se reinicia el diseño de las pantallas de SiPortfolio desde cero. Este documento es la fuente de verdad del diseño A3. Flujo: pegar en Stitch (modo Mobile) el STYLE SYSTEM + cada prompt → exportar las 6 imágenes → entregarlas a Claude para el rebuild de la capa visual Flutter (la lógica/datos/canon ya verificados no se tocan).

**Revisión A3-R (2026-07-28):** Fernando precisó la semántica del portafolio: (1) los LOs son un ACTIVO financiero del SiPartner; (2) los LOs tienen estado de actividad (enviando casos vs. dormido); (3) agregaciones por LO y por grupo se mantienen; (4) el dinero tiene TRES estados — causado/ganado, pendiente de cobro (pago al corte cada 30 días, pay period 2) y cobrado; (5) SiPortfolio es el área de tableros financieros del SiPartner; (6) clase mundial UI/UX Android. Prompts ST-07, ST-08, ST-09 y ST-11 fueron revisados; ST-10 sin cambios.

**Revisión A3-R2 (2026-07-28) — restauración de P34:** al releer el Acta A0 se detectó que la Zona 3 SiPortfolio especifica **6 pantallas, no 5**. P34 "Ranking & Escalera" ("Leaderboard de SiPartners, progreso hacia SiFounder (plata) y SiBroker (oro), territorios disponibles", textual del Acta) es DISTINTA de P35 "Mi negocio", y se perdió silenciosamente cuando el código Flutter fusionó P34+P35 en la construcción anterior. Decisión explícita del fundador: restaurarla como 6ª pantalla independiente con prompt propio **ST-12**. Restricción técnica respetada: el Acta A0 declara Flutter + Hive local, SIN BACKEND — el leaderboard de otros SiPartners es DATO SEMILLA MOCKEADO (misma categoría que el dialer mock, el Calendly mock y la cuenta bancaria mock), y la pantalla se diseña para sentirse viva con datos estáticos. Decisión de deduplicación: **la escalera de estatus se muda ÍNTEGRA de ST-11 a ST-12**; ST-11 fue re-patcheado (ver ST-11 revisado A3-R2).

**Instrucciones de uso en Stitch (stitch.withgoogle.com):** modo Mobile. Prefijar SIEMPRE el bloque STYLE SYSTEM antes de cada prompt de pantalla. Exportar imágenes como referencia visual — NO exportar código de Stitch.

---

## 1 · LÓGICA DE DISEÑO

**Tesis: SiPortfolio no es un dashboard financiero — es la escritura de propiedad de un negocio.** El usuario es un estudiante bilingüe que jamás ha tenido un activo. La zona debe producir una emoción en este orden: *orgullo → apetito → urgencia*. Cada pantalla responde UNA pregunta en 3 segundos, con UNA sola cifra amarilla dueña del héroe:

- **P32 Dashboard:** "¿cuánto he ganado ya?" → orgullo. El odómetro amarillo sobre navy es lo primero y lo más grande que existe.
- **P30 Mapa:** "¿dónde vive mi negocio?" → imperio. No son pins, son *personas*: las caritas convierten geografía en relaciones. El mapa es la única pantalla full-navy porque es ceremonial, es el "wow" de la zona.
- **P31 Ficha 360°:** "¿cuánto vale esta relación y cuánto le queda?" → apetito. La carita grande junto al dinero: nunca mostramos dinero sin la persona que lo produce.
- **P33 Proyector:** "¿qué pasa si firmo uno más?" → urgencia honesta. El héroe no vende humo: enseña el acantilado del mes 12 y por eso convierte.
- **P34 Ranking & Escalera:** "¿qué tan alto estoy frente a otros como yo, y qué medalla sigue?" → ambición pública. La comparación social es el amplificador entre apetito y urgencia (ver 1-R2).
- **P35 Mi Negocio:** "¿qué tan grande soy por dentro?" → estatus analítico privado. El resumen ejecutivo del dueño: cortes por estado, tier, costa y equipo.

**Sistema compositivo compartido (las 6 pantallas riman):**
1. **Héroe navy arriba, siempre** (radio 24, sombra navy): kicker en mayúsculas cielo → cifra Poppins ExtraBold amarilla → contexto humano en cielo (caritas o conteo de LOs). Navy = zona ceremonial del dinero.
2. **Debajo del pliegue, blanco cálido de trabajo:** cards radio 16, datos en Inter, títulos Barlow. El navy celebra; el blanco analiza.
3. **Regla de una cifra:** una sola cifra amarilla grande por pantalla. Todo lo demás la sirve. Dos odómetros compitiendo = cero odómetros.
4. **Ritmo de densidad:** héroe (baja densidad, respiración máxima) → fila de acción/estadísticas → evidencia (barras, embudo, chart) → detalle listable. Grid base-4, whitespace generoso; la densidad crece al bajar, nunca al revés.
5. **Disciplina de color como semántica:** amarillo = dinero y solo dinero; rojo = una sola acción por pantalla (slider, CTA); cielo = texto secundario sobre navy Y estado vivo/activo; metálicos = solo medallas. Si el ojo ve amarillo, ganó plata. Si ve rojo, debe tocar. Si ve punto cielo, ese LO está produciendo.
6. **La carita es la moneda visual:** aparece a 36px (pin), 48px (grid/lista), 56px (mini-card), 76px+ (ficha). Misma identidad en las cuatro escalas — el usuario reconoce a "su gente" antes de leer un nombre.

**Por qué:** los dashboards financieros fríos (tablas, azul corporativo, gauges) le hablan a un analista. Nuestro usuario necesita sentir que *ya es dueño de algo que crece*, con calidez Local Hero: cifras enormes y celebratorias, personas con cara, y una sola verdad matemática repetida hasta el cansancio — 500/500/200 por 12 meses, el portafolio se apila.

### 1-R · AJUSTE DE LÓGICA DE DISEÑO (A3-R: tres estados del dinero + actividad del LO)

Los tres estados del dinero no rompen la tesis: la refinan. **La cifra héroe del dashboard sigue siendo el causado ($16,400)** porque es la cifra de identidad: solo crece, nunca retrocede, y es la que sostiene el orgullo de "ya soy dueño de algo". El cobrado es el extracto bancario — mira hacia atrás, no emociona; el pendiente es pequeño y volátil — como héroe encogería el negocio a $2,100. Pero el pendiente se convierte en el nuevo motor emocional del centro de la pantalla: **"en camino"** — dinero ya ganado, con fecha cierta, que NO es proyección. Por eso se visualiza como logística y no como esperanza: cifra navy en negrita (no amarilla, preservando la regla de una cifra), barra de progreso hacia el corte y cuenta regresiva — "entra en el corte del 15 ago · faltan 18 días" — el lenguaje de un paquete rastreado, no de un pronóstico. Emocionalmente: el Proyector promete; el corte *garantiza*. El estado de actividad del LO se pinta en **cielo, el color de lo humano/vivo**: punto cielo sólido = enviando casos; carita atenuada = dormida. Así el mapa y el grid dejan de ser censo y se vuelven pulso, y los 2 LOs apagados crean la urgencia honesta que alimenta SiRadar: despertarlos o reemplazarlos. Secuencia final: orgullo (causado) → anticipación (en camino) → urgencia (activos 5/7).

**Dataset canónico A3-R usado en todos los prompts** (derivado de la semilla real + `payoutFor(closed) = $500 + $500 + $200×(n−2)`): portafolio de **7 LOs firmados en 6 estados, 61 closed loans, $16,400 causado = $14,300 cobrado + $2,100 en camino** (9 casos cerrados aún no cobrados que entran en el **corte del 15 ago** — pay period 2, pagos cada 30 días, faltan 18 días al 28 jul). **Activos 5 de 7** (enviando casos: Yulissa, Andres, Paola, Vanessa, Natalia; dormidos: Sebastian GA, Camilo CA). Por LO: Yulissa Ramírez TX 8 closed = $2,200 ($1,800 cobrado + $400 en camino, 2 casos); Andres FL 14 = $3,400 ($3,000 + $400, 2 casos); Natalia DC 12 = $3,000 ($2,600 + $400, 2 casos); Vanessa IL 11 = $2,800 ($2,600 + $200, 1 caso); Paola TX 3 = $1,200 ($500 + $700, 2 casos: su 2º closed $500 + $200); Sebastian GA 9 = $2,400 (todo cobrado); Camilo CA 4 = $1,400 (todo cobrado). Ventana restante del portafolio **$17,000**; 2 LOs nuevos × 2 loans/mes = **$5,400 c/u** → proyección total **$27,800**.

### 1-R2 · LÓGICA DE P34 RANKING & ESCALERA (A3-R2)

En la secuencia orgullo → apetito → urgencia, P34 inserta el **deseo de estatus** como amplificador entre el apetito y la urgencia: el Dashboard dice "ya gané $16,400" (orgullo privado); el Ranking dice "otros exactamente como tú ganaron más — y estás a $1,400 del puesto 3" (ambición pública). La comparación social convierte la cifra abstracta del Proyector ("un LO nuevo vale $5,400") en un movimiento concreto en una tabla con nombres y caras. Los territorios agregan escasez real: Georgia ya fue reclamada; Carolina del Norte, Arizona y Nueva Jersey siguen libres — urgencia de llegar al oro antes que otro. **Honestidad del dato semilla:** el negocio paga en cortes de 30 días, así que una tabla de posiciones "al corte del 15 jul" es *naturalmente estática* — es standings de temporada, no feed en vivo. Prohibido todo lo que solo tiene sentido en tiempo real: nada de "actualizado hace 2 min", tickers, badges LIVE pulsantes. Mismo contrato de ficción que el dialer y la cuenta bancaria mock: cifras no redondas, derivadas de la fórmula payoutFor, que se sienten auditadas, no infladas.

**Dataset semilla del leaderboard (A3-R2)** — todos los totales cumplen `total = 200×closed + 600×LOs` (equivalente a sumar `payoutFor` cuando todo LO tiene ≥2 closed, como en el portafolio del usuario): #1 Marisol Gutiérrez, 11 LOs, 94 closed, 8 estados, $25,400 (SiFounder, badge plata); #2 Diego Fuentes, 9 LOs, 80 closed, 7 estados, $21,400; #3 Valentina Ríos, 8 LOs, 65 closed, 5 estados, $17,800; **#4 USUARIO ("TÚ"), 7 LOs, 61 closed, 6 estados, $16,400**; #5 Kevin Morales, 6 LOs, 48 closed, 4 estados, $13,200; #6 Alejandra Peña, 4 LOs, 29 closed, 3 estados, $8,200 (red sin casos este periodo, carita atenuada). Delta accionable: $1,400 al puesto 3 ≈ un LO nuevo con 4 closed ($500+$500+$200+$200). Territorios sin SiBroker: Carolina del Norte, Arizona, Nueva Jersey; Georgia reclamada por R. Castillo (SiBroker, fuera de esta cohorte del ranking). Requisitos de escalera: SiFounder = 8 LOs + 1 SiPartner reclutado (usuario: 7/8 y 0/1); SiBroker = 100 closed + territorio exclusivo (usuario: 61/100).

---

## 2 · STYLE SYSTEM (prefijar en cada prompt de Stitch)

```
STYLE SYSTEM — JoinSi by HOMESI (Android app, 412x915, mobile portrait):
Brand colors ONLY: deep navy #001A40, red #FF4040, light sky blue #A6DEFF, warm yellow #F8C845, warm white #FCFCFA background; support neutrals: gray #6B7280 body text, #E5E7EB hairlines. NO other hues, no gradients to foreign colors, no teal, no purple.
Money and celebration numbers are ALWAYS yellow #F8C845 on navy #001A40 — never any other color combination for money. Never white text on yellow or sky. Red is reserved for one primary action per screen.
Typography: Poppins ExtraBold for hero numbers and headlines; Barlow Bold for section titles; Inter Regular/Medium for body and data. Section kickers: small ALL-CAPS labels with wide letter-spacing in sky blue on navy, gray on white.
Shapes: pill buttons (fully rounded), cards 16px radius with soft translucent navy shadows, large hero containers 24px radius, small chips 8px radius, generous whitespace, 4px-base spacing grid.
Brand mark: small white house icon inside a red circle. Warm, human, energetic "local hero" mood — never cold corporate fintech. No robots, no AI imagery, no stock-photo gloss.
Bottom navigation bar on warm white: 3 tabs — SiAcademy (graduation cap icon), SiRadar (radar sweep icon), SiPortfolio (USA map-pin icon, ACTIVE state in red #FF4040 with red label).
Loan Officer avatars ("caritas"): friendly flat-illustrated cartoon faces inside geometric frames (circle, squircle, hexagon, diamond) in brand color combos (navy/sky/red/yellow), warm smiling latino professionals, each one distinct.
Activity semantics: a small solid sky-blue dot on/near a carita = actively sending cases this month; a dimmed carita at reduced opacity with thin gray ring = no cases this month. Sky blue is the color of "alive"; yellow stays money-only.
```

---

## 3 · PROMPTS STITCH (6 pantallas A3-R2)

### ST-07 · P30 Mapa USA Vivo (REVISADO A3-R)

```
Design a full dark-navy mobile map screen "Mi mapa USA" for a mortgage recruiting app. Entire screen background deep navy #001A40, immersive dark-mode map.
Top app bar on navy: white bold title "Mi mapa USA", small reset-view icon in sky blue on the right.
Below it one horizontal scrolling row of filter chips (8px radius, thin sky-blue outline, sky-blue 12px text): active chip "Solo firmados · 7" filled solid yellow #F8C845 with navy text; inactive chips "Enviando casos · 5", "Boutique", "Mid", "Top", "West", "Central", "East", "FHA", "ITIN", "Conventional".
Hero (70% of screen): a stylized USA states map in slightly lighter navy tones with thin darker state borders; states holding portfolio glow a touch lighter. Pinned on their states: 7 small friendly cartoon-face avatars ("caritas", 36px, illustrated faces in circle/squircle/hexagon/diamond frames using navy/sky/red/yellow combos), two on Texas, one each on Florida, California, Georgia, Illinois, Washington DC. FIVE caritas (both Texas, Florida, Illinois, DC) have a soft glowing sky-blue ring = sending cases this month; TWO caritas (Georgia, California) are dimmed to ~60% opacity with a thin gray ring = asleep. Each carita wears a tiny yellow circular badge with a navy number of closed loans (8, 14, 4, 9, 11, 12, 3). One carita (Texas) is enlarged as selected.
Small floating legend chip top-left on translucent darker navy, two lines in 11px sky blue: "badge = closed loans" and "brillo cielo = enviando casos este mes".
Bottom sheet mini-card floating over the map: warm white card, 16px radius, soft shadow. Left: selected carita avatar 56px with sky-glow ring and tiny red edit dot. Middle: "Yulissa Ramirez" bold navy 16px, "Dallas, TX · NMLS 1400731" small gray, chips row "Mid" + "FHA" + a sky-outline chip with solid sky dot "Enviando casos", pipeline line "44 leads · 20 pre-approvals · 11 ratified · 8 closed" in 11px gray. Right column: money pill "$2,200" yellow-on-navy, "mes 5/12" tiny gray, red text-link "Abrir 360°".
Pinned footer bar in slightly lighter navy with four stats, labels in sky 11px, values white bold 18px: "5 de 7 activos", "6 estados", "61 closed loans", and "$16,400 ganado" with the money value in yellow.
Bottom nav: SiPortfolio tab active in red.
```

### ST-08 · P32 Dashboard de Dinero (REVISADO A3-R)

```
Design the money home screen of SiPortfolio — a financial asset-portfolio dashboard (brokerage-grade information density) with warm Local Hero character — on warm white #FCFCFA background, vertically scrollable, generous whitespace.
Hero at top: large navy #001A40 container, 24px radius, soft navy shadow, roomy padding. Inside: caps kicker "GANADO ESTE AÑO" in sky blue with wide letter-spacing; below it a huge odometer-style figure "$16,400" in yellow #F8C845 Poppins ExtraBold ~48px — the single largest element and the ONLY big yellow number on screen; under it one sky-blue 13px line with a small solid sky dot: "5 de 7 Loan Officers enviando casos · 6 estados".
Below the hero, two equal white cards side by side (16px radius). LEFT anticipation card: caps gray kicker "EN CAMINO", value "$2,100" big bold navy (NOT yellow), caption "9 casos cerrados · aún no cobrados" tiny gray, then a slim sky-blue progress bar filling toward the pay cut with caption "entra en el corte del 15 ago · faltan 18 días" navy semibold 11px, and a full-width red #FF4040 pill button "VER MI CORTE" in white bold — the only red button on the whole screen. RIGHT card: caps kicker "COBRADO", value "$14,300" bold navy, subtitle "ya en tu cuenta · pagos cada 30 días" tiny gray.
Next a wide navy card (16px radius) acting as door to the USA map: left side an overlapping fan of 5 small cartoon-face avatars (caritas, 40px, sky-glow ringed = sending cases); text "Mi mapa USA" white bold + "6 estados · 5 enviando casos" sky 12px; yellow chevron on the right.
Then two light tiles in a row: "Proyector de ingresos" with an upward trend icon in red, and "Mi negocio" with a bar-chart icon in red, both navy bold 13px labels.
Section title "Mi portafolio" in Barlow Bold navy with a tiny gray sublabel "5 activos · 2 sin casos este mes", then a vertical list of LO cards: each warm white card with carita 48px left (active ones with a small solid sky dot on the frame), name bold navy, location + "mes x/12" gray small, thin funnel line tiny gray, and on the right a rounded navy money pill with yellow bold total plus one tiny gray line under it "cobrado / en camino". Show 3 rows: "Yulissa Ramirez · Dallas, TX · mes 5/12 · 44/20/11/8 lead→closed" pill "$2,200" + "cobrado $1,800 · en camino $400"; "Andres Bello · Miami, FL · mes 6/12" pill "$3,400" + "cobrado $3,000 · en camino $400"; "Natalia Pardo · Washington, DC · mes 8/12" pill "$3,000" + "cobrado $2,600 · en camino $400".
Bottom nav 3 tabs, SiPortfolio (USA pin) active in red.
```

### ST-09 · P31 Ficha de Portafolio LO 360° (REVISADO A3-R)

```
Design a Loan Officer relationship detail screen ("ficha 360") on warm white background, scrollable, navy app bar with white bold title "Yulissa Ramirez".
Hero: navy container 24px radius. Left: large friendly cartoon-face avatar (carita) 80px in a squircle frame with sky-blue glow ring and a tiny red edit badge. Right: "Dallas, TX" sky 13px, "NMLS 1400731" sky 11px, a small sky-outline chip with a solid sky dot reading "Enviando casos" 11px, then the money headline "$2,200" in yellow Poppins ExtraBold ~32px with caption "ganado con esta relación" in sky 11px — the only big yellow figure on screen.
Directly under the hero: a money-state strip — one white card 16px radius split into two cells by a thin hairline. Left cell: caps gray kicker "COBRADO", value "$1,800" bold navy. Right cell: caps gray kicker "EN CAMINO", value "$400" bold navy, caption "2 casos cerrados · entra en el corte del 15 ago" tiny gray with a tiny clock icon — earned money traveling to you, not a projection.
Section kicker "VENTANA DE 12 MESES" gray caps with wide tracking. Under it a segmented progress track of 12 small rounded segments: first 5 filled solid yellow, remaining 7 light gray #E5E7EB. Caption row: left "Mes 5 de 12 · faltan 7 meses" navy semibold 13px; right a small navy money pill "$2,200" in yellow meaning value still to come; sub-caption "por venir · $314/mes durante 7 meses" tiny gray.
Section kicker "EMBUDO DE PRODUCCIÓN". Four thin horizontal bars, single sky-blue family with decreasing opacity, left-aligned, values right-aligned bold navy: Leads 44 (longest), Pre-approvals 20, Ratified 11, Closed loans 8.
A "how you get paid" callout: very light red-tinted panel with a 4px solid red left border, kicker "CÓMO TE PAGAN" in red caps, body navy 13px: "$500 + $500 en los dos primeros closed loans de este LO, luego $200 por cada closed loan durante 12 meses. Cada caso cerrado se cobra al corte: pagos cada 30 días. Tu portafolio se apila: cada LO que firmas suma un flujo mensual nuevo."
Bottom row: three small white KPI cards (16px radius): "TIER / Mid", "PROGRAMA / FHA", "RITMO REAL / 1.6 por mes", caps gray labels, bold navy values.
Warm, human, ownership feeling — a relationship that is a producing asset, not a CRM record. Bottom nav SiPortfolio active red.
```

### ST-10 · P33 Proyector de Ingresos — SIN CAMBIOS

El Proyector habla del futuro condicional ("si firmas"); los tres estados del dinero pertenecen al pasado y al presente garantizado. Mezclarlos diluiría la distinción emocional proyección vs. dinero en camino. Se mantiene el prompt A3 original íntegro.

```
Design an income projector screen on warm white background, navy app bar titled "Proyector de ingresos" in white bold.
Hero: navy container 24px radius. Kicker "PRÓXIMOS 12 MESES" sky caps wide-tracked; giant yellow figure "$27,800" Poppins ExtraBold ~44px; beneath it a slim horizontal stacked bar: left segment muted steel-blue labeled portion, right segment yellow. Legend row of two dots: steel-blue dot "Portafolio por entrar — $17,000" and yellow dot "LOs nuevos — $10,800", labels sky 11px, values white bold 13px.
Section kicker "SI FIRMAS" gray caps. Two slider rows: bold navy 15px labels "2 Loan Officers nuevos" and "2.0 closed loans / mes cada uno", each with a red #FF4040 slider (red thumb, red active track, light gray inactive track).
Explainer callout: light red-tinted panel with 4px red left border, navy 13px body: "Cada Loan Officer nuevo vale $5,400 en tus primeros 12 meses con él: $500 + $500 en sus dos primeros closed loans, luego $200 por closed loan. El portafolio se apila — no se reemplaza. Y cada ventana se cierra en el mes 12."
Section kicker "MES A MES" plus one gray 12px line: "Dónde se agotan tus ventanas actuales — y qué reponen los LOs nuevos."
Main chart: navy panel 24px radius containing a 12-column stacked bar chart, month numbers 1–12 in sky 11px under the bars. Bottom segments in muted steel-blue (current portfolio) start tall and step DOWN month by month until almost zero at months 11–12 — a visible cliff. Top segments in solid yellow (new LOs) start small in month 1, jump at the $500 ramp months and settle steady, so total bars stay healthy while the blue erodes. Rounded 4px bar tops.
Tone: honest ambition — the chart argues "keep recruiting", not "get rich". Bottom nav SiPortfolio active red.
```

### ST-11 · P35 Mi Negocio (REVISADO A3-R2 — la escalera de estatus se mudó a ST-12)

Cambio A3-R2: el héroe de medallas sale de esta pantalla (ahora vive solo en ST-12). El héroe pasa a ser el resumen ejecutivo 2×2 dentro de navy, y queda un único chip plano de estatus como puerta hacia P34. Prohibidas las medallas metálicas en esta pantalla.

```
Design an executive "Mi negocio" summary screen on warm white background, navy app bar titled "Mi negocio" in white bold, scrollable.
Hero: navy container 24px radius, caps kicker "MI NEGOCIO EN UNA MIRADA" in sky blue wide-tracked. Inside the navy hero a 2x2 stat grid with caps sky 11px labels: "GANADO / $16,400" with the money value in yellow Poppins ExtraBold ~32px — the only yellow figure on screen; "CLOSED LOANS / 61" white bold; "ACTIVOS / 5 de 7" white bold preceded by a small solid sky dot; "ESTADOS / 6" white bold.
At the hero's bottom edge one slim status pill chip (slightly lighter navy fill, thin sky outline): a small FLAT white house icon + "SiPartner · ranking y escalera →" in sky 12px — flat icon only, NO metallic medals anywhere on this screen.
Section kicker "GANADO POR ESTADO": horizontal thin bar chart, single sky-blue bars left-aligned, state code labels navy 12px left, money values bold navy right: TX $3,400, FL $3,400, DC $3,000, IL $2,800, GA $2,400, CA $1,400.
Section kicker "GANADO POR TIER": same bar style: Top $9,200, Mid $7,200.
Section kicker "GANADO POR COSTA": East $8,800, Central $6,200, West $1,400.
Section kicker "MIS LOAN OFFICERS" with tiny gray sublabel "punto cielo = enviando casos este mes": a grid of 7 distinct friendly cartoon-face avatars (caritas 48px, mixed circle/squircle/hexagon/diamond frames in navy/sky/red/yellow combos), first names centered under each in navy bold 11px: Yulissa, Andres, Paola, Sebastian, Vanessa, Natalia, Camilo. Yulissa, Andres, Paola, Vanessa and Natalia each carry a small solid sky-blue dot on the frame edge; Sebastian and Camilo are dimmed to ~60% opacity with a tiny gray caption "sin casos este mes" under the name.
Feeling: a young entrepreneur reviewing a real, growing business — proud, warm, orderly. Bottom nav SiPortfolio active red.
```

### ST-12 · P34 Ranking & Escalera (NUEVO A3-R2 — restaurado del Acta A0)

Único hogar de las medallas metálicas casa. Leaderboard = dato semilla mockeado enmarcado como standings de temporada al corte de pago (nunca feed en vivo).

```
Design a competitive status screen "Ranking y escalera" for a mortgage recruiting app, warm white #FCFCFA background, scrollable, navy app bar with white bold title "Ranking y escalera".
Hero: navy #001A40 container 24px radius, caps kicker "ESCALERA DE ESTATUS" in sky blue wide-tracked. Inside, a horizontal ladder of three metallic HOUSE-shaped medallions connected by a slim progress track: bronze house fully lit labeled "SiPartner" white bold with "alcanzado" sky 11px; silver house half-dimmed labeled "SiFounder" with two tiny sky-outline chips "7/8 LOs" and "0/1 SiPartner reclutado"; gold house dimmed labeled "SiBroker" with chip "61/100 closed · territorio exclusivo". The connecting track fills solid sky blue past bronze and ~85% of the way toward silver, then light gray. Metallic bronze/silver/gold shading allowed ONLY on these three medals. One closing sky 12px line under the ladder: "Te falta 1 LO y 1 SiPartner reclutado para la plata".
Directly under the hero a full-width red #FF4040 pill button "EMPEZAR MI RUTA A SiFOUNDER" in white bold — the only red action on the screen.
Section kicker "RANKING RED JOINSI · CORTE DEL 15 JUL" gray caps with tiny gray sublabel "el ranking se actualiza en cada corte de pago · cada 30 días". Vertical leaderboard of 6 rows, each a warm white card 16px radius: left a bold navy rank numeral, then a friendly cartoon-face carita avatar 48px, name bold navy 14px with a stats line "x LOs · y closed · z estados" gray 11px, and on the right a small rounded navy pill with the money total in yellow bold.
Rows: 1 "Marisol Gutierrez · 11 LOs · 94 closed · 8 estados" pill "$25,400" plus a tiny silver house badge by her name; 2 "Diego Fuentes · 9 LOs · 80 closed · 7 estados" pill "$21,400"; 3 "Valentina Rios · 8 LOs · 65 closed · 5 estados" pill "$17,800"; 4 is the USER row — highlighted with a soft sky-tinted background and thin navy outline, a small "TÚ" chip in navy text on solid yellow, "7 LOs · 61 closed · 6 estados" pill "$16,400"; 5 "Kevin Morales · 6 LOs · 48 closed · 4 estados" pill "$13,200"; 6 "Alejandra Pena · 4 LOs · 29 closed · 3 estados" pill "$8,200" with her carita dimmed to ~60% opacity and a tiny gray caption "red sin casos este periodo". Rows 1-4 caritas carry the small solid sky-blue dot on the frame edge = their networks sent cases this period.
Between rows 3 and 4 a slim connector callout line, navy semibold 12px with a tiny navy up-arrow: "A $1,400 del puesto 3 — un LO nuevo te sube".
Section kicker "TERRITORIOS SiBROKER DISPONIBLES" gray caps with tiny gray sublabel "estados sin SiBroker asignado · se reclaman al llegar al oro". Horizontal scrolling row of 4 cards 16px radius: three available cards — "Carolina del Norte", "Arizona", "Nueva Jersey" — each with a thin navy state-outline icon, navy bold name, gray caption "disponible", and a thin sky-blue top accent; one dimmed card "Georgia" with caption "reclamado por R. Castillo · SiBroker" and a tiny gold house badge.
Mood: a league table the user is climbing — competitive but warm, teammates not rivals; NO live-ticker, no "LIVE" badges, no real-time timestamps — this is a season standings board frozen at the pay cut. Bottom nav 3 tabs, SiPortfolio active in red.
```

---

## 4 · PARA EL REBUILD FLUTTER

1. **Regla de una cifra amarilla por pantalla:** si Stitch devuelve dos números amarillos grandes, se implementa solo uno; el otro baja a navy sobre blanco. "En camino" y "cobrado" son SIEMPRE navy en negrita, nunca amarillo.
2. **Héroe navy siempre primero en el árbol:** kicker cielo caps → cifra `moneyStyle()` → contexto humano. Nunca meter CTAs rojos dentro del héroe.
3. **Un solo rojo accionable por pantalla** (VER MI CORTE, sliders, "Abrir 360°", "EMPEZAR MI RUTA A SiFOUNDER"): si aparecen dos, uno se degrada a link navy.
4. **Toda cifra de dinero sale de `LoanOfficer.payoutFor()` / `remainingWindowValue()` / derivados de casos** — jamás replicar la fórmula ni hardcodear; el rediseño visual no toca la capa canónica ya verificada.
5. **Carita en 4 escalas fijas (36/48/56/76-80)** con el mismo `AvatarSpec`; el reconocimiento entre pantallas depende de esa constancia. El estado de actividad (anillo cielo / atenuado) es propiedad del `AvatarSpec`, no un widget ad-hoc por pantalla.
6. **Densidad creciente hacia abajo:** héroe aireado (padding sp24), luego cards sp16, luego listas; nunca comprimir el héroe para que "quepa más".
7. **Viz monocroma por entidad:** barras y embudos en una sola familia (cielo/steel) con opacidad; el amarillo en charts solo para el segmento "dinero nuevo" del proyector.
8. **El acantilado del mes 12 es contenido, no decoración:** el chart debe calcularse mes a mes real aunque la imagen de Stitch lo estilice distinto.
9. **Medallas metálicas encapsuladas en `MedallaCasa`** y prohibidas fuera de ST-12 (P34 Ranking & Escalera). En P35 el estatus se representa SOLO con el ícono plano de casa dentro del chip "SiPartner · ranking y escalera →". El track de progreso de la escalera es cielo, nunca amarillo (amarillo = dinero).
10. Si la composición de Stitch contradice el sistema P1B (texto blanco sobre amarillo, rainbow en barras, dos héroes), **gana el sistema**: Stitch aporta layout y mood, no excepciones a las reglas.
11. **P34 no es P35 y no se vuelven a fusionar:** son dos rutas, dos pantallas, dos entradas de navegación (P35 accede a P34 vía el chip de estatus; el Dashboard puede enlazar ambas). El bug de fusión que borró P34 queda documentado aquí como anti-patrón.

### 4-R · IMPLICACIONES PARA EL MODELO DE DATOS (A3-R)

- `LoanOfficer` deja de resumir producción en un `int closed`: necesita `List<ClosedCase>` con `{closedDate, collectedDate?}` por caso. `earned` sigue saliendo de `payoutFor(closedCases.length)` — la fórmula canónica no cambia.
- `payoutFor` gana un derivado `marginalPayoutFor(n)` (valor del caso n-ésimo: $500, $500, luego $200) para poder valorar caso a caso el pendiente.
- Derivados por LO, nunca campos duplicados: `collectedAmount` = suma de payouts marginales con `collectedDate != null`; `pendingAmount = earned − collectedAmount`; `pendingCases` = casos con `collectedDate == null`.
- Nuevo derivado `activityStatus` (enum `enviandoCasos | sinCasosEsteMes`), calculado de `closedCases` con `closedDate` dentro del período de pago vigente — no se almacena.
- `Store`/estado global: `nextCutDate` (DateTime), `payPeriodDays = 30`, `payPeriodNumber = 2`; `daysToCut` derivado de `now`.
- Agregados globales memoizados en el Store: `totalEarned`, `totalCollected`, `totalPending`, `pendingCasesCount`, `activeCount` — deben cuadrar por construcción: `totalEarned == totalCollected + totalPending`.
- Acción `applyCut()` que marca `collectedDate` en batch al llegar el corte (para demo/simulación del ciclo de pago).
- Semilla A3-R: 9 casos pendientes distribuidos Yulissa 2 ($400), Andres 2 ($400), Natalia 2 ($400), Vanessa 1 ($200), Paola 2 ($700, incluye su 2º closed de $500) = $2,100; Sebastian y Camilo sin casos en el período.

### 4-R2 · IMPLICACIONES PARA EL MODELO DE DATOS (A3-R2 — P34)

- Nueva entidad semilla `RivalSiPartner` (Hive local, SIN backend): `{name, avatarSpec, losCount, closedCount, statesCount, statusTier (siPartner|siFounder|siBroker), networkActiveThisPeriod (bool)}`. El total ganado se DERIVA con la misma economía canónica: `earned = 200×closedCount + 600×losCount` (válido porque toda semilla asume LOs con ≥2 closed) — jamás hardcodear los dólares del leaderboard.
- Semilla canónica del ranking: Marisol Gutiérrez 11/94/8 (SiFounder), Diego Fuentes 9/80/7, Valentina Ríos 8/65/5, USUARIO 7/61/6, Kevin Morales 6/48/4, Alejandra Peña 4/29/3 (inactiva). El usuario se inserta ordenado por `earned`, nunca en posición fija: si su portafolio real crece, sube de puesto solo — el ranking mock reacciona al dato real y se siente vivo.
- `deltaToNextRank` derivado (hoy $1,400) alimenta el connector callout; el marco temporal del ranking reutiliza `nextCutDate`/`payPeriodNumber` del Store — "corte del 15 jul" = corte anterior (`payPeriodNumber − 1`), coherente con el corte del 15 ago del Dashboard.
- Entidad semilla `Territory`: `{name, region, claimedBy?}` — NC, AZ, NJ libres; GA reclamada ("R. Castillo").
- Requisitos de escalera como constantes canónicas: `siFounderReq = {los: 8, siPartnersRecruited: 1}`, `siBrokerReq = {closed: 100, territory: true}`; el progreso se deriva del portafolio real del usuario.
