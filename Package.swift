// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuantiLogger",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "QuantiLogger",
            targets: ["QuantiLoggerMac"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "4.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "QuantiLoggerMac",
            dependencies: ["RxSwift", "RxCocoa"],
            path: "QuantiLogger/common"
        )
    ]
)
