import PackageDescription

let package = Package(
    name: "DataURI",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
    ]
)
