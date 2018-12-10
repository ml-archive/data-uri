// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "DataURI",
    products: [
        .library(name: "DataURI", targets: ["DataURI"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/core.git", from: "3.0.0"),
    ],
    targets: [
        .target(
        name: "DataURI",
        dependencies: ["Core"]
        ),
        .testTarget(
        name: "DataURITests",
        dependencies: ["DataURI"]
        )
    ]
)
