import Foundation

public enum ImageResolution: Equatable {
    case local(URL)
    case remoteRejected(String)
    case missing(String)
}

public struct LocalImageResolver {
    private let baseDirectory: URL
    private let fileManager: FileManager

    public init(markdownFileURL: URL, fileManager: FileManager = .default) {
        self.baseDirectory = markdownFileURL.deletingLastPathComponent().standardizedFileURL
        self.fileManager = fileManager
    }

    public func resolve(_ rawPath: String) -> ImageResolution {
        let lowercasePath = rawPath.lowercased()
        if lowercasePath.hasPrefix("http://") || lowercasePath.hasPrefix("https://") {
            return .remoteRejected(rawPath)
        }

        let candidate = baseDirectory.appendingPathComponent(rawPath).standardizedFileURL
        guard candidate.path.hasPrefix(baseDirectory.path + "/") || candidate.path == baseDirectory.path else {
            return .missing(rawPath)
        }

        return fileManager.fileExists(atPath: candidate.path) ? .local(candidate) : .missing(rawPath)
    }
}
