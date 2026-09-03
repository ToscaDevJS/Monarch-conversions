import Testing
import Foundation
import SwiftUI
@testable import Monarch_conversions

@Suite struct ViewportGeometryTests {
    @Test func layoutConstantsDefineArithmeticValidatedWindowMinimums() {
        // minWindowHeight must be at least 700pt to support typical MacBook displays
        // and avoid clipping critical action buttons.
        #expect(MonarchUI.Layout.minWindowWidth >= 1180)
        #expect(MonarchUI.Layout.minWindowHeight >= 700)
    }

    @Test func settingsLayoutDefinesMaxContainerBoundsForWideDisplays() {
        // Prevents content from appearing as an isolated narrow column on 27" displays.
        #expect(MonarchUI.Layout.Settings.maxContainerWidth == 1280)
        #expect(MonarchUI.Layout.Settings.maxContainerWidth >= MonarchUI.Layout.Settings.requiredWidth)
    }

    @Test func convertLayoutDefinesMaxContentBoundsAndSettingBoxClamping() {
        // Clamps overall content width and prevents destination box blowout on 2560px monitors.
        #expect(MonarchUI.Layout.Convert.maxContentWidth == 1440)
        #expect(MonarchUI.Layout.Convert.destinationBoxMaxWidth == 320)
    }

    @Test func convertSceneArithmeticHeightVerification() {
        // Non-column chrome (Nav + Heading + insets + footer)
        let topNavHeight: CGFloat = 50
        let headingHeight: CGFloat = 130
        let columnTopGap: CGFloat = 24
        let scenePaddingTotal: CGFloat = MonarchUI.Layout.scenePadding * 2 // 56
        let footerHeight: CGFloat = 38
        let nonColumnChrome = topNavHeight + headingHeight + columnTopGap + scenePaddingTotal + footerHeight

        // Left column populated (Dropzone 180 + gap 20 + Queue header 18 + spacing 12 + max queue 340)
        let leftColumnFull: CGFloat = 180 + 20 + 18 + 12 + 340 // 570
        let rightColumnCompact: CGFloat = 320 + 20 + 266 // 606

        let fullContentHeight = nonColumnChrome + max(leftColumnFull, rightColumnCompact)
        #expect(fullContentHeight >= 868)

        // Verifies that at 700pt, a vertical ScrollView is strictly required to display the scene safely
        #expect(fullContentHeight > MonarchUI.Layout.minWindowHeight)
    }
}
