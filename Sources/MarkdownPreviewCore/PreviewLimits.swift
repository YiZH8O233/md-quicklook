public struct PreviewLimits {
    public let maxStyledBytes: UInt64

    public init(maxStyledBytes: UInt64 = 1_000_000) {
        self.maxStyledBytes = maxStyledBytes
    }

    public func shouldUseSimplifiedPreview(fileSize: UInt64) -> Bool {
        fileSize > maxStyledBytes
    }
}
