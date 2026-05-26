public struct PreviewGenerationGate {
    private var latestGeneration = 0

    public init() {}

    public mutating func startNewRequest() -> Int {
        latestGeneration += 1
        return latestGeneration
    }

    public func isCurrent(_ generation: Int) -> Bool {
        generation == latestGeneration
    }
}
