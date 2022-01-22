// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlaygroundTester",
    platforms: [
      .iOS(.v15)
    ],
    products: [

        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PlaygroundTester",
            targets: ["PlaygroundTester"]),
    ],
    dependencies: [
      .package(name: "Difference", url: "https://github.com/krzysztofzablocki/Difference.git", .branch("master")),
    ],
    targets: [
      // Targets are the basic building blocks of a package. A target can define a module or a test suite.
      // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PlaygroundTester",
            dependencies: ["Difference"],
            path: "PlaygroundTester/Sources/PlaygroundTester",
            exclude: ["../../../PlaygroundTesterDemoApp"],
            swiftSettings: [.define("TESTING_ENABLED", .when(configuration: .debug))]),
        .testTarget(
            name: "PlaygroundTesterTests",
            dependencies: ["PlaygroundTester"],
            path: "PlaygroundTester/Tests/PlaygroundTesterTests"),
    ]
)
