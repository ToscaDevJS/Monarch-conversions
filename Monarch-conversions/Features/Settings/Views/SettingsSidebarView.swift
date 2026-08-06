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
        VStack(alignment: .leading, spacing: 22) {
            // General Group
            VStack(alignment: .leading, spacing: 5) {
                Text("GENERAL")
                    .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                    .foregroundStyle(MonarchUI.Color.textDim)
                    .tracking(0.8)
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
            VStack(alignment: .leading, spacing: 5) {
                Text("WORKSPACE")
                    .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                    .foregroundStyle(MonarchUI.Color.textDim)
                    .tracking(0.8)
                    .padding(.top, 14)
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
        .padding(.trailing, 28)
        .frame(width: 230, alignment: .leading)
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
                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(height: 38)
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
