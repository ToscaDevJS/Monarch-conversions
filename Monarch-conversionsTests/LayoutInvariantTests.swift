import Testing
import SwiftUI
@testable import Monarch_conversions

@Suite struct LayoutInvariantTests {
    @Test func settingsSurfaceFitsMinimumWindowWidth() {
        let requiredWidth = MonarchUI.Layout.scenePadding * 2
            + MonarchUI.Layout.Settings.requiredWidth

        #expect(requiredWidth <= MonarchUI.Layout.minWindowWidth)
    }

    @Test func tableContentWidthMatchesColumns() {
        let expectedFixedTotal = MonarchUI.Layout.TableColumn.status
            + MonarchUI.Layout.TableColumn.fileID
            + MonarchUI.Layout.TableColumn.fileName
            + MonarchUI.Layout.TableColumn.dimensions
            + MonarchUI.Layout.TableColumn.output
            + MonarchUI.Layout.TableColumn.project

        #expect(MonarchUI.Layout.TableColumn.fixedTotal == expectedFixedTotal)
        #expect(MonarchUI.Layout.TableColumn.fixedTotal == 1205)

        let expectedContentWidth = expectedFixedTotal
            + MonarchUI.Layout.TableColumn.addedMinWidth
            + MonarchUI.Layout.TableColumn.horizontalPadding * 2

        #expect(MonarchUI.Layout.TableColumn.contentWidth == expectedContentWidth)
        #expect(MonarchUI.Layout.TableColumn.contentWidth == 1349)
    }

    @Test func dashboardViewportRequiresHorizontalScrollToFitMinimumWindow() {
        // The table's content width (1349pt) exceeds the window floor (1180pt).
        // This proves that horizontal scrolling is strictly required to reach all columns.
        #expect(MonarchUI.Layout.TableColumn.contentWidth > MonarchUI.Layout.minWindowWidth)

        // The outer dashboard container adds only scene padding; because the table
        // scrolls horizontally inside that viewport, the surface fits the window floor.
        let nonScrollableFloor = MonarchUI.Layout.scenePadding * 2
        #expect(nonScrollableFloor <= MonarchUI.Layout.minWindowWidth)
    }

    @Test func convertSurfaceFitsMinimumWindowWidth() {
        let requiredWidth = MonarchUI.Layout.scenePadding * 2
            + MonarchUI.Layout.Convert.leftColumnMin
            + MonarchUI.Layout.Convert.columnGap
            + MonarchUI.Layout.Convert.compactSettingsWidth

        #expect(requiredWidth <= MonarchUI.Layout.minWindowWidth)
        #expect(requiredWidth == 1046)
    }

    @Test func outputSettingsCompactLayoutMatchesDeclaredWidth() {
        let expectedInnerWidth = MonarchUI.Layout.Convert.formatBoxWidth
            + MonarchUI.Layout.Convert.qualityBoxWidth
            + MonarchUI.Layout.Convert.metadataBoxWidth
            + MonarchUI.Layout.Convert.settingBoxSpacing * 2

        #expect(MonarchUI.Layout.Convert.outputSettingsCompactContentWidth == expectedInnerWidth)
        #expect(MonarchUI.Layout.Convert.outputSettingsCompactContentWidth == 550)

        let expectedPaddedWidth = expectedInnerWidth
            + MonarchUI.Layout.Convert.outputSettingsHorizontalPadding * 2

        #expect(MonarchUI.Layout.Convert.compactSettingsWidth == expectedPaddedWidth)
        #expect(MonarchUI.Layout.Convert.compactSettingsWidth == 586)
    }
}
