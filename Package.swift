// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Freebase",
    platforms: [
        .macOS(.v12),
        .iOS(.v13),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Freebase",
            targets: ["Freebase"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wildthink/uniqueid", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/wildthink/Runtime.git", branch: "master"),
//        .package(url: "https://github.com/ikhvorost/KeyValueCoding.git", from: "1.0.0"),
        .package(path: "/Users/jason/SwiftDevelopment/packages/SwiftSQL/"),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.9.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Freebase",
            dependencies: [
                .product(name: "UniqueID", package: "uniqueid"),
                .product(name: "Runtime", package: "Runtime"),
            ]),
        .testTarget(
            name: "FreebaseTests",
            dependencies: [
                "Freebase",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]),
    ],
    swiftLanguageVersions: [.version("5.6")]
)
