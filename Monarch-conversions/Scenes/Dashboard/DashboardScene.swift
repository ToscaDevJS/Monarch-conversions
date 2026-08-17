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
                .padding(28)
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
                ConversionDetailModalView(record: record) {
                    selectedRecord = nil
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: selectedRecord != nil)
        .onAppear {
            cleanLegacySeedsIfNeeded()
        }
    }

    private func cleanLegacySeedsIfNeeded() {
        let legacyNames = [
            "hero-banner.png", "product-shot.jpg", "brand-mark.svg",
            "event-poster.tiff", "launch-grid.jpg", "team-photo.png",
            "podcast-cover.png", "newsletter-header.jpg"
        ]
        let descriptor = FetchDescriptor<ConversionRecord>()
        if let allRecords = try? modelContext.fetch(descriptor) {
            for record in allRecords {
                if legacyNames.contains(record.fileName) || record.project == "Marketing" || record.project == "Storefront" || record.project == "Brand" || record.project == "Events" {
                    modelContext.delete(record)
                }
            }
            try? modelContext.save()
        }
    }
}

#Preview {
    DashboardScene()
        .modelContainer(for: ConversionRecord.self, inMemory: true)
}
