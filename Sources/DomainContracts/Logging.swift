public protocol Logging: Sendable {
    func info(_ message: String)
    func error(_ error: Error, context: String)
}
