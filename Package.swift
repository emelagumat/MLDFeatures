// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MLDFeatures",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "MLDFeatures",
            targets: ["RemoteImage"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.2.0"),
        .package(url: "https://github.com/kishikawakatsumi/swift-power-assert.git", from: "0.12.0")
    ],
    targets: [
        .target(
            name: "RemoteImage", 
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "PowerAssert", package: "swift-power-assert")
            ]
        ),
        .testTarget(
            name: "MLDFeaturesTests",
            dependencies: ["RemoteImage"]),
    ]
)
