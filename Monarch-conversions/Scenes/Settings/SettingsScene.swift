import SwiftUI

struct SettingsScene: View {
    @Bindable var userSettings: UserSettings = UserSettings()
    @State private var selectedSection: SettingsSection = .appearance
    var onSelectTab: ((AppTab) -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                TopNavHeaderView(activeTab: .settings, onSelectTab: onSelectTab)
                
                SettingsHeadingView()
                
                HStack(alignment: .top, spacing: 0) {
                    SettingsSidebarView(selectedSection: $selectedSection)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            AppearancePanelView(settings: userSettings)
                            LanguagePanelView(settings: userSettings)
                            WorkflowPanelView(settings: userSettings)
                        }
                        .padding(.leading, 42)
                        .frame(maxWidth: 770, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 30)
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
