// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Transmission",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
        .macCatalyst(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Transmission",
            targets: ["Transmission"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nathantannar4/Engine", from: "0.1.11"),
        .package(url: "https://github.com/nathantannar4/Turbocharger", from: "0.1.8"),
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
