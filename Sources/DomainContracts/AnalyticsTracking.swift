public protocol AnalyticsTracking: Sendable {
    func track(_ event: String, properties: [String: String])
}
