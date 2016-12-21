import PackageDescription

let package = Package(
    name: "DataURI",
    dependencies: [
        .Package(url: "https://github.com/vapor/core.git", majorVersion: 1),
    ]
)
