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
                    
                    ConversionsTableView(searchText: searchText, onSelectTab: onSelectTab) { record in
                        selectedRecord = record
                    }
                }
                .padding(MonarchUI.Layout.scenePadding)
                .background(MonarchUI.Color.background)
                
                Spacer(minLength: 0)
                
                BatchStatusFooterView(
                    items: [],
                    settings: ConversionSettings(),
                    isProcessing: false
                )
            }
            .background(MonarchUI.Color.background)
            .ignoresSafeArea(.all, edges: .bottom)
            
            if let record = selectedRecord {
                ConversionDetailModalView(
                    record: record,
                    onClose: {
                        selectedRecord = nil
                    },
                    onDelete: {
                        modelContext.delete(record)
                        try? modelContext.save()
                        selectedRecord = nil
                    }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: selectedRecord != nil)
    }
}

#Preview {
    DashboardScene()
        .modelContainer(for: ConversionRecord.self, inMemory: true)
}
