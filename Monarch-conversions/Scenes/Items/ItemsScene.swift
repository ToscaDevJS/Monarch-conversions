import SwiftUI
import SwiftData

struct ItemsScene: View {
    var body: some View {
        ItemListView()
    }
}

#Preview {
    ItemsScene()
        .modelContainer(for: Item.self, inMemory: true)
}
