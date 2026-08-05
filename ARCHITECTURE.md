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
│   └── RootView.swift                  Contenedor raíz y montaje de DashboardScene
│
├── Scenes/                             PANTALLAS DE NIVEL SUPERIOR
│   └── Dashboard/
│       └── DashboardScene.swift        Dashboard principal de Monarch image tools
│
├── Features/                           BLOQUES DE PRODUCTO CON DOMINIO PROPIO
│   └── Conversions/
│       ├── Models/
│       │   └── ConversionRecord.swift  @Model SwiftData para historial de conversiones
│       ├── Services/
│       │   └── ConversionSeedService.swift  Servicio de datos iniciales
│       └── Views/
│           ├── TopNavHeaderView.swift        Barra de navegación principal
│           ├── GlobalSearchBarView.swift     Buscador global con shortcut ⌘K
│           ├── MetricsHeaderView.swift       Barra de métricas y sparkline
│           ├── ConversionsTableView.swift    Tabla interactiva de conversiones
│           ├── TelemetryFooterView.swift     Barra de telemetría y métricas de nodo
│           └── StatusFooterView.swift        Barra de estado de archivo e indicadores
│
├── Core/                               CROSS-CUTTING — imported POR features
│   └── Theme/
│       └── MonarchUI.swift             Design tokens del sistema de diseño Paper
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

If a direction points backward, it's a code smell — refactor.

## Reglas para dependencias externas (SDKs) [INVARIANTE]

1. **Añadir vía Swift Package Manager**.
2. **`import` confinado a una sola capa** (`Services/` en Features o wrapper en `Core/`).
3. **Nunca en Views, Models ni ViewModels**.
