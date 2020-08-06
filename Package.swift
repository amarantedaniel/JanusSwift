// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Janus",
    platforms: [
        .macOS(.v10_14), .iOS(.v13), .tvOS(.v13),
    ],
    products: [
        .library(
            name: "Janus",
            targets: ["Janus"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Janus",
            dependencies: []
        ),
        .testTarget(
            name: "JanusTests",
            dependencies: ["Janus"]
        ),
    ]
)
