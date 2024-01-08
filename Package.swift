// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Transmission",
    platforms: [
        .visionOS(.v1),
        .iOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "Transmission",
            targets: ["Transmission"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nathantannar4/Engine", from: "1.3.0"),
        .package(url: "https://github.com/nathantannar4/Turbocharger", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "Transmission",
            dependencies: [
                "Engine",
                "Turbocharger",
            ]
        )
    ]
)
