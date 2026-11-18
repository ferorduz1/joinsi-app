# INSUMOS DEL CONSTRUCTOR PARA LA SPEC A4 · SiRadar
**De:** Claude Code (constructor) · **Para:** CEO de producto y arquitecto · **Fecha:** 2026-11-18
**Base:** `main` en `f7b598b`. Todas las líneas citadas existen hoy en el repo; verifícalas con `git grep`.

Esto **no es la spec**: la spec es tuya y de Fernando. Es la lista de lo que la spec tiene que dejar decidido por escrito para que yo pueda construir A4 sin reinterpretar el canon. Cada punto trae mi default. Si la spec no cierra un punto, me detengo ahí y te pregunto.

---

## 1 · Bloqueos que necesitan autorización explícita en la spec

Retirar el `enum Stage` (canon del funnel §0 y §6) obliga a tocar cosas que `CLAUDE.md` protege. Sin una enmienda escrita (§7 de tu plantilla de spec), no las puedo tocar.

| # | Qué se rompe | Dónde | Mi default |
|---|---|---|---|
| **B1** | `canon_test.dart` selecciona el portafolio con `l.stage == Stage.signed` | `test/canon_test.dart:65`, `:115`, `:123` | Autorizar **solo** el cambio del selector (por ejemplo `l.isSigned`). Todas las aserciones numéricas quedan idénticas: 7 LOs, 61 closed, 6 estados, $16,400 causado = $14,300 cobrado + $2,100 en camino, 9 casos al corte, 5 activos, $17,000 de ventana. Si una cifra cambia, se rompió el negocio y paro |
| **B2** | `compiles_test.dart` exige `Stage.values.length == 8`, `stageLabel` y `promiseLabel` | `test/compiles_test.dart:52`, `:69`, `:70` | Autorizar retirarlos junto con los símbolos que desaparecen, y agregar los nuevos (`FunnelNode`, etc.) |
| **B3** | Pantallas de SiPortfolio **ya aprobadas** filtran por `Stage.signed` | `lib/zones/portfolio/usa_map_screen.dart:79`, `:96` · `lib/data/store.dart:69` (`portfolio()`), `:131` (`applyCut`) | Autorizar cirugía de una línea por sitio: cambia el selector, no cambia nada visible. Es la única forma de no tener dos definiciones de "firmado" |
| **B4** | Subir `Store._seedVersion` a 5 resiembra el box de Hive | `lib/data/store.dart` | Dejar escrito que **se pierde lo hecho en el celular**: caritas elegidas, fotos y cortes cobrados. Para un prototipo es aceptable, pero Fernando lo tiene que saber antes de instalar |

Hoy `Stage` aparece en 6 archivos de `lib/` y 2 de `test/`. `nextTouch` no se lee en ningún sitio fuera del modelo. `promise` solo se pinta en `radar_home.dart:52`, y ningún prospecto de la semilla lo trae, así que esa rama está muerta. Reemplazarlos no rompe nada vivo.

---

## 2 · Decisiones de modelo

| # | Pregunta | Mi default y por qué |
|---|---|---|
| **M1** | ¿`Prospect` es una clase aparte o `LoanOfficer` gana los campos del funnel? (el canon §6 deja las dos opciones) | **Una sola entidad, `LoanOfficer`**, con los campos del funnel. `isSigned` se deriva de "nodo G hecho". Así el id y la carita son los mismos en SiRadar y en el mapa (hoy `radar_home.dart` ya lo promete en un comentario), la transición G → SiPortfolio es un cambio de estado y no una copia, y `payoutFor` no se toca |
| **M2** | ¿Qué funnel llevan los 7 LOs ya firmados de la semilla? | Todos los nodos A–G en "hecho", con la fecha de G = hoy menos `monthOf12` meses. Así la historia de cada LO es coherente con su ventana de 12 meses |
| **M3** | Todo estado de nodo, vencimiento y salud depende de "hoy" | **Las derivaciones reciben `now` como parámetro** (por defecto `DateTime.now()`), y los tests pasan una fecha fija. Sin esto, los tests de "vencido" cambian de resultado según el día en que corran: el mismo tipo de intermitencia que ya tuvimos con `google_fonts` |
| **M4** | Umbrales de vencimiento (canon §8.1) | Lo que decidas, pero en **un solo sitio del código**, como `payoutFor`, y fijado por un test de canon |
| **M5** | **¿Cuáles son las preguntas del SQL (nodo E)?** | **No tengo default: no lo puedo inventar.** El canon dice que es "un formulario real que se diligencia y persiste", pero no dice qué pregunta. Necesito campos, tipo (texto, opción, número) y cuáles son obligatorios. Es conocimiento de María Teresa: lo tiene que traer Fernando. **Es el hueco de contenido más grande de A4** |
| **M6** | ¿Qué pasa con un prospecto inactivado? | Se queda en los datos con `inactivatedDate` y `inactivatedReason`, sale del funnel y del tope de 20, y **no aparece en ninguna pantalla nueva** (no invento una lista de "devueltos" que no está en el Acta) |
| **M7** | El tope de 20 | Invariante de la semilla, vigilado por un test. El prototipo no tiene flujo de asignación, así que no hay botón que lo pueda violar. Hoy la semilla trae 17 prospectos |

---

## 3 · Pantallas

El Acta (§3) fija P20–P26 y el canon del funnel reemplaza P22. Necesito que la spec diga, por cada ID, **qué archivo es, desde dónde se abre y a dónde lleva**. Dos puntos concretos:

- **P23, lanzador de llamada.** El Acta dice "auto-avance de stage: contestó ✓ / no contestó → reintento programado". Con el funnel eso significa marcar C o D con su resultado. La pregunta es qué es "reintento programado": ¿un nodo que queda pendiente con una fecha nueva, o un intento contado dentro del mismo nodo? Mi default es lo primero: el nodo sigue pendiente y gana `dueDate`.
- **¿El dialer es mock o abre el marcador real del celular?** Mi default es **mock**. Si abre el marcador real (`tel:`), hace falta `url_launcher` y una entrada `<queries>` en el `AndroidManifest`, y eso choca con la sección 4.

---

## 4 · Permisos y CI: una restricción que condiciona el alcance

El repo no versiona `android/`: el CI lo regenera con `flutter create` en cada build. Por eso **cualquier cosa que viva en el `AndroidManifest`** (permiso de notificaciones para P26, micrófono para A5, `<queries>` para `tel:`) desaparece en el siguiente build, salvo que el workflow la inyecte después de `flutter create`. Ese parche es mío: tu puente no puede escribir en `.github/workflows/`.

Tu `00_LEEME` §8 ya lo anticipa (alertas dentro de la app en A4, notificaciones del sistema en un subsprint). Mi default es mantenerlo así: **A4 sin ningún permiso nuevo.**

---

## 5 · Cómo propongo partir la construcción

Una sola tarea gigante para A4 es difícil de verificar con tus tres revisiones adversariales. Propongo cuatro prompts, cada uno con `analyze` en 0 issues y los tests en verde antes de su commit:

| Prompt | Qué | Por qué en este orden |
|---|---|---|
| **A4.1** | Modelo, semilla v5 y tests de canon nuevos. **Sin UI.** La app sigue funcionando con las pantallas actuales adaptadas por B3 | Es donde se puede romper el negocio. Se verifica en aislamiento, con números, antes de que exista una sola pantalla |
| **A4.2** | P20 bandeja y P22 funnel | El corazón visible |
| **A4.3** | P21 ficha 360, P23 lanzador y P24 playbook | Cuelgan del nodo activo |
| **A4.4** | P25 pre-funnel social y P26 alertas | Las que dependen de contenido de HOMESÍ |

Después viene la secuencia de tu `00_LEEME` §6: gate funcional, Stitch, capa visual y APK.

---

## 6 · Lo que necesito de Fernando antes de A4.1

1. **Las preguntas del SQL** (M5). Sin ellas, el nodo E no se puede construir.
2. **Android Studio abierto una vez.** A4 es el sprint con más interacción hasta ahora. Sin SDK local, cada ajuste visual cuesta un build de CI de 5 minutos.
