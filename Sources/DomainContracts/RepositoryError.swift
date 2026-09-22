public enum RepositoryError: Error, Sendable {
    case notFound
    case network(message: String)
    case decoding(message: String)
}
