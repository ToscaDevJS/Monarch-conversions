import Foundation
import SwiftData

enum ConversionStatus: String, Codable {
    case working = "Working"
    case done = "Done"
}

@Model
final class ConversionRecord {
    @Attribute(.unique) var id: String
    var fileId: String
    var fileName: String
    var inputFormat: String
    var dimensions: String
    var outputFormat: String
    var outputSize: String
    var project: String
    var statusRaw: String
    var timestamp: Date

    var status: ConversionStatus {
        get { ConversionStatus(rawValue: statusRaw) ?? .working }
        set { statusRaw = newValue.rawValue }
    }

    init(
        id: String = UUID().uuidString,
        fileId: String,
        fileName: String,
        inputFormat: String,
        dimensions: String,
        outputFormat: String,
        outputSize: String,
        project: String,
        status: ConversionStatus = .working,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.fileId = fileId
        self.fileName = fileName
        self.inputFormat = inputFormat
        self.dimensions = dimensions
        self.outputFormat = outputFormat
        self.outputSize = outputSize
        self.project = project
        self.statusRaw = status.rawValue
        self.timestamp = timestamp
    }
}
