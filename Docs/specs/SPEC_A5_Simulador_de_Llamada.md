# SPEC A5 · Simulador de llamada (P13) · v0.1
**Estado:** concepto APROBADO por Fernando (2026-10-27). Detalles en discusión. Se construye en A5.
**Fuentes:** `Docs/JOINSI_A1_Prompts_Stitch_Higgsfield_Voces.md` Parte 3 (árbol de Carlos Mendoza) · Acta A0 §2 · ST-03.

## 1 · Requisito del Director
En el prototipo, el usuario ya vive una llamada simulada completa con un Loan Officer (Carlos Mendoza), de principio a fin.

## 2 · Mecánica de cada turno
1. Carlos habla: clip pregrabado, una de tres variantes al azar.
2. El usuario ve tres tarjetas de respuesta y escoge una.
3. Se abre el micrófono y el usuario lee la tarjeta en voz alta.
4. Toca "listo" y Carlos responde según la tarjeta escogida.

**La tarjeta decide el camino del árbol. La voz no interviene en la ruta.** Por eso la conversación siempre es coherente: toda opción tiene su respuesta grabada.

## 3 · Grabación y métricas
- La voz se graba por turno y se guarda solo en el celular (sin backend).
- Al final de la llamada, el usuario puede escucharse turno por turno ("escucha cómo sonaste").
- Métricas locales, porque la app conoce el texto exacto de la tarjeta: velocidad (palabras / duración), pausas largas y demora en empezar a hablar.
- Los cuatro medidores del árbol (Pitch, Precisión, LAER, Resiliencia) no cambian.

## 4 · Modo silencioso
El usuario puede avanzar solo con tarjetas cuando no puede hablar en voz alta. Las métricas de voz quedan en blanco.

## 5 · Consentimiento
La primera vez que se abre el micrófono, una línea explica que la voz se graba para que el usuario se escuche y que se queda en su celular.

## 6 · Después del MVP
1. Con backend: transcripción y análisis con IA de fluidez, empatía, tono y fidelidad al texto.
2. Conversación libre con Gemini Live sobre la misma pantalla (canon del Acta A0).

## 7 · Implicaciones técnicas
- Permiso de micrófono en Android: requiere parchear el manifiesto que genera el CI. Se resuelve junto con las notificaciones del sistema (subsprint de permisos).
- Dependencias de producción: voz de Carlos elegida en Higgsfield, cifras del nodo N05 cerradas (225 vs 275 bps) y los ~48 clips generados.

## 8 · Preguntas abiertas (con default)
1. ¿Las métricas de voz cuentan para aprobar el módulo? Default: no en el prototipo; se muestran como retroalimentación.
2. ¿Duración máxima de grabación por turno? Default: 20 segundos.
3. ¿Cuántas llamadas grabadas se guardan? Default: la última y la de mejor puntaje.
4. El simulador de objeciones (P12) dice "selección más texto libre" en el Acta; sin IA el texto libre no se puede interpretar. Default: solo selección en el prototipo.

## 9 · Enmienda al canon
El micrófono deja de ser "post-MVP para conversar" y entra al prototipo con la función de **grabar, no de entender**. Registrado en la bitácora el 2026-10-27.
