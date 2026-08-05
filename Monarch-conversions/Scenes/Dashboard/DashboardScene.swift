import SwiftUI
import SwiftData

struct DashboardScene: View {
    @Environment(\.modelContext) private var modelContext
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content Area
            VStack(spacing: 0) {
                TopNavHeaderView()
                
                GlobalSearchBarView(searchText: $searchText)
                    .padding(.top, 43)
                
                MetricsHeaderView()
                
                ConversionsTableView()
            }
            .padding(28)
            .background(MonarchUI.Color.background)
            
            Spacer(minLength: 0)
            
            // Bottom Bars
            VStack(spacing: 0) {
                TelemetryFooterView()
                StatusFooterView()
            }
        }
        .background(MonarchUI.Color.background)
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            ConversionSeedService.seedInitialDataIfNeeded(modelContext: modelContext)
        }
    }
}

#Preview {
    DashboardScene()
        .modelContainer(for: ConversionRecord.self, inMemory: true)
}
