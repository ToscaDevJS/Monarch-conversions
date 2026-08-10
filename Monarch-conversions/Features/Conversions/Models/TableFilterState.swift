import Foundation

struct TableFilterState: Equatable, Sendable {
    var status: ConversionStatus?
    var inputFormat: ImageFormat?
    var outputFormat: ImageFormat?
    var project: String?
    var searchText: String = ""

    init(
        status: ConversionStatus? = nil,
        inputFormat: ImageFormat? = nil,
        outputFormat: ImageFormat? = nil,
        project: String? = nil,
        searchText: String = ""
    ) {
        self.status = status
        self.inputFormat = inputFormat
        self.outputFormat = outputFormat
        self.project = project
        self.searchText = searchText
    }

    var isActive: Bool {
        status != nil || inputFormat != nil || outputFormat != nil || project != nil || !searchText.isEmpty
    }

    mutating func reset() {
        status = nil
        inputFormat = nil
        outputFormat = nil
        project = nil
        searchText = ""
    }
}

extension Sequence where Element == ConversionRecord {
    func filtered(with state: TableFilterState) -> [ConversionRecord] {
        filter { record in
            if let status = state.status, record.status != status {
                return false
            }
            if let inputFormat = state.inputFormat, record.inputFormat != inputFormat {
                return false
            }
            if let outputFormat = state.outputFormat, record.outputFormat != outputFormat {
                return false
            }
            if let project = state.project, record.project != project {
                return false
            }
            let query = state.searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if !query.isEmpty {
                let matchesFileName = record.fileName.lowercased().contains(query)
                let matchesFileId = record.fileId.lowercased().contains(query)
                let matchesProject = record.project.lowercased().contains(query)
                let matchesInput = record.inputFormatRaw.lowercased().contains(query)
                let matchesOutput = record.outputFormatRaw.lowercased().contains(query)
                if !(matchesFileName || matchesFileId || matchesProject || matchesInput || matchesOutput) {
                    return false
                }
            }
            return true
        }
    }
}
