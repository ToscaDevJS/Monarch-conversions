import SwiftUI
import SwiftData

struct MetricsHeaderView: View {
    @Query private var records: [ConversionRecord]

    private var processedText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: records.count)) ?? "\(records.count)"
    }

    private var convertedTodayText: String {
        let todayCount = records.filter {
            $0.status == .done && Calendar.current.isDateInToday($0.timestamp)
        }.count
        return "\(todayCount)"
    }

    private var storageProcessedText: String {
        let totalOutputBytes = records.reduce(0) { $0 + $1.outputSizeBytes }
        return ConversionFormatting.byteSize(totalOutputBytes)
    }

    private var activeProjectsText: String {
        let uniqueProjects = Set(records.map { $0.project })
        return "\(uniqueProjects.count)"
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Images processed
            VStack(alignment: .leading, spacing: 5) {
                Text("metrics.processed", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textSecondary)

                Text(processedText)
                    .font(MonarchUI.Font.mono(size: 21, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            DividerLine()

            // Converted today
            VStack(alignment: .leading, spacing: 5) {
                Text("metrics.converted_today", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textSecondary)

                Text(convertedTodayText)
                    .font(MonarchUI.Font.mono(size: 21, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .padding(.leading, 24)
            .frame(maxWidth: .infinity, alignment: .leading)

            DividerLine()

            // Total Output Storage
            VStack(alignment: .leading, spacing: 5) {
                Text("Total Output", comment: "Total output bytes of conversions")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textSecondary)

                Text(storageProcessedText)
                    .font(MonarchUI.Font.mono(size: 21, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .padding(.leading, 24)
            .frame(maxWidth: .infinity, alignment: .leading)

            DividerLine()

            // Active projects
            VStack(alignment: .leading, spacing: 5) {
                Text("metrics.active_projects", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textSecondary)

                Text(activeProjectsText)
                    .font(MonarchUI.Font.mono(size: 21, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .padding(.leading, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 16)
        .padding(.top, 24)
        .overlay(
            Rectangle()
                .fill(MonarchUI.Color.divider)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

private struct DividerLine: View {
    var body: some View {
        Rectangle()
            .fill(MonarchUI.Color.divider)
            .frame(width: 1, height: 36)
    }
}

#Preview {
    MetricsHeaderView()
        .padding()
        .background(MonarchUI.Color.background)
}
