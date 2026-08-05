import SwiftUI
import SwiftData

struct ConversionsTableView: View {
    @Query(sort: \ConversionRecord.timestamp, order: .reverse) private var records: [ConversionRecord]
    
    var body: some View {
        VStack(spacing: 0) {
            // Table Controls & Filters
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(MonarchUI.Color.statusGreen)
                        .frame(width: 7, height: 7)
                        .shadow(color: MonarchUI.Color.statusGreenGlow, radius: 2)
                    
                    Text("Active conversions")
                        .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                
                Spacer()
                
                HStack(spacing: 24) {
                    FilterDropdown(title: "Status: All")
                    FilterDropdown(title: "Input: All")
                    FilterDropdown(title: "Output: All")
                    FilterDropdown(title: "Project: All")
                    
                    Button("Reset") {}
                        .buttonStyle(.plain)
                        .font(MonarchUI.Font.sans(size: 13))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
            }
            .padding(.bottom, 8)
            .frame(height: 36)
            .overlay(
                Rectangle()
                    .fill(MonarchUI.Color.divider)
                    .frame(height: 1),
                alignment: .bottom
            )
            
            // Table Header Columns
            HStack(spacing: 0) {
                Text("Status")
                    .frame(width: 137, alignment: .leading)
                Text("File ID ⓘ")
                    .frame(width: 115, alignment: .leading)
                Text("File name")
                    .frame(width: 274, alignment: .leading)
                Text("Dimensions")
                    .frame(width: 235, alignment: .leading)
                Text("Output")
                    .frame(width: 274, alignment: .leading)
                Text("Project")
                    .frame(width: 170, alignment: .leading)
                Text("Added")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(MonarchUI.Font.sans(size: 11, weight: .semibold))
            .foregroundStyle(SwiftUI.Color(hex: "#A3A3A3"))
            .padding(.horizontal, 12)
            .frame(height: 44)
            .overlay(
                Rectangle()
                    .fill(MonarchUI.Color.divider)
                    .frame(height: 1),
                alignment: .bottom
            )
            
            // Table Rows
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(records.enumerated()), id: \.element.id) { index, record in
                        TableRowView(record: record, isEven: index % 2 == 0)
                    }
                }
            }
        }
        .padding(.top, 64)
    }
}

private struct FilterDropdown: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 5) {
            Text(title)
                .font(MonarchUI.Font.sans(size: 13))
                .foregroundStyle(MonarchUI.Color.textMuted)
            Image(systemName: "chevron.down")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(MonarchUI.Color.textMuted)
        }
    }
}

private struct TableRowView: View {
    let record: ConversionRecord
    let isEven: Bool
    
    var rowBackground: SwiftUI.Color {
        if record.status == .working {
            return isEven ? MonarchUI.Color.rowWorkingBg : MonarchUI.Color.rowAlternateBg
        } else {
            return isEven ? MonarchUI.Color.rowEvenBg : MonarchUI.Color.rowAlternateBg
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Status Pill
            HStack {
                if record.status == .working {
                    HStack(spacing: 4) {
                        Text("↻ Working")
                            .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.accentVioletBg)
                    }
                    .frame(width: 73, height: 25)
                    .background(MonarchUI.Color.accentViolet)
                    .clipShape(Capsule())
                } else {
                    HStack(spacing: 4) {
                        Text("✓ Done")
                            .font(MonarchUI.Font.sans(size: 11, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.pillDoneText)
                    }
                    .frame(width: 96, height: 25)
                    .background(MonarchUI.Color.pillDoneBg)
                    .clipShape(Capsule())
                }
            }
            .frame(width: 137, alignment: .leading)
            
            // File ID
            Text(record.fileId)
                .font(MonarchUI.Font.sans(size: 13))
                .foregroundStyle(MonarchUI.Color.textMuted)
                .frame(width: 115, alignment: .leading)
            
            // File name
            HStack(spacing: 9) {
                Text(record.inputFormat.uppercased())
                    .font(MonarchUI.Font.sans(size: 8, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .background(MonarchUI.Color.badgeGrayBg)
                
                Text(record.fileName)
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
            }
            .frame(width: 274, alignment: .leading)
            
            // Dimensions
            Text(record.dimensions)
                .font(MonarchUI.Font.sans(size: 13))
                .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                .frame(width: 235, alignment: .leading)
            
            // Output
            HStack(spacing: 9) {
                Text(String(record.outputFormat.prefix(1)).uppercased())
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .background(SwiftUI.Color(hex: "#474747"))
                
                Text("\(record.outputFormat) · \(record.outputSize)")
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(MonarchUI.Color.textMuted)
            }
            .frame(width: 274, alignment: .leading)
            
            // Project
            Text(record.project)
                .font(MonarchUI.Font.sans(size: 13))
                .foregroundStyle(MonarchUI.Color.textMuted)
                .frame(width: 170, alignment: .leading)
            
            // Added
            Text(timeAgoString(from: record.timestamp))
                .font(MonarchUI.Font.sans(size: 13))
                .foregroundStyle(MonarchUI.Color.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .frame(height: 50)
        .background(rowBackground)
        .overlay(
            Rectangle()
                .fill(MonarchUI.Color.background)
                .frame(height: 1),
            alignment: .bottom
        )
    }

    private func timeAgoString(from date: Date) -> String {
        let interval = Int(Date().timeIntervalSince(date))
        if interval < 60 { return "just now" }
        let minutes = interval / 60
        return "\(minutes) min ago"
    }
}

#Preview {
    ConversionsTableView()
        .padding()
        .background(MonarchUI.Color.background)
}
