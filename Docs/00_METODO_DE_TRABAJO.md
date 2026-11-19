# 00 · MÉTODO DE TRABAJO · JoinSi by HOMESÍ
**Versión:** 1.0 · 2026-10-27 · **Aprobado por:** Fernando ("Dale, aprobado")
**Para qué existe:** que el producto se diseñe con Fernando, se especifique por escrito y se construya con Claude Code, cambiando de chat cuantas veces haga falta sin perder contexto.

---

## 1 · Los tres roles

| Rol | Quién | Dónde trabaja | Qué produce |
|---|---|---|---|
| **Director** | Fernando Orduz | Desde el móvil (voz a texto) y el laptop | Decisiones, aprobaciones ("APROBADO …"), assets, validación del APK |
| **CEO de producto y arquitecto** | Chat JoinSi #N, en el proyecto claude.ai **"JoinSi · CEO de producto"**, sesión de Cowork con `C:\Joinsi` conectado | `Docs/` y `CLAUDE.md` | Co-diseño, specs, bitácora, memoria, prompts para Claude Code, verificación |
| **Constructor** | Claude Code en `C:\Joinsi` | `Code/joinsi_app/` y git | Código, tests, commits, push, APK del CI |

El CEO de producto conversa con Fernando, cuestiona y propone. **No escribe código de producto ni commitea.** El constructor **no reinterpreta el canon**.

## 2 · Dónde vive cada cosa

| Qué | Dónde | Quién lo escribe |
|---|---|---|
| Canon y memoria del proyecto | `Docs/` en el repo (fuente de verdad) | CEO |
| Estado y decisiones abiertas | `Docs/JOINSI_Memoria_LTM_Proyecto.md` | CEO |
| Historia de decisiones | `Docs/JOINSI_Bitacora_de_Decisiones.md` | CEO, en el momento en que se decide |
| Specs de funcionalidades | `Docs/specs/SPEC_<sprint>_<tema>.md` | CEO, con Fernando |
| Notas de relevo entre chats | `Docs/relevos/RELEVO_JoinSi_<NN>_a_<MM>.md` | CEO que cierra |
| Tareas para Claude Code | `Docs/prompts/PROMPT_<sprint>_<tema>.md` (el de A3.1 quedó en `Docs/` por historia) | CEO |
| Reportes largos e insumos del constructor | `Docs/constructor/REPORTE_CONSTRUCTOR_<fecha>.md` · `Docs/constructor/INSUMOS_<sprint>_<tema>.md` | Constructor. El CEO los lee y no los edita; las decisiones que salen de ahí las registra el CEO en la bitácora. Los reportes cortos siguen en el chat de Claude Code |
| Contexto de negocio de HOMESÍ | `Docs/JOINSI_Contexto_HOMESI.md` | CEO, con fecha y fuente por dato |
| Sistema de marca | `Docs/P1B_Sistema_de_Marca_HOMESI_Oficial.md` | No se edita |
| Contrato del constructor | `CLAUDE.md` (raíz) | CEO |
| Proyecto claude.ai | Instrucciones y 3 espejos (`00_LEEME`, LTM, Contexto HOMESÍ) | Fernando los sube; el CEO avisa cuándo refrescarlos |
| Memoria personal de Claude | Preferencias de Fernando, nunca canon de JoinSi | Automática |

**Regla:** si un dato del proyecto claude.ai o de un chat contradice `Docs/`, manda `Docs/`.

## 3 · El ciclo de una funcionalidad

1. **Co-diseño.** Fernando trae una idea o el CEO propone. El CEO la examina en voz alta: por qué, para qué, cómo, implicaciones evidentes y no evidentes, riesgos y beneficios. Hace como máximo 5 preguntas, cada una con su default, y después propone y actúa. Nada de bucles de preguntas.
2. **Decisión escrita en el momento.** Cada decisión de Fernando entra a la bitácora en el mismo turno en que la toma, con su frase textual cuando es clave.
3. **Spec.** El CEO escribe o actualiza la spec en `Docs/specs/`. Estados: `BORRADOR` → `EN DISCUSIÓN` → `APROBADA vX (fecha, frase de Fernando)`. Una spec aprobada solo cambia con una nueva aprobación.
4. **Prompt.** Con la spec aprobada, el CEO escribe la tarea en `Docs/prompts/`. Fernando le dice a Claude Code: *"Lee y ejecuta Docs/prompts/PROMPT_…md"*.
5. **Construcción.** Claude Code ejecuta, corre `flutter analyze` (0 issues) y `flutter test`, commitea por tema, hace push y reporta.
6. **Verificación.** El CEO revisa en el repo (`git log`, `git diff`, árbol del Acta) y corre **tres revisiones adversariales** sobre el código real antes de proponer un gate. La tercera es obligatoria.
7. **Gate.** Fernando aprueba ("APROBADO A-N") o corrige. Sus correcciones son canon inmediato.
8. **Diseño visual y APK.** En sprints de pantallas: Stitch (prompts del CEO con el STYLE SYSTEM) → capa visual → solo entonces el APK al celular.

## 4 · Plantilla de spec

```
# SPEC <sprint> · <tema> · v<n>
Estado: BORRADOR | EN DISCUSIÓN | APROBADA v<n> (<fecha>, "<frase de Fernando>")
Fuentes: <documentos del canon que la gobiernan>

1 · Requisito del Director
2 · Experiencia (qué vive cada persona, paso a paso)
3 · Reglas de negocio y datos (qué se deriva, qué se guarda)
4 · Fuera de alcance
5 · Implicaciones técnicas y dependencias
6 · Preguntas abiertas (con default)
7 · Enmiendas al canon que introduce
```

## 5 · Plantilla de prompt para Claude Code

```
# PROMPT <sprint> · <tema>
Emitido por: CEO JoinSi #N · <fecha> · Spec: Docs/specs/<archivo>
Reglas: qué se toca y qué no · un commit por tema · analyze y test antes de cada commit
Contexto: lo mínimo que necesita saber
Pasos: numerados, verificables
Reporte: hashes, salida de analyze/test, git status, desviaciones (máximo 12 líneas)
Cierre: "Y para ahí."
```

## 6 · Ritual de relevo entre chats

**Cuándo cambiar de chat** (basta una señal):
- El chat resumió su propio contexto (aparece un resumen automático de la conversación anterior).
- El CEO olvida o contradice algo ya decidido.
- Se cerró un sprint o un gate.
- Fernando dice "relevo".

**Checklist de cierre** (lo ejecuta el CEO saliente, en este orden):
1. Bitácora al día: toda decisión del chat registrada.
2. LTM: §0 estado, §9 decisiones abiertas y §10 ruta actualizados.
3. Specs: estado correcto en cada una.
4. Nota de relevo en `Docs/relevos/RELEVO_JoinSi_<NN>_a_<MM>.md` con: estado en 5 líneas, temas abiertos en conversación, decisiones de este chat, lo primero que debe hacer el siguiente y lo que Fernando espera recibir.
5. `00_LEEME_ARRANQUE_ARQUITECTO.md` apunta a la nota de relevo nueva.
6. Si la LTM cambió mucho, avisar a Fernando que refresque los espejos del proyecto claude.ai.
7. Los cambios de `Docs/` quedan commiteados por la siguiente tarea de Claude Code (regla en `CLAUDE.md` §7). Si no hay tarea próxima, el CEO escribe un prompt corto solo para commitearlos.

**Arranque del chat nuevo:** Fernando abre una sesión en el proyecto "JoinSi · CEO de producto" con `C:\Joinsi` conectado y pega el prompt de la sección 9 de `00_LEEME_ARRANQUE_ARQUITECTO.md`.

## 7 · Sincronía con el resto de HOMESÍ

JoinSi depende de decisiones que se toman en el proyecto CEO Agéntico (oferta al LO, compensación, marca, compliance). Para que no trabaje con datos viejos:
- `Docs/JOINSI_Contexto_HOMESI.md` fecha cada dato y nombra su fuente.
- **Toda cifra de negocio se confirma con Fernando antes de entrar a una spec, a un audio o a un video.**
- Cuando Fernando cambie una decisión de HOMESÍ en otro proyecto, se lo dice al CEO de JoinSi, y este actualiza el documento de contexto y la bitácora.

## 8 · Estilo de conversación con Fernando

- Español, ritmo tranquilo, frases directas y en voz activa.
- Sin figuras poéticas de IA, sin guiones largos en la prosa, sin comentarios de proceso dentro de entregables.
- Interpretar la intención, no la ortografía (voz a texto desde el móvil).
- Antes de escribir en el chat, verificar en el repo. Nunca afirmar el estado de memoria.
- Cerrar cada respuesta con un solo siguiente paso.
