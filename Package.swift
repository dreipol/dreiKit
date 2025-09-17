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
        .library(
            name: "dreiKitUIKit",
            targets: ["dreiKitUIKit"]
        ),
        .library(
            name: "dreiKitLocation",
            targets: ["dreiKitLocation"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "dreiKit",
            dependencies: [],
            linkerSettings: [
                .linkedFramework("SwiftUI"),
                .linkedFramework("UIKit"),
            ]
        ),
        .target(
            name: "dreiKitUIKit",
            dependencies: [],
            linkerSettings: [
                .linkedFramework("UIKit"),
            ]
        ),
        .target(
            name: "dreiKitLocation",
            dependencies: [],
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("CoreLocation"),
            ]
        ),
        .testTarget(
            name: "dreiKitTests",
            dependencies: ["dreiKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
