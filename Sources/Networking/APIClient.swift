import Foundation
import DomainContracts

public protocol APIClient: Sendable {
    func get(_ path: String) async throws -> Data
    func post(_ path: String, body: Data) async throws -> Data
}

public struct APIClientConfiguration: Sendable {
    public let baseURL: URL
    public init(baseURL: URL) { self.baseURL = baseURL }

    public static let production = APIClientConfiguration(
        baseURL: URL(string: "https://api.example.com")!
    )
}

public final class URLSessionAPIClient: APIClient {
    private let configuration: APIClientConfiguration
    private let session: URLSession
    private let logger: any Logging

    public init(
        configuration: APIClientConfiguration,
        session: URLSession = .shared,
        logger: any Logging
    ) {
        self.configuration = configuration
        self.session = session
        self.logger = logger
    }

    public func get(_ path: String) async throws -> Data {
        let url = configuration.baseURL.appendingPathComponent(path)
        logger.info("GET \(url.absoluteString)")
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        return data
    }

    public func post(_ path: String, body: Data) async throws -> Data {
        let url = configuration.baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        logger.info("POST \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        try Self.validate(response)
        return data
    }

    private static func validate(_ response: URLResponse) throws {
        let status = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard (200..<300).contains(status) else {
            throw RepositoryError.network(message: "Unexpected status code \(status)")
        }
    }
}
