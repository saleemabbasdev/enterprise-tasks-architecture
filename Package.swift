// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "EnterpriseTasksArchitecture",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "DomainContracts", targets: ["DomainContracts"]),
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        .library(name: "TasksFeature", targets: ["TasksFeature"]),
        .executable(name: "TasksApp", targets: ["App"])
    ],
    targets: [
        .target(name: "DomainContracts"),

        .target(
            name: "Networking",
            dependencies: ["DomainContracts"]
        ),

        .target(name: "DesignSystem"),

        .target(
            name: "TasksFeature",
            dependencies: ["DomainContracts", "DesignSystem"]
        ),

        .target(
            name: "TestSupport",
            dependencies: ["DomainContracts"]
        ),

        .executableTarget(
            name: "App",
            dependencies: ["DomainContracts", "Networking", "TasksFeature"]
        ),

        .testTarget(
            name: "DomainContractsTests",
            dependencies: ["DomainContracts"]
        ),

        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking", "TestSupport", "DomainContracts"]
        ),

        .testTarget(
            name: "TasksFeatureTests",
            dependencies: ["TasksFeature", "TestSupport", "DomainContracts"]
        )
    ]
)
