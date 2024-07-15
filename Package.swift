// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Transmission",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "Transmission",
            targets: ["Transmission"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nathantannar4/Engine", branch: "symbiose-1.8.3"),
        .package(url: "https://github.com/symbiose-technologies/Turbocharger", branch: "symbiose-1.3.1"),
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
