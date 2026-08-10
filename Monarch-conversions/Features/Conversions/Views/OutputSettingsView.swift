import SwiftUI

struct OutputSettingsView: View {
    @Binding var settings: ConversionSettings
    var isProcessing: Bool = false
    var onAddBatch: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("output.title", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                
                Spacer()
                
                Text("output.preset", tableName: "Conversions")
                    .font(MonarchUI.Font.mono(size: 11))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
            }
            
            HStack(spacing: 10) {
                // Format Box (Selected)
                VStack(alignment: .leading, spacing: 4) {
                    Text("output.format", tableName: "Conversions")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(MonarchUI.Color.accentViolet)
                        .tracking(0.5)
                    Menu {
                        ForEach(ImageFormat.outputEligibleCases, id: \.self) { fmt in
                            Button(fmt.rawValue) {
                                settings.targetFormat = fmt
                            }
                        }
                    } label: {
                        Text("\(settings.targetFormat.rawValue) ⌄")
                            .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                    }
                    .menuStyle(.borderlessButton)
                }
                .padding(.horizontal, 12)
                .frame(width: 180, height: 70, alignment: .leading)
                .background(MonarchUI.Color.accentVioletBg)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.accentViolet, lineWidth: 1)
                )
                
                // Quality Box
                VStack(alignment: .leading, spacing: 4) {
                    Text("output.quality", tableName: "Conversions")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(MonarchUI.Color.textSubtle)
                        .tracking(0.5)
                    Menu {
                        Button("95% (Maximum)") { settings.quality = 0.95 }
                        Button("82% (High)") { settings.quality = 0.82 }
                        Button("65% (Medium)") { settings.quality = 0.65 }
                        Button("45% (Low)") { settings.quality = 0.45 }
                    } label: {
                        Text("\(Int(settings.quality * 100))% ⌄")
                            .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                    }
                    .menuStyle(.borderlessButton)
                }
                .padding(.horizontal, 12)
                .frame(width: 180, height: 70, alignment: .leading)
                .background(MonarchUI.Color.surface)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                )
                
                // Dimensions Box
                VStack(alignment: .leading, spacing: 4) {
                    Text("output.dimensions", tableName: "Conversions")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(MonarchUI.Color.textSubtle)
                        .tracking(0.5)
                    Menu {
                        Button("Keep Original") {
                            settings.maxWidth = nil
                            settings.maxHeight = nil
                        }
                        Button("Max 2048px") {
                            settings.maxWidth = 2048
                            settings.maxHeight = 2048
                        }
                        Button("Max 1024px") {
                            settings.maxWidth = 1024
                            settings.maxHeight = 1024
                        }
                    } label: {
                        let text = settings.maxWidth != nil ? "Max \(settings.maxWidth!)px ⌄" : "Original ⌄"
                        Text(text)
                            .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                    }
                    .menuStyle(.borderlessButton)
                }
                .padding(.horizontal, 12)
                .frame(width: 230, height: 70, alignment: .leading)
                .background(MonarchUI.Color.surface)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                )
                
                // Metadata Box
                VStack(alignment: .leading, spacing: 4) {
                    Text("output.metadata", tableName: "Conversions")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(MonarchUI.Color.textSubtle)
                        .tracking(0.5)
                    Menu {
                        Button("Preserve Metadata") { settings.preserveMetadata = true }
                        Button("Remove EXIF") { settings.preserveMetadata = false }
                    } label: {
                        Text(settings.preserveMetadata ? "Preserve ⌄" : "Remove EXIF ⌄")
                            .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                    }
                    .menuStyle(.borderlessButton)
                }
                .padding(.horizontal, 12)
                .frame(width: 170, height: 70, alignment: .leading)
                .background(MonarchUI.Color.surface)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                )

                // Destination Folder Box
                VStack(alignment: .leading, spacing: 4) {
                    Text("Destination Folder", comment: "Output folder selection title")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(MonarchUI.Color.textSubtle)
                        .tracking(0.5)
                    Menu {
                        Button("Same as Source File") {
                            settings.outputDirectoryURL = nil
                        }
                        Button("Choose Folder...") {
                            if let selected = DirectoryPickerHelper.pickFolder() {
                                settings.outputDirectoryURL = selected
                            }
                        }
                    } label: {
                        let folderLabel = settings.outputDirectoryURL?.lastPathComponent ?? "Same as Source"
                        Text("\(folderLabel) ⌄")
                            .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                    }
                    .menuStyle(.borderlessButton)
                }
                .padding(.horizontal, 12)
                .frame(height: 70)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(MonarchUI.Color.surface)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                )
            }
            
            HStack {
                HStack(spacing: 8) {
                    Text("output.estimated_savings", tableName: "Conversions")
                        .font(MonarchUI.Font.sans(size: 13))
                        .foregroundStyle(MonarchUI.Color.textSecondary)
                    
                    Text("Target: \(settings.targetFormat.rawValue) (\(Int(settings.quality * 100))%)")
                        .font(MonarchUI.Font.mono(size: 13, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.accentViolet)
                }
                
                Spacer()
                
                Button {
                    onAddBatch?()
                } label: {
                    HStack(spacing: 6) {
                        if isProcessing {
                            ProgressView()
                                .controlSize(.small)
                        }
                        Text(isProcessing ? "Converting..." : "Convert Batch", comment: "Convert action button")
                            .font(MonarchUI.Font.sans(size: 14, weight: .semibold))
                            .foregroundStyle(MonarchUI.Color.accentVioletBg)
                    }
                    .padding(.horizontal, 28)
                    .frame(height: 42)
                    .background(isProcessing ? MonarchUI.Color.accentViolet.opacity(0.5) : MonarchUI.Color.accentViolet)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                }
                .disabled(isProcessing)
                .buttonStyle(.plain)
            }
            .padding(.top, 4)
        }
        .padding(18)
        .background(MonarchUI.Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
        )
    }
}

@MainActor
struct DirectoryPickerHelper {
    static func pickFolder() -> URL? {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Select Output Folder"
        return panel.runModal() == .OK ? panel.url : nil
    }
}

#Preview {
    OutputSettingsView(settings: .constant(ConversionSettings()))
        .padding()
        .background(MonarchUI.Color.background)
}
