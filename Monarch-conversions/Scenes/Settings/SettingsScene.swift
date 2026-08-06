import SwiftUI

struct SettingsScene: View {
    @State private var userSettings = UserSettings()
    @State private var selectedSection: SettingsSection = .appearance
    var onSelectTab: ((AppTab) -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                TopNavHeaderView(activeTab: .settings, onSelectTab: onSelectTab)
                
                SettingsHeadingView()
                
                HStack(alignment: .top, spacing: 40) {
                    SettingsSidebarView(selectedSection: $selectedSection)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            AppearancePanelView(settings: userSettings)
                            LanguagePanelView(settings: userSettings)
                            WorkflowPanelView(settings: userSettings)
                        }
                    }
                    .frame(maxWidth: 770)
                }
                .padding(.top, 32)
            }
            .padding(28)
            .background(MonarchUI.Color.background)
            
            Spacer(minLength: 0)
            
            VStack(spacing: 0) {
                TelemetryFooterView()
                StatusFooterView()
            }
        }
        .background(MonarchUI.Color.background)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    SettingsScene()
}
