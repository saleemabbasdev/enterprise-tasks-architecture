import os
import DomainContracts

public final class OSLogger: Logging {
    private let logger = Logger(subsystem: "com.enterprise.tasks", category: "app")

    public init() {}

    public func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    public func error(_ error: Error, context: String) {
        logger.error("\(context, privacy: .public): \(error.localizedDescription, privacy: .public)")
    }
}
