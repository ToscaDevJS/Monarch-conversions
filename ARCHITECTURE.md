# Arquitectura de Monarch-conversions

Guía de la organización del código y el modelo de crecimiento del proyecto.

## Filosofía [INVARIANTE]

**Vertical slicing pragmático.** Organizamos el código por *qué hace para el usuario* (features), no por *qué tipo de objeto es* (Models/, ViewModels/, Views/ a nivel raíz). Cada feature contiene lo que necesita y crece con la estructura que pide el problema, no con una plantilla impuesta.

**Sin abstracción prematura.** No creamos carpetas, protocolos ni capas hasta que aparece el segundo caso que las justifica. La estructura emerge con el código; no se diseña hipotéticamente.

**Una carpeta nace con su primer archivo real. Nunca antes.**

## Estructura actual

```
Monarch-conversions/
├── App/                                APP SHELL — composición raíz
│   ├── Monarch_conversionsApp.swift    @main, WindowGroup, ModelContainer
│   └── RootView.swift                  Contenedor raíz y routing de scenes
│
├── Scenes/                             PANTALLAS DE NIVEL SUPERIOR
│   └── Items/
│       └── ItemsScene.swift            Scene principal de gestión de items
│
├── Features/                           BLOQUES DE PRODUCTO CON DOMINIO PROPIO
│   └── Items/
│       ├── Models/
│       │   └── Item.swift              @Model SwiftData
│       └── Views/
│           └── ItemListView.swift      Vista de listado y acciones de items
│
├── Core/                               CROSS-CUTTING — imported POR features
│   └── Theme/
│       └── MonarchUI.swift             Design tokens (espaciados, radios)
│
└── Assets.xcassets/                    AccentColor, AppIcon
```

## Reglas de dirección de dependencias [INVARIANTE]

```
App  →  Scenes  →  Features  →  Core
```

- **App** conoce a todos. Es el único sitio que instancia servicios concretos y los inyecta.
- **Scenes** componen features, cablean su comunicación y manejan navegación interna. No contienen lógica de dominio ni persistencia.
- **Features** son autocontenidas. Una feature no importa a otra feature — nunca.
- **Core** no importa nada hacia arriba. Solo `SwiftUI`, `Foundation` y cosas de plataforma.

Si una flecha va en dirección contraria, es un *code smell* — refactor.

## Comunicación entre features [INVARIANTE]

Hay exactamente **dos mecanismos bendecidos**:

1. **Cableado en la Scene — para eventos y acciones efímeras.**
La scene inyecta closures o un `@Observable` de coordinación.

2. **Datos compartidos vía SwiftData — para estado que persiste.**
Se promociona el `@Model` a `Core/Models/` y ambas features lo consumen desde ahí.

## Qué va en cada carpeta [INVARIANTE]

### `App/`
Composición raíz, `@main`, `ModelContainer` compartido y vista raíz.

### `Scenes/`
Pantallas completas desde la perspectiva del usuario.

### `Features/`
Bloques de producto con dominio propio.

### `Core/`
Código transversal sin dueño (tokens UI, modelos compartidos, networking).

## Reglas para dependencias externas (SDKs) [INVARIANTE]

1. **Añadir vía Swift Package Manager**.
2. **`import` confinado a una sola capa** (`Services/` en Features o wrapper en `Core/`).
3. **Nunca en Views, Models ni ViewModels**.

## Disparadores de evolución [INVARIANTE]

| Carpeta / archivo | Detonante |
|---|---|
| `App/AppDependencies.swift` | 1er servicio con protocolo + impl real |
| `App/PersistenceStack.swift` | Schema de SwiftData con >3 `@Model` |
| `Features/*/Services/` | 1ª llamada a API externa en la feature |
| `Features/*/ViewModels/` | View pasa de ~100 LOC o lógica no trivial |
| `Scenes/*/XRouter.swift` | Scene con >1 sub-vista navegable |
| `Core/Models/` | 2ª feature necesita leer/escribir el mismo `@Model` |
