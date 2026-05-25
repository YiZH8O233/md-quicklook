import Foundation
import XCTest
@testable import MarkdownPreviewCore

final class MarkdownFileReaderTests: XCTestCase {
    func testReadsUTF8Text() throws {
        let directory = try Self.makeTemporaryDirectory()
        let fileURL = directory.appendingPathComponent("note.md")
        try "# Hello".data(using: .utf8)?.write(to: fileURL)

        XCTAssertEqual(try MarkdownFileReader().readText(from: fileURL), "# Hello")
    }

    func testFallsBackToMacOSRomanText() throws {
        let directory = try Self.makeTemporaryDirectory()
        let fileURL = directory.appendingPathComponent("legacy.md")
        let text = "Café"
        try XCTUnwrap(text.data(using: .macOSRoman)).write(to: fileURL)

        XCTAssertEqual(try MarkdownFileReader().readText(from: fileURL), text)
    }

    private static func makeTemporaryDirectory() throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
