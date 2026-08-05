import SwiftUI
import SwiftData

struct RootView: View {
    var body: some View {
        ItemsScene()
    }
}

#Preview {
    RootView()
        .modelContainer(for: Item.self, inMemory: true)
}
