// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BezelKit",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .visionOS(.v1)
    ],

    products: [
        .library(
            name: "BezelKit",
            targets: ["BezelKit"]
        )
    ],

    dependencies: [
        // Add future dependencies here.
    ],

    targets: [

        // Main Library
        .target(
            name: "BezelKit",
            dependencies: [],
            path: "Sources/BezelKit",
            resources: [
                // Add package resources here if needed.
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),

        // Unit Tests
        .testTarget(
            name: "BezelKitTests",
            dependencies: ["BezelKit"],
            path: "Tests/BezelKitTests"
        )
    ],

    swiftLanguageModes: [
        .v6
    ]
)
