import Foundation

public struct MarkdownFileReader {
    public enum ReadError: Error, Equatable {
        case unreadable
    }

    public init() {}

    public func readText(from url: URL) throws -> String {
        let data = try Data(contentsOf: url)
        if let utf8 = String(data: data, encoding: .utf8) {
            return utf8
        }
        if let fallback = String(data: data, encoding: .macOSRoman) {
            return fallback
        }
        throw ReadError.unreadable
    }
}
