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
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.0.0-rc.2"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .quantiLogger
    ],
    swiftLanguageVersions: [.v5]
)

extension Target {
    static var quantiLogger: Target {
    #if os(iOS)
      return Target.target(name: "QuantiLogger",
                           dependencies: [.product(name: "RxCocoa", package: "RxSwift"),
                                          .product(name: "RxSwift", package: "RxSwift")],
                           path: "QuantiLogger",
                           sources: ["common", "ios"])
    #else
      return Target.target(name: "QuantiLogger",
                           dependencies: [.product(name: "RxCocoa", package: "RxSwift"),
                                          .product(name: "RxSwift", package: "RxSwift")],
                           path: "QuantiLogger",
                           sources: ["common"])
    #endif
  }
}
