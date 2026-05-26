import XCTest
@testable import MarkdownPreviewCore

final class PreviewGenerationGateTests: XCTestCase {
    func testOnlyLatestPreviewGenerationIsCurrent() {
        var gate = PreviewGenerationGate()

        let first = gate.startNewRequest()
        XCTAssertTrue(gate.isCurrent(first))

        let second = gate.startNewRequest()
        XCTAssertFalse(gate.isCurrent(first))
        XCTAssertTrue(gate.isCurrent(second))
    }
}
