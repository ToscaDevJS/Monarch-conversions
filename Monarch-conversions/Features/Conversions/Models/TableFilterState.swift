import Foundation

struct TableFilterState: Equatable, Sendable {
    var status: ConversionStatus?
    var inputFormat: ImageFormat?
    var outputFormat: ImageFormat?
    var project: String?

    init(
        status: ConversionStatus? = nil,
        inputFormat: ImageFormat? = nil,
        outputFormat: ImageFormat? = nil,
        project: String? = nil
    ) {
        self.status = status
        self.inputFormat = inputFormat
        self.outputFormat = outputFormat
        self.project = project
    }

    var isActive: Bool {
        status != nil || inputFormat != nil || outputFormat != nil || project != nil
    }

    mutating func reset() {
        status = nil
        inputFormat = nil
        outputFormat = nil
        project = nil
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
            return true
        }
    }
}
