// swift-tools-version: 6.0

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
        
        // Main Package
        .target(
            name: "Bezel"
        ),
        
        // Unit Tests
        .testTarget(
            name: "BezelTests",
            dependencies: ["Bezel"]
        )
    ]
)
