import SwiftUI
import SwiftData

struct RootView: View {
    var body: some View {
        DashboardScene()
    }
}

#Preview {
    RootView()
        .modelContainer(for: ConversionRecord.self, inMemory: true)
}
