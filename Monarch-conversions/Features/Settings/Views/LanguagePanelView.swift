import SwiftUI

struct LanguagePanelView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Language & region")
                    .font(MonarchUI.Font.sans(size: 18, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                Text("Choose the language and units shown across Monarch.")
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(MonarchUI.Color.textSubtle)
            }
            
            HStack(spacing: 12) {
                // Display Language Field Box
                Menu {
                    ForEach(AppLanguage.allCases) { lang in
                        Button {
                            settings.language = lang
                        } label: {
                            HStack {
                                Text(lang.displayName)
                                if settings.language == lang {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("DISPLAY LANGUAGE")
                            .font(MonarchUI.Font.mono(size: 10, weight: .regular))
                            .foregroundStyle(MonarchUI.Color.textMuted)
                            .tracking(0.7)
                        
                        HStack {
                            Text(settings.displayLanguage)
                                .font(MonarchUI.Font.sans(size: 14))
                                .foregroundStyle(MonarchUI.Color.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(MonarchUI.Color.textMuted)
                        }
                    }
                    .padding(.horizontal, 13)
                    .frame(width: 276, height: 56)
                    .overlay(
                        Rectangle()
                            .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Display Language, currently \(settings.displayLanguage)")
                .accessibilityHint("Double tap to change display language")
                
                // Date Format Field Box
                VStack(alignment: .leading, spacing: 3) {
                    Text("DATE FORMAT")
                        .font(MonarchUI.Font.mono(size: 10, weight: .regular))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                        .tracking(0.7)
                    
                    HStack {
                        Text(settings.dateFormat)
                            .font(MonarchUI.Font.sans(size: 14))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(MonarchUI.Color.textMuted)
                    }
                }
                .padding(.horizontal, 13)
                .frame(width: 212, height: 56)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                )
            }
        }
        .padding(.vertical, 24)
        .overlay(
            Rectangle()
                .fill(MonarchUI.Color.divider)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

#Preview {
    LanguagePanelView(settings: UserSettings())
        .padding()
        .background(MonarchUI.Color.background)
}
