import XCTest
@testable import MarkdownPreviewCore

final class PreviewLimitsTests: XCTestCase {
    func testUsesStyledPreviewBelowOrAtLimit() {
        let limits = PreviewLimits(maxStyledBytes: 1024)

        XCTAssertFalse(limits.shouldUseSimplifiedPreview(fileSize: 512))
        XCTAssertFalse(limits.shouldUseSimplifiedPreview(fileSize: 1024))
        XCTAssertEqual(limits.previewMode(fileSize: 512), .styledMarkdown)
        XCTAssertEqual(limits.previewMode(fileSize: 1024), .styledMarkdown)
    }

    func testUsesSimplifiedPreviewAboveLimit() {
        let limits = PreviewLimits(maxStyledBytes: 1024)

        XCTAssertTrue(limits.shouldUseSimplifiedPreview(fileSize: 2048))
        XCTAssertEqual(limits.previewMode(fileSize: 2048), .plainText)
    }
}
