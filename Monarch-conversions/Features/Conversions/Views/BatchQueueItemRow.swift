import SwiftUI
#if canImport(AppKit)
import AppKit
#endif

struct BatchQueueItemRow: View {
    let item: BatchQueueItem
    let isSelected: Bool
    let onSelect: () -> Void

    private func revealInFinder(url: URL) {
        #if os(macOS)
        NSWorkspace.shared.activateFileViewerSelecting([url])
        #endif
    }
    
    private var trailingText: String {
        guard let targetFormat = item.targetFormat else {
            return "No target"
        }
        if let targetBytes = item.targetSizeBytes, let pct = item.reductionPercent {
            let sizeStr = ConversionFormatting.byteSize(targetBytes)
            let pctStr = ConversionFormatting.reduction(percent: pct)
            return "\(targetFormat.rawValue) · \(sizeStr) (\(pctStr))"
        } else {
            return targetFormat.rawValue
        }
    }

    var body: some View {
        Button(action: onSelect) {
            HStack {
                HStack(spacing: 10) {
                    Text(item.format.rawValue.uppercased())
                        .font(MonarchUI.Font.sans(size: 8, weight: .bold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                        .frame(width: 26, height: 26)
                        .background(MonarchUI.Color.badgeGrayBg)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                        Text("\(ConversionFormatting.dimensions(item.dimensions)) · \(ConversionFormatting.byteSize(item.originalSizeBytes))")
                            .font(MonarchUI.Font.mono(size: 11))
                            .foregroundStyle(MonarchUI.Color.textMuted)
                    }
                }
                
                Spacer()
                
                if item.status == .converting {
                    HStack(spacing: 4) {
                        ProgressView()
                            .controlSize(.small)
                        Text("Converting...")
                            .font(MonarchUI.Font.sans(size: 11, weight: .semibold))
                            .foregroundStyle(MonarchUI.Color.accentViolet)
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 22)
                    .background(MonarchUI.Color.accentVioletBg)
                    .clipShape(Capsule())
                    .accessibilityIdentifier("status-converting")
                } else if item.status == .done {
                    HStack(spacing: 6) {
                        HStack(spacing: 6) {
                            Text("✓ Done")
                                .font(MonarchUI.Font.sans(size: 11, weight: .bold))
                                .foregroundStyle(MonarchUI.Color.statusGreen)
                            if item.isFallbackDestination {
                                Text("· Downloads")
                                    .font(MonarchUI.Font.sans(size: 10, weight: .medium))
                                    .foregroundStyle(MonarchUI.Color.textMuted)
                            }
                        }
                        .padding(.horizontal, 8)
                        .frame(height: 22)
                        .background(MonarchUI.Color.statusGreen.opacity(0.15))
                        .clipShape(Capsule())
                        .accessibilityIdentifier("status-done")

                        if let outputURL = item.outputFileURL {
                            Button {
                                revealInFinder(url: outputURL)
                            } label: {
                                Image(systemName: "folder")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(MonarchUI.Color.textPrimary)
                                    .frame(width: 24, height: 22)
                                    .background(MonarchUI.Color.badgeGrayBg)
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                            }
                            .buttonStyle(.plain)
                            .help("Reveal in Finder")
                            .accessibilityIdentifier("reveal-in-finder-button")
                        }
                    }
                } else if item.status == .failed {
                    HStack(spacing: 4) {
                        Text("✕ Failed")
                            .font(MonarchUI.Font.sans(size: 11, weight: .bold))
                            .foregroundStyle(MonarchUI.Color.statusRed)
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 22)
                    .background(MonarchUI.Color.statusRed.opacity(0.15))
                    .clipShape(Capsule())
                    .accessibilityIdentifier("status-failed")
                } else if isSelected {
                    Text(trailingText)
                        .font(MonarchUI.Font.sans(size: 11, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.accentVioletBg)
                        .padding(.horizontal, 8)
                        .frame(height: 22)
                        .background(MonarchUI.Color.accentViolet)
                        .clipShape(Capsule())
                } else {
                    Text(trailingText)
                        .font(MonarchUI.Font.mono(size: 11))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
            }
            .padding(12)
            .background(isSelected ? MonarchUI.Color.accentVioletBg : MonarchUI.Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(isSelected ? MonarchUI.Color.accentViolet : MonarchUI.Color.divider, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .onDrag {
            if let provider = item.dragItemProvider {
                return provider
            }
            return NSItemProvider()
        }
        .contextMenu {
            if let outputURL = item.outputFileURL {
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.writeObjects([outputURL as NSURL])
                } label: {
                    Label("Copy Converted File", systemImage: "doc.on.doc")
                }

                Button {
                    revealInFinder(url: outputURL)
                } label: {
                    Label("Reveal in Finder", systemImage: "folder")
                }
            } else if let sourceURL = item.fileURL {
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.writeObjects([sourceURL as NSURL])
                } label: {
                    Label("Copy Source File", systemImage: "doc.on.doc")
                }

                Button {
                    revealInFinder(url: sourceURL)
                } label: {
                    Label("Show Source in Finder", systemImage: "folder")
                }
            }
        }
    }
}
