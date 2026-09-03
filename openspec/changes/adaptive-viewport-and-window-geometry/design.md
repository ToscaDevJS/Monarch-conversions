# Design: Adaptive Viewport Geometry, Vertical Overflow & Window Expansion

## Context

The Monarch Paper design system specifies geometric constants for horizontal alignment (`minWindowWidth: 1180`), but vertical dimensions were previously unverified. At runtime, minimum window constraints (`minWindowHeight: 600`) fail to accommodate `ConvertScene`, which requires ~868pt–904pt of vertical clearance. Concurrently, viewports on wide desktop displays (e.g. 2560×1440) exhibit unbalanced negative space due to rigid left-alignment in `SettingsScene` and infinite horizontal stretch of destination boxes in `ConvertScene`.

## Arithmetic Proof of Vertical Invariant Failure

### Breakdown of Vertical Footprint in `ConvertScene`

| Component / Layer | Natural Height | Spacing / Inset | Cumulative Height |
|---|---|---|---|
| Scene Outer Padding (Top) | - | 28pt | 28pt |
| `TopNavHeaderView` | 32pt + 18pt bottom padding | - | 78pt |
| `ConvertHeadingView` | ~58pt text content | 28pt top + 20pt bottom | 184pt |
| Column Top Gap | - | 24pt | 208pt |
| **Columns (Left / Right Max)** | | | |
| *Left Column (Populated)*: | | | |
| - `BatchDropzoneView` | 180pt | - | - |
| - Inter-card Spacing | 20pt | - | - |
| - `BatchQueueView` (Header + Divider) | 18pt | 12pt inner | - |
| - `BatchQueueView` Scroll Container | 340pt (maxHeight) | - | - |
| *Left Column Subtotal* | **570pt** | | - |
| *Right Column (Populated)*: | | | |
| - `SquooshInspectorView` (Header + Split) | 40pt + 280pt = 320pt | - | - |
| - Inter-card Spacing | 20pt | - | - |
| - `OutputSettingsView` (Compact / Wide) | 186pt (wide) / 266pt (compact) | - | - |
| *Right Column Subtotal* | **526pt – 606pt** | | - |
| Column Height (Max of Left and Right) | **570pt – 606pt** | - | 778pt – 814pt |
| Scene Outer Padding (Bottom) | - | 28pt | 806pt – 842pt |
| `BatchStatusFooterView` | 38pt (pinned) | - | **844pt – 880pt** |

**Observation**: Even when the batch queue is empty (0 items, queue collapsed to 18pt header), the Right Column requires 526pt, yielding a minimal required height of **800pt–824pt**.

**Deficit at `minWindowHeight: 600`**:
$$600\text{pt} - 868\text{pt} = -268\text{pt}$$
Between 224pt and 304pt of content is cut off at the bottom of the window without a vertical scrollview.

---

## Architectural Decisions

### ADR 1: Dual Protection for Vertical Layout (Scroll Safety + Realistic Floor)
- **Decision**: 
  1. Wrap the column contents of `ConvertScene` in a vertical `ScrollView` with `.scrollBounceBehavior(.basedOnSize)`.
  2. Dock `TopNavHeaderView` at the top and `BatchStatusFooterView` at the bottom outside the scrollable body to preserve persistent navigation and conversion progress monitoring.
  3. Increase `MonarchUI.Layout.minWindowHeight` from 600pt to 700pt (ensuring usability on 13" MacBooks, whose screen height is typically ~800–900pt, minus ~100pt for menu bar and dock).
- **Rationale**: Setting `minWindowHeight` to 900pt would break small laptop screens. Conversely, keeping it at 600pt without a scrollview truncates actionable UI. The combination of a 700pt floor + a vertical scrollview provides guaranteed accessibility across all displays.

### ADR 2: Wide-Display Responsive Clamping and Centering
- **Decision**:
  1. In `SettingsScene`, wrap the sidebar and detail area inside an `HStack` clamped to a maximum container width (`maxContainerWidth: 1280pt`) and centered horizontally with flexible margins (`Spacer()`).
  2. In `ConvertScene`, introduce `Layout.Convert.rightColumnMax: 860pt` or distribute extra space with bounded ratios, preventing `destinationBox` from stretching infinitely across 2000+ pixels.
  3. In `SquooshInspectorView`, clamp split-view width or scale preview images within an aspect-ratio-preserving container.
- **Rationale**: Human eye saccades degrade when text and buttons stretch beyond 1200–1400pt. Keeping controls proportionally bounded creates a focused, professional workstation feel on 4K/5K displays.

### ADR 3: Nested Scroll Conflict Mitigation
- **Decision**: In `ConvertScene`, when the outer view is enclosed in a `ScrollView`, the inner `BatchQueueView` list continues to scroll its items, but its height is constrained with a flexible upper bound. On macOS, nested scroll views dispatch trackpad wheel events to the hovered container cleanly.
- **Rationale**: Standard macOS SwiftUI handles nested scroll containers predictably when inner views have explicit bounds.

---

## Component Layout Hierarchy

```
RootView (minWidth: 1180, minHeight: 700)
├── AppRouter (preserves active tab)
└── ConvertScene
    ├── TopNavHeaderView (Fixed Top Chrome: 50pt)
    ├── ScrollView(.vertical) {
    │   └── VStack {
    │       ├── ConvertHeadingView (~130pt)
    │       └── HStack(alignment: .top, spacing: 24) {
    │           ├── Left Column (Dropzone + Rejections + Queue)
    │           └── Right Column (SquooshInspector + OutputSettings)
    │       }
    │       .frame(maxWidth: Layout.Convert.maxContentWidth)
    │   }
    │   .padding(Layout.scenePadding)
    │   }
    └── BatchStatusFooterView (Fixed Bottom Chrome: 38pt)
```

---

## SettingsScene Wide Layout Architecture

```
SettingsScene
├── TopNavHeaderView (Fixed Top)
├── ScrollView(.vertical) {
│   └── VStack(alignment: .leading) {
│       ├── SettingsHeadingView
│       └── HStack(alignment: .top, spacing: 0) {
│           ├── SettingsSidebarView (230pt)
│           └── SettingsDetailView (maxWidth: 770pt)
│       }
│   }
│   .frame(maxWidth: Layout.Settings.maxContainerWidth) // ~1280pt
│   .frame(maxWidth: .infinity, alignment: .center)     // Centered on large screens
│   .padding(Layout.scenePadding)
│   }
└── BatchStatusFooterView (Fixed Bottom)
```
