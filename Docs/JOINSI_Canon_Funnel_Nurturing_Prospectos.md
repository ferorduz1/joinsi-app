# JOINSI by HOMESI — CANON: Funnel de Nurturing de Prospectos
## Reemplaza P22 "Pipeline de nodos" · Redefine el corazón de SiRadar (A4)
**Fecha:** 2026-07-28 · **Origen:** definición directa de Fernando · **Estado:** CANON DECIDIDO. Fernando ordenó "Reemplaza por esta lógica" (2026-07-28). Los 4 detalles de §8 se cierran en el plan de A4 con su default, salvo objeción del Director. Copia al repo: 2026-10-23 (antes vivía solo en la memoria del proyecto claude.ai)
**Gobernado por:** Acta A0 v1.1 + P1B · **Zona:** SiRadar (A4)

---

## 0 · QUÉ REEMPLAZA (para que no queden dos verdades)

| Antes (Acta A0) | Ahora |
|---|---|
| **P22 Pipeline de nodos** — recorrido horizontal de 8 etapas (Assigned → Pre-funnel → Call 1 → Follow-up → Call 3 → Meeting PD → Deciding → Signed), una pantalla por prospecto | **Funnel de Nurturing** — pantalla ÚNICA con nodos por milestone para TODOS los prospectos vivos simultáneamente, con filtros |
| `enum Stage { assigned, preFunnel, call1, followUp, call2, meetingPD, deciding, signed }` | Modelo de **nodos accionables con estado propio** (ver §3). El "stage" deja de ser un escalar y pasa a ser el nodo más avanzado completado |
| Tamagotchi como barra de calor abstracta | El **contador de días desde asignación** y la **salud de la relación** salen del cumplimiento real de los nodos |

**Regla:** ninguna pantalla puede seguir mostrando el pipeline de 8 etapas del Acta A0. Esta es la única verdad del recorrido de prospección.

---

## 1 · PRINCIPIO RECTOR

El funnel separa explícitamente **lo que el reclutador controla** de **lo que no controla**. Esa frontera es el corazón del diseño: el reclutador es evaluado y guiado SOLO sobre sus 5 nodos accionables; los 2 nodos finales (reunión y firma) son visibles pero de solo lectura, porque dependen de HOMESI y del prospecto. Nada frustra más a un vendedor que un tablero que lo culpa por algo que no está en sus manos.

Cada nodo responde tres preguntas sin que el usuario tenga que pensar: **qué hacer exactamente · desde cuándo está pendiente · qué pasa si no lo hago.**

---

## 2 · ESTRUCTURA DE NODOS (por prospecto)

### Bloque 1 — EN CONTROL DEL RECLUTADOR (5 nodos, accionables)

| Nodo | Nombre | Qué exige | Evidencia |
|---|---|---|---|
| **A** | Pre-funnel social · POST | Publicar 1 post en una red social (material entregado por HOMESI). El nodo muestra un indicador de info con la instrucción exacta | Check "hecho" |
| **B** | Pre-funnel social · DM | Saludo casual con pitch prediseñado + pedir quedar en contacto | Check "hecho" |
| **C** | Cold call 1 | Primera llamada en frío (playbook contextual disponible) | Check + resultado (contestó / no contestó) |
| **D** | Cold call 2 · seguimiento | Llamada de seguimiento a la llamada en frío | Check + resultado |
| **E** | **SQL** | Artefacto calificador que el RECLUTADOR debe responder. Es el entregable formal de su trabajo de calificación | Formulario respondido (obligatorio, no un check) |

**Aquí termina el control del reclutador.**

### Bloque 2 — FUERA DE SU CONTROL (2 nodos, solo lectura)

| Nodo | Nombre | Quién lo mueve |
|---|---|---|
| **F** | Reunión presencial del prospecto (con Director de Producción) | HOMESI |
| **G** | Firma de contrato | HOMESI / el prospecto |

Se muestran atenuados con etiqueta explícita del tipo "fuera de tu control · lo mueve HOMESI". El reclutador NO puede marcarlos.

### Bloque 3 — NURTURING PERPETUO (3 nodos temporizados)

Mientras el prospecto siga en el **pipeline vivo** (no firmado, no inactivado), se abren nodos de nurturing a los **30, 60 y 90 días**:

| Nodo | Se abre a | Qué exige |
|---|---|---|
| **N30** | día 30 | Enviar pieza de conocimiento (material entregado por HOMESI, pero **el reclutador debe enviarlo**) |
| **N60** | día 60 | Segunda pieza de conocimiento |
| **N90** | día 90 | Tercera pieza de conocimiento |

Propósito declarado: generar engagement y mantener viva la relación con un prospecto que aún no convierte. La pieza la produce HOMESI; el envío es del reclutador — el valor está en el contacto humano, no en el contenido.

---

## 3 · MODELO DE ESTADO POR NODO

Cada nodo tiene UNO de estos estados:

- **Bloqueado** — el nodo anterior no está hecho, o aún no se cumple el tiempo (N30/N60/N90)
- **Pendiente** — disponible para actuar. Muestra días transcurridos desde que se habilitó
- **Vencido** — pendiente más allá del umbral esperado. Es lo que deteriora la salud de la relación
- **Hecho** — completado (con fecha)
- **Fuera de control** — solo nodos F y G

**Contador de días:** cada prospecto lleva un contador desde que HOMESI se lo asignó. Ese número es visible siempre — es la conciencia del tiempo que el módulo Tamagotchi buscaba enseñar, ahora anclada a un dato real.

**Indicador de salud de la relación:** derivado del cumplimiento de nodos y de los días vencidos. Sana / en riesgo / deteriorada. NO es un dato almacenado: se calcula.

---

## 4 · INACTIVACIÓN DE UN PROSPECTO (devolución a HOMESI)

El reclutador puede **inactivar** un prospecto en cualquier momento. Inactivar = sacarlo de su funnel y **devolverlo a HOMESI**.

**Requisitos obligatorios para inactivar (ambos, sin excepción):**
1. **SQL diligenciado** — el artefacto calificador respondido
2. **Nota con la razón** — texto libre obligatorio

Sin esos dos, la acción no procede. Razón de negocio: un prospecto devuelto sin diagnóstico es una pérdida de inteligencia para HOMESI; el SQL + la nota son el activo que queda.

---

## 5 · LA PANTALLA

- **Visual de nodos por milestones**, un tren de nodos por cada prospecto vivo.
- **Todos los prospectos a la vez** en una sola pantalla (no una pantalla por prospecto).
- **Máximo 20 prospectos simultáneos** — restricción de producto, no técnica: mantiene el foco y hace la pantalla legible. HOMESI no carga más de 20 a la vez.
- **Filtros** para ver todos o un subconjunto (por estado de nodo, por vencidos, por días, por tier, por estado geográfico).
- Cada fila/tarjeta de prospecto muestra: carita, nombre, días desde asignación, tren de nodos con sus estados, indicador de salud, y acceso a inactivar.

---

## 6 · CONSECUENCIAS PARA EL MODELO DE DATOS (contrato para A4)

- `Prospect` (o `LoanOfficer` en fase de prospección) gana: `assignedDate`, `List<FunnelNode>`, `sqlAnswers?`, `inactivatedReason?`, `inactivatedDate?`
- `FunnelNode {key (A|B|C|D|E|F|G|N30|N60|N90), state, completedDate?, dueDate?}`
- `daysSinceAssigned` — derivado de `assignedDate` y `now`, nunca almacenado
- `nodeState(key)` — derivado: bloqueado/pendiente/vencido/hecho/fueraDeControl
- `relationshipHealth` — derivado del conteo de nodos vencidos y días sin actividad. **Nunca un campo**
- `canInactivate` — requiere `sqlAnswers != null && inactivatedReason != null`
- **El `enum Stage` de 8 valores se retira.** Lo que hoy llaman "stage" pasa a ser un derivado: el nodo más avanzado en estado "hecho"
- Restricción de semilla: **máximo 20 prospectos activos simultáneos**
- Los nodos A–E y N30/N60/N90 se resuelven con **check "hecho offline"** (el prototipo no tiene mensajería ni redes sociales reales) — misma categoría de ficción declarada que el dialer mock y la cuenta bancaria mock. El nodo E (SQL) es la excepción: es un formulario real que sí se diligencia y persiste.

---

## 7 · RELACIÓN CON EL NURTURING POST-FIRMA (no confundir)

Existen DOS sistemas de nurturing, y son distintos:

| | **Este documento** | **Backlog §3-bis de la LTM** |
|---|---|---|
| A quién cuida | **Prospecto** (aún no firma) | **LO ya reclutado** (firmado, en el portafolio) |
| Dónde vive | SiRadar (A4) | SiPortfolio / ficha 360° (sin sprint asignado) |
| Nodos | A–E, F–G, N30/N60/N90 | Chat mensual, visita semanal al dashboard, escalación a business plan a los 30 días sin ratificados, chat mensual de conocimiento |
| Estado | **CANON — reemplaza P22** | **Backlog — no ejecutar sin decisión** |

Ambos comparten filosofía (cuidar la relación o se muere) y mecánica (check "hecho offline" + indicador de salud), y deben compartir componentes visuales en el código para no divergir.

---

## 8 · PREGUNTAS ABIERTAS (resolver antes de construir A4)

1. **Umbrales de vencimiento:** ¿cuántos días puede estar pendiente cada nodo antes de marcarse vencido? (propuesta por defecto: A y B → 3 días · C → 5 días · D → 5 días tras C · E → 7 días tras D)
2. **¿Los nodos N30/N60/N90 corren desde la asignación o desde el último contacto?** (propuesta: desde la asignación, para que sea predecible)
3. **¿Un prospecto que llega a G (firma) sale del funnel** y aparece en SiPortfolio como LO del portafolio? (propuesta: sí, transición automática — es el puente entre las dos zonas)
4. **Nomenclatura de nodos:** Fernando usó "E, F y G" tanto para SQL/reunión/firma como para los nurturing de 30/60/90. Aquí se resolvió como A–E (control), F–G (fuera de control), N30/N60/N90 (nurturing). **Confirmar.**
