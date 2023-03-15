// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Auth",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Auth",
            targets: ["Auth"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MalyshevMaksim/CommonUI", from: "0.0.2"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.1.3")
    ],
    targets: [
        .target(
            name: "Auth",
            dependencies: ["CommonUI", "SnapKit",
                .product(name: "Lottie", package: "lottie-spm")
            ]
        ),
        .testTarget(
            name: "AuthTests",
            dependencies: ["Auth"]),
    ]
)
