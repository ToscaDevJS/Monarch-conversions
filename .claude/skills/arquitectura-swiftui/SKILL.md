---
name: arquitectura-swiftui
description: Arquitectura de vertical slicing pragmático (App → Scenes → Features → Core) para apps Apple con SwiftUI. Usa esta skill SIEMPRE que el usuario empiece una app o proyecto nuevo de iOS/macOS/watchOS/visionOS; pida crear o añadir una feature, pantalla, scene, servicio, modelo, ViewModel o componente a una app SwiftUI; pregunte dónde colocar un archivo o cómo organizar carpetas; integre un SDK externo (Supabase, Firebase, etc.) en una app Swift; o pida revisar, refactorizar o auditar la estructura de un proyecto Swift. Actívala también cuando mencione "arquitectura", "estructura del proyecto", "scaffolding" o "vertical slicing" en contexto Apple, aunque no pida la skill por su nombre.
---

# Arquitectura SwiftUI — vertical slicing pragmático

Sistema de organización de código para apps Apple. Se aplica igual a cualquier nicho: lo que cambia por proyecto son los **nombres** (qué scenes y features existen); lo que nunca cambia son los **invariantes**.

## Invariantes (no negociables)

1. **Dirección de dependencias:** `App → Scenes → Features → Core`. Nunca al revés.
2. **Una feature no referencia a otra feature.** Comunicación solo por dos vías: (a) cableado en la scene que las compone (closures o `@Observable` inyectado) para eventos efímeros, o (b) `@Model` compartido promovido a `Core/Models/` para estado persistente. Prohibido: `EventBus.shared`, `NotificationCenter` para dominio propio, referencias cruzadas.
3. **SDKs externos confinados:** el `import` de terceros solo vive en `Features/X/Services/` o en un wrapper con nombre propio dentro de `Core/`. Nunca en Views, Models ni ViewModels.
4. **Una carpeta nace con su primer archivo real.** Jamás carpetas vacías "para luego".
5. **Feature = dominio propio** (modelos, servicios, lógica; potencialmente reutilizable entre scenes). La composición visual que solo usa una scene vive DENTRO de esa scene, no en `Features/`.
6. **Crecer por dolor, no por ritual.** Antes de crear una carpeta o capa nueva, verifica su disparador en la tabla de `references/architecture-template.md`.

## Modo 1 — Bootstrap de proyecto nuevo

Cuando el usuario empieza una app:

1. **Deriva del nicho** las scenes iniciales (pantallas de nivel superior) y las features con dominio propio. Ejemplo: app de recetas → features `Recipes` y `MealPlan`; scenes `Home` y `Cook`. Pregunta al usuario solo si el nicho no da para inferirlo.
2. **Arranca mínimo:** todas las features en Nivel 0 (`Models/` + `Views/`), scenes de un solo archivo, `Core/Theme/` con los design tokens. Nada de `Services/`, `ViewModels/`, routers ni `Domain/` el día 1.
3. **Lee `references/architecture-template.md` completo** y genera el `ARCHITECTURE.md` del proyecto: sustituye `{{APP_NAME}}`, reemplaza los ejemplos por las scenes/features reales del proyecto, ajusta la sección "Estructura actual" a lo que de verdad se creó, y conserva íntegras las secciones marcadas `[INVARIANTE]`.
4. Si el proyecto usa Claude Code, añade al `CLAUDE.md` del repo: "La estructura sigue `ARCHITECTURE.md` — consúltalo antes de crear archivos o carpetas."
5. Ofrece copiar `scripts/audit.py` al repo (p. ej. en `Tools/`) para verificación local o en CI.

## Modo 2 — Colocación de código nuevo

Ante "crea X" o "¿dónde va X?" en un proyecto existente, aplica este árbol:

1. **¿Es un `@Model`?** Lo usa una sola feature → `Features/X/Models/`. Lo usan 2+ features → `Core/Models/` (y actualiza el `ARCHITECTURE.md` del proyecto).
2. **¿Es una View?**
   - Tiene dominio propio o es reutilizable entre scenes → `Features/X/Views/`.
   - Solo define cómo se ve UNA scene (headers, menús, paneles del marco) → subcarpeta de esa scene (`Scenes/Editor/Chrome/`...).
   - Primitivo visual sin dominio usado por 2+ sitios → `Core/Components/`.
3. **¿Es un servicio o integra un SDK?** → `Features/X/Services/` con protocolo + implementación. El `import` del SDK vive SOLO ahí. Si una 2ª feature necesita el mismo SDK → wrapper con nombre propio de la app en `Core/`.
4. **¿Es un ViewModel?** Solo si la View supera ~100 LOC o acumula lógica no trivial → `Features/X/ViewModels/`. Si no, todavía no toca.
5. **¿Es una extensión o helper?** Lo usan 2+ features → `Core/Foundation/`. Uno solo → junto a su único consumidor.
6. **¿Es navegación?** Router/Destination de una scene → `Scenes/X/` cuando haya >1 sub-vista navegable. Estado global de sesión o deep links → `App/Routing/`.

Al crear el archivo, verifica que no rompe los invariantes 1–3. Si el usuario pide algo que los rompe (p. ej. `import Supabase` en una View), no lo hagas en silencio: explica la regla en una frase y ofrece la alternativa correcta.

Ante la duda entre dos ubicaciones, consulta las heurísticas y la tabla de disparadores del template — y si sigue empatado, elige la opción que cree MENOS estructura.

## Modo 3 — Auditoría de un proyecto existente

1. Ejecuta `python3 scripts/audit.py <ruta-del-proyecto>`. Detecta: referencias cruzadas entre features, Core referenciando capas superiores, Features referenciando Scenes/App, imports de SDKs en capas prohibidas, carpetas vacías, y disparadores de evolución alcanzados (feature >15 archivos, subcarpeta >5 archivos, Views >100 LOC, >3 `@Model`).
2. El script es heurístico (regex, sin compilador): **confirma cada hallazgo leyendo el código** antes de afirmarlo, y revisa a mano lo que el script no puede ver (semántica de dominio, features que deberían fusionarse, composición de scene disfrazada de feature).
3. Reporta en dos niveles: **violaciones** (rompen invariantes — propón el refactor concreto) y **disparadores alcanzados** (evolución pendiente — propón el paso exacto de la tabla). No propongas Nivel 2 (`Domain/Data/Presentation`) salvo que se cumplan sus TRES detonantes a la vez.

## Cuándo leer el reference

Lee `references/architecture-template.md` completo en Modo 1 (bootstrap). En Modos 2–3, consúltalo puntualmente cuando necesites la tabla de disparadores, las heurísticas operativas o los niveles de madurez. No lo cargues para decisiones triviales que los invariantes de arriba ya resuelven.
