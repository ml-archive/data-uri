// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "DataURI",
    products: [
        .library(name: "DataURI", targets: ["DataURI"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
    ],
    targets: [
        .target(
        name: "DataURI",
        dependencies: ["Vapor"],
        path: "Sources"
        ),
        .testTarget(
        name: "DataUIRTests",
        dependencies: ["DataURI"],
        path: "Tests"
        )
    ]

)
