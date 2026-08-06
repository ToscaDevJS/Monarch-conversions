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
│   ├── RootView.swift                  Contenedor raíz y switch de escenas
│   └── Routing/
│       └── AppRouter.swift             Gestor de navegación activa (AppTab)
│
├── Scenes/                             PANTALLAS DE NIVEL SUPERIOR
│   ├── Dashboard/
│   │   └── DashboardScene.swift        Dashboard principal de Monarch (STUDIO)
│   ├── Convert/
│   │   └── ConvertScene.swift          Vista de nueva conversión batch y Squoosh inspector (CONVERT)
│   └── Settings/
│       └── SettingsScene.swift         Pantalla de preferencias del workspace (SETTINGS)
│
├── Features/                           BLOQUES DE PRODUCTO CON DOMINIO PROPIO
│   ├── Conversions/
│   │   ├── Models/
│   │   │   ├── ConversionRecord.swift  @Model SwiftData para historial de conversiones
│   │   │   └── BatchQueueItem.swift    Modelo de items para la cola de conversión batch
│   │   ├── Services/
│   │   │   └── ConversionSeedService.swift  Servicio de datos iniciales
│   │   └── Views/
│   │       ├── TopNavHeaderView.swift        Barra de navegación superior (STUDIO, CONVERT, SETTINGS)
│   │       ├── GlobalSearchBarView.swift     Buscador global con shortcut ⌘K
│   │       ├── MetricsHeaderView.swift       Barra de métricas y sparkline
│   │       ├── ConversionsTableView.swift    Tabla interactiva de conversiones con selección
│   │       ├── ConversionDetailModalView.swift Modal detallado de conversión (Paper 4S-0)
│   │       ├── ConvertHeadingView.swift      Encabezado de la página de nueva conversión
│   │       ├── BatchDropzoneView.swift       Zona de arrastre e importación de archivos
│   │       ├── BatchQueueView.swift          Lista de la cola de archivos batch
│   │       ├── BatchQueueItemRow.swift       Fila individual de item en la cola
│   │       ├── SquooshInspectorView.swift    Inspector visual de calidad 1:1 con split slider
│   │       ├── OutputSettingsView.swift      Panel de ajustes de salida y estimado de ahorro
│   │       ├── TelemetryFooterView.swift     Barra de telemetría y métricas de nodo
│   │       └── StatusFooterView.swift        Barra de estado e indicadores de sistema
│   │
│   └── Settings/
│       ├── Models/
│       │   └── UserSettings.swift        @Observable para estado de preferencias del usuario
│       └── Views/
│           ├── SettingsHeadingView.swift     Encabezado de ajustes del workspace
│           ├── SettingsSidebarView.swift     Navegación lateral de secciones (GENERAL / WORKSPACE)
│           ├── AppearancePanelView.swift     Panel de esquemas de color y previsualizaciones
│           ├── LanguagePanelView.swift       Panel de idioma de interfaz y formato de fecha
│           └── WorkflowPanelView.swift       Panel de ajuste fino de notificaciones y flujo
│
├── Core/                               CROSS-CUTTING — imported POR features
│   ├── Navigation/
│   │   └── AppTab.swift                Enum de navegación principal (STUDIO, CONVERT, SETTINGS)
│   └── Theme/
│       └── MonarchUI.swift             Tokens de color y tipografía del sistema de diseño Paper
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
