import SwiftUI
import SwiftData

struct ConversionsTableView: View {
    @Query(sort: \ConversionRecord.timestamp, order: .reverse) private var records: [ConversionRecord]
    @State private var filterState = TableFilterState()
    var searchText: String = ""
    var onSelectRecord: ((ConversionRecord) -> Void)? = nil
    
    private var filteredRecords: [ConversionRecord] {
        var state = filterState
        state.searchText = searchText
        return records.filtered(with: state)
    }

    private var availableProjects: [String] {
        Array(Set(records.map { $0.project })).sorted()
    }

    var body: some View {
        VStack(spacing: 0) {
            // Table Controls & Filters
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(MonarchUI.Color.statusGreen)
                        .frame(width: 7, height: 7)
                        .shadow(color: MonarchUI.Color.statusGreenGlow, radius: 2)
                    
                    Text("table.active_conversions", tableName: "Conversions")
                        .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    // Status Filter
                    Menu {
                        Button("Status: All") { filterState.status = nil }
                        Button("Status: Working") { filterState.status = .working }
                        Button("Status: Done") { filterState.status = .done }
                    } label: {
                        FilterLabel(title: "Status: \(filterState.status?.rawValue ?? "All")")
                    }
                    .menuStyle(.borderlessButton)

                    // Input Format Filter
                    Menu {
                        Button("Input: All") { filterState.inputFormat = nil }
                        ForEach(ImageFormat.allCases, id: \.self) { fmt in
                            Button(fmt.rawValue) { filterState.inputFormat = fmt }
                        }
                    } label: {
                        FilterLabel(title: "Input: \(filterState.inputFormat?.rawValue ?? "All")")
                    }
                    .menuStyle(.borderlessButton)

                    // Output Format Filter
                    Menu {
                        Button("Output: All") { filterState.outputFormat = nil }
                        ForEach(ImageFormat.outputEligibleCases, id: \.self) { fmt in
                            Button(fmt.rawValue) { filterState.outputFormat = fmt }
                        }
                    } label: {
                        FilterLabel(title: "Output: \(filterState.outputFormat?.rawValue ?? "All")")
                    }
                    .menuStyle(.borderlessButton)

                    // Project Filter
                    Menu {
                        Button("Project: All") { filterState.project = nil }
                        ForEach(availableProjects, id: \.self) { proj in
                            Button(proj) { filterState.project = proj }
                        }
                    } label: {
                        FilterLabel(title: "Project: \(filterState.project ?? "All")")
                    }
                    .menuStyle(.borderlessButton)

                    // Reset Button
                    Button {
                        filterState.reset()
                    } label: {
                        Text("table.reset", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 13, weight: filterState.isActive ? .semibold : .regular))
                            .foregroundStyle(filterState.isActive ? MonarchUI.Color.accentViolet : MonarchUI.Color.textMuted)
                    }
                    .disabled(!filterState.isActive)
                    .buttonStyle(.plain)
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
                Text("table.col_status", tableName: "Conversions")
                    .frame(width: 137, alignment: .leading)
                Text("table.col_file_id", tableName: "Conversions")
                    .frame(width: 115, alignment: .leading)
                Text("table.col_file_name", tableName: "Conversions")
                    .frame(width: 274, alignment: .leading)
                Text("table.col_dimensions", tableName: "Conversions")
                    .frame(width: 235, alignment: .leading)
                Text("table.col_output", tableName: "Conversions")
                    .frame(width: 274, alignment: .leading)
                Text("table.col_project", tableName: "Conversions")
                    .frame(width: 170, alignment: .leading)
                Text("table.col_added", tableName: "Conversions")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(MonarchUI.Font.sans(size: 11, weight: .semibold))
            .foregroundStyle(MonarchUI.Color.textSubtle)
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
                    ForEach(Array(filteredRecords.enumerated()), id: \.element.id) { index, record in
                        TableRowView(record: record, isEven: index % 2 == 0) {
                            onSelectRecord?(record)
                        }
                    }
                }
            }
        }
        .padding(.top, 64)
    }
}

private struct FilterLabel: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(MonarchUI.Font.sans(size: 13))
            .foregroundStyle(MonarchUI.Color.textMuted)
    }
}

private struct TableRowView: View {
    let record: ConversionRecord
    let isEven: Bool
    var onSelect: (() -> Void)? = nil
    
    var rowBackground: SwiftUI.Color {
        if record.status == .working {
            return isEven ? MonarchUI.Color.rowWorkingBg : MonarchUI.Color.rowAlternateBg
        } else {
            return isEven ? MonarchUI.Color.rowEvenBg : MonarchUI.Color.rowAlternateBg
        }
    }
    
    var body: some View {
        Button {
            onSelect?()
        } label: {
            HStack(spacing: 0) {
                // Status Pill
                HStack {
                    if record.status == .working {
                        HStack(spacing: 4) {
                            Text("status.working", tableName: "Conversions")
                                .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                                .foregroundStyle(MonarchUI.Color.accentVioletBg)
                        }
                        .frame(width: 73, height: 25)
                        .background(MonarchUI.Color.accentViolet)
                        .clipShape(Capsule())
                    } else {
                        HStack(spacing: 4) {
                            Text("status.done", tableName: "Conversions")
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
                    Text(record.inputFormat.rawValue.uppercased())
                        .font(MonarchUI.Font.sans(size: 8, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                        .frame(width: 20, height: 20)
                        .background(MonarchUI.Color.badgeGrayBg)
                    
                    Text(record.fileName)
                        .font(MonarchUI.Font.sans(size: 13))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                .frame(width: 274, alignment: .leading)
                
                // Dimensions
                Text(ConversionFormatting.dimensions(record.dimensions))
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                    .frame(width: 235, alignment: .leading)
                
                // Output
                HStack(spacing: 9) {
                    Text(String(record.outputFormat.rawValue.prefix(1)).uppercased())
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                        .frame(width: 20, height: 20)
                        .background(MonarchUI.Color.badgeGrayBg)
                    
                    Text("\(record.outputFormat.rawValue) · \(ConversionFormatting.byteSize(record.outputSizeBytes))")
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
        .buttonStyle(.plain)
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
