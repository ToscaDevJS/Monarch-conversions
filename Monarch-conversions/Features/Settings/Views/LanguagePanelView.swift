import SwiftUI

struct LanguagePanelView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Language & region")
                    .font(MonarchUI.Font.sans(size: 16, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                Text("Choose the language and units shown across Monarch.")
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
            }
            
            HStack(spacing: 24) {
                // Display Language Field
                VStack(alignment: .leading, spacing: 6) {
                    Text("DISPLAY LANGUAGE")
                        .font(MonarchUI.Font.sans(size: 11, weight: .bold))
                        .foregroundStyle(MonarchUI.Color.textSecondary)
                    
                    HStack {
                        Text(settings.displayLanguage)
                            .font(MonarchUI.Font.sans(size: 13))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(MonarchUI.Color.textMuted)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(MonarchUI.Color.background)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(MonarchUI.Color.divider, lineWidth: 1)
                    )
                }
                .frame(width: 276)
                
                // Date Format Field
                VStack(alignment: .leading, spacing: 6) {
                    Text("DATE FORMAT")
                        .font(MonarchUI.Font.sans(size: 11, weight: .bold))
                        .foregroundStyle(MonarchUI.Color.textSecondary)
                    
                    HStack {
                        Text(settings.dateFormat)
                            .font(MonarchUI.Font.sans(size: 13))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(MonarchUI.Color.textMuted)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(MonarchUI.Color.background)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(MonarchUI.Color.divider, lineWidth: 1)
                    )
                }
                .frame(width: 212)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(MonarchUI.Color.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
        )
    }
}

#Preview {
    LanguagePanelView(settings: UserSettings())
        .padding()
        .background(MonarchUI.Color.background)
}
