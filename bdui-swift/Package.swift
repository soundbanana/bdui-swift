// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "bdui-swift",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "bdui-swift",
            targets: ["bdui-swift"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/google/flatbuffers.git", branch: "master")
    ],
    targets: [
        .target(
            name: "bdui-swift",
            dependencies: [
                .product(name: "FlatBuffers", package: "flatbuffers")
            ]
        ),
    ]
)
