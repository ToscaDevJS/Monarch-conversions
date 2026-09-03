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
            
            ViewThatFits(in: .horizontal) {
                // Wide layout: single row
                HStack(spacing: MonarchUI.Layout.Convert.settingBoxSpacing) {
                    formatBox
                    qualityBox
                    dimensionsBox
                    metadataBox
                    destinationBox
                }

                // Compact layout: two rows
                VStack(alignment: .leading, spacing: MonarchUI.Layout.Convert.settingBoxSpacing) {
                    HStack(spacing: MonarchUI.Layout.Convert.settingBoxSpacing) {
                        formatBox
                        qualityBox
                        metadataBox
                    }

                    HStack(spacing: MonarchUI.Layout.Convert.settingBoxSpacing) {
                        dimensionsBox
                        destinationBox
                    }
                }
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
        .padding(MonarchUI.Layout.Convert.outputSettingsHorizontalPadding)
        .background(MonarchUI.Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
        )
    }

    private var formatBox: some View {
        OutputSettingBox(
            title: Text("output.format", tableName: "Conversions"),
            isSelected: true,
            width: MonarchUI.Layout.Convert.formatBoxWidth
        ) {
            Menu {
                ForEach(ImageFormat.outputEligibleCases, id: \.self) { fmt in
                    Button(fmt.rawValue) {
                        settings.targetFormat = fmt
                    }
                }
            } label: {
                Text(settings.targetFormat.rawValue)
                    .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .menuStyle(.borderlessButton)
        }
    }

    private var qualityBox: some View {
        OutputSettingBox(
            title: Text("output.quality", tableName: "Conversions"),
            width: MonarchUI.Layout.Convert.qualityBoxWidth
        ) {
            Menu {
                Button("95% (Maximum)") { settings.quality = 0.95 }
                Button("82% (High)") { settings.quality = 0.82 }
                Button("65% (Medium)") { settings.quality = 0.65 }
                Button("45% (Low)") { settings.quality = 0.45 }
            } label: {
                Text("\(Int(settings.quality * 100))%")
                    .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .menuStyle(.borderlessButton)
        }
    }

    private var dimensionsBox: some View {
        OutputSettingBox(
            title: Text("output.dimensions", tableName: "Conversions"),
            width: MonarchUI.Layout.Convert.dimensionsBoxWidth
        ) {
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
                let text = settings.maxWidth != nil ? "Max \(settings.maxWidth!)px" : "Original"
                Text(text)
                    .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .menuStyle(.borderlessButton)
        }
    }

    private var metadataBox: some View {
        OutputSettingBox(
            title: Text("output.metadata", tableName: "Conversions"),
            width: MonarchUI.Layout.Convert.metadataBoxWidth
        ) {
            Menu {
                Button("Preserve Metadata") { settings.preserveMetadata = true }
                Button("Remove EXIF") { settings.preserveMetadata = false }
            } label: {
                Text(settings.preserveMetadata ? "Preserve" : "Remove EXIF")
                    .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .menuStyle(.borderlessButton)
        }
    }

    private var destinationBox: some View {
        OutputSettingBox(
            title: Text("Destination Folder", comment: "Output folder selection title"),
            width: MonarchUI.Layout.Convert.destinationBoxMaxWidth
        ) {
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
                Text(folderLabel)
                    .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .menuStyle(.borderlessButton)
        }
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
