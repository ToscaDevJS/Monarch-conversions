import SwiftUI
import SwiftData

struct DashboardScene: View {
    @Environment(\.modelContext) private var modelContext
    @State private var searchText: String = ""
    @State private var selectedRecord: ConversionRecord? = nil
    var onSelectTab: ((AppTab) -> Void)? = nil
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Main Content Area
                VStack(spacing: 0) {
                    TopNavHeaderView(activeTab: .studio, onSelectTab: onSelectTab)
                    
                    GlobalSearchBarView(searchText: $searchText)
                        .padding(.top, 43)
                    
                    MetricsHeaderView()
                    
                    ConversionsTableView { record in
                        selectedRecord = record
                    }
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
            
            if let record = selectedRecord {
                ConversionDetailModalView(record: record) {
                    selectedRecord = nil
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: selectedRecord != nil)
        .onAppear {
            ConversionSeedService.seedInitialDataIfNeeded(modelContext: modelContext)
        }
    }
}

#Preview {
    DashboardScene()
        .modelContainer(for: ConversionRecord.self, inMemory: true)
}
