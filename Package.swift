// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "DataURI",
    products: [
        .library(name: "DataURI", targets: ["DataURI"])
    ],
    dependencies: [],
    targets: [
        .target(
        name: "DataURI",
        dependencies: []
        ),
        .testTarget(
        name: "DataURITests",
        dependencies: ["DataURI"]
        )
    ]
)
