import AppKit
import UniformTypeIdentifiers

@MainActor
public struct ImageFilePicker {
    public static func pickFiles(allowedContentTypes: [UTType] = ImageImportService.allowedContentTypes) -> [URL] {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = allowedContentTypes

        let response = panel.runModal()
        if response == .OK {
            return panel.urls
        }
        return []
    }
}
