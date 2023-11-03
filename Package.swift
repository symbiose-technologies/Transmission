// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Transmission",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
        .macCatalyst(.v13),
//        .visionOS(.v1),
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
        .package(url: "https://github.com/nathantannar4/Engine", from: "1.0.0"),
        .package(url: "https://github.com/nathantannar4/Turbocharger", from: "1.0.0"),
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
