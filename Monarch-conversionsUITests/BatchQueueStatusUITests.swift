import XCTest

final class BatchQueueStatusUITests: XCTestCase {
    private var app: XCUIApplication?

    @MainActor
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    override func tearDownWithError() throws {
        app?.terminate()
        app = nil
    }

    @MainActor
    func testConvertSceneLaunches() throws {
        let app = launchConvertScene()

        XCTAssertTrue(app.descendants(matching: .any)["batch-dropzone"].exists)
        XCTAssertTrue(app.buttons["browse-files-button"].exists)
        XCTAssertTrue(app.buttons["nav-convert"].exists)
    }

    @MainActor
    func testStatusBadgeAccessibilityIdentifiers() throws {
        let app = launchConvertScene()

        let convertingBadge = app.descendants(matching: .any)["status-converting"]
        let doneBadge = app.descendants(matching: .any)["status-done"]
        let failedBadge = app.descendants(matching: .any)["status-failed"]
        let revealButton = app.buttons["reveal-in-finder-button"]

        XCTAssertTrue(app.descendants(matching: .any)["batch-queue"].exists)
        XCTAssertFalse(
            convertingBadge.exists || doneBadge.exists || failedBadge.exists || revealButton.exists,
            "Status badges and reveal buttons should not be visible with an empty queue"
        )
    }

    @MainActor
    private func launchConvertScene() -> XCUIApplication {
        let app = XCUIApplication()
        self.app = app
        app.launchArguments += ["-ui-testing-convert"]
        app.launch()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5), "App should launch in the foreground")

        let dropzone = app.descendants(matching: .any)["batch-dropzone"]
        XCTAssertTrue(dropzone.waitForExistence(timeout: 5), "Convert scene should be visible on launch")

        return app
    }
}
