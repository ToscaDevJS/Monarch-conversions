import SwiftUI

struct SettingsScene: View {
    @State var userSettings: UserSettings = UserSettings()
    @State private var selectedSection: SettingsSection = .appearance
    var onSelectTab: ((AppTab) -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            TopNavHeaderView(activeTab: .settings, onSelectTab: onSelectTab)
                .padding(.horizontal, MonarchUI.Layout.scenePadding)
                .padding(.top, MonarchUI.Layout.scenePadding)

            VStack(spacing: 0) {
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
            .frame(maxWidth: MonarchUI.Layout.Settings.maxContainerWidth)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, MonarchUI.Layout.scenePadding)
            .padding(.bottom, MonarchUI.Layout.scenePadding)
            
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
