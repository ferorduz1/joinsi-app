# ARRANQUE EN LAPTOP NUEVO — instrucciones para el agente

> **Eres Claude Code recién despertado en un laptop nuevo (Windows 11, Core i7, 8–16 GB RAM).**
> Fernando Orduz (el Director) acaba de migrar JoinSi desde un HP ENVY 13 con 3.9 GB de RAM y
> disco al 97%. Este documento es tu tarea completa. **Ejecútalo en orden, de arriba abajo.**
>
> Lee también `CLAUDE.md` en la raíz del repo: es el canon del proyecto y no se reinterpreta.
> Este archivo es solo el arranque; cuando termines, tu trabajo se rige por `CLAUDE.md`.

---

## REGLAS DE ESTA TAREA

1. **Ejecuta tú lo que puedas ejecutar.** No le dictes a Fernando comandos que tú mismo puedes correr.
2. **Para en seco y pídele acción a él solo en los 3 puntos marcados `🙋 HUMANO`.** Son pasos que requieren un navegador o una respuesta interactiva que tú no puedes dar.
3. **No commitees nada durante este arranque.** El repo debe quedar limpio al terminar.
4. **Reporta la verdad cruda.** Si algo falla, di qué falló con el error textual. Nada de "todo listo" optimista.
5. **Fernando escribe desde el móvil, por voz a texto:** mensajes cortos, con erratas. Interpreta la intención, no la ortografía.
6. Si un paso ya está hecho (por ejemplo Git ya instalado), detéctalo, dilo en una línea y sigue. No repitas trabajo.

---

## PASO 1 · Diagnóstico de la máquina

Corre y reporta en una tabla compacta qué hay y qué falta:

```powershell
foreach ($c in 'git','gh','flutter','dart','code','python','node') {
  $x = Get-Command $c -ErrorAction SilentlyContinue
  if ($x) { "$c -> $($x.Source)" } else { "$c -> FALTA" }
}
Get-CimInstance Win32_ComputerSystem | Select-Object @{n='RAM_GB';e={[math]::Round($_.TotalPhysicalMemory/1GB,1)}},Model
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID,@{n='LibreGB';e={[math]::Round($_.FreeSpace/1GB,1)}}
```

---

## PASO 2 · Instalar lo que falte

Solo lo que el Paso 1 reportó como FALTA. `winget` puede pedir elevación: si falla por permisos,
dile a Fernando que abra *Terminal (Administrador)* y pégale el comando exacto.

```powershell
winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements
winget install --id Microsoft.VisualStudioCode -e --accept-source-agreements --accept-package-agreements
```

**Node y Python NO son necesarios para JoinSi.** No los instales salvo que Fernando los pida.

Después de instalar, los comandos nuevos no existen en tu sesión actual de shell. Úsalos por ruta
absoluta (`& "C:\Program Files\Git\cmd\git.exe" --version`) o refresca el PATH del proceso:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
```

---

## PASO 3 · Identidad de Git

```powershell
git config --global user.name "Fernando"
git config --global user.email "forduz1@gmail.com"
git config --global --list
```

Estos son exactamente los valores del laptop viejo. No los cambies.

---

## PASO 4 · 🙋 HUMANO — login de GitHub

Tú no puedes autenticarte por él. Dile, con estas palabras:

> Corre `gh auth login` en tu terminal y responde: **GitHub.com** → **HTTPS** → **Y** (autenticar Git
> con tus credenciales) → **Login with a web browser**. Copia el código de 8 caracteres que aparece,
> presiona Enter, pégalo en el navegador y autoriza. Avísame cuando termines.

**Espera su confirmación.** Luego verifica tú mismo:

```powershell
gh auth status
```

Debe decir que está autenticado como `ferorduz1`. Si no, no avances.

---

## PASO 5 · Clonar el proyecto

**Fuera de OneDrive.** En el laptop viejo el repo vivía dentro de OneDrive y eso hacía que OneDrive
y git pelearan por los mismos archivos. Aquí va en `C:\Proyectos`:

```powershell
if (-not (Test-Path C:\Proyectos)) { New-Item -ItemType Directory C:\Proyectos | Out-Null }
cd C:\Proyectos
git clone https://github.com/ferorduz1/joinsi-app.git
cd C:\Proyectos\joinsi-app
git log --oneline -3
git status
```

**Verifica:** el commit más reciente debe ser el de `CLAUDE.md` sobre `4f855ed`
("A3-R2: rediseno SiPortfolio sobre Stitch aprobado"), y el working tree limpio.

Si Claude Code está abierto en otra carpeta, dile a Fernando que abra una sesión en
`C:\Proyectos\joinsi-app` para que `CLAUDE.md` se cargue automáticamente.

---

## PASO 6 · Restaurar el archivo de permisos local

`.claude/settings.local.json` no viaja en git. Recréalo con exactamente este contenido:

```json
{
  "permissions": {
    "allow": [
      "Bash(git ls-remote *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git push *)",
      "Bash(awk '{print $5, $9}')",
      "Bash(gh --version)",
      "Bash(gh auth *)",
      "Bash(flutter --version)"
    ]
  }
}
```

Son los permisos que Fernando ya había concedido en el laptop viejo. No agregues ni quites nada.

---

## PASO 7 · Instalar Flutter

**Requisito duro: Flutter stable con Dart >= 3.7** (el proyecto usa `CardThemeData` en
`ThemeData.cardTheme`, que exige Flutter >= 3.29). Con Dart menor, el proyecto no compila.

No adivines una URL de descarga: pídele a Google el canal stable actual.

```powershell
$j = Invoke-RestMethod "https://storage.googleapis.com/flutter_infra_release/releases/releases_windows.json"
$rel = $j.releases | Where-Object { $_.hash -eq $j.current_release.stable } | Select-Object -First 1
"Version: $($rel.version)  Dart: $($rel.dart_sdk_version)"
$url = "$($j.base_url)/$($rel.archive)"
$zip = "$env:TEMP\flutter_stable.zip"
Invoke-WebRequest $url -OutFile $zip
Expand-Archive $zip -DestinationPath C:\ -Force
```

Queda en `C:\flutter`. **No lo pongas en "Archivos de programa"**: da errores de permisos.
La descarga es ~1 GB; avísale a Fernando que va a tardar y no lo dejes sin señal de progreso.

### Agregar al PATH del usuario — con cuidado

⚠️ **Nunca sobrescribas el PATH.** Lee, verifica que no esté, y agrega:

```powershell
$p = [Environment]::GetEnvironmentVariable('Path','User')
if ($p -notlike '*C:\flutter\bin*') {
  [Environment]::SetEnvironmentVariable('Path', ($p.TrimEnd(';') + ';C:\flutter\bin'), 'User')
  "PATH de usuario actualizado"
} else { "Ya estaba en el PATH" }
$env:Path += ';C:\flutter\bin'   # para esta sesion
flutter --version
```

Confirma que la línea de Dart diga **3.7 o superior**. Si dice menos, algo salió mal: repórtalo y para.

---

## PASO 8 · LA PRUEBA DE FUEGO — primera corrida de los tests

**Contexto que debes entender antes de correr esto:** en el laptop viejo **nunca hubo Flutter**.
Los tests entraron con el commit `4f855ed` y **jamás se han ejecutado en una máquina real**. Esta es
la primera vez. No los des por buenos de antemano.

```powershell
cd C:\Proyectos\joinsi-app\Code\joinsi_app
flutter pub get
flutter analyze
flutter test
```

Reglas de interpretación, no negociables:

- **`flutter analyze` es BLOQUEANTE.** `flutter test` solo compila el test y lo que este importa:
  puedes tener los tests verdes y la app rota. Sin analyze limpio, nada está terminado.
- **Si falla `test/canon_test.dart`, lo que se rompió es el modelo de negocio, no el código.**
  Ese test protege la regla de compensación ($500 + $500, luego $200/caso), el embudo de la semilla,
  la coherencia entre el promedio declarado de un LO y su historial, y que no haya `Color(0x...)`
  fuera de `lib/core/tokens.dart`. **Repórtalo y para. No lo "ajustes" para que pase.**
- Si falla por entorno (dependencias, versión de Dart, red), dilo como problema de entorno y arréglalo.

Reporta el resultado textual de los tres comandos. Sin adornos.

---

## PASO 9 · Android (solo para compilar el APK)

Los tests del Paso 8 **no necesitan Android SDK**. Esto es para generar el APK instalable.

```powershell
winget install --id Google.AndroidStudio -e --accept-source-agreements --accept-package-agreements
```

**🙋 HUMANO:** dile a Fernando que abra Android Studio una vez y deje correr su asistente inicial,
y que después ejecute él mismo:

```
flutter doctor --android-licenses
```

y acepte todo con `y` + Enter. Tú no puedes responder ese prompt interactivo.

Luego verifica tú:

```powershell
flutter doctor
```

Para compilar cuando haga falta: `flutter build apk --release` → el APK sale en
`build/app/outputs/flutter-apk/app-release.apk`.

> **Recuerda:** este repo versiona solo `lib/`, `test/`, `assets/` y `pubspec.yaml`. Que no existan
> carpetas `android/` ni `ios/` **es intencional** — las genera `flutter create` (lo hace el workflow
> de GitHub Actions en cada push). **No es un error y no hay que arreglarlo.** Si alguna vez corres
> `flutter create` en local, respalda `lib/` antes: puede pisar `main.dart`.

---

## PASO 10 · 🙋 HUMANO — pedir los assets de marca

Esto lo ordena `CLAUDE.md` §0 y es tu obligación, no un detalle opcional.
Fernando los tiene **perfeccionados** y te los va a entregar. **No los inventes, no uses
placeholders como definitivos.** Pídeselos así:

- `logo_oficial_transparente.png` — la casa en círculo rojo, 512×512 con alpha
  → destino: `Code/joinsi_app/assets/brand/logo_oficial_transparente.png`
- Intro 1: `INTRO_Logo_HOMESI_Animado__2_.html` — wordmark animado (capturar a 1920×1080)
- Intro 2: animación del logo casa
- Videos V0–V4 y los ~48 clips de audio del árbol de llamada → se usan en el sprint A5

Sin el logo la app corre con un ícono de respaldo: tolerable para desarrollar, **no para una demo**.

---

## PASO 11 · Cierre del arranque

Deja el repo limpio (`git status` sin cambios tuyos) y entrega un informe de **máximo 8 líneas**:

1. Qué instalaste y qué ya estaba.
2. Versión de Flutter y de Dart.
3. Resultado textual de `flutter analyze` y `flutter test`.
4. Qué quedó pendiente y por qué (por ejemplo licencias de Android si él aún no las aceptó).
5. La lista de assets que le pediste.
6. Tu entendimiento, en una línea, de en qué quedó A3 y qué implica A4.

**Y para ahí.** No arranques A4 ni escribas código de producto sin un `APROBADO` explícito de Fernando.

---

## CONTEXTO QUE NO DEBES REDESCUBRIR

Esto ya fue auditado y verificado en el laptop viejo. No lo investigues de nuevo:

- **El repo está limpio.** Historial auditado commit por commit: un solo autor, cero contaminación de
  otros proyectos. (Hubo un incidente en que una sesión de Claude Desktop apuntó a este repo creyendo
  ser otro proyecto; se auditó y no dejó rastro.)
- **No existe ningún secreto fuera de GitHub.** Se buscó `.env`, `.pem`, `.key`, `*.jks`,
  `local.properties`, `key.properties` y archivos de credenciales: no hay ninguno. No hay nada que
  reconfigurar ni ninguna llave que pedir.
- **No hay backend.** Persistencia local con Hive. Sin Supabase, sin API, sin variables de entorno.
- **En la raíz del repo hay una copia legacy** de `lib/` y `assets/` de la fase A2, más
  `joinsi_app_A2.zip`. Es el estado anterior, **no basura**. No la borres sin autorización del Director.
- **`build-apk_NUEVO.yml`** (raíz del repo) es una versión mejorada del workflow de build que **nunca
  se activó**: publica el APK como Release público de tag fijo `apk-latest`, descargable desde el
  celular sin login de GitHub. Está ahí a propósito, inactivo, esperando decisión del Director.
  **No lo muevas a `.github/workflows/` por iniciativa propia.**
- **`lib/data/usa_map_data.dart` es generado** (proyección AlbersUSA de `us-atlas@3`, simplificada con
  Ramer–Douglas–Peucker a ~2.275 puntos). No lo edites a mano.
- **El laptop viejo sigue encendido y con una copia.** No es urgente rescatar nada de allá; ya se
  verificó que todo lo único está en GitHub o fue transportado.
