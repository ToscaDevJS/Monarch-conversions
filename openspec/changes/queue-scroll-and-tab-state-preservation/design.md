# Design: Queue Scroll View, Window Constraints & Tab State Preservation

## Architecture

### 1. `BatchQueueView`
```swift
ScrollView {
    LazyVStack(spacing: 8) {
        ForEach(items) { item in
            BatchQueueItemRow(
                item: item,
                isSelected: selectedId == item.id
            ) {
                selectedId = item.id
            }
        }
    }
}
.frame(maxHeight: 320)
```

### 2. `RootView` State Preservation
```swift
ZStack {
    DashboardScene { newTab in
        router.navigateTo(newTab)
    }
    .opacity(router.activeTab == .studio || router.activeTab == .dashboard ? 1 : 0)
    .allowsHitTesting(router.activeTab == .studio || router.activeTab == .dashboard)

    ConvertScene { newTab in
        router.navigateTo(newTab)
    }
    .opacity(router.activeTab == .convert ? 1 : 0)
    .allowsHitTesting(router.activeTab == .convert)

    SettingsScene(userSettings: userSettings) { newTab in
        router.navigateTo(newTab)
    }
    .opacity(router.activeTab == .settings ? 1 : 0)
    .allowsHitTesting(router.activeTab == .settings)
}
.frame(minWidth: 860, minHeight: 600)
```

### 3. `Monarch_conversionsApp`
```swift
WindowGroup {
    RootView()
        .frame(minWidth: 860, minHeight: 600)
}
.windowResizability(.contentMinSize)
```
