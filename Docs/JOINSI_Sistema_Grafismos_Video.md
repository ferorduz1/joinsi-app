# JOINSI — SISTEMA DE GRAFISMOS EN PANTALLA
## Subtítulos · Lower thirds · Frames · Cifras
**Gobernado por:** P1B Sistema de Marca HOMESÍ Oficial · Acta A0 v1.1
**Regla madre:** ningún texto se genera dentro del video AI. Todo grafismo se compone en post sobre el clip limpio.

---

## 1 · LOS DOS REGISTROS

El sistema tiene dos personalidades y no se mezclan dentro de una misma pieza.

### Registro SOBRIO — para lo cinematográfico
Usado en: **V1** (Gloria y el nicho latino), **V2** (el flow del reclutamiento), **V3** (pricing), **V4** (compensación).
Es documental. El grafismo no compite con la emoción: la acompaña y desaparece.

### Registro FRESCO — para lo joven
Usado en: **V0** (landing) y los tramos de María guiando.
Es energía de oportunidad. El grafismo entra con ritmo, respira color y celebra.

---

## 2 · SUBTÍTULOS

**Obligatorios siempre que haya diálogo.** Sin excepción, en ambos registros.

| Propiedad | SOBRIO | FRESCO |
|---|---|---|
| Familia | Inter SemiBold | Poppins Bold |
| Tamaño (sobre 1080p) | 44 px | 60 px |
| Color base | `#FCFCFA` | `#FCFCFA` |
| Palabra enfatizada | `#F8C845` | `#F8C845` |
| Fondo | ninguno | ninguno |
| Legibilidad | sombra `0 2px 8px rgba(0,26,64,.55)` | sombra `0 3px 12px rgba(0,26,64,.65)` |
| Posición | 12% desde el borde inferior | 14% desde el borde inferior |
| Máx. por tarjeta | 2 líneas / 42 caracteres | 1 línea / 28 caracteres |
| Entrada | fundido 160 ms | corte seco, palabra por palabra al ritmo del habla |

**Énfasis en amarillo — regla de uso:** solo sobre el **SÍ**, sobre cifras, y sobre la palabra que carga la promesa (*keep*, *close*, *yours*). Nunca más de dos énfasis por tarjeta.

**Nunca:** blanco sobre amarillo · caja negra de fondo · mayúsculas sostenidas en frases largas · más de tres tamaños en una pieza.

### Plantilla ASS lista para ffmpeg

```
[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, OutlineColour, BackColour, Bold, BorderStyle, Outline, Shadow, Alignment, MarginV, Encoding
Style: Sobrio, Inter SemiBold,44,&H00FAFCFC,&H8C401A00,&H00000000,0,1,0,3,2,110,1
Style: Fresco, Poppins Bold,60,&H00FAFCFC,&H9C401A00,&H00000000,1,1,0,4,2,130,1
Style: Enfasis,Poppins Bold,60,&H0045C8F8,&H9C401A00,&H00000000,1,1,0,4,2,130,1
```
*(colores ASS en BGR: `&H00FAFCFC` = New Day · `&H0045C8F8` = Latin Mornings · outline = navy translúcido)*

---

## 3 · LOWER THIRD DE PERSONAJE

Aparece **una sola vez** por personaje, a los 1.5 s de su primer plano, dura 3 s.

### SOBRIO
```html
<div class="lt-sobrio">
  <span class="rule"></span>
  <div class="txt">
    <p class="name">Gloria Ramírez</p>
    <p class="role">Loan Officer · Houston, TX</p>
  </div>
</div>
<style>
.lt-sobrio{position:absolute;left:96px;bottom:180px;display:flex;gap:20px;align-items:center;
  animation:ltIn .32s cubic-bezier(.22,1,.36,1) both}
.lt-sobrio .rule{width:5px;height:76px;background:#FF4040;border-radius:3px}
.lt-sobrio .name{font:700 46px/1.1 'Barlow';color:#FCFCFA;margin:0;
  text-shadow:0 2px 10px rgba(0,26,64,.6)}
.lt-sobrio .role{font:500 26px/1.3 'Inter';color:#A6DEFF;margin:6px 0 0;letter-spacing:.02em}
@keyframes ltIn{from{opacity:0;transform:translateX(-24px)}to{opacity:1;transform:none}}
</style>
```
La barra roja de 5 px es la misma de las Reglas de Oro del Playbook — continuidad de sistema entre medios.

### FRESCO
Mismo bloque, con `.name` en Poppins 800 y un **chip pill** en `#F8C845` con texto navy encima del nombre (`SIPARTNER`, Inter 700, 20 px, tracking `.18em`, padding 8/22, radio 999).

---

## 4 · LA FIRMA MANUSCRITA (Kalam)

**Kalam es condimento, no ingrediente.** Aparece máximo **dos veces por video**, nunca como subtítulo ni como cuerpo.

Usos autorizados:
- El **✓** que marca un hito cumplido (Kalam 700, `#F8C845`, rotación −6°)
- Una anotación de tres palabras que subraya el remate: *sí califican*, *and it stacks*
- El círculo trazado a mano alrededor de una cifra clave

```css
.kalam-mark{font:700 54px 'Kalam';color:#F8C845;transform:rotate(-6deg);
  text-shadow:0 2px 8px rgba(0,26,64,.45);
  animation:draw .5s cubic-bezier(.22,1,.36,1) both}
@keyframes draw{from{opacity:0;transform:rotate(-6deg) scale(.7)}to{opacity:1;transform:rotate(-6deg) scale(1)}}
```

---

## 5 · FRAMES DE CIFRA (el reemplazo del texto en video AI)

Toda cifra vive aquí, nunca en el plano generado.

**Tarjeta de cifra — fondo navy pleno `#001A40`, 100% de pantalla o inserto de 60%:**
- Numeral: **Poppins 800**, 200–320 px, `#F8C845`
- Etiqueta superior: kicker Inter 600, 24 px, tracking `.18em`, `#A6DEFF`
- Regla roja de 5 px a la izquierda del bloque
- Entrada: contador odómetro 1000 ms con `cubic-bezier(.22,1,.36,1)`
- Salida: fundido 200 ms

**Aplicación por video:**
| Video | Frames de cifra |
|---|---|
| V2 | `$500 + $500` primeros dos closed loans · `$200` por caso · `12 meses` |
| V3 | comparativo — columna HOMESÍ en navy, columna competidor en `#E8EAF0` |
| V4 | `225 bps` → `2.25%` → `$300,000` → **`$6,750`** |
| V0 | contador de apilamiento del portafolio + las tres medallas casa |

**Prohibido:** doble eje, 3D, rainbow, degradados sobre cifras, sombras negras.

---

## 6 · MEDALLAS DE ESTATUS EN VIDEO

Silueta de la casa del logo oficial, en los tres metales ratificados (bronce `#B0793A` · plata `#B9C2CC` · oro `#D9A93D`). Entrada escalonada de 320 ms cada una sobre navy, con la etiqueta debajo en Inter 700 tracking `.12em`. Solo en V0 y en la graduación de la app. Los metales **no se usan en ningún otro grafismo**.

---

## 7 · APERTURA Y CIERRE

**Apertura de toda pieza:** Intro 1 (wordmark HOMESÍ animado, captura del HTML a 1920×1080) → Intro 2 (logo casa creciendo) → primer plano.
**Cierre de toda pieza:** logo casa centrado sobre navy + tagline *We say **SÍ** when others say no.* — el SÍ en `#F8C845`, resto en `#FCFCFA`, Barlow Bold. Duración 2.5 s.

---

## 8 · MONTAJE (para Claude Code en escritorio)

```bash
# 1 · Normalizar todos los clips a 1080p24
for f in clip_*.mp4; do
  ffmpeg -i "$f" -vf "scale=1920:1080:force_original_aspect_ratio=decrease,\
pad=1920:1080:(ow-iw)/2:(oh-ih)/2,fps=24" -c:v libx264 -crf 18 -c:a aac "norm_$f"
done

# 2 · Concatenar en orden de guion
ffmpeg -f concat -safe 0 -i orden.txt -c copy cuerpo.mp4

# 3 · Montar narración Bram por bloque (ducking del audio de escena)
ffmpeg -i cuerpo.mp4 -i vo.wav -filter_complex \
"[0:a]volume=0.25[amb];[amb][1:a]amix=inputs=2:duration=first[a]" \
-map 0:v -map "[a]" -c:v copy narrado.mp4

# 4 · Quemar subtítulos con el estilo de marca
ffmpeg -i narrado.mp4 -vf "ass=subs.ass" -c:a copy subtitulado.mp4

# 5 · Anteponer intros y añadir cierre
ffmpeg -f concat -safe 0 -i pieza.txt -c copy V1_FINAL.mp4
```

Los grafismos HTML (frames de cifra, lower thirds, medallas) se capturan con Playwright a 1920×1080 en PNG con alpha o en secuencia, y se superponen con `overlay` en el paso 4.

---

## 9 · LISTA DE VERIFICACIÓN ANTES DE PUBLICAR

- [ ] Ningún texto legible generado por AI sobrevive en el corte
- [ ] Todo diálogo tiene subtítulo
- [ ] Un solo lower third por personaje
- [ ] Kalam aparece dos veces o menos
- [ ] Cifras solo en frames navy, nunca en el plano
- [ ] Los dos intros al frente, el cierre con tagline al final
- [ ] Ningún color fuera de la paleta oficial
- [ ] Blanco nunca sobre amarillo ni sobre Light Sky
- [ ] Voces: Bram narrador · Pixie María · personajes con su voz de escena
