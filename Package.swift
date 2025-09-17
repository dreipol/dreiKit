// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "dreiKit",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "dreiKit",
            targets: ["dreiKit"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "dreiKit",
            dependencies: [],
            linkerSettings: [
                .linkedFramework("UIKit"),
            ]
        ),
        .testTarget(
            name: "dreiKitTests",
            dependencies: ["dreiKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
