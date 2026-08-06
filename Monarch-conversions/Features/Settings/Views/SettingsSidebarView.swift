import SwiftUI

enum SettingsSection: String, CaseIterable, Identifiable {
    case appearance = "Appearance"
    case language = "Language & region"
    case notifications = "Notifications"
    case conversionDefaults = "Conversion defaults"
    case storagePrivacy = "Storage & privacy"
    
    var id: String { rawValue }
}

struct SettingsSidebarView: View {
    @Binding var selectedSection: SettingsSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // General Group
            VStack(alignment: .leading, spacing: 4) {
                Text("GENERAL")
                    .font(MonarchUI.Font.sans(size: 11, weight: .bold))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
                    .padding(.bottom, 6)
                
                SidebarItem(title: "Appearance", isSelected: selectedSection == .appearance) {
                    selectedSection = .appearance
                }
                SidebarItem(title: "Language & region", isSelected: selectedSection == .language) {
                    selectedSection = .language
                }
                SidebarItem(title: "Notifications", isSelected: selectedSection == .notifications) {
                    selectedSection = .notifications
                }
            }
            
            // Workspace Group
            VStack(alignment: .leading, spacing: 4) {
                Text("WORKSPACE")
                    .font(MonarchUI.Font.sans(size: 11, weight: .bold))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
                    .padding(.bottom, 6)
                
                SidebarItem(title: "Conversion defaults", isSelected: selectedSection == .conversionDefaults) {
                    selectedSection = .conversionDefaults
                }
                SidebarItem(title: "Storage & privacy", isSelected: selectedSection == .storagePrivacy) {
                    selectedSection = .storagePrivacy
                }
            }
            
            Spacer()
        }
        .frame(width: 201)
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
                    .font(MonarchUI.Font.sans(size: 13, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? MonarchUI.Color.textPrimary : MonarchUI.Color.textSecondary)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? MonarchUI.Color.surface : SwiftUI.Color.clear)
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
