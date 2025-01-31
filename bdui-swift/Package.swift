// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "bdui-swift",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "bdui-swift",
            targets: ["bdui-swift"]
        ),
        .library(
            name: "bdui-swift-tests",
            targets: ["bdui-swift-tests"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/google/flatbuffers.git", exact: .init(stringLiteral: "24.12.23"))
    ],
    targets: [
        .target(
            name: "bdui-swift",
            dependencies: [
                .product(name: "FlatBuffers", package: "flatbuffers"),
                "bdui-swift-resources"
            ],
            path: "Sources/bdui-swift"
        ),
        .target(
            name: "bdui-swift-resources",
            dependencies: [
                .product(name: "FlatBuffers", package: "flatbuffers")
            ],
            path: "Resources/",
            resources: [
                .process("Button.fbs"),
                .process("StackView.fbs")
            ]
        ),
        .testTarget(
            name: "bdui-swift-tests",
            dependencies: [
                "bdui-swift",
                "bdui-swift-resources"
            ],
            path: "Tests/bdui-swift-tests"
        )
    ]
)
