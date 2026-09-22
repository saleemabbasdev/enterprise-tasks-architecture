/// Semantic events the feature emits. The application coordinator decides
/// how these map to navigation — TasksFeature never imports another
/// feature module or a navigation/routing type directly.
public enum TasksFeatureEvent: Sendable {
    case taskSelected(id: String)
    case settingsRequested
}
