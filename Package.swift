// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuantiLogger",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "QuantiLogger",
            targets: ["QuantiLogger"]
        ),
        .library(
            name: "QuantiLoggerMac",
            targets: ["QuantiLoggerMac"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/marmelroy/Zip.git", .upToNextMinor(from: "2.1.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "QuantiLogger",
            dependencies: ["Zip"],
            path: "QuantiLogger/"
        ),
        .target(
            name: "QuantiLoggerMac",
            dependencies: ["Zip"],
            path: "QuantiLogger/"
        ),
        .testTarget(
            name: "QuantiLoggerTests",
            dependencies: ["Zip", QuantiLogger"],
            path: "QuantiLoggerTests/"
        ),
        .target(
            name: "QuantiLoggerExample",
            dependencies: ["Zip", "QuantiLogger"],
            path: "QuantiLoggerExample/"
        ),
        .target(
            name: "QuantiLoggerExampleUITests",
            dependencies: ["Zip", "QuantiLogger", QuantiLoggerExample"],
            path: "QuantiLoggerExampleUITests/"
        )

    ]
)
