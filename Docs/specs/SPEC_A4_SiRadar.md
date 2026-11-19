# SPEC A4 · SiRadar con el Funnel de Nurturing · v0.1
**Estado:** BORRADOR (2026-11-19, CEO de producto JoinSi #3). No se construye nada hasta que diga `APROBADA`.
**Fuentes:** Acta A0 §3 (P20–P26, IDs inmutables) · `Docs/JOINSI_Canon_Funnel_Nurturing_Prospectos.md` (reemplaza P22 y el `enum Stage`) · `Docs/JOINSI_Filosofia_y_Journey.md` §2, §4, §5 · `Docs/JOINSI_A1_Prompts_Stitch_Higgsfield_Voces.md` (ST-05, ST-06, V2, árbol de Carlos) · `Docs/JOINSI_Contexto_HOMESI.md` §3–§5 · `Docs/constructor/INSUMOS_A4_para_la_spec.md` (B1–B4, M1–M7, commit `8f7b161`) · `Docs/constructor/REPORTE_CONSTRUCTOR_2026-11-18.md` §4 (regla de `google_fonts`).

---

## 1 · Requisito del Director

SiRadar es el motor de prospección del SiPartner, nunca un "CRM". HOMESÍ le asigna como máximo 20 prospectos vivos. Cada prospecto recorre un tren de nodos: A post, B DM, C llamada 1, D llamada 2, E SQL (lo que el SiPartner controla); F reunión con el Director de Producción y G firma (solo lectura, los mueve HOMESÍ); N30, N60 y N90 de nurturing mientras siga vivo. Inactivar devuelve el prospecto a HOMESÍ y exige SQL y nota. El tablero mide al SiPartner solo por lo que controla. ("Reemplaza por esta lógica", Fernando, 2026-07-28.)

## 2 · Experiencia

### 2.1 · Un día del SiPartner en SiRadar
1. Abre la pestaña SiRadar y cae en **P20**. Ve cuántos prospectos nuevos le asignó HOMESÍ hoy y una cola ordenada de lo que toca hacer: primero lo vencido, luego lo que vence hoy, luego mañana.
2. Toca la acción del primer prospecto. Si es A, B o un N, abre **P25** con el material listo para copiar y marca "hecho". Si es C o D, abre **P23**, hace la llamada simulada y registra si contestó. Si es E, llena el SQL.
3. Cuando quiere ver todo su negocio de prospección, abre **P22**: un tren por prospecto, todos a la vez, con filtros.
4. Antes de llamar a alguien, abre su **P21** (ficha 360°) y, durante la llamada, el **P24** (playbook del nodo en que va).
5. La campana de P20 abre **P26**: la agenda de hoy, mañana y la semana, derivada de los nodos.
6. Si decide soltar un prospecto, lo inactiva desde P21 o P22: SQL completo, nota con la razón, confirmación. El prospecto vuelve a HOMESÍ y desaparece de sus pantallas.
7. Cuando HOMESÍ marca G (firma), el LO sale del funnel y aparece en SiPortfolio con la misma carita.

### 2.2 · Pantallas (una por ID del Acta; no se fusionan ni se agregan)

| ID | Archivo | Pregunta que responde en 3 s | Se abre desde | Lleva a |
|---|---|---|---|---|
| **P20** Radar principal (bandeja) | `lib/zones/radar/radar_home.dart` (reemplaza el stub) | "¿Qué hago hoy y con quién?" | Pestaña SiRadar del `shell.dart` | P26 (campana con contador), P22 ("Ver mi funnel"), P21 (tocar la ficha), acción del nodo activo (ver §2.3) |
| **P21** Ficha 360° del prospecto | `lib/zones/radar/prospect_360_screen.dart` | "¿Quién es, qué le duele y qué le he hecho?" | P20, P22, P26 | P23, P24, P25, SQL, inactivar |
| **P22** Funnel de Nurturing | `lib/zones/radar/funnel_screen.dart` | "¿Cómo va cada uno de mis prospectos?" | P20 | P21 (tocar tarjeta), hoja del nodo (tocar nodo), inactivar |
| **P23** Lanzador de llamada | `lib/zones/radar/call_launcher_screen.dart` | "¿Contestó o no, y cuándo vuelvo a llamar?" | Acción de los nodos C o D (P20, P21, P22, P26) | P24 durante la llamada; al cerrar, vuelve a la pantalla de origen |
| **P24** Playbook en contexto | `lib/zones/radar/playbook_screen.dart` | "¿Qué digo ahora, en este nodo?" | P21, P23, hoja del nodo | Vuelve |
| **P25** Pre-funnel social | `lib/zones/radar/social_prefunnel_screen.dart` | "¿Qué publico o envío, y ya lo hice?" | Acción de los nodos A, B, N30, N60, N90 | Copiar texto, marcar el nodo hecho, volver |
| **P26** Alertas y agenda | `lib/zones/radar/alerts_screen.dart` | "¿Qué se me vence?" | Campana de P20; contador en la pestaña SiRadar | Acción del nodo de cada alerta |

Componentes que **no son pantallas** (no reciben ID, viven como hojas modales de la pantalla que los abre):
- `lib/zones/radar/sql_form_sheet.dart`: el formulario del nodo E.
- `lib/zones/radar/inactivate_sheet.dart`: el flujo de inactivación.
- `lib/zones/radar/node_sheet.dart`: la hoja que abre un nodo en P22 (estado, fechas, acción).
- `lib/zones/radar/node_actions.dart`: **una sola función** `openNodeAction(context, lo, key)` que decide a dónde lleva cada nodo. P20, P21, P22 y P26 la usan; ninguna pantalla decide la ruta por su cuenta.
- `lib/widgets/node_train.dart`: el tren de nodos. Se escribe genérico porque el nurturing post-firma (backlog) lo va a reutilizar (canon del funnel §7).

### 2.3 · A dónde lleva cada nodo (`openNodeAction`)

| Nodo | Acción del SiPartner | Destino |
|---|---|---|
| A, B | Publicar el post / enviar el DM | P25 en la pestaña del nodo, con botón "Ya lo hice" |
| C, D | Llamar | P23 |
| E | Llenar y entregar el SQL | `sql_form_sheet` |
| F, G | Ninguna | Hoja del nodo en solo lectura: "Fuera de tu control · lo mueve HOMESÍ" |
| N30, N60, N90 | Enviar la pieza de conocimiento | P25 en la pestaña de piezas |

### 2.4 · Contenido de cada pantalla (funcional; el look lo define después Stitch)

**P20.** Héroe navy. **Cifra amarilla única:** "En la mesa de HOMESÍ", la suma de `projectedFirstYear()` de los prospectos vivos con E hecho, con la etiqueta "si firman y cierran a su ritmo declarado". Ata el dinero al entregable que controla el SiPartner (el SQL) y usa la fórmula que ya existe; no promete por los que ni siquiera calificó. Banner derivado "HOMESÍ te asignó N prospectos nuevos hoy" (N = asignados con fecha de hoy; si N = 0 no aparece). Cola de fichas MQL ordenada por urgencia: carita, nombre, NMLS, ciudad y estado, tier, volumen estimado, programa, días desde la asignación, salud de la relación, nodo activo con su vencimiento y su botón de acción. El rojo accionable va solo en la acción del primer elemento de la cola. Al final, los que esperan a HOMESÍ (E hecho, sin nodo propio pendiente) con la etiqueta "esperando a HOMESÍ".

**P21.** Encabezado con carita, datos MQL y teléfono. Tren de nodos del prospecto. Historial de toques derivado de las fechas de los nodos y de los intentos de llamada. "Lo que le duele" y "programas gancho" salen del SQL si está; si no, dicen "por descubrir en la llamada". El "pricing hook" sale del contenido del playbook para el programa del prospecto. Botones: acción del nodo activo, playbook, ver o editar el SQL, inactivar.

**P22.** Encabezado con el cumplimiento del SiPartner: "X de Y nodos al día" (nodos A–E y N habilitados que no están vencidos). Sin dinero en esta pantalla. Una tarjeta por prospecto vivo (máximo 20): carita, nombre, días desde la asignación, tren de 10 nodos con su estado, salud y acceso a inactivar. Filtros: nodo activo, solo vencidos, días desde la asignación (0–7, 8–30, 31+), tier y estado. Orden por defecto: urgencia, igual que P20.

**P23.** Prospecto, número (ficticio, §3.7) y botón "Llamar". La llamada es **simulada**: pantalla de llamada con cronómetro y botón al playbook. Al colgar, dos botones: "Contestó" (el nodo queda hecho con resultado contestó) y "No contestó" (se registra el intento y se programa el reintento con fecha y hora; por defecto dentro de 2 días a las 10:00). Al tercer intento sin respuesta aparece "Cerrar como no contestó", que deja el nodo hecho con ese resultado para que el funnel avance.

**P24.** Recibe prospecto y nodo. Muestra para ese nodo: qué decir (2 o 3 líneas de guion), pain relievers, battle cards de objeciones con LAER y el artefacto de mitigación de riesgo que aplique. El texto vive en `lib/data/radar_content.dart` y lo redacta el CEO (§5.5).

**P25.** Recibe prospecto y nodo. Tres pestañas: Post (nodo A, con secuencia de publicación sugerida), DM (nodo B) y Piezas (N30, N60, N90). Cada pieza: texto listo, botón "Copiar" (portapapeles del sistema, sin permisos) y "Ya lo hice", que marca el nodo. Las imágenes de los posts las entrega HOMESÍ: en A4 se muestra "imagen: la entrega HOMESÍ", no se inventa.

**P26.** Lista derivada, nunca guardada, agrupada en Hoy, Mañana y Esta semana. Tipos: vencido, vence hoy (con la hora si es un reintento, por ejemplo "Carlos M.: reintento hoy a las 4:00 pm"), vence mañana, nuevo asignado hoy y nurturing que se abrió hoy. Tocar una alerta ejecuta `openNodeAction`. El contador de la campana y de la pestaña es el número de alertas de Hoy.

## 3 · Reglas de negocio y datos

### 3.1 · Entidad (M1)
**Una sola entidad, `LoanOfficer`**, gana los campos del funnel. El id y la carita son los mismos en SiRadar y en el mapa, la firma es un cambio de estado y no una copia, y `payoutFor` no se toca.

Campos nuevos (persistidos): `DateTime assignedDate` · `List<FunnelNode> funnel` (siempre los 10 nodos, en orden) · `Map<String, Object?>? sqlAnswers` · `String? inactivatedReason` · `DateTime? inactivatedDate` · `String phone`.
Campos que se retiran: `Stage stage`, `DateTime? nextTouch`, `String? promise`, el `enum Stage`, `stageLabel()` y `promiseLabel()`.

Archivo nuevo `lib/models/funnel.dart`:
- `enum NodeKey { a, b, c, d, e, f, g, n30, n60, n90 }`
- `enum NodeState { bloqueado, pendiente, vencido, hecho, fueraDeControl }`
- `enum CallResult { contesto, noContesto }`
- `enum Health { sana, enRiesgo, deteriorada }`
- `class FunnelNode { NodeKey key; DateTime? completedDate; CallResult? result; List<DateTime> attempts; DateTime? retryAt; }` (`result`, `attempts` y `retryAt` solo aplican a C y D)
- `class FunnelRules`: todas las constantes de §3.3 en un solo sitio, como `payoutFor`.

**El estado de un nodo no se guarda.** El canon §6 pone `state` dentro de `FunnelNode`, pero el mismo canon dice que `nodeState(key)` es derivado. Se guardan los hechos (fechas, resultado, intentos, reintento) y el estado sale de ellos y de `now` (enmienda E5).

Derivados (todos reciben `DateTime now`, sin `DateTime.now()` adentro; M3):
`isSigned` (G hecho) · `isInactive` (`inactivatedDate != null`) · `isAlive` (ni firmado ni inactivo) · `daysSinceAssigned(now)` · `enabledDate(key)` · `dueDate(key)` · `nodeState(key, now)` · `activeNode(now)` (el primer nodo propio pendiente o vencido, por urgencia) · `currentNode` (el nodo más avanzado hecho: es lo que antes se llamaba "stage") · `daysSinceLastTouch(now)` · `health(now)` · `sqlComplete` · `canInactivate(reason)`.

### 3.2 · Secuencia y estados (canon §2 y §3)
- A se habilita en `assignedDate`. B cuando A está hecho, C cuando B, D cuando C, E cuando D. Un nodo no habilitado está **bloqueado**.
- F y G son **fueraDeControl** mientras no estén hechos y **hecho** (solo lectura) cuando HOMESÍ los marca. El SiPartner no tiene ninguna acción sobre ellos: la API del modelo los rechaza.
- N30, N60 y N90 se habilitan en `assignedDate` + 30, 60 y 90 días, solo mientras el prospecto esté vivo. No dependen de A–E.
- **Pendiente:** habilitado, no hecho y hoy no ha pasado su vencimiento. **Vencido:** hoy es posterior a la fecha de vencimiento. Se compara por fecha local, sin horas.
- Un nodo hecho lleva su fecha. "Ya lo hice" usa `now`; no se puede fechar hacia atrás. Justo después de marcar hay un "Deshacer" de unos segundos; después no.

### 3.3 · Umbrales (M4; canon §8.1 con su default, más lo que el canon no cubría)

| Constante en `FunnelRules` | Valor |
|---|---|
| A vence a los N días de habilitarse | 3 |
| B | 3 |
| C | 5 |
| D | 5 |
| E | 7 |
| N30, N60, N90 se abren a los días | 30, 60, 90 desde la asignación |
| N30, N60, N90 vencen a los N días de abrirse | 7 |
| Reintento por defecto tras "No contestó" | 2 días, 10:00 |
| Intentos sin respuesta antes de ofrecer "Cerrar como no contestó" | 3 |
| Con un reintento programado, el vencimiento de C o D es | la fecha de `retryAt` |
| Tope de prospectos vivos | 20 |
| Nota mínima para inactivar | 20 caracteres sin contar espacios a los lados |

### 3.4 · Salud de la relación (derivada, nunca un campo)
Cuenta sobre los nodos propios habilitados (A–E y N): número de vencidos y máximo de días vencido. Inactividad = días desde el último toque (asignación, nodo hecho o intento de llamada).

- **Deteriorada:** 2 o más nodos vencidos, o uno vencido por más de 7 días, o más de 21 días de inactividad con E sin hacer.
- **Sana:** ningún nodo vencido y, si E no está hecho, 10 días o menos de inactividad.
- **En riesgo:** todo lo demás.

**Regla no evidente:** cuando E está hecho, la inactividad deja de contar. Lo que sigue (F y G) lo mueve HOMESÍ, y el canon prohíbe culpar al SiPartner por eso. En esa etapa la salud solo baja si se le vence un N.

### 3.5 · SQL del nodo E (M5)
- La definición de preguntas es **dato**, en un solo archivo, `lib/data/sql_form.dart`. Cambiar el contenido cuando María Teresa lo valide no toca la lógica.
- Las respuestas se guardan en `sqlAnswers` por id de pregunta. Se puede guardar a medias. `sqlComplete` exige todas las obligatorias. "Entregar SQL" marca E hecho; solo se ofrece si E está habilitado y el SQL está completo.
- El SQL se puede editar después de entregado mientras el prospecto siga vivo; editar no cambia la fecha de E.
- Para inactivar, el SQL se abre aunque E esté bloqueado (ver §3.6).
- Solo datos profesionales del LO. Nada de datos de borrowers, documentos de identidad ni promesas de tasa.

**Borrador de preguntas · pendiente de validar con María Teresa**

| id | Pregunta | Tipo | Obligatoria |
|---|---|---|---|
| q01 | ¿Hablaste directamente con el LO? | Sí / No | Sí |
| q02 | ¿Verificaste que su licencia NMLS está activa? | Sí / No / No pude verificar | Sí |
| q03 | ¿En qué estados tiene licencia? | Varios estados de la lista del mapa | Sí (al menos uno) |
| q04 | ¿Cuántos closed loans cierra al mes, en promedio? | Número de 0 a 50 (admite ,5) o "No lo sé" | Sí |
| q05 | ¿Qué parte de su producción es con clientes latinos? | Menos de 25% / 25–50% / 50–75% / Más de 75% / No lo sé | Sí |
| q06 | ¿Qué programas usa más? | Varios de `kPrograms` + Otro | No |
| q07 | ¿Dónde trabaja hoy? | Banco o retail lender (W-2) / Broker / División de otro lender / Independiente / Otro | Sí |
| q08 | ¿Qué le duele más hoy? | Pricing / Compensación / Operación y soporte / Marketing y leads / Tecnología / Tiempos de cierre / Otro | Sí |
| q09 | ¿Cuánto gana hoy por caso? | Menos de 150 bps / 150–200 / 200–250 / Más de 250 / No lo dijo | No |
| q10 | ¿Cuál fue su objeción principal? | Su base de datos / Ya cambió de compañía antes / Pricing / No tiene tiempo / Ninguna / Otra | Sí |
| q11 | ¿Tiene contrato con permanencia o no competencia? | Sí / No / No lo sé | No |
| q12 | ¿Cuándo podría decidir? | Menos de 30 días / 30–90 días / Más de 90 / No lo sé | Sí |
| q13 | ¿Aceptó reunirse con el Director de Producción? | Sí, con fecha / Sí, sin fecha / Todavía no / No | Sí |
| q14 | Lo que HOMESÍ debe saber | Texto libre, máximo 500 caracteres | No |

Por qué estas: q01–q04 confirman que el prospecto es real y licenciado; q05–q08 lo ubican en el avatar (LO mid volume latino) y en los tres ejes de la campaña de Meta (pricing y compensación, operación y soporte, congruencia latina); q09–q11 anticipan la conversación del nodo F; q12–q13 dicen a HOMESÍ qué hacer con él.

### 3.6 · Inactivación (M6; canon §4)
- Desde P21 o desde la tarjeta de P22. Paso 1: SQL (se abre con lo que ya tenga; debe quedar completo). Paso 2: nota con la razón (mínimo de §3.3). Paso 3: confirmar "Devolver a HOMESÍ". Sin los dos requisitos, el botón de confirmar no se habilita y el modelo rechaza la operación.
- El prospecto se queda en los datos con `inactivatedDate` e `inactivatedReason`, sale del funnel y del tope de 20, y **no aparece en ninguna pantalla**, incluido el mapa de SiPortfolio (enmienda E3). No hay lista de devueltos: no está en el Acta.
- No se deshace en el prototipo.

### 3.7 · Semilla v5 (`Store._seedVersion = 5`; M2, M7)
- `seedLos({DateTime? now})`: todas las fechas son relativas a `now` (por defecto `DateTime.now()`). Los tests pasan una fecha fija.
- **Los 7 LOs firmados quedan intactos** en todo lo que ya existe (cifras, programas, caritas). Su funnel: A–G hechos, con G = `now` − `monthOf12` × 30 días y la asignación 40 días antes de G (A +0, B +1, C +3, D +7, E +10, F +20, G +40). C y D con resultado contestó. Su SQL se llena con `seedSqlAnswers(lo)`, determinista, desde los datos que ya tienen (estado, programa, promedio). Sus N no aplican.
- **Los 17 prospectos** conservan id, nombre, ciudad, estado, NMLS, tier, programa y promedio. Ninguno inactivado. Total de la semilla: 24 (el `compiles_test` sigue diciendo 24).
- Teléfono: código de área real de la ciudad + `555-01NN`, con NN = número del id (`lo08` → `555-0108`). El rango 555-0100 a 555-0199 está reservado para ficción.

Tabla de la semilla. **d** = días desde la asignación; las columnas de nodos dicen el día (contado desde la asignación) en que quedó hecho. C y D hechos tienen resultado contestó salvo que se diga otra cosa.

| id | Nombre | d | A | B | C | D | E | F | N | Estado al sembrar |
|---|---|---|---|---|---|---|---|---|---|---|
| lo12 | Javier Ocampo | 0 | | | | | | | | A pendiente · sana · nuevo hoy |
| lo14 | Esteban Rojas | 0 | | | | | | | | A pendiente · sana · nuevo hoy |
| lo18 | Gustavo Pena | 0 | | | | | | | | A pendiente · sana · nuevo hoy |
| lo21 | Sandra Bermudez | 5 | | | | | | | | A vencido (2 días) · en riesgo |
| lo24 | Hernan Gaitan | 12 | | | | | | | | A vencido (9 días) · deteriorada |
| lo09 | Marta Villegas | 4 | 1 | | | | | | | B vence hoy · sana |
| lo20 | Felipe Arango | 3 | 1 | | | | | | | B vence mañana · sana |
| lo16 | Mauricio Lara | 9 | 2 | | | | | | | B vencido (4 días) · en riesgo |
| lo08 | Carlos Mendoza | 6 | 0 | 1 | | | | | | C: 1 intento sin respuesta el día 5, reintento hoy 16:00 · vence hoy · sana |
| lo22 | Tomas Bedoya | 5 | 0 | 1 | | | | | | C vence mañana · sana |
| lo17 | Isabela Cruz | 8 | 1 | 2 | | | | | | C vencido (1 día) · en riesgo |
| lo11 | Lucia Moreno | 10 | 1 | 2 | 5 | | | | | D vence hoy · sana |
| lo19 | Adriana Solis | 16 | 1 | 2 | 4 | | | | | D: intentos sin respuesta los días 8 y 11, reintento el día 13 10:00 · vencido (3 días) · en riesgo |
| lo15 | Carolina Nieto | 14 | 0 | 1 | 3 | 6 | | | | E vencido (1 día) · en riesgo |
| lo10 | Ricardo Salas | 21 | 0 | 1 | 3 | 7 | 9 | | | Esperando a HOMESÍ (F) · sana |
| lo13 | Diana Castano | 38 | 1 | 2 | 4 | 8 | 12 | 20 | | N30 vencido (1 día) · en riesgo |
| lo23 | Valeria Cordoba | 66 | 0 | 1 | 2 | 6 | 10 | 18 | N30 día 31 | N60 vence mañana · sana |

Los prospectos con E hecho (lo10, lo13, lo23) tienen SQL completo generado por `seedSqlAnswers`.

**Cifras que produce la semilla con `now` fijo** (las fija el test de canon nuevo):
- Vivos: 17 (tope 20). Nuevos hoy: 3.
- Salud: 10 sanas, 6 en riesgo, 1 deteriorada.
- Nodos vencidos: 7 (lo21 A, lo24 A, lo16 B, lo17 C, lo19 D, lo15 E, lo13 N30).
- Alertas de hoy: 7 vencidas + 3 que vencen hoy (lo09 B, lo08 C con reintento a las 16:00, lo11 D). Mañana: 3 (lo20 B, lo22 C, lo23 N60). Nuevos hoy: 3.
- "En la mesa de HOMESÍ" (P20): lo10 $8,000 + lo13 $5,800 + lo23 $7,000 = **$20,800**, todo desde `projectedFirstYear()`.
- SiPortfolio, sin cambios: 7 LOs · 61 closed · 6 estados · $16,400 = $14,300 + $2,100 · 9 casos al corte · 5 activos · $17,000 de ventana.

**Efecto no evidente de las fechas relativas:** se calculan al sembrar y quedan guardadas como fechas absolutas. En el celular el funnel envejece de verdad: en dos semanas sin uso casi todo estará vencido. Es honesto (es el Tamagotchi real), pero una demo vieja se verá deteriorada. Resembrar es subir `_seedVersion`. Un botón de "reiniciar demo" queda para A6 (P40), fuera de A4.

### 3.8 · Transición G → SiPortfolio (canon §8.3)
Cuando G queda hecho, `isSigned` pasa a verdadero: el LO sale de `prospects()` y entra a `portfolio()`, con la misma carita, sin dinero (closed 0) y con su ventana de 12 meses en el mes 0. En el prototipo nadie marca G desde la app (lo mueve HOMESÍ y no hay backend): la transición la prueba un test de modelo.

### 3.9 · Persistencia
- `toMap()` guarda solo hechos: el funnel como lista de mapas (`k`, fecha hecha, resultado, intentos, reintento), SQL, inactivación, teléfono y asignación. **No guarda** estado de nodo, salud, días ni "stage".
- `fromMap()` sigue siendo defensivo: un mapa de la semilla v4 (con `stage` y sin `funnel`) no puede crashear; si falta el funnel, se crea vacío.
- `Store` gana, como delgadas capas de persistencia sobre funciones puras del modelo: `prospects(now)`, `markNode`, `undoMark`, `logCallAttempt`, `closeNoAnswer`, `saveSql`, `deliverSql`, `inactivate`, `radarAtStake(now)` y `alerts(now)`. La lógica vive en el modelo para que los tests no necesiten Hive.

## 4 · Fuera de alcance de A4
- Notificaciones del sistema (P41), permiso de micrófono y cualquier permiso nuevo en el `AndroidManifest`: subsprint **A4-N**.
- Marcador real del teléfono (`tel:` y `url_launcher`) y compartir a redes reales: el dialer es mock y el material se copia al portapapeles.
- Asignación de prospectos desde HOMESÍ, mover F y G desde la app y cualquier backend.
- Lista de prospectos devueltos.
- Íconos de redes sociales del prospecto en la ficha MQL: la semilla no tiene ese dato y no se inventa.
- Nurturing post-firma (backlog del canon §7).
- Tests de widgets (ver §5.4).
- Capa visual: va en A4-S (prompts de Stitch con el STYLE SYSTEM) y A4-R, después del gate funcional.
- Botón de reiniciar demo (A6).

## 5 · Implicaciones técnicas y dependencias

### 5.1 · Bloqueos que esta spec autoriza (B1–B4)

| # | Resolución |
|---|---|
| **B1** | `test/canon_test.dart:65`, `:115` y `:123`: se cambia **solo** el selector `l.stage == Stage.signed` por `l.isSigned`. Las aserciones quedan idénticas. Si una cifra cambia, se rompió el negocio: se para y se reporta (enmienda E1) |
| **B2** | `test/compiles_test.dart:52`, `:69` y `:70`: se retiran con los símbolos que desaparecen. Se agregan los símbolos nuevos y cada archivo nuevo de `lib/` entra a la lista de imports, como exige el propio archivo (E2) |
| **B3** | `lib/data/store.dart:69` y `:131`, `lib/zones/portfolio/usa_map_screen.dart:79` y `:96`: el selector pasa a `isSigned`. En `_passes` y `_countIf` del mapa se agrega una línea que excluye a los inactivos. Nada visible cambia hoy, porque la semilla no trae inactivos (E3) |
| **B4** | Subir a la v5 resiembra el box. Qué se conserva depende de la pregunta 4 de §6. Fernando lo sabe antes de instalar el APK de A4.1 (E4) |

### 5.2 · Tests nuevos de canon (`test/funnel_canon_test.dart`, con `now` fijo)
Archivo aparte para que el diff de `canon_test.dart` sean tres líneas.
1. La semilla tiene como máximo 20 vivos (17 exactos) y 24 LOs en total.
2. Los 7 firmados tienen A–G hechos, G = now − monthOf12 × 30 días, y siguen dando las cifras de SiPortfolio.
3. Secuencia: B bloqueado hasta que A esté hecho, y así hasta E.
4. Umbrales: los valores de `FunnelRules` son los de §3.3.
5. Vencimiento con reintento: tras "No contestó", C sigue pendiente y vence en `retryAt`; al tercer intento se puede cerrar como no contestó.
6. N30 se abre el día 30 desde la asignación y vence 7 días después.
7. F y G son de solo lectura: `markNode` los rechaza.
8. Inactivar exige SQL completo y nota de al menos 20 caracteres; sin cualquiera de los dos se rechaza; con ambos, el prospecto sale de los vivos y del tope.
9. Salud derivada: la semilla da 10 sanas, 6 en riesgo, 1 deteriorada; y la inactividad no cuenta cuando E está hecho.
10. Determinismo: el mismo `now` da los mismos estados; un `now` 10 días después da más vencidos.
11. Transición G → SiPortfolio: marcar G vuelve firmado al prospecto, lo saca de los vivos y no le crea dinero.
12. Alertas y "En la mesa de HOMESÍ": las cifras de §3.7.
13. `toMap()` no contiene `stage`, `state`, `health` ni días; ida y vuelta por `toMap`/`fromMap` conserva el funnel; un mapa v4 no crashea.
14. SQL: `sqlComplete` exige exactamente las obligatorias del borrador.
15. Según la pregunta 4 de §6: la función que conserva caritas y fotos por id (`carryAvatars`) es pura y tiene su test.

Y los 18 actuales en verde, con solo el cambio de B1 y B2.

### 5.3 · Tiempo y determinismo (M3)
Ninguna derivación llama a `DateTime.now()` por dentro: todas reciben `now`. Las pantallas pasan `DateTime.now()` una vez por construcción. Las fechas se comparan como fechas locales (sin hora), salvo la hora del reintento, que solo se muestra.

### 5.4 · Regla de `google_fonts` (lección del 18-nov)
Los tests de A4 son de modelo y de datos. Ninguno construye widgets ni llama funciones de `theme.dart`. Si más adelante se necesitan tests de widgets, primero se resuelve cómo se cargan las fuentes sin red; si no, nacen intermitentes.

### 5.5 · Contenido (P24, P25, P26)
- El texto del playbook, del pre-funnel y de las piezas N30/N60/N90 lo redacta el CEO en `Docs/specs/A4_Contenido_Playbook_PreFunnel.md`, desde A1 (V2 pain relievers, objeciones de los nodos N04, N07 y N08 del árbol de Carlos), la Filosofía §5 y el lenguaje de la campaña de Meta (Contexto §5). Va marcado "pendiente de validar con María Teresa". El constructor lo pasa tal cual a `lib/data/radar_content.dart`; no redacta copy.
- Toda cifra de compensación del LO sale de **una constante** (`kLoCompensation` o similar) y no se escribe dentro del texto. Depende de la pregunta 2 de §6.
- Términos de industria siempre en inglés; "comisión", nunca "split"; nadie promete una tasa.

### 5.6 · Permisos y CI
A4 no agrega ningún permiso, ninguna dependencia nueva ni toca `android/`. El portapapeles y los selectores de fecha y hora de Flutter no piden permisos. Recomendación: correr `PROMPT_A3-2` (Flutter fijo en el CI) antes de A4.1.

### 5.7 · Partición de la construcción
Cada prompt: `flutter analyze` en 0 issues y tests en verde antes de cada commit; el CEO verifica en el repo antes de emitir el siguiente.

| Prompt | Qué | Verificación |
|---|---|---|
| **A4.1** | `lib/models/funnel.dart`, cambios en `LoanOfficer`, `sql_form.dart` (borrador), semilla v5, `Store` nuevo, cirugía B3, tests (B1, B2 y §5.2). El stub de `radar_home.dart` se adapta lo mínimo para compilar: lista de vivos con nodo actual y días. **Sin pantallas nuevas** | Tres revisiones adversariales del CEO sobre el código real, porque aquí es donde se puede romper el negocio. **El APK de este push es el de la revisión visual de A3** |
| **A4.2** | P20 y P22, `node_train.dart`, `node_sheet.dart`, `node_actions.dart`, `sql_form_sheet.dart`, `inactivate_sheet.dart` | Recorrido de los flujos contra §2 |
| **A4.3** | P21, P23 y P24, con `radar_content.dart` (necesita el documento de contenido del CEO y la respuesta 2 de §6) | Ídem |
| **A4.4** | P25 y P26, contador en la pestaña SiRadar del `shell.dart` | Ídem, y releer el árbol del Acta: P20–P26 existen, cada uno en su archivo, ninguno fusionado |

Después: **gate funcional A4** (tres revisiones adversariales, la tercera obligatoria) → A4-S Stitch → A4-R capa visual → APK → "APROBADO A4".

**Implicación no evidente del CI:** cada push a `main` publica el APK en el link fijo. Los APK de A4.2 a A4.4 tendrán pantallas funcionales sin capa visual. Si Fernando instala alguno, es para probar flujos, no para juzgar el look; la regla de secuencia sigue: el APK que se aprueba es el de A4-R.

### 5.8 · Riesgos
- **Negocio:** retirar `Stage` toca el selector del portafolio. Lo vigilan las cifras intactas de `canon_test` y la revisión adversarial de A4.1.
- **Contenido:** el SQL y el playbook son borradores. Si María Teresa los cambia mucho, cambia un archivo de datos, no la lógica.
- **Producto:** la cifra amarilla de P20 es dinero potencial. Se etiqueta como tal y solo cuenta prospectos con SQL entregado, para no prometer por todo el radar.
- **Demo:** la semilla envejece en el celular (§3.7).

## 6 · Preguntas abiertas para Fernando (con default)

1. **SQL (M5).** ¿Se construye con el borrador de 14 preguntas de §3.5 mientras María Teresa lo valida? **Default: sí.** Queda como dato en un solo archivo; su validación es requisito del gate funcional A4, no de A4.1.
2. **Compensación del LO.** ¿P24 usa 275 bps completos para el LO con fee plano de US$650 por caso cerrado para HOMESÍ (oferta de octubre de 2026), o los 225 bps del Acta? **Default: 275 bps + US$650**, en una sola constante. Si lo confirmas, se enmienda el Acta A0 #7 y `CLAUDE.md` §2, y quedan pendientes V3, V4, el nodo N05 de Carlos y la etiqueta "225 bps" del stub de SiAcademy.
3. **Reglas del funnel (canon §8).** ¿Apruebas los umbrales y reglas de §3.3 y §3.4 (A y B 3 días, C 5, D 5, E 7; N desde la asignación y con 7 días para enviarse; reintento a 2 días con máximo 3 intentos; salud como en §3.4; G pasa solo a SiPortfolio; nomenclatura A–E, F–G, N30-N60-N90)? **Default: sí, todo.**
4. **Borrado al subir la semilla (B4).** **Default: se conservan las caritas y fotos que elegiste, por id; las cifras y los cortes cobrados vuelven a la semilla**, para que la revisión visual de A3 se haga sobre las cifras canónicas. Son unas diez líneas con su test. La alternativa es aceptar que se pierde todo.
5. **Dialer.** **Default: mock.** Los números son ficticios (555-01NN), así que el marcador real no aporta nada en el prototipo y exigiría `url_launcher` y un parche del manifiesto en el CI.

## 7 · Enmiendas al canon que introduce (vigentes cuando la spec se apruebe)

| # | Enmienda | Afecta |
|---|---|---|
| E1 | `canon_test.dart`: cambian solo los tres selectores; ninguna aserción | `CLAUDE.md` §6, regla de no tocar el test |
| E2 | `compiles_test.dart`: salen `Stage`, `stageLabel` y `promiseLabel`; entran los símbolos nuevos | `test/compiles_test.dart` |
| E3 | Cirugía de una línea en pantallas aprobadas de SiPortfolio (`usa_map_screen.dart`) y en `store.dart`: "firmado" pasa a ser `isSigned`, y los inactivos no se pintan en el mapa. Nada visible cambia | A3 aprobado, regla de cirugía |
| E4 | La semilla v5 resiembra el celular; qué se conserva lo decide la pregunta 4 | `CLAUDE.md` §5 |
| E5 | `FunnelNode` no guarda `state`: guarda hechos y el estado se deriva. Gana `result`, `attempts` y `retryAt` | Canon del funnel §6 |
| E6 | P23: el "auto-avance de stage" del Acta es marcar C o D; "reintento programado" es un intento más dentro del mismo nodo, con fecha y hora | Acta A0 §3, P23 |
| E7 | P20: el "score de calor" del Acta es la salud de la relación de §3.4 | Acta A0 §3, P20; canon del funnel §0 |
| E8 | P26 funciona dentro de la app; las notificaciones del sistema (P41) van en A4-N | Acta A0 §3, P26 y P41 |
| E9 | El canon §8 queda cerrado con las respuestas a la pregunta 3 | Canon del funnel §8 |
| E10 | `Prospect` del canon §6 y del `00_LEEME` §8 se resuelve como la misma entidad `LoanOfficer` | Canon del funnel §6 |
| E11 | Cifra de compensación del LO, según la pregunta 2 | Acta A0 #7, `CLAUDE.md` §2 |
