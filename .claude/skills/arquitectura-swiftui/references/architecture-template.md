<!--
PLANTILLA — instrucciones para Claude al instanciar:
1. Sustituye {{APP_NAME}} por el nombre real del proyecto.
2. Las scenes y features que aparecen son EJEMPLOS ilustrativos: reemplázalas por
   las derivadas del nicho del proyecto (misma forma, otros nombres).
3. Ajusta "Estructura actual" a lo que realmente exista: solo carpetas con su
   primer archivo real. Ajusta "Modelo de crecimiento" al destino plausible del
   proyecto.
4. Conserva ÍNTEGRAS las secciones marcadas [INVARIANTE] (puedes adaptar los
   nombres de los ejemplos dentro de ellas, nunca las reglas).
5. Borra este bloque de comentario del archivo final.
-->

# Arquitectura de {{APP_NAME}}

Guía de la organización del código y el modelo de crecimiento del proyecto.

## Filosofía [INVARIANTE]

**Vertical slicing pragmático.** Organizamos el código por *qué hace para el usuario* (features), no por *qué tipo de objeto es* (Models/, ViewModels/, Views/ a nivel raíz). Cada feature contiene lo que necesita y crece con la estructura que pide el problema, no con una plantilla impuesta.

**Sin abstracción prematura.** No creamos carpetas, protocolos ni capas hasta que aparece el segundo caso que las justifica. La estructura emerge con el código; no se diseña hipotéticamente.

**Una carpeta nace con su primer archivo real. Nunca antes.**

## Estructura actual

<!-- EJEMPLO — sustituir por la estructura real del proyecto -->

```
{{APP_NAME}}/
├── App/                                APP SHELL — composición raíz
│   ├── {{APP_NAME}}App.swift           @main, WindowGroup, ModelContainer
│   ├── RootView.swift                  Switch de scene activa según AppRouter
│   └── Routing/
│       └── AppRouter.swift             @Observable con la scene activa
│
├── Scenes/                             PANTALLAS DE NIVEL SUPERIOR
│   ├── Home/
│   │   └── HomeScene.swift             Landing
│   └── Main/
│       ├── MainScene.swift             Pantalla principal (compone features)
│       └── Chrome/                     Marco visual propio de esta scene
│           └── Header.swift
│
├── Features/                           BLOQUES DE PRODUCTO CON DOMINIO PROPIO
│   └── {{FEATURE}}/
│       ├── Models/
│       │   └── {{Modelo}}.swift        @Model SwiftData
│       └── Views/
│           └── {{Vista}}.swift
│
├── Core/                               CROSS-CUTTING — imported POR features
│   ├── Theme/
│   │   └── {{APP_NAME}}UI.swift        Design tokens (colores, radii, spacing)
│   └── Components/
│       └── ...                         Primitivos UI reutilizables
│
└── Assets.xcassets/                    AccentColor, AppIcon
```

## Reglas de dirección de dependencias [INVARIANTE]

```
App  →  Scenes  →  Features  →  Core
```

- **App** conoce a todos. Es el único sitio que instancia servicios concretos y los inyecta.
- **Scenes** componen features, cablean su comunicación y manejan navegación interna. No contienen lógica de dominio ni persistencia.
- **Features** son autocontenidas. Una feature no importa a otra feature — nunca. Cómo se comunican, en la sección siguiente.
- **Core** no importa nada hacia arriba. Solo `SwiftUI`, `Foundation` y cosas de plataforma.

Si una flecha va en dirección contraria, es un *code smell* — refactor.

## Comunicación entre features [INVARIANTE]

"Una feature no importa a otra feature" es la regla que antes se pone a prueba. Hay exactamente **dos mecanismos bendecidos**; la elección depende de la naturaleza de lo comunicado:

**1. Cableado en la Scene — para eventos y acciones efímeras.**
La scene que compone las features es la dueña del flujo: inyecta closures o un `@Observable` de coordinación que las features reciben sin conocerse entre sí.

```swift
// MainScene.swift — la scene cablea; las features no se conocen
FeatureAPanel(onEvent: { event in
    store.append(event)             // store lo posee la scene
})
FeatureBView(store: store)
```

**2. Datos compartidos vía SwiftData — para estado que persiste.**
Si dos features leen/escriben el mismo `@Model`, ese modelo deja de pertenecer a una feature: se promociona a `Core/Models/` y ambas lo consumen desde ahí. SwiftData actúa como bus: una escribe, la otra observa con `@Query`.

**Regla de decisión:** ¿es un evento de UI que muere al consumirse? → cableado en la scene. ¿Es estado que sobrevive a la sesión? → modelo compartido en `Core/Models/`.

**Anti-patterns explícitos:** imports o referencias cruzadas entre features, singletons globales tipo `EventBus.shared`, `NotificationCenter` para dominio propio.

## Qué va en cada carpeta [INVARIANTE]

### `App/`
Composición raíz. Contiene el `@main`, el `ModelContainer` compartido, y la vista raíz que decide qué scene mostrar.

**Subcarpeta `Routing/`:** routers globales, estado de sesión, parseo de deep links. Lo que no pertenece a una scene concreta.

### `Scenes/`
Pantallas completas desde la perspectiva del usuario. Cada scene ensambla features, cablea su comunicación y gestiona su navegación interna.

**Subcarpetas de composición local** (`Chrome/`, `Canvas/`...): bloques visuales sin modelos propios que solo usa esta scene. Viven dentro de la scene, no en `Features/`. Si una segunda scene los necesita, se promocionan: a `Core/Components/` si son primitivos visuales, o a `Features/` si resulta que sí llevan dominio.

Archivos típicos de una scene madura:
- `XScene.swift` — la View raíz con `NavigationStack`.
- `XRouter.swift` — `@Observable` con `path` y sheets presentados.
- `XDestination.swift` — enum de destinos posibles dentro de la scene.

Una scene recién nacida es solo su View raíz; router y destinos aparecen con la navegación interna.

### `Features/`
Bloques de producto con **dominio propio** (modelos, servicios, lógica) y potencialmente reutilizables entre scenes.

**¿Feature o composición de scene?** Test rápido: ¿tiene modelo/dominio propio, o lo usaría otra scene tal cual? → feature. ¿Solo define cómo se ve una scene concreta? → subcarpeta de esa scene. Un header con menús no es una feature; un chat con persistencia, sí.

Cada feature puede crecer en 3 niveles de madurez:

**Nivel 0 — feature simple:**
```
Features/X/
├── Models/          @Model o struct
└── Views/           SwiftUI views
```

**Nivel 1 — aparece un servicio externo:**
```
Features/X/
├── Models/
├── Services/        protocol + implementación (API, SDK externo)
├── ViewModels/      @Observable
└── Views/
```

**Nivel 2 — feature crítica, múltiples backends, tests pesados:**
```
Features/X/
├── Domain/          entidades puras + UseCases + repos (protocolos)
├── Data/            @Model, impl repos, mappers
└── Presentation/    ViewModels + Views
```

**Nivel 2 es la última opción, no una meta.** Solo se aplica cuando los tres detonantes ocurren a la vez (>20 archivos **y** múltiples backends **y** tests pesados), nunca por estética. Y ojo: a diferencia de la extracción a SwiftPM, migrar de Nivel 1 a Nivel 2 **sí implica reescritura real** — entidades duplicadas, mappers, repos. Lo esperable es que ninguna feature llegue a Nivel 2, y eso es señal de salud, no de deuda.

**Cada subcarpeta nace con contenido.** Las vacías no existen.

### `Core/`
Código transversal sin dueño. Lo importan varias features o scenes.

Subcarpetas previstas (aparecen cuando se llenan):
- `Theme/` — design tokens.
- `Components/` — primitivos UI reutilizables.
- `Models/` — `@Model` compartidos por 2+ features (cuando aparezca el primero).
- `Networking/` — HTTP client y abstracciones (cuando aparezca la 1ª request).
- `Persistence/` — helpers de SwiftData y mappers (cuando haga falta).
- `Analytics/` — tracking abstraction (cuando se decida el provider).
- `Foundation/` — extensiones de `Date`, `String`, `Logger` setup.

## Reglas para dependencias externas (SDKs) [INVARIANTE]

1. **Añadir vía Swift Package Manager** (File → Add Package Dependencies en Xcode).
2. **`import` confinado a una sola capa.** Nunca en Views, Models ni ViewModels. Solo en `Services/` de la feature que la usa, o en un wrapper dentro de `Core/`.
3. **Si dos features la necesitan**, sube el wrapper a `Core/` con un nombre propio de la app (ej: `AsyncRemoteImage` envolviendo `Kingfisher`).
4. **Configuración global** (API keys, endpoints) vive en `App/Configuration/` cuando aparezca. Los secretos nunca al repo.

Ejemplo correcto:
```swift
// ✅ Features/Auth/Services/SupabaseAuthService.swift
import Supabase

final class SupabaseAuthService: AuthService { ... }
```

Ejemplo incorrecto:
```swift
// ❌ Features/Auth/Views/SignInView.swift
import Supabase                          // acopla UI al SDK
```

## Modelo de crecimiento

<!-- EJEMPLO — ajustar al destino plausible del proyecto -->

El destino al que evolucionamos (no el punto de partida):

```
{{APP_NAME}}/
├── App/
│   ├── {{APP_NAME}}App.swift
│   ├── AppDependencies.swift           (cuando llegue el 1er servicio)
│   ├── PersistenceStack.swift          (cuando el Schema crezca)
│   ├── RootView.swift
│   └── Routing/
│       ├── AppRouter.swift
│       ├── AuthState.swift             (con Auth)
│       └── DeepLink.swift              (con URLs entrantes)
├── Core/
│   ├── Theme/
│   ├── Components/
│   ├── Models/                         (1er @Model compartido entre features)
│   ├── Networking/                     (1ª request HTTP)
│   ├── Persistence/                    (helpers de SwiftData)
│   ├── Analytics/                      (1er provider)
│   └── Foundation/                     (1ª extensión reutilizable)
├── Features/
│   ├── Auth/                           (implementar login)
│   └── {{FEATURE}}/
│       ├── Models/
│       ├── Services/
│       ├── ViewModels/
│       └── Views/
├── Scenes/
│   ├── Auth/                           AuthScene + AuthRouter + AuthDestination
│   ├── Home/
│   └── {{SCENE}}/                      + Router + Destination + composición local
├── Resources/                          (fuentes, localizables, seeds)
│   ├── Assets.xcassets
│   ├── Fonts/
│   └── Localization/
└── Tests/                              (1er test real)
    └── {{FEATURE}}Tests/
```

## Disparadores de evolución [INVARIANTE]

Cuándo añadir cada carpeta o pieza:

| Carpeta / archivo | Detonante |
|---|---|
| `App/AppDependencies.swift` | 1er servicio con protocolo + impl real |
| `App/PersistenceStack.swift` | Schema de SwiftData con >3 `@Model` |
| `App/Routing/AuthState.swift` | Integración de Auth |
| `App/Routing/DeepLink.swift` | Soporte de URLs entrantes |
| `Features/Auth/` | Decisión de provider (Supabase, Firebase, custom) |
| `Features/*/Services/` | 1ª llamada a API externa en la feature |
| `Features/*/ViewModels/` | View pasa de ~100 LOC o lógica no trivial |
| `Features/*/Domain/` + `Data/` | >20 archivos **y** múltiples backends **y** tests pesados (los tres a la vez) |
| `Scenes/*/XRouter.swift` | Scene con >1 sub-vista navegable |
| `Core/Models/` | 2ª feature necesita leer/escribir el mismo `@Model` |
| Promover bloque local de scene | 2ª scene necesita el mismo bloque visual → `Core/Components/` o `Features/` |
| `Core/Networking/` | 1ª HTTP request |
| `Core/Analytics/` | Decisión del provider de tracking |
| `Core/Foundation/` | 1ª extensión reutilizable entre features |
| `Resources/Fonts/` | Añadir una fuente custom |
| `Resources/Localization/` | Soporte multiidioma |
| `Tests/` | 1er test (o setup de CI) |
| **SwiftPM packages locales** | Build >15s, o 2º developer, o extracción a widget/watch/macOS target |

## Heurísticas operativas [INVARIANTE]

- **Si dudas dónde va un archivo nuevo**, pregúntate: ¿lo usa solo una feature? → dentro de esa feature. ¿Dos o más? → `Core/`.
- **Si dudas si algo es feature o composición de scene:** ¿tiene modelo/dominio propio o lo usaría otra scene? → `Features/`. ¿Solo define cómo se ve esta scene? → subcarpeta de la scene.
- **Si dos features "necesitan hablar"**, la respuesta nunca es un import: o la scene cablea el evento, o el dato compartido sube a `Core/Models/`.
- **Si una subcarpeta dentro de una feature crece a >5 archivos**, divídela.
- **Si una feature pasa de 15 archivos totales**, evalúa promover a `Domain/Data/Presentation` (recordando que es última opción).
- **Si el archivo `{{APP_NAME}}App.swift` empieza a mezclar setup + navegación + DI**, extrae a `PersistenceStack.swift` / `AppDependencies.swift`.
- **Si hay duplicación visual entre features o scenes** (paneles, botones, etc.), extrae a `Core/Components/`.

## Tests [INVARIANTE]

Cuando lleguen:

- **Tests de `Services/`** (con mocks de repositorios) — alto valor.
- **Tests de `Domain/UseCases/`** (cuando existan) — alto valor.
- **Tests de Views** — no compensan. Frágiles y cubren poco.
- **Snapshot tests** — solo para los primitivos de `Core/Components/` si llegan a pagar el coste.

## Extracción a SwiftPM (cuando llegue) [INVARIANTE]

Esta estructura mapea 1:1 a Swift Packages locales:

```
{{APP_NAME}}/
├── Packages/
│   ├── {{APP_NAME}}Core/    desde Core/
│   ├── {{APP_NAME}}X/       desde Features/X/
│   └── ...
├── App/                     solo composition root
└── ...
```

La migración es **mecánica, sin reescribir código** — solo añadir `Package.swift` y marcar lo público con `public`.

**El único punto no mecánico: el `Schema`.** Los `@Model` viven en las features, pero el `ModelContainer` los agrega en `App/`. Al extraer paquetes, `App` importará todos los paquetes que contengan modelos para montar el `Schema`. Es correcto — App es la composition root y conoce a todos — pero conviene tenerlo presente: es el único sitio donde la extracción obliga a tocar imports en cadena. Los modelos compartidos de `Core/Models/` viajan con `{{APP_NAME}}Core`, lo que simplifica esa agregación.

## Resumen [INVARIANTE]

1. **Pragmático antes que dogmático.** Clean Architecture, MVVM-C, etc. son herramientas, no metas.
2. **Crecer por dolor real, no por ritual.** Cada carpeta aparece cuando tiene contenido que la justifica. Nivel 2 es última opción.
3. **Límites claros desde el día 1** (App → Scenes → Features → Core). Mantener la dirección evita la entropía.
4. **Las features no se hablan directamente.** O la scene cablea el evento, o el dato compartido vive en `Core/Models/`.
5. **Preparada para escalar a SwiftPM** sin reescribir (salvo la agregación del Schema en App), cuando el compile time o el tamaño de equipo lo exija.
