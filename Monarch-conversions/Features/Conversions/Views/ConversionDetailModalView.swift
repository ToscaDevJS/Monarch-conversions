import SwiftUI
#if canImport(AppKit)
import AppKit
#endif

struct ConversionDetailModalView: View {
    let record: ConversionRecord
    let onClose: () -> Void

    @State private var copiedNameFeedback: Bool = false
    @State private var copiedIdFeedback: Bool = false
    @State private var copiedFileFeedback: Bool = false
    @State private var loadedThumbnail: NSImage? = nil

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: record.timestamp)
    }

    private func revealInFinder(url: URL) {
        #if os(macOS)
        NSWorkspace.shared.activateFileViewerSelecting([url])
        #endif
    }

    private func copyFileToClipboard(url: URL) {
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([url as NSURL])
        copiedFileFeedback = true
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            copiedFileFeedback = false
        }
        #endif
    }

    var body: some View {
        ZStack {
            // Semi-transparent Backdrop
            SwiftUI.Color.black.opacity(0.72)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            // Modal Card Box
            VStack(spacing: 0) {
                // Header Bar
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        if record.status == .working {
                            HStack(spacing: 4) {
                                Text("status.working", tableName: "Conversions")
                                    .font(MonarchUI.Font.sans(size: 11, weight: .semibold))
                                    .foregroundStyle(MonarchUI.Color.accentVioletBg)
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 22)
                            .background(MonarchUI.Color.accentViolet)
                            .clipShape(Capsule())
                        } else {
                            HStack(spacing: 4) {
                                Text("status.done", tableName: "Conversions")
                                    .font(MonarchUI.Font.sans(size: 11, weight: .bold))
                                    .foregroundStyle(MonarchUI.Color.statusGreen)
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 22)
                            .background(MonarchUI.Color.statusGreen.opacity(0.15))
                            .clipShape(Capsule())
                        }

                        Text("#\(ConversionFormatting.shortFileId(record.fileId))")
                            .font(MonarchUI.Font.mono(size: 12, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textSecondary)
                    }

                    Spacer()

                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(MonarchUI.Color.textSubtle)
                            .frame(width: 26, height: 26)
                            .background(MonarchUI.Color.shortcutBg)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(.cancelAction)
                }
                .padding(.horizontal, 22)
                .frame(height: 56)
                .overlay(
                    Rectangle()
                        .fill(MonarchUI.Color.divider)
                        .frame(height: 1),
                    alignment: .bottom
                )

                // Main Content (Split Preview & Inspection Grid)
                HStack(alignment: .top, spacing: 24) {
                    // Left Column: Visual Preview & Drag Card
                    VStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(MonarchUI.Color.cardDarkBg)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
                                )

                            if let image = loadedThumbnail {
                                Image(nsImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(8)
                            } else {
                                VStack(spacing: 10) {
                                    HStack(spacing: 8) {
                                        Text(record.inputFormat.rawValue.uppercased())
                                            .font(MonarchUI.Font.mono(size: 12, weight: .bold))
                                            .foregroundStyle(MonarchUI.Color.textPrimary)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(MonarchUI.Color.badgeGrayBg)
                                            .clipShape(RoundedRectangle(cornerRadius: 4))

                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundStyle(MonarchUI.Color.accentViolet)

                                        Text(record.outputFormat.rawValue.uppercased())
                                            .font(MonarchUI.Font.mono(size: 12, weight: .bold))
                                            .foregroundStyle(MonarchUI.Color.accentViolet)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(MonarchUI.Color.accentVioletBg)
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                    }

                                    Text(record.fileName)
                                        .font(MonarchUI.Font.sans(size: 11))
                                        .foregroundStyle(MonarchUI.Color.textMuted)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 12)
                                }
                            }
                        }
                        .frame(width: 240, height: 200)
                        .onDrag {
                            if let outputURL = record.outputURL {
                                return NSItemProvider(contentsOf: outputURL) ?? NSItemProvider(object: outputURL as NSURL)
                            }
                            return NSItemProvider()
                        }

                        if record.outputURL != nil {
                            HStack(spacing: 4) {
                                Image(systemName: "hand.draw")
                                    .font(.system(size: 10))
                                Text("Drag image to Finder or external apps")
                                    .font(MonarchUI.Font.sans(size: 11))
                            }
                            .foregroundStyle(MonarchUI.Color.textMuted)
                        }
                    }

                    // Right Column: Metadata & Technical Inspection
                    VStack(alignment: .leading, spacing: 16) {
                        // File Name Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("FILE NAME")
                                .font(MonarchUI.Font.mono(size: 10, weight: .regular))
                                .foregroundStyle(MonarchUI.Color.textDim)
                                .tracking(0.6)

                            HStack(spacing: 8) {
                                Text(record.fileName)
                                    .font(MonarchUI.Font.sans(size: 15, weight: .semibold))
                                    .foregroundStyle(MonarchUI.Color.textPrimary)
                                    .lineLimit(1)
                                    .truncationMode(.middle)

                                Button {
                                    NSPasteboard.general.clearContents()
                                    NSPasteboard.general.setString(record.fileName, forType: .string)
                                    copiedNameFeedback = true
                                    Task {
                                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                                        copiedNameFeedback = false
                                    }
                                } label: {
                                    Text(copiedNameFeedback ? "Copied!" : "Copy")
                                        .font(MonarchUI.Font.sans(size: 11, weight: .medium))
                                        .foregroundStyle(copiedNameFeedback ? MonarchUI.Color.statusGreen : MonarchUI.Color.accentViolet)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(MonarchUI.Color.accentVioletBg)
                                        .clipShape(RoundedRectangle(cornerRadius: 3))
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        Divider()
                            .background(MonarchUI.Color.divider)

                        // 2x2 Specs Grid
                        Grid(alignment: .leading, horizontalSpacing: 28, verticalSpacing: 14) {
                            GridRow {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("TRANSFORMATION")
                                        .font(MonarchUI.Font.mono(size: 10))
                                        .foregroundStyle(MonarchUI.Color.textDim)
                                    Text("\(record.inputFormat.rawValue.uppercased()) ➔ \(record.outputFormat.rawValue.uppercased())")
                                        .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                                        .foregroundStyle(MonarchUI.Color.textPrimary)
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text("DIMENSIONS")
                                        .font(MonarchUI.Font.mono(size: 10))
                                        .foregroundStyle(MonarchUI.Color.textDim)
                                    Text("\(ConversionFormatting.dimensions(record.dimensions)) px")
                                        .font(MonarchUI.Font.mono(size: 13))
                                        .foregroundStyle(MonarchUI.Color.textPrimary)
                                }
                            }

                            GridRow {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("OUTPUT SIZE")
                                        .font(MonarchUI.Font.mono(size: 10))
                                        .foregroundStyle(MonarchUI.Color.textDim)
                                    Text(ConversionFormatting.byteSize(record.outputSizeBytes))
                                        .font(MonarchUI.Font.mono(size: 13, weight: .medium))
                                        .foregroundStyle(MonarchUI.Color.textPrimary)
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text("PROCESSED DATE")
                                        .font(MonarchUI.Font.mono(size: 10))
                                        .foregroundStyle(MonarchUI.Color.textDim)
                                    Text(formattedDate)
                                        .font(MonarchUI.Font.sans(size: 12))
                                        .foregroundStyle(MonarchUI.Color.textSecondary)
                                }
                            }
                        }

                        if let path = record.outputFilePath {
                            Divider()
                                .background(MonarchUI.Color.divider)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("OUTPUT PATH")
                                    .font(MonarchUI.Font.mono(size: 10))
                                    .foregroundStyle(MonarchUI.Color.textDim)

                                Text(path)
                                    .font(MonarchUI.Font.mono(size: 11))
                                    .foregroundStyle(MonarchUI.Color.textMuted)
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(22)

                // Footer Action Bar
                HStack(spacing: 12) {
                    if let outputURL = record.outputURL {
                        Button {
                            revealInFinder(url: outputURL)
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "folder")
                                    .font(.system(size: 12))
                                Text("Reveal in Finder")
                                    .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 32)
                            .background(MonarchUI.Color.shortcutBg)
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)

                        Button {
                            copyFileToClipboard(url: outputURL)
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: copiedFileFeedback ? "checkmark" : "doc.on.doc")
                                    .font(.system(size: 12))
                                Text(copiedFileFeedback ? "Copied!" : "Copy File")
                                    .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 32)
                            .background(MonarchUI.Color.shortcutBg)
                            .foregroundStyle(copiedFileFeedback ? MonarchUI.Color.statusGreen : MonarchUI.Color.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }

                    Button {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(record.fileId, forType: .string)
                        copiedIdFeedback = true
                        Task {
                            try? await Task.sleep(nanoseconds: 1_500_000_000)
                            copiedIdFeedback = false
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: copiedIdFeedback ? "checkmark" : "number")
                                .font(.system(size: 12))
                            Text(copiedIdFeedback ? "ID Copied!" : "Copy ID")
                                .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 32)
                        .background(MonarchUI.Color.shortcutBg)
                        .foregroundStyle(copiedIdFeedback ? MonarchUI.Color.statusGreen : MonarchUI.Color.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Button(action: onClose) {
                        Text("Close")
                            .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                            .foregroundStyle(SwiftUI.Color.white)
                            .padding(.horizontal, 16)
                            .frame(height: 32)
                            .background(MonarchUI.Color.accentViolet)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(.cancelAction)
                }
                .padding(.horizontal, 22)
                .frame(height: 60)
                .background(MonarchUI.Color.cardDarkBg.opacity(0.5))
                .overlay(
                    Rectangle()
                        .fill(MonarchUI.Color.divider)
                        .frame(height: 1),
                    alignment: .top
                )
            }
            .frame(width: 680)
            .background(MonarchUI.Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
            )
            .shadow(color: SwiftUI.Color.black.opacity(0.4), radius: 32, y: 16)
            .onAppear {
                if let url = record.outputURL, let image = NSImage(contentsOf: url) {
                    loadedThumbnail = image
                }
            }
        }
    }
}
