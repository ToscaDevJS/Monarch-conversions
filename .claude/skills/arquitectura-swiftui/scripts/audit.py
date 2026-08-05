#!/usr/bin/env python3
"""
Auditoría de arquitectura vertical slicing para proyectos SwiftUI.

Uso:
    python3 audit.py /ruta/al/proyecto

Verifica los invariantes (App → Scenes → Features → Core):
  ❌ Referencias cruzadas entre features
  ❌ Core referenciando tipos de Features/Scenes/App
  ❌ Features referenciando tipos de Scenes/App
  ❌ Scenes referenciando tipos de App
  ❌ Imports de SDKs de terceros en Views/Models/ViewModels
  ⚠️  Carpetas vacías
  ℹ️  Disparadores de evolución alcanzados (feature >15 archivos,
      subcarpeta >5, View >100 LOC, >3 @Model)

Heurístico (regex, sin compilador): confirmar los hallazgos leyendo el código.
Código de salida 1 si hay violaciones — apto para CI.
"""

from __future__ import annotations

import re
import sys
from collections import defaultdict
from pathlib import Path

LAYERS = ("App", "Scenes", "Features", "Core")

# Frameworks de Apple / sistema cuyo import NO cuenta como SDK de terceros.
APPLE_FRAMEWORKS = {
    "Swift", "SwiftUI", "SwiftData", "Foundation", "Combine", "Observation",
    "UIKit", "AppKit", "WatchKit", "WidgetKit", "AVFoundation", "AVKit",
    "CoreData", "CoreGraphics", "CoreImage", "CoreLocation", "CoreML",
    "CoreMotion", "CoreText", "CoreHaptics", "CoreBluetooth", "CoreNFC",
    "CoreSpotlight", "CoreTransferable", "CloudKit", "MapKit", "PhotosUI",
    "Photos", "StoreKit", "HealthKit", "HomeKit", "GameKit", "SpriteKit",
    "SceneKit", "RealityKit", "ARKit", "Vision", "NaturalLanguage", "Speech",
    "UserNotifications", "BackgroundTasks", "Network", "Security",
    "LocalAuthentication", "AuthenticationServices", "SafariServices",
    "WebKit", "MessageUI", "EventKit", "EventKitUI", "Contacts", "ContactsUI",
    "PDFKit", "QuickLook", "UniformTypeIdentifiers", "OSLog", "os",
    "XCTest", "Testing", "Charts", "TipKit", "AppIntents", "ActivityKit",
    "GroupActivities", "Metal", "MetalKit", "Accelerate", "simd", "Dispatch",
    "CryptoKit", "WeatherKit", "MusicKit", "ShazamKit", "LinkPresentation",
    "Intents", "IntentsUI", "CarPlay", "SwiftUICore", "PlaygroundSupport",
}

TYPE_DECL_RE = re.compile(
    r"\b(?:struct|class|enum|actor|protocol)\s+([A-Z][A-Za-z0-9_]*)"
)
IMPORT_RE = re.compile(
    r"^\s*(?:@[\w()]+\s+)?import\s+(?:struct\s+|class\s+|enum\s+|func\s+)?"
    r"([A-Za-z_][A-Za-z0-9_]*)",
    re.MULTILINE,
)
MODEL_ATTR_RE = re.compile(r"@Model\b")


def strip_noise(source: str) -> str:
    """Elimina (a grosso modo) comentarios y strings para reducir falsos positivos."""
    source = re.sub(r'"""[\s\S]*?"""', '""', source)          # strings multilínea
    source = re.sub(r'"(?:\\.|[^"\\\n])*"', '""', source)      # strings simples
    source = re.sub(r"/\*[\s\S]*?\*/", "", source)             # /* ... */
    source = re.sub(r"//[^\n]*", "", source)                   # // ...
    return source


def find_arch_root(start: Path) -> Path | None:
    """Busca (hasta 3 niveles) el directorio que contiene Features/ y otra capa."""
    candidates = [start]
    for depth in range(3):
        next_level = []
        for cand in candidates:
            if not cand.is_dir():
                continue
            names = {p.name for p in cand.iterdir() if p.is_dir()}
            if "Features" in names and names & {"App", "Scenes", "Core"}:
                return cand
            next_level.extend(
                p for p in cand.iterdir()
                if p.is_dir() and not p.name.startswith(".")
                and p.name not in {"build", "DerivedData", "Pods", ".git"}
            )
        candidates = next_level
    return None


def swift_files(root: Path):
    return sorted(p for p in root.rglob("*.swift") if p.is_file())


def layer_of(path: Path, arch_root: Path) -> tuple[str, str]:
    """Devuelve (capa, unidad). La unidad es la feature/scene concreta, o ''."""
    rel = path.relative_to(arch_root)
    parts = rel.parts
    if not parts or parts[0] not in LAYERS:
        return ("", "")
    layer = parts[0]
    unit = parts[1] if layer in ("Features", "Scenes") and len(parts) > 2 else ""
    return (layer, unit)


def main() -> int:
    if len(sys.argv) != 2:
        print(__doc__)
        return 2

    start = Path(sys.argv[1]).resolve()
    if not start.exists():
        print(f"❌ La ruta no existe: {start}")
        return 2

    arch_root = find_arch_root(start)
    if arch_root is None:
        print("❌ No se encontró una raíz con Features/ + (App/|Scenes/|Core/) "
              f"bajo {start}.")
        return 2

    print(f"🔍 Auditando: {arch_root}\n")

    violations: list[str] = []
    warnings: list[str] = []
    triggers: list[str] = []

    # ---- Recolección -------------------------------------------------------
    files: list[Path] = []
    for layer in LAYERS:
        layer_dir = arch_root / layer
        if layer_dir.is_dir():
            files.extend(swift_files(layer_dir))

    sources: dict[Path, str] = {}
    stripped: dict[Path, str] = {}
    for f in files:
        try:
            text = f.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        sources[f] = text
        stripped[f] = strip_noise(text)

    # Tipos declarados → (capa, unidad). Los nombres ambiguos se descartan.
    decl_site: dict[str, tuple[str, str]] = {}
    ambiguous: set[str] = set()
    for f, text in stripped.items():
        layer, unit = layer_of(f, arch_root)
        for name in TYPE_DECL_RE.findall(text):
            if len(name) < 3:
                continue
            site = (layer, unit)
            if name in decl_site and decl_site[name] != site:
                ambiguous.add(name)
            else:
                decl_site[name] = site
    for name in ambiguous:
        decl_site.pop(name, None)

    rank = {"Core": 0, "Features": 1, "Scenes": 2, "App": 3}

    # ---- 1–4. Dirección de dependencias y referencias cruzadas ------------
    for f, text in stripped.items():
        layer, unit = layer_of(f, arch_root)
        if not layer:
            continue
        rel = f.relative_to(arch_root)
        for name, (t_layer, t_unit) in decl_site.items():
            if (t_layer, t_unit) == (layer, unit):
                continue
            if not re.search(rf"\b{re.escape(name)}\b", text):
                continue
            if layer == "Features" and t_layer == "Features" and unit != t_unit:
                violations.append(
                    f"Referencia cruzada entre features: {rel} usa `{name}` "
                    f"(declarado en Features/{t_unit}). "
                    f"→ cablear en la scene o promover a Core/Models/."
                )
            elif rank.get(layer, 9) < rank.get(t_layer, -1):
                violations.append(
                    f"Dependencia en dirección contraria: {rel} ({layer}) usa "
                    f"`{name}` declarado en {t_layer}"
                    f"{'/' + t_unit if t_unit else ''}. "
                    f"→ invertir: {t_layer} puede conocer a {layer}, no al revés."
                )

    # ---- 5. Imports de SDKs de terceros en capas prohibidas ----------------
    for f, text in sources.items():
        layer, unit = layer_of(f, arch_root)
        rel = f.relative_to(arch_root)
        posix = rel.as_posix()
        for module in IMPORT_RE.findall(text):
            if module in APPLE_FRAMEWORKS:
                continue
            in_services = "/Services/" in f"/{posix}"
            in_core_wrapper = (
                layer == "Core"
                and not any(s in posix for s in ("Core/Components/", "Core/Theme/"))
            )
            if in_services or in_core_wrapper:
                continue
            if layer == "App":
                warnings.append(
                    f"Import de terceros en App: {rel} importa `{module}`. "
                    f"Revisar: idealmente App solo instancia servicios que ya "
                    f"envuelven el SDK."
                )
            else:
                violations.append(
                    f"SDK fuera de sitio: {rel} importa `{module}`. "
                    f"→ mover a Features/X/Services/ (con protocolo) o a un "
                    f"wrapper en Core/."
                )

    # ---- 6. Carpetas vacías ------------------------------------------------
    for layer in LAYERS:
        layer_dir = arch_root / layer
        if not layer_dir.is_dir():
            continue
        for d in sorted(p for p in layer_dir.rglob("*") if p.is_dir()):
            if not any(d.iterdir()):
                warnings.append(
                    f"Carpeta vacía: {d.relative_to(arch_root)}/ — "
                    f"una carpeta nace con su primer archivo real."
                )

    # ---- 7. Disparadores de evolución -------------------------------------
    per_feature: dict[str, list[Path]] = defaultdict(list)
    for f in files:
        layer, unit = layer_of(f, arch_root)
        if layer == "Features" and unit:
            per_feature[unit].append(f)

    for feature, flist in sorted(per_feature.items()):
        if len(flist) > 15:
            triggers.append(
                f"Features/{feature} tiene {len(flist)} archivos (>15) — "
                f"evaluar Domain/Data/Presentation SOLO si además hay múltiples "
                f"backends y tests pesados."
            )
        by_sub: dict[str, int] = defaultdict(int)
        for f in flist:
            sub = f.relative_to(arch_root / "Features" / feature).parts
            if len(sub) > 1:
                by_sub[sub[0]] += 1
        for sub, n in sorted(by_sub.items()):
            if n > 5:
                triggers.append(
                    f"Features/{feature}/{sub}/ tiene {n} archivos (>5) — dividir."
                )

    model_files = [f for f, t in stripped.items() if MODEL_ATTR_RE.search(t)]
    n_models = sum(len(MODEL_ATTR_RE.findall(stripped[f])) for f in model_files)
    if n_models > 3:
        triggers.append(
            f"Hay {n_models} @Model en el proyecto (>3) — "
            f"extraer App/PersistenceStack.swift."
        )

    for f, text in sources.items():
        layer, _ = layer_of(f, arch_root)
        posix = f.relative_to(arch_root).as_posix()
        is_view_file = "/Views/" in f"/{posix}" or layer == "Scenes"
        if is_view_file:
            loc = text.count("\n") + 1
            if loc > 100:
                triggers.append(
                    f"{posix} tiene {loc} líneas (>100) — "
                    f"considerar extraer ViewModel o dividir la vista."
                )

    # ---- Informe -----------------------------------------------------------
    def section(title: str, icon: str, items: list[str]) -> None:
        print(f"{icon} {title}: {len(items)}")
        for item in items:
            print(f"   {icon} {item}")
        print()

    section("Violaciones de invariantes", "❌", violations)
    section("Avisos", "⚠️", warnings)
    section("Disparadores de evolución alcanzados", "ℹ️", triggers)

    if not violations and not warnings and not triggers:
        print("✅ Estructura limpia: sin violaciones ni disparadores pendientes.")
    elif not violations:
        print("✅ Sin violaciones de invariantes.")

    return 1 if violations else 0


if __name__ == "__main__":
    sys.exit(main())
