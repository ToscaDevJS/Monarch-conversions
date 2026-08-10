import SwiftUI

struct LanguagePanelView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text("settings.section_language", tableName: "Settings")
                    .font(MonarchUI.Font.sans(size: 18, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                Text("language.subtitle", tableName: "Settings")
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
                        Text("language.display_language", tableName: "Settings")
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
                Menu {
                    ForEach(["Jul 31, 2026", "31/07/2026", "2026-07-31"], id: \.self) { format in
                        Button {
                            settings.dateFormat = format
                        } label: {
                            HStack {
                                Text(format)
                                if settings.dateFormat == format {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("language.date_format", tableName: "Settings")
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
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Date Format, currently \(settings.dateFormat)")
                .accessibilityHint("Double tap to change date format")
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
