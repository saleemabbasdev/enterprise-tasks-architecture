import DomainContracts

public final class NullLogger: Logging, @unchecked Sendable {
    public init() {}
    public func info(_ message: String) {}
    public func error(_ error: Error, context: String) {}
}
