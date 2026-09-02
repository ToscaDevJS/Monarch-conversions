import XCTest

final class BatchQueueStatusUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testConvertSceneAndStatusBadgesAccessibility() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing-convert"]
        app.launch()

        let window = app.windows.firstMatch
        if !window.waitForExistence(timeout: 3) {
            app.typeKey("n", modifierFlags: .command)
            _ = window.waitForExistence(timeout: 5)
        }

        let navConvert = app.buttons["nav-convert"]
        if navConvert.waitForExistence(timeout: 5) {
            navConvert.click()
        }

        let dropzone = app.descendants(matching: .any)["batch-dropzone"]
        XCTAssertTrue(dropzone.waitForExistence(timeout: 5), "Convert scene should be visible on launch")
        XCTAssertTrue(app.buttons["browse-files-button"].exists)
        XCTAssertTrue(app.buttons["nav-convert"].exists)

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
}
