import Testing
import Foundation
@testable import Monarch_conversions

@Suite struct ProjectConfigurationTests {
    private var projectRootURL: URL {
        URL(fileURLWithPath: #file)
            .deletingLastPathComponent() // Monarch-conversionsTests
            .deletingLastPathComponent() // Project Root
    }

    @Test func pbxprojDoesNotContainInvalidDeploymentTarget() throws {
        let pbxprojURL = projectRootURL
            .appendingPathComponent("Monarch-conversions.xcodeproj")
            .appendingPathComponent("project.pbxproj")
        
        let content = try String(contentsOf: pbxprojURL, encoding: .utf8)
        #expect(!content.contains("MACOSX_DEPLOYMENT_TARGET = 26.5;"))
        #expect(content.contains("MACOSX_DEPLOYMENT_TARGET = 14.0;"))
    }

    @Test func pbxprojIncludesSpanishInKnownRegions() throws {
        let pbxprojURL = projectRootURL
            .appendingPathComponent("Monarch-conversions.xcodeproj")
            .appendingPathComponent("project.pbxproj")
        
        let content = try String(contentsOf: pbxprojURL, encoding: .utf8)
        #expect(content.contains("knownRegions = (\n\t\t\t\ten,\n\t\t\t\tBase,\n\t\t\t\tes,\n\t\t\t);"))
    }

    @Test func distributionScriptsExistAndAreExecutable() {
        let fileManager = FileManager.default
        let scriptNames = ["build.sh", "test.sh", "archive.sh"]

        for scriptName in scriptNames {
            let scriptURL = projectRootURL.appendingPathComponent("scripts").appendingPathComponent(scriptName)
            #expect(fileManager.fileExists(atPath: scriptURL.path), "Script \(scriptName) must exist")
            #expect(fileManager.isExecutableFile(atPath: scriptURL.path), "Script \(scriptName) must be executable")
        }
    }
}
