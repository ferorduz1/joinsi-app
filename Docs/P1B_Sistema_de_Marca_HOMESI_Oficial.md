# P1B · SISTEMA DE MARCA HOMESÍ — MANUAL COMPLETO DE IDENTIDAD PARA LA APP
### Única fuente de verdad visual. Manda sobre P1, P3 y P4 en todo lo que sea diseño.
**Fuente:** Brand Book HOMESÍ 2025, Powered by Supreme Lending · **Emitido por:** CMO Agéntico · Julio 2026
**Copia al repo de JoinSi:** 2026-10-23, desde la memoria del proyecto CEO Agéntico. Para JoinSi rigen además las precisiones del Acta A0 §4 y de `CLAUDE.md` §3 (firma "Powered by Supreme Lending" solo en el lockup; metales de estatus solo en `MedallaCasa`).

> Este documento es **normativo**. Si algo aquí contradice otro archivo del paquete, gana este.
> Al final hay un bloque de **tokens CSS listos para pegar** — úsalo tal cual, no reinventes valores.

---

# 1 · FUNDAMENTOS

## 1.1 Arquetipo de marca
**"Local Hero"** — el campeón de la comunidad. Se expresa en dos atributos:
- **People's Champion:** voz de la gente, historias reales, abierto al diálogo.
- **Real & Human:** tecnología humanizada, vive y respira el servicio.

**Traducción al diseño:** la app **no puede sentirse corporativa ni fría**. Debe sentirse como el vecino experto que por fin te dice que sí. Cálida, directa, con aire.

## 1.2 Tagline y manifiesto
- **Tagline:** *"We say SÍ when others say no."* (el "SÍ" siempre en amarillo Latin Mornings)
- **Misión:** *"Your path HOME SÍmplified."*
- **Firma obligatoria:** *"Powered by Supreme Lending"* en el header.

## 1.3 Los cinco principios de diseño de la app
1. **Aire generoso.** Jerarquía por espacio antes que por línea divisoria.
2. **El color es semántico, no decorativo.** Cada color tiene un trabajo asignado (§3.3).
3. **Movimiento con propósito.** 200–400ms, easing suave. Nada rebota, nada parpadea.
4. **Densidad progresiva.** La vista general respira; el detalle es denso pero legible.
5. **Dos registros, una marca.** El manual y lo que ve el cliente se distinguen por *tratamiento*, no por paleta (§9).

---

# 2 · LOGO Y MARCAS

## 2.1 Logo primario (decisión del Director)
**La casa dentro del círculo rojo.** HOMESÍ tiene más de un símbolo avalado en el Brand Book —el doble chevrón y los íconos del sistema— pero para esta app el primario es **la casa**.

- **Header:** `[casa-círculo roja]` + wordmark **HOMESÍ** + `Powered by Supreme Lending`
- **Favicon:** la casa-círculo (roja sobre claro, o blanca sobre navy)
- **Archivo:** `logo_oficial_transparente.png` (512×512, PNG con alpha, recortado del archivo real del Brand Book)
- **En Higgsfield:** `media_id 86a96e38-bb95-4f80-9605-a19a3b4b5f13`

## 2.2 Vector de la casa (para uso inline)
```svg
<svg viewBox="0 0 100 100" role="img" aria-label="HOMESÍ">
  <circle cx="50" cy="50" r="50" fill="#FF4040"/>
  <path d="M30 70 V45 L50 27 L70 45 V70 a3 3 0 0 1-3 3 H33 a3 3 0 0 1-3-3 Z" fill="#FCFCFA"/>
  <path d="M43 73 V56 a7 7 0 0 1 14 0 V73 Z" fill="#FF4040"/>
</svg>
```
> **Preferir siempre el PNG oficial** sobre este vector. El vector es respaldo para tamaños pequeños o cuando se necesita un solo color.

## 2.3 Chevrón (símbolo secundario)
El doble chevrón hacia **arriba** dentro de squircle rojo — representa progreso y "pasos". En esta app **no es el logo**: se usa como **ícono "Growth"** del sistema (§6).
```svg
<svg viewBox="0 0 100 100"><rect width="100" height="100" rx="26" fill="#FF4040"/>
<path d="M27 53 L50 34 L73 53" fill="none" stroke="#FCFCFA" stroke-width="11.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M27 70 L50 51 L73 70" fill="none" stroke="#FCFCFA" stroke-width="11.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
```

## 2.4 Clear space y tamaños
- **Clear space mínimo:** el alto de la casa alrededor de todo el lockup. Nada invade esa zona.
- **Tamaño mínimo:** 24px de alto para el símbolo solo; 96px de ancho para el lockup horizontal.
- **Versiones válidas:** positivo (rojo sobre claro) · negativo (blanco sobre navy o rojo) · mono navy.

## 2.5 Prohibido
Deformar o rotar · cambiar los colores fuera de las variantes del Brand Book · aplicar sombras, degradados o contornos al logo · encerrarlo en formas ajenas · usar el chevrón como logo primario en esta app · redibujarlo a mano.

---

# 3 · COLOR

## 3.1 Paleta oficial (valores exactos — prohibido cualquier color fuera de esta lista)

| Nombre | HEX | RGB | Rol |
|---|---|---|---|
| **Enriching Skies** | `#001A40` | 0,26,64 | **Primario.** Tinta de autoridad, títulos, fondos oscuros, texto de lectura |
| **Warm Embrace** | `#FF4040` | 255,64,64 | **Primario.** La marca. CTAs, acentos, reglas de oro, columna "HOMESÍ" en comparativos |
| **Light Sky** | `#A6DEFF` | 166,222,255 | Secundario. Fondos suaves, chips, destacados, texto sobre navy |
| **Latin Mornings** | `#F8C845` | 248,200,69 | Secundario. Énfasis cálido, estado activo, el "SÍ" del tagline |
| **New Day** | `#FCFCFA` | 252,252,250 | Secundario. Fondo base de la app |

## 3.2 Neutros de apoyo (autorizados por el Director, uso restringido)

| Nombre | HEX | Uso exclusivo |
|---|---|---|
| Competitor Gray | `#E8EAF0` | **Solo** la columna del competidor / status quo en battle cards |
| Neutral Text | `#6B7280` | Texto secundario, notas al pie, metadatos |
| Hairline | `#E5E7EB` | Bordes de 1px, separadores sutiles |

## 3.3 Reglas semánticas del color (no negociables)
- **Rojo = la marca y lo que importa.** CTA primario, acentos, reglas de oro, la columna HOMESÍ. **Nunca** para "error" genérico ni como relleno decorativo masivo.
- **Navy = autoridad.** Títulos, texto de lectura, fondos de sección oscura. Es el color con el que se *lee*.
- **Light Sky y Latin Mornings = respiro y énfasis.** Nunca como fondo dominante de lectura larga.
- **New Day = el lienzo.** Fondo base.
- **Gris frío = el otro lado.** Reservado a la columna del competidor/status quo.

## 3.4 Combinaciones válidas (contraste verificado)

| Fondo | Texto permitido |
|---|---|
| New Day `#FCFCFA` | Navy `#001A40` (15.9:1 ✅) · Neutral `#6B7280` (4.8:1 ✅) · Rojo `#FF4040` solo en ≥24px bold |
| Navy `#001A40` | New Day `#FCFCFA` (15.9:1 ✅) · Light Sky `#A6DEFF` (10.9:1 ✅) · Latin Mornings `#F8C845` (9.4:1 ✅) |
| Rojo `#FF4040` | New Day `#FCFCFA` (3.4:1 — solo ≥18px bold) · Navy `#001A40` (4.7:1 ✅) |
| Light Sky `#A6DEFF` | Navy `#001A40` (10.9:1 ✅). **Nunca** texto blanco |
| Latin Mornings `#F8C845` | Navy `#001A40` (9.4:1 ✅). **Nunca** texto blanco |

> **Regla dura:** texto blanco sobre amarillo o sobre light sky está prohibido — no pasa contraste.

---

# 4 · TIPOGRAFÍA

## 4.1 Familias

| Rol | Familia | Fallback autorizado |
|---|---|---|
| **Headline / H1** | **Articulat CF Bold** | **Poppins 700/800** — si se usa el fallback, **declararlo en un comentario del código** |
| **H2 / H3 / sub-heads** | **Barlow Bold** | — (Google Fonts) |
| **Cuerpo y datos** | **Inter** Regular / Bold para cifras | — (Google Fonts) |
| **Notas manuscritas** | **Kalam** | — (Google Fonts) |

```html
<link href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;600;700&family=Inter:wght@400;500;600;700&family=Kalam:wght@400;700&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
```

## 4.2 Escala tipográfica completa

| Nivel | Familia | Tamaño | Peso | Tracking | Line-height | Color |
|---|---|---|---|---|---|---|
| **H1** | Articulat/Poppins | 48px | 700 | -0.01em | 1.05 | Navy |
| **H2** | Barlow | 36px | 700 | -0.005em | 1.15 | Navy |
| **H3** | Barlow | 24px | 700 | 0 | 1.25 | Navy |
| **H4** | Barlow | 18px | 400 | 0 | 1.35 | Navy |
| **Body** | Inter | 16px | 400 | 0 | 1.6 | Navy |
| **Body small** | Inter | 14px | 400 | 0 | 1.55 | Neutral `#6B7280` |
| **Cifra clave** | Inter | 16–48px | 700 | -0.02em | 1.1 | Navy o Rojo |
| **Botón** | Inter | 16px | 700 | 0.01em | 1 | según variante |
| **Kicker / etiqueta** | Inter | 12px | 600 | **0.18em** | 1.2 | Neutral o Light Sky |
| **Numeral de etapa** | Articulat/Poppins | 64–96px | 800 | -0.02em | 0.9 | Latin Mornings o Rojo |
| **Nota manuscrita** | Kalam | 18–22px | 400 | 0 | 1.3 | Latin Mornings |
| **Regla de oro** | Barlow | 22px | 700 | 0 | 1.4 | Navy, itálica opcional |

## 4.3 Reglas de uso
- **Los kickers van en MAYÚSCULAS** con tracking 0.18em. Es la firma tipográfica del sistema.
- **Kalam es un condimento, no un ingrediente.** Se usa para las señales de avance de la cinta de artefactos y las anotaciones del árbol de decisión. **Nunca** para cuerpo.
- **Máximo 75 caracteres por línea** en texto de lectura.
- **Nunca** más de tres tamaños distintos en un mismo bloque visual.

---

# 5 · ESPACIADO, GRILLA, TRAZOS Y SOMBRAS

## 5.1 Escala de espaciado (base 4px)
`4 · 8 · 12 · 16 · 24 · 32 · 48 · 64 · 96 · 128`
Usar **solo** estos valores. Nada de 13px, 27px o 45px.

## 5.2 Grilla
- **Contenedor máximo:** 1280px, centrado, con 32px de margen lateral (16px en móvil).
- **Grilla:** 12 columnas, gutter 24px.
- **Breakpoints:** `≥1280` escritorio · `900–1279` tablet · `380–899` móvil (el riel de etapas colapsa a scroll horizontal bajo 900).

## 5.3 Trazos y bordes

| Elemento | Especificación |
|---|---|
| **Hairline / separador** | 1px `#E5E7EB` |
| **Borde de tarjeta** | 1px `#E5E7EB`, radio 16px |
| **Barra de Regla de Oro** | **5px** izquierda, Rojo `#FF4040`, sobre fondo crema muy sutil |
| **Borde de énfasis** | 2px Navy |
| **Trazo de ícono lineal** | **2.5px**, `stroke-linecap:round`, `stroke-linejoin:round` |
| **Conector / flecha de flujo** | 2px, con punta redondeada |
| **Anillo de foco (accesibilidad)** | 3px Latin Mornings, offset 2px |

## 5.4 Radios de esquina
`8px` chips y etiquetas · `16px` tarjetas y paneles · `24px` contenedores grandes · `999px` botones (pill) y avatares.

## 5.5 Sombras (suaves, nunca duras)
```css
--shadow-sm: 0 1px 2px rgba(0,26,64,.06);
--shadow-md: 0 4px 12px rgba(0,26,64,.08);
--shadow-lg: 0 12px 32px rgba(0,26,64,.12);
```
> Las sombras siempre en **navy translúcido**, jamás negro puro.

---

# 6 · ICONOGRAFÍA

## 6.1 Sistema PRIMARIO — los cuatro íconos temáticos
Del Brand Book. Cada uno es una **forma dentro de un círculo**, disponible en las cuatro variantes de color (círculo rojo/navy/sky/amarillo con la forma en contraste).

| Ícono | Forma | Uso en la app |
|---|---|---|
| **Growth** | doble chevrón ↑ | Métricas, crecimiento, flywheel, benchmarks |
| **Home** | casa | Borrower, vivienda, cierre, Won |
| **Opportunity** | cerradura / ojo de llave | Rescate, "la puerta", programas de nicho |
| **Latino** | asterisco de 6 puntas | Comunidad, mercado latino, co-marketing |

**Tamaños:** 32px (inline) · 48px (tarjeta) · 64px (encabezado de sección).

## 6.2 Sistema SECUNDARIO — íconos lineales de industria
Set lineal rojo del Brand Book (casas, documentos, llaves, gráficas, calendarios, contratos, personas). Trazo grueso redondeado.

- **Trazo:** 2.5px, cap y join redondeados
- **Color:** un solo color por ícono — Rojo por defecto; Navy cuando va sobre fondo claro con mucho rojo alrededor
- **Tamaño:** 20px (fila de tabla) · 24px (lista) · 32px (encabezado)
- **Uso:** filas de battle cards, encabezados de etapa, ítems de checklist, tipos de artefacto

## 6.3 Reglas
- **Nunca mezclar** el sistema de círculos con el lineal dentro del mismo bloque.
- **Nunca rellenar** un ícono lineal ni contornear uno de círculo.
- Cada ícono lleva **texto al lado** — el ícono nunca comunica solo.

---

# 7 · COMPONENTES

## 7.1 Botones (del Brand Book — pill, Inter Bold 16px, padding 14px/28px)

| Estado | Opción 1 (rojo) | Opción 2 (amarillo) |
|---|---|---|
| **Activo** | fondo `#FF4040`, texto `#FCFCFA` | fondo `#F8C845`, texto `#001A40` |
| **Hover** | fondo transparente, borde 2px `#FF4040`, texto `#FF4040` | borde 2px `#F8C845`, texto `#F8C845` |
| **Action** | fondo `#001A40`, texto `#FCFCFA` | fondo `#001A40`, texto `#FCFCFA` |
| **Inactivo** | fondo `#E8EAF0`, texto `#6B7280`, sin puntero | ídem |

## 7.2 Tarjetas
Fondo `#FCFCFA` · borde 1px `#E5E7EB` · radio 16px · padding 24px · `--shadow-sm`. En hover: `--shadow-md` y traslación de -2px en Y.

## 7.3 Chips / etiquetas de rol
Pill, padding 6px/14px, Inter 12px 600, tracking 0.08em.
Performance → Light Sky con texto navy · BD → Rojo con texto blanco · LO → Navy con texto blanco · BM → Latin Mornings con texto navy · Soporte → gris con texto neutro.

## 7.4 Tablas
Cabecera con **borde inferior navy de 2px**, texto en kicker (12px, mayúsculas, tracking 0.18em, neutral). Filas separadas por hairline 1px. **Sin degradados, sin cebra pesada** — como mucho `#FCFCFA` alternado. Cifras en Inter Bold, alineadas a la derecha, tabulares.

## 7.5 Regla de Oro (componente distintivo)
Barra izquierda **5px roja** · fondo crema muy sutil (`rgba(255,64,64,.04)`) · texto Barlow Bold 22px navy · etiqueta superior "REGLA DE ORO" en kicker rojo. **Sin caja de color pesada.**

## 7.6 Callout / nota
Fondo blanco · borde 1px `#E5DCC6` · radio 12px · sin cabecera de color.

## 7.7 Nodo de decisión (para los mapas de proceso)
Rombo o compuerta con borde 2px navy. **Ruta que avanza** en verde-metodología o dorado; **ruta de salida** en rojo. Toda ruta NO termina en un destino registrado — nunca en el vacío.

---

# 8 · GRÁFICAS Y VISUALIZACIÓN DE DATOS

> Método: elegir la forma → asignar color por su trabajo → **validar** → aplicar specs de marca → capa de hover → accesibilidad. **El color va al final.**

## 8.1 Qué forma usar

| El dato responde a… | Forma correcta |
|---|---|
| Un solo número que es el titular | **Stat tile / número héroe** — no una gráfica |
| Comparar magnitudes entre categorías | Barras horizontales |
| Composición de un total | Barras apiladas (**nunca** dona con más de 3 partes) |
| Cambio en el tiempo | Línea (2px) |
| Avance por etapas del funnel | Barras horizontales ordenadas o funnel escalonado |
| Relación entre dos variables | Dispersión (marcadores ≥8px) |

**Prohibido:** doble eje Y (dos escalas) — es el error #1. Dos medidas de escala distinta → dos gráficas. También prohibido: 3D, rainbow, dona con muchas porciones, y color por ranking en vez de por entidad.

## 8.2 Paleta categórica — **validada, no improvisada**

Estos valores pasaron los seis checks del validador (banda de luminosidad, piso de croma, separación para daltonismo, piso de visión normal, contraste). **Asignar en orden fijo, jamás cíclico.**

**Modo claro** (superficie `#FCFCFA`) — 5 slots, todos PASS:

| Slot | Hue | HEX |
|---|---|---|
| 1 | azul | `#1E5AA8` |
| 2 | rojo | `#E23B3B` |
| 3 | violeta | `#6B4EA8` |
| 4 | teal | `#12876B` |
| 5 | ámbar | `#B87A00` |

*Peor par adyacente: CVD ΔE 9.3 · visión normal ΔE 19.4 · todos ≥3:1 de contraste.*

**Modo oscuro** (superficie navy elevada `#0A1E3F`) — 5 slots, todos PASS:

| Slot | Hue | HEX |
|---|---|---|
| 1 | azul | `#4A86D6` |
| 2 | rojo | `#D64C4C` |
| 3 | violeta | `#8A73D1` |
| 4 | teal | `#17906F` |
| 5 | ámbar | `#B98418` |

*Peor par adyacente: CVD ΔE 9.3 · visión normal ΔE 18.3.*

> **Por qué la paleta de gráficas no es la de marca:** los colores de marca (navy casi negro, light sky casi blanco) no caben en una misma banda de luminosidad, y el amarillo no alcanza contraste. Estos cinco hues son **primos de marca** — nacen del azul y el rojo HOMESÍ — pero están calibrados para que se distingan incluso con daltonismo. El rojo y el azul de marca siguen mandando en la interfaz; la gráfica usa sus versiones legibles.

## 8.3 Otras escalas de color
- **Secuencial** (magnitud continua: mapas de calor): **un solo hue**, claro→oscuro. Default azul: `#CDE2FB → #9EC5F4 → #5598E7 → #2A78D6 → #184F95`. Para rampas ordinales, no arrancar más claro que `#86B6EF`.
- **Divergente** (polaridad): **azul ↔ rojo** con **gris neutro** al centro (`#F0EFEC` claro / `#383835` oscuro). Nunca un hue en el punto medio.
- **Estado** (reservado, nunca como "serie 4"): bueno `#12876B` · advertencia `#B87A00` · grave `#E23B3B` · crítico `#8A1F1F`. Siempre acompañados de **ícono + texto**, jamás color solo.

## 8.4 Anatomía de las marcas
Barras finas con **extremos redondeados de 4px** anclados a la línea base · líneas de **2px** · marcadores **≥8px** · **2px de separación** entre rellenos adyacentes y segmentos apilados · anillo de 2px del color de la superficie en marcas superpuestas · rejilla y ejes **recesivos** (`#E5E7EB`, 1px).

## 8.5 Texto en gráficas
**El texto nunca lleva el color de la serie.** Valores, etiquetas y leyendas van en tinta navy o neutral; la identidad la carga la marca de color al lado. Etiquetas directas **selectivas** — jamás un número sobre cada punto.

## 8.6 Interacción y accesibilidad
- **Hover por defecto:** crosshair + tooltip en línea/área; tooltip por marca en barras/puntos/celdas. Solo un stat tile sin plot puede omitirlo.
- **Leyenda siempre presente con ≥2 series** (una sola serie no lleva leyenda — el título la nombra); hasta 4 series además con etiqueta directa. La identidad **nunca** depende solo del color.
- **Vista de tabla** disponible siempre.
- **Filtros** en una sola fila arriba de las gráficas.
- Si una serie cae por filtro, **los supervivientes no se repintan** — el color sigue a la entidad, no al ranking.

---

# 9 · LOS DOS REGISTROS

La app distingue lo que es **manual interno** de lo que **ve el cliente** — pero **no por paleta** (ambos usan la oficial), sino por **tratamiento**:

| | **Registro manual** (Lado A, artefactos internos) | **Registro marca** (customer-facing) |
|---|---|---|
| Fondo | New Day `#FCFCFA` con mucho aire | Bloques de color saturado (navy, rojo) |
| Tinta | Navy sobre claro | Blanco o Light Sky sobre color |
| Densidad | Baja, para leer | Alta, para impactar |
| Ejemplos | Dossier, scorecards, guiones, mapas | Battle cards, FAQ, posts, one-pagers |

Esa diferencia **le enseña al usuario, sin decírselo**, que aprende en un lenguaje y entrega en otro.

---

# 10 · ELEMENTOS DE ACOMPAÑAMIENTO

## 10.1 Neighborhood Pattern
Franja de chevrones navy. **Solo decoración sutil en pies de página y bandas, opacidad ≤15%.** Jamás compitiendo con contenido.
```svg
<svg width="120" height="60" viewBox="0 0 120 60" xmlns="http://www.w3.org/2000/svg">
 <g fill="none" stroke="#001A40" stroke-width="6" stroke-linecap="round" opacity="0.12">
  <path d="M0 40 L15 25 L30 40 M30 40 L45 25 L60 40 M60 40 L75 25 L90 40 M90 40 L105 25 L120 40"/>
  <path d="M0 58 L15 43 L30 58 M30 58 L45 43 L60 58 M60 58 L75 43 L90 58 M90 58 L105 43 L120 58"/>
 </g></svg>
```

## 10.2 Sistema manuscrito (Hand-Drawn)
Flechas curvas navy trazadas a mano + formas (óvalo, rectángulo, triángulo) para circular datos. Se combinan con **Kalam en amarillo**. Úsalas para conectar "viene de → va hacia" en el Lado A y para las señales de avance de la cinta. Es lo que le da el alma de *Local Hero* — **con moderación**.

---

# 11 · MOVIMIENTO

| Transición | Duración | Easing |
|---|---|---|
| Cambio de lado A/B | 320ms | `cubic-bezier(.22,1,.36,1)` — cross-fade |
| Cambio de etapa | 280ms | `cubic-bezier(.22,1,.36,1)` — deslizamiento lateral |
| Hover de tarjeta | 200ms | `ease-out` |
| Aparición de tooltip | 140ms | `ease-out` |
| Entrada de logo (intro) | 1100ms | `cubic-bezier(.22,1,.36,1)` |
| Barrido rojo de salida | 1000ms | `cubic-bezier(.76,0,.24,1)` |

**Respetar `prefers-reduced-motion`:** con la preferencia activa, todo se reduce a fades de 120ms.

---

# 12 · FOTOGRAFÍA Y VIDEO

## 12.1 Dirección (Brand Book · Photography)
> *"Refleja el corazón de la comunidad latina — cálida, alegre, centrada en la familia. Cada imagen celebra los momentos que importan: la alegría de recibir las llaves, el abrazo de la familia, la calidez de un nuevo comienzo."*

Familias latinas multigeneracionales · luz natural cálida · momentos de llaves, mudanza, abrazos · realismo editorial auténtico, **nunca stock frío**.

## 12.2 Reglas técnicas obligatorias
- **Rostros completos, jamás recortados** por el encuadre. Verificación de headroom obligatoria.
- Encuadre que muestre **cabeza, torso y algo del entorno útil** (mesa, documentos). Nunca solo cabezas apretadas.
- **Sin texto legible dentro de la imagen** (la portada es la única excepción).
- Gradación cálida natural. Los **overlays gráficos** encima van en paleta oficial.

## 12.3 🎭 Regla de casting — diversidad colombiana real
**Colombia no tiene un solo rostro.** Prohibido describir personajes colombianos por un único tono de piel. Se construye con **región, rasgos, cabello, ojos y expresión**:
**Paisa** (Antioquia): tez clara-olivácea, cabello castaño, ojos miel, sonrisa abierta · **Costeño** (Caribe): piel morena cálida, cabello rizado, calidez efusiva · **Cachaco** (Bogotá): tez olivácea fría, cabello lacio, porte contenido · **Afrocolombiano** (Pacífico): piel marrón profunda, presencia amplia · **Santandereano**: rasgos angulosos, cabello negro grueso.

> **Si aparecen tres o más personas juntas, deben representar al menos dos perfiles regionales distintos.**

## 12.4 Video
Los videos finales **ya traen subtítulos quemados y cama musical** — no superponer subtítulos en la app. Subtítulos en Montserrat ExtraBold 52px, blanco con contorno navy, inferior centrado. Rótulo permanente *"Recreación · Material de entrenamiento"* inferior derecha (obligatorio por la Doctrina de Demos).

---

# 13 · TOKENS CSS — PEGAR TAL CUAL

```css
:root{
  /* ── PALETA OFICIAL ── */
  --enriching-skies:#001A40;   /* navy primario */
  --warm-embrace:#FF4040;      /* rojo primario */
  --light-sky:#A6DEFF;
  --latin-mornings:#F8C845;
  --new-day:#FCFCFA;

  /* ── NEUTROS DE APOYO ── */
  --competitor-gray:#E8EAF0;
  --neutral-text:#6B7280;
  --hairline:#E5E7EB;

  /* ── TIPOGRAFÍA ── */
  --font-display:'Articulat CF','Poppins',system-ui,sans-serif;
  --font-head:'Barlow',system-ui,sans-serif;
  --font-body:'Inter',system-ui,sans-serif;
  --font-hand:'Kalam',cursive;

  --fs-h1:48px; --fs-h2:36px; --fs-h3:24px; --fs-h4:18px;
  --fs-body:16px; --fs-small:14px; --fs-kicker:12px;
  --tracking-kicker:.18em;

  /* ── ESPACIADO ── */
  --s1:4px; --s2:8px; --s3:12px; --s4:16px; --s5:24px;
  --s6:32px; --s7:48px; --s8:64px; --s9:96px; --s10:128px;

  /* ── RADIOS ── */
  --r-chip:8px; --r-card:16px; --r-panel:24px; --r-pill:999px;

  /* ── TRAZOS ── */
  --stroke-hairline:1px; --stroke-icon:2.5px;
  --stroke-emphasis:2px; --stroke-rule:5px;

  /* ── SOMBRAS ── */
  --shadow-sm:0 1px 2px rgba(0,26,64,.06);
  --shadow-md:0 4px 12px rgba(0,26,64,.08);
  --shadow-lg:0 12px 32px rgba(0,26,64,.12);

  /* ── MOVIMIENTO ── */
  --ease-brand:cubic-bezier(.22,1,.36,1);
  --dur-fast:200ms; --dur-mid:320ms; --dur-slow:1000ms;

  /* ── GRÁFICAS · modo claro (validado) ── */
  --viz-surface:#FCFCFA;
  --series-1:#1E5AA8; --series-2:#E23B3B; --series-3:#6B4EA8;
  --series-4:#12876B; --series-5:#B87A00;
  --viz-grid:#E5E7EB; --viz-ink:#001A40; --viz-ink-soft:#6B7280;
  --status-good:#12876B; --status-warn:#B87A00;
  --status-serious:#E23B3B; --status-critical:#8A1F1F;
}

/* ── GRÁFICAS · modo oscuro (validado, superficie navy elevada) ── */
@media (prefers-color-scheme: dark){
  :root:where(:not([data-theme="light"])){
    --viz-surface:#0A1E3F;
    --series-1:#4A86D6; --series-2:#D64C4C; --series-3:#8A73D1;
    --series-4:#17906F; --series-5:#B98418;
    --viz-grid:#1E3358; --viz-ink:#FCFCFA; --viz-ink-soft:#A6B4CC;
  }
}
:root[data-theme="dark"]{
  --viz-surface:#0A1E3F;
  --series-1:#4A86D6; --series-2:#D64C4C; --series-3:#8A73D1;
  --series-4:#17906F; --series-5:#B98418;
  --viz-grid:#1E3358; --viz-ink:#FCFCFA; --viz-ink-soft:#A6B4CC;
}

@media (prefers-reduced-motion: reduce){
  *{animation-duration:120ms !important; transition-duration:120ms !important}
}
```

---

# 14 · LISTA DE PROHIBICIONES

❌ Colores fuera de la paleta oficial (salvo los tres neutros de apoyo y la paleta de gráficas validada)
❌ La paleta arena/oro de S1–S5A — **queda anulada**
❌ Texto blanco sobre amarillo o sobre light sky
❌ El chevrón como logo primario en esta app
❌ Redibujar el logo a mano — usar el archivo oficial
❌ Sombras, degradados o contornos sobre el logo
❌ Doble eje Y en cualquier gráfica
❌ Rainbow, 3D, donas con más de 3 porciones
❌ Color como único portador de identidad
❌ Texto con el color de la serie
❌ Mezclar el sistema de íconos de círculo con el lineal en un mismo bloque
❌ Valores de espaciado fuera de la escala base-4
❌ Rostros recortados por el encuadre
❌ Elencos colombianos homogéneos
❌ `localStorage` / `sessionStorage` (restricción técnica del entorno)
❌ Poesía corporativa, solemnidad, relleno

---

*Sistema de marca HOMESÍ para la app del Playbook B2B · CMO Agéntico · Julio 2026*
*Paletas de gráficas validadas con el validador de seis checks — no reemplazar valores sin re-validar.*
