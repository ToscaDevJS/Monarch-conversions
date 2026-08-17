import SwiftUI

struct ConversionDetailModalView: View {
    let record: ConversionRecord
    let onClose: () -> Void
    @State private var copiedFeedback: Bool = false
    
    var body: some View {
        ZStack {
            // Semi-transparent Backdrop
            SwiftUI.Color.black.opacity(0.68)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }
            
            // Modal Card Box
            VStack(spacing: 0) {
                // Header Bar
                HStack {
                    HStack(spacing: 11) {
                        if record.status == .working {
                            HStack(spacing: 4) {
                                Text("status.working", tableName: "Conversions")
                                    .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                                    .foregroundStyle(MonarchUI.Color.accentVioletBg)
                            }
                            .padding(.horizontal, 10)
                            .frame(height: 25)
                            .background(MonarchUI.Color.accentViolet)
                            .clipShape(Capsule())
                        } else {
                            HStack(spacing: 4) {
                                Text("status.done", tableName: "Conversions")
                                    .font(MonarchUI.Font.sans(size: 11, weight: .medium))
                                    .foregroundStyle(MonarchUI.Color.pillDoneText)
                            }
                            .padding(.horizontal, 10)
                            .frame(height: 25)
                            .background(MonarchUI.Color.pillDoneBg)
                            .clipShape(Capsule())
                        }
                        
                        Text("Batch \(record.fileId)")
                            .font(MonarchUI.Font.mono(size: 14))
                            .foregroundStyle(MonarchUI.Color.textSecondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    
                    Spacer()
                    
                    Button(action: onClose) {
                        Text("×")
                            .font(MonarchUI.Font.sans(size: 17))
                            .foregroundStyle(MonarchUI.Color.textSubtle)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Rectangle()
                                    .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .frame(height: 74)
                .overlay(
                    Rectangle()
                        .fill(MonarchUI.Color.divider)
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                // Title Block
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text("modal.details", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 20, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                            .tracking(-0.3)
                        
                        Text("modal.queued_now", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 12))
                            .foregroundStyle(MonarchUI.Color.textMuted)
                    }
                    
                    HStack(spacing: 9) {
                        Text("modal.original_file", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 12))
                            .foregroundStyle(MonarchUI.Color.textSecondary)
                        
                        Text(record.fileName)
                            .font(MonarchUI.Font.mono(size: 12))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                        
                        Button {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(record.fileName, forType: .string)
                            copiedFeedback = true
                            Task {
                                try? await Task.sleep(nanoseconds: 1_500_000_000)
                                copiedFeedback = false
                            }
                        } label: {
                            Text(copiedFeedback ? "Copied!" : String(localized: "modal.copy_name", table: "Conversions"))
                                .font(MonarchUI.Font.sans(size: 12))
                                .foregroundStyle(copiedFeedback ? MonarchUI.Color.statusGreen : MonarchUI.Color.accentViolet)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 112)
                .overlay(
                    Rectangle()
                        .fill(MonarchUI.Color.divider)
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                // Input -> Output Row
                HStack(spacing: 0) {
                    // Input Column
                    VStack(alignment: .leading, spacing: 6) {
                        Text("modal.input", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 11, weight: .semibold))
                            .foregroundStyle(MonarchUI.Color.textSubtle)
                            .tracking(0.6)
                        
                        HStack(spacing: 9) {
                            Text(record.inputFormat.rawValue.uppercased())
                                .font(MonarchUI.Font.sans(size: 10, weight: .semibold))
                                .foregroundStyle(MonarchUI.Color.textPrimary)
                                .frame(width: 28, height: 28)
                                .background(MonarchUI.Color.badgeGrayBg)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text("\(record.inputFormat.rawValue.uppercased()) image")
                                    .font(MonarchUI.Font.sans(size: 14))
                                    .foregroundStyle(MonarchUI.Color.textPrimary)
                                Text("\(ConversionFormatting.dimensions(record.dimensions)) px")
                                    .font(MonarchUI.Font.mono(size: 11))
                                    .foregroundStyle(MonarchUI.Color.textSubtle)
                            }
                        }
                    }
                    .frame(width: 220, alignment: .leading)
                    
                    // Arrow Indicator
                    Spacer()
                    Text("────→")
                        .font(MonarchUI.Font.mono(size: 18))
                        .foregroundStyle(MonarchUI.Color.accentViolet)
                    Spacer()
                    
                    // Output Column
                    VStack(alignment: .leading, spacing: 6) {
                        Text("modal.output", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 11, weight: .semibold))
                            .foregroundStyle(MonarchUI.Color.textSubtle)
                            .tracking(0.6)
                        
                        HStack(spacing: 9) {
                            Text(String(record.outputFormat.rawValue.prefix(1).uppercased()))
                                .font(MonarchUI.Font.sans(size: 15))
                                .foregroundStyle(MonarchUI.Color.textPrimary)
                                .frame(width: 28, height: 28)
                                .background(MonarchUI.Color.badgeGrayBg)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text("\(record.outputFormat.rawValue) image")
                                    .font(MonarchUI.Font.sans(size: 14))
                                    .foregroundStyle(MonarchUI.Color.textPrimary)
                                Text("Quality 82 · \(ConversionFormatting.byteSize(record.outputSizeBytes))")
                                    .font(MonarchUI.Font.mono(size: 11))
                                    .foregroundStyle(MonarchUI.Color.textSubtle)
                            }
                        }
                    }
                    .frame(width: 220, alignment: .leading)
                }
                .padding(.horizontal, 24)
                .frame(height: 126)
                .overlay(
                    Rectangle()
                        .fill(MonarchUI.Color.divider)
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                // Conversion Progress Block
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("modal.progress", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                        Spacer()
                        Text(record.status == .working ? "42% complete" : "100% complete")
                            .font(MonarchUI.Font.mono(size: 12))
                            .foregroundStyle(MonarchUI.Color.accentViolet)
                    }
                    
                    // Progress Bar track
                    GeometryReader { pGeo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(MonarchUI.Color.divider)
                            Rectangle()
                                .fill(MonarchUI.Color.accentViolet)
                                .frame(width: record.status == .working ? pGeo.size.width * 0.42 : pGeo.size.width)
                        }
                    }
                    .frame(height: 6)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("modal.upload_verified", tableName: "Conversions")
                                .font(MonarchUI.Font.sans(size: 11))
                                .foregroundStyle(MonarchUI.Color.textSecondary)
                            Text("modal.complete", tableName: "Conversions")
                                .font(MonarchUI.Font.sans(size: 12))
                                .foregroundStyle(MonarchUI.Color.textPrimary)
                        }
                        .frame(width: 220, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("modal.encoding", tableName: "Conversions")
                                .font(MonarchUI.Font.sans(size: 11))
                                .foregroundStyle(MonarchUI.Color.textSecondary)
                            Text(record.status == .working ? String(localized: "modal.in_progress", table: "Conversions") : String(localized: "modal.complete", table: "Conversions"))
                                .font(MonarchUI.Font.sans(size: 12))
                                .foregroundStyle(MonarchUI.Color.textPrimary)
                        }
                        .frame(width: 220, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("modal.optimize_save", tableName: "Conversions")
                                .font(MonarchUI.Font.sans(size: 11))
                                .foregroundStyle(MonarchUI.Color.textSecondary)
                            Text(record.status == .working ? String(localized: "modal.waiting", table: "Conversions") : String(localized: "modal.complete", table: "Conversions"))
                                .font(MonarchUI.Font.sans(size: 12))
                                .foregroundStyle(record.status == .working ? MonarchUI.Color.textMuted : MonarchUI.Color.textPrimary)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                .frame(height: 145)
                .overlay(
                    Rectangle()
                        .fill(MonarchUI.Color.divider)
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                // Conversion Settings Box
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("modal.settings", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                        Spacer()
                        Text("\(record.outputFormat.rawValue) · Quality 82")
                            .font(MonarchUI.Font.mono(size: 11))
                            .foregroundStyle(MonarchUI.Color.textSecondary)
                    }
                    
                    HStack {
                        Text("Keep original size · Strip metadata · \(record.outputFormat.rawValue) output")
                            .font(MonarchUI.Font.mono(size: 11))
                            .foregroundStyle(MonarchUI.Color.textSubtle)
                    }
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 34)
                    .background(MonarchUI.Color.searchBg)
                    .overlay(
                        Rectangle()
                            .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 24)
                .frame(height: 105)
                .overlay(
                    Rectangle()
                        .fill(MonarchUI.Color.divider)
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                // Action Buttons Bar
                HStack(spacing: 12) {
                    Button {
                        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: NSHomeDirectory())
                    } label: {
                        Text("modal.open_original", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                            .frame(width: 138, height: 36)
                            .overlay(
                                Rectangle()
                                    .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: onClose) {
                        Text("modal.close", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 13, weight: .semibold))
                            .foregroundStyle(MonarchUI.Color.accentVioletBg)
                            .frame(width: 84, height: 36)
                            .background(MonarchUI.Color.accentViolet)
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(.cancelAction)
                    
                    Spacer()
                    
                    Text("modal.esc_hint", tableName: "Conversions")
                        .font(MonarchUI.Font.mono(size: 11))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
                .padding(.horizontal, 24)
                .frame(height: 74)
            }
            .frame(width: 760)
            .background(MonarchUI.Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
            )
            .shadow(color: SwiftUI.Color.black.opacity(0.35), radius: 40, y: 24)
        }
    }
}
