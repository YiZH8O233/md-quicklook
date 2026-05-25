import XCTest
@testable import MarkdownPreviewCore

final class PreviewLimitsTests: XCTestCase {
    func testUsesStyledPreviewBelowOrAtLimit() {
        let limits = PreviewLimits(maxStyledBytes: 1024)

        XCTAssertFalse(limits.shouldUseSimplifiedPreview(fileSize: 512))
        XCTAssertFalse(limits.shouldUseSimplifiedPreview(fileSize: 1024))
    }

    func testUsesSimplifiedPreviewAboveLimit() {
        let limits = PreviewLimits(maxStyledBytes: 1024)

        XCTAssertTrue(limits.shouldUseSimplifiedPreview(fileSize: 2048))
    }
}
