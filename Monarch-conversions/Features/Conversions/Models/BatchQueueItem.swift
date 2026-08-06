import Foundation

struct BatchQueueItem: Identifiable {
    let id = UUID()
    let name: String
    let format: String
    let dimensions: String
    let originalSize: String
    let targetFormat: String
    let targetSize: String
    let reductionPercentage: String
    var isSelected: Bool = false
}
