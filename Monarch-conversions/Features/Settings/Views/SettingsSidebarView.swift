import SwiftUI

enum SettingsSection: String, CaseIterable, Identifiable {
    case appearance = "Appearance"
    case language = "Language & region"
    case notifications = "Notifications"
    case conversionDefaults = "Conversion defaults"
    case storagePrivacy = "Storage & privacy"
    case about = "About Monarch"
    
    var id: String { rawValue }
}

struct SettingsSidebarView: View {
    @Binding var selectedSection: SettingsSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            // General Group
            VStack(alignment: .leading, spacing: 5) {
                Text("settings.group_general", tableName: "Settings")
                    .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                    .foregroundStyle(MonarchUI.Color.textDim)
                    .tracking(0.8)
                    .padding(.bottom, 6)
                
                SidebarItem(title: String(localized: "settings.section_appearance", table: "Settings"), isSelected: selectedSection == .appearance) {
                    selectedSection = .appearance
                }
                SidebarItem(title: String(localized: "settings.section_language", table: "Settings"), isSelected: selectedSection == .language) {
                    selectedSection = .language
                }
                SidebarItem(title: String(localized: "settings.section_notifications", table: "Settings"), isSelected: selectedSection == .notifications) {
                    selectedSection = .notifications
                }
            }
            
            // Workspace Group
            VStack(alignment: .leading, spacing: 5) {
                Text("settings.group_workspace", tableName: "Settings")
                    .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                    .foregroundStyle(MonarchUI.Color.textDim)
                    .tracking(0.8)
                    .padding(.top, 14)
                    .padding(.bottom, 6)
                
                SidebarItem(title: String(localized: "settings.section_defaults", table: "Settings"), isSelected: selectedSection == .conversionDefaults) {
                    selectedSection = .conversionDefaults
                }
                SidebarItem(title: String(localized: "settings.section_storage", table: "Settings"), isSelected: selectedSection == .storagePrivacy) {
                    selectedSection = .storagePrivacy
                }
            }
            
            // System & Info Group
            VStack(alignment: .leading, spacing: 5) {
                Text("ABOUT", comment: "About section header")
                    .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                    .foregroundStyle(MonarchUI.Color.textDim)
                    .tracking(0.8)
                    .padding(.top, 14)
                    .padding(.bottom, 6)
                
                SidebarItem(title: "About Monarch", isSelected: selectedSection == .about) {
                    selectedSection = .about
                }
            }
            
            Spacer()
        }
        .padding(.trailing, 28)
        .frame(width: MonarchUI.Layout.Settings.sidebarWidth, alignment: .leading)
        .overlay(
            Rectangle()
                .fill(MonarchUI.Color.divider)
                .frame(width: 1),
            alignment: .trailing
        )
    }
}

private struct SidebarItem: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(MonarchUI.Font.sans(size: 14, weight: isSelected ? .medium : .regular))
                    .foregroundStyle(isSelected ? MonarchUI.Color.textPrimary : MonarchUI.Color.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(minHeight: 38)
            .background(
                Rectangle()
                    .fill(isSelected ? MonarchUI.Color.sidebarActiveBg : SwiftUI.Color.clear)
            )
            .overlay(
                Rectangle()
                    .fill(isSelected ? MonarchUI.Color.accentViolet : SwiftUI.Color.clear)
                    .frame(width: 2),
                alignment: .leading
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsSidebarView(selectedSection: .constant(.appearance))
        .padding()
        .background(MonarchUI.Color.background)
}
