// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Baraholka",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "BaraholkaCore",
            targets: ["BaraholkaCore"]
        )
    ],
    targets: [
        .target(
            name: "BaraholkaCore",
            path: "Sources/BaraholkaCore"
        ),
        .testTarget(
            name: "BaraholkaCoreTests",
            dependencies: ["BaraholkaCore"],
            path: "Tests/BaraholkaCoreTests"
        )
    ]
)
