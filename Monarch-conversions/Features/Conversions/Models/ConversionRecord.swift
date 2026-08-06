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
    var inputFormatRaw: String
    var pixelWidth: Int
    var pixelHeight: Int
    var outputFormatRaw: String
    var outputSizeBytes: Int64
    var project: String
    var statusRaw: String
    var timestamp: Date

    var inputFormat: ImageFormat {
        get { ImageFormat(rawValue: inputFormatRaw) ?? .png }
        set { inputFormatRaw = newValue.rawValue }
    }

    var outputFormat: ImageFormat {
        get { ImageFormat(rawValue: outputFormatRaw) ?? .png }
        set { outputFormatRaw = newValue.rawValue }
    }

    var dimensions: PixelDimensions {
        get { PixelDimensions(width: pixelWidth, height: pixelHeight) }
        set {
            pixelWidth = newValue.width
            pixelHeight = newValue.height
        }
    }

    var status: ConversionStatus {
        get { ConversionStatus(rawValue: statusRaw) ?? .working }
        set { statusRaw = newValue.rawValue }
    }

    init(
        id: String = UUID().uuidString,
        fileId: String,
        fileName: String,
        inputFormat: ImageFormat,
        dimensions: PixelDimensions,
        outputFormat: ImageFormat,
        outputSizeBytes: Int64,
        project: String,
        status: ConversionStatus = .working,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.fileId = fileId
        self.fileName = fileName
        self.inputFormatRaw = inputFormat.rawValue
        self.pixelWidth = dimensions.width
        self.pixelHeight = dimensions.height
        self.outputFormatRaw = outputFormat.rawValue
        self.outputSizeBytes = outputSizeBytes
        self.project = project
        self.statusRaw = status.rawValue
        self.timestamp = timestamp
    }
}
