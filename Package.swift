// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuantiLogger",
    platforms: [
        .iOS(.v12), .macOS(.v10_12)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "QuantiLogger",
            targets: ["QuantiLogger"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.1.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "QuantiLogger",
                dependencies: [.product(name: "RxCocoa", package: "RxSwift"),
                               .product(name: "RxSwift", package: "RxSwift")],
                path: "QuantiLogger",
                exclude: ["ios/Info.plist", "mac/InfoMac.plist"]
        ),
        .target(name: "QuantiLoggerExample",
                dependencies: [.product(name: "RxCocoa", package: "RxSwift"),
                               .product(name: "RxSwift", package: "RxSwift"),
                               .target(name: "QuantiLogger")],
                path: "QuantiLoggerExample"
        ),
        .testTarget(name: "QuantiLoggerTests",
                    dependencies: [.target(name: "QuantiLogger")],
                    path: "QuantiLoggerTests")
    ],
    swiftLanguageVersions: [.v5]
)
