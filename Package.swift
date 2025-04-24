// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "DetailModule",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DetailModule",
            targets: ["DetailModule"]),
    ],
    dependencies: [
        .package(path: "../CoreModule")
    ],
    targets: [
        .target(
            name: "DetailModule",
            dependencies: [
                .product(name: "CoreModule", package: "CoreModule")
            ]),
        .testTarget(
            name: "DetailModuleTests",
            dependencies: ["DetailModule"]),
    ]
)
