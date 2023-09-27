// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swift-emelagudev-features",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "MLDFeatures",
            targets: ["MLDFeatures"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.2.0"),
        .package(url: "https://github.com/kishikawakatsumi/swift-power-assert.git", from: "0.12.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0")
    ],
    targets: [
        .target(
            name: "MLDFeatures",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "MLDFeaturesTests",
            dependencies: [
                "MLDFeatures",
                .product(name: "PowerAssert", package: "swift-power-assert")
            ])
    ]
)
