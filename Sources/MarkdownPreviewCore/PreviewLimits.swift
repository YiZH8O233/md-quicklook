public struct PreviewLimits {
    public enum PreviewMode: Equatable {
        case styledMarkdown
        case plainText
    }

    public let maxStyledBytes: UInt64

    public init(maxStyledBytes: UInt64 = 1_000_000) {
        self.maxStyledBytes = maxStyledBytes
    }

    public func shouldUseSimplifiedPreview(fileSize: UInt64) -> Bool {
        fileSize > maxStyledBytes
    }

    public func previewMode(fileSize: UInt64) -> PreviewMode {
        shouldUseSimplifiedPreview(fileSize: fileSize) ? .plainText : .styledMarkdown
    }
}
