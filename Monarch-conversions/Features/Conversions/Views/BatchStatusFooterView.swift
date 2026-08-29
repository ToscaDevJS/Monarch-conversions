import SwiftUI
#if canImport(AppKit)
import AppKit
#endif

public struct BatchStatusFooterView: View {
    public let items: [BatchQueueItem]
    public let settings: ConversionSettings
    public let isProcessing: Bool
    public var onCancel: (() -> Void)? = nil

    public init(
        items: [BatchQueueItem],
        settings: ConversionSettings,
        isProcessing: Bool,
        onCancel: (() -> Void)? = nil
    ) {
        self.items = items
        self.settings = settings
        self.isProcessing = isProcessing
        self.onCancel = onCancel
    }

    public var totalOriginalBytes: Int64 {
        items.reduce(0) { $0 + $1.originalSizeBytes }
    }

    public var doneItems: [BatchQueueItem] {
        items.filter { $0.status == .done }
    }

    public var doneOriginalBytes: Int64 {
        doneItems.reduce(0) { $0 + $1.originalSizeBytes }
    }

    public var doneOutputBytes: Int64 {
        doneItems.compactMap(\.targetSizeBytes).reduce(0, +)
    }

    public var totalSavedBytes: Int64 {
        max(0, doneOriginalBytes - doneOutputBytes)
    }

    public var totalReductionPct: Int? {
        guard doneOriginalBytes > 0, !doneItems.isEmpty else { return nil }
        let diff = Double(doneOutputBytes - doneOriginalBytes)
        let pct = (diff / Double(doneOriginalBytes)) * 100.0
        return Int(round(pct))
    }

    private func openDestinationFolder() {
        #if os(macOS)
        if let url = settings.outputDirectoryURL {
            NSWorkspace.shared.open(url)
        } else if let downloads = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
            NSWorkspace.shared.open(downloads)
        }
        #endif
    }

    public var body: some View {
        HStack(spacing: 0) {
            // Left: Engine & Batch Queue Stats
            HStack(spacing: 12) {
                // Engine Badge
                HStack(spacing: 6) {
                    Circle()
                        .fill(MonarchUI.Color.statusGreen)
                        .frame(width: 7, height: 7)
                        .shadow(color: MonarchUI.Color.statusGreen.opacity(0.4), radius: 3)

                    Text("ImageIO Local")
                        .font(MonarchUI.Font.mono(size: 11, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }

                DividerBar()

                // Queue File Count & Total Size
                HStack(spacing: 6) {
                    Text("\(items.count) \(items.count == 1 ? "file" : "files")")
                        .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)

                    Text("·")
                        .foregroundStyle(MonarchUI.Color.textMuted)

                    Text(ConversionFormatting.byteSize(totalOriginalBytes))
                        .font(MonarchUI.Font.mono(size: 11))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }

                DividerBar()

                // Target Format & Quality
                HStack(spacing: 6) {
                    Text(settings.targetFormat.rawValue.uppercased())
                        .font(MonarchUI.Font.mono(size: 10, weight: .bold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(MonarchUI.Color.badgeGrayBg)
                        .clipShape(RoundedRectangle(cornerRadius: 2))

                    Text("\(Int(settings.quality * 100))%")
                        .font(MonarchUI.Font.mono(size: 11))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
            }

            Spacer()

            // Center: Output Destination
            Button {
                openDestinationFolder()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "folder")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textMuted)

                    if let outputDir = settings.outputDirectoryURL {
                        Text(outputDir.lastPathComponent)
                            .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                    } else {
                        Text("Same as Source (or Downloads)")
                            .font(MonarchUI.Font.sans(size: 12))
                            .foregroundStyle(MonarchUI.Color.textMuted)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(MonarchUI.Color.surface)
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(MonarchUI.Color.divider, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            .help("Open Output Folder in Finder")

            Spacer()

            // Right: Conversion Realtime Status
            HStack(spacing: 10) {
                if isProcessing {
                    HStack(spacing: 8) {
                        HStack(spacing: 6) {
                            ProgressView()
                                .controlSize(.small)
                            Text("Converting \(doneItems.count + 1) of \(items.count)...")
                                .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                                .foregroundStyle(MonarchUI.Color.accentViolet)
                        }

                        if let onCancel = onCancel {
                            Button(action: onCancel) {
                                Text("action.cancel", tableName: "Common")
                                    .font(MonarchUI.Font.sans(size: 11, weight: .semibold))
                                    .foregroundStyle(MonarchUI.Color.statusRed)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(MonarchUI.Color.statusRed.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("cancel-conversion-button")
                        }
                    }
                } else if !doneItems.isEmpty {
                    HStack(spacing: 6) {
                        Text("✓ \(doneItems.count) done")
                            .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                            .foregroundStyle(MonarchUI.Color.statusGreen)

                        if let pct = totalReductionPct, pct < 0 {
                            Text("· Saved \(ConversionFormatting.byteSize(totalSavedBytes)) (\(abs(pct))%)")
                                .font(MonarchUI.Font.mono(size: 11))
                                .foregroundStyle(MonarchUI.Color.textMuted)
                        }
                    }
                } else if items.isEmpty {
                    Text("Ready · Drop images to convert")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                } else {
                    Text("\(items.count) queued · Press ⌘R to convert")
                        .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 38)
        .background(MonarchUI.Color.surface)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(MonarchUI.Color.divider),
            alignment: .top
        )
    }
}

private struct DividerBar: View {
    var body: some View {
        Rectangle()
            .fill(MonarchUI.Color.divider)
            .frame(width: 1, height: 14)
    }
}
