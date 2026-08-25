// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Bezel",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Bezel",
            targets: ["Bezel"]
        )
    ],
    targets: [
        .target(
            name: "Bezel"
        ),
        .testTarget(
            name: "BezelTests",
            dependencies: ["Bezel"]
        )
    ]
)
