// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "dreiKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "dreiKit",
            targets: ["dreiKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "dreiKit",
            dependencies: []),
        .testTarget(
            name: "dreiKitTests",
            dependencies: ["dreiKit"]),
    ],
    swiftLanguageVersions: [.v5]
)
