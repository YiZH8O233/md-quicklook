import Foundation
import XCTest
@testable import MarkdownPreviewCore

final class LocalImageResolverTests: XCTestCase {
    func testResolvesExistingRelativeImage() throws {
        let directory = try Self.makeTemporaryDirectory()
        let imageDirectory = directory.appendingPathComponent("images", isDirectory: true)
        try FileManager.default.createDirectory(at: imageDirectory, withIntermediateDirectories: true)
        let markdownURL = directory.appendingPathComponent("note.md")
        let imageURL = imageDirectory.appendingPathComponent("diagram.png")
        try Data([0x89, 0x50, 0x4E, 0x47]).write(to: imageURL)

        let result = LocalImageResolver(markdownFileURL: markdownURL).resolve("images/diagram.png")

        XCTAssertEqual(result, .local(imageURL.standardizedFileURL))
    }

    func testRejectsRemoteImages() throws {
        let directory = try Self.makeTemporaryDirectory()
        let markdownURL = directory.appendingPathComponent("note.md")

        XCTAssertEqual(
            LocalImageResolver(markdownFileURL: markdownURL).resolve("https://example.com/a.png"),
            .remoteRejected("https://example.com/a.png")
        )
    }

    func testReportsMissingImages() throws {
        let directory = try Self.makeTemporaryDirectory()
        let markdownURL = directory.appendingPathComponent("note.md")

        XCTAssertEqual(
            LocalImageResolver(markdownFileURL: markdownURL).resolve("missing.png"),
            .missing("missing.png")
        )
    }

    func testRejectsParentDirectoryTraversal() throws {
        let directory = try Self.makeTemporaryDirectory()
        let markdownURL = directory.appendingPathComponent("note.md")

        XCTAssertEqual(
            LocalImageResolver(markdownFileURL: markdownURL).resolve("../outside.png"),
            .missing("../outside.png")
        )
    }

    private static func makeTemporaryDirectory() throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
