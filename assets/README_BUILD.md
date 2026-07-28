# JoinSi — Cómo compilar el APK (con Claude Code)

## Una sola vez
1. Instala Claude Code en tu escritorio (claude.com/claude-code).
2. Abre una terminal en esta carpeta (joinsi_app) y ejecuta `claude`.
3. Dile: "Instala Flutter y el Android SDK, luego ejecuta flutter pub get
   y compila flutter build apk --release. Resuelve cualquier error."
   (Claude Code instala todo; tarda ~15-30 min la primera vez.)

## Cada build siguiente
- "Compila el APK" → produce build/app/outputs/flutter-apk/app-release.apk
- Ese archivo se envía por WhatsApp/Drive; en el celular Android se instala
  activando "instalar apps de origen desconocido". Sin Play Store, sin cuenta.

## Assets pendientes de colocar
- assets/brand/logo_oficial_transparente.png (el PNG oficial 512x512)
- assets/video/V0..V4.mp4 (Higgsfield, con los dos intros al frente)
- assets/audio/N01_v1.mp3 ... (48 clips del árbol de Carlos Mendoza)

## Estado del andamiaje (A2)
- Tokens P1B completos (tokens.dart) + tema + tipografía Poppins/Barlow/Inter
- Navegación 3 zonas + toggle ES/EN en vivo + lockup de marca
- Hive con 24 LOs semilla, dinero, racha y progreso persistentes
- SiPortfolio: dashboard de dinero funcional con odómetro animado
- SiRadar: fichas MQL con tiers y CTAs
- SiAcademy: mapa de aprendizaje con nodos y progreso
- Pendiente A3-A5: mapa USA, pipeline de nodos, simuladores, videos
