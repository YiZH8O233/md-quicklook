import Foundation

public enum ImageResolution: Equatable {
    case local(URL)
    case remoteRejected(String)
    case missing(String)
}

public struct LocalImageResolver {
    private let baseDirectory: URL
    private let resolvedBaseDirectory: URL
    private let fileManager: FileManager

    public init(markdownFileURL: URL, fileManager: FileManager = .default) {
        self.baseDirectory = markdownFileURL.deletingLastPathComponent().standardizedFileURL
        self.resolvedBaseDirectory = baseDirectory.resolvingSymlinksInPath()
        self.fileManager = fileManager
    }

    public func resolve(_ rawPath: String) -> ImageResolution {
        let lowercasePath = rawPath.lowercased()
        if lowercasePath.hasPrefix("http://") || lowercasePath.hasPrefix("https://") {
            return .remoteRejected(rawPath)
        }

        let candidate = baseDirectory.appendingPathComponent(rawPath).standardizedFileURL
        let resolvedCandidate = candidate.resolvingSymlinksInPath()
        guard resolvedCandidate.path.hasPrefix(resolvedBaseDirectory.path + "/") || resolvedCandidate.path == resolvedBaseDirectory.path else {
            return .missing(rawPath)
        }

        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: candidate.path, isDirectory: &isDirectory),
              !isDirectory.boolValue else {
            return .missing(rawPath)
        }

        return .local(candidate)
    }
}
