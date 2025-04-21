// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "mcp-cli-test",
    platforms: [
        .macOS("13.0"),
     ],
    products: [
        .executable(name: "mcp-cli-test", targets: ["mcp-cli-test"])
    ],
    dependencies: [
        .package(url: "https://github.com/modelcontextprotocol/swift-sdk.git", from: "0.7.1"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0")
    ],
    targets: [
        .executableTarget(
            name: "mcp-cli-test",
            dependencies: [
                .product(name: "MCP", package: "swift-sdk"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/"
        )
    ]
)
