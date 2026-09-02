import SwiftUI

struct SettingsScene: View {
    @State var userSettings: UserSettings = UserSettings()
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
                            if selectedSection == .about {
                                AboutPanelView()
                            } else {
                                AppearancePanelView(settings: userSettings)
                                LanguagePanelView(settings: userSettings)
                                WorkflowPanelView(settings: userSettings)
                            }
                        }
                        .padding(.leading, MonarchUI.Layout.Settings.detailLeadingPadding)
                        .frame(maxWidth: MonarchUI.Layout.Settings.detailMaxWidth, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 30)
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
    }
}

#Preview {
    SettingsScene()
}
