// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "JobsBrowserCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "JobsBrowserCore", targets: ["JobsBrowserCore"])
    ],
    targets: [
        .target(
            name: "JobsBrowserCore",
            path: "Sources/JobsBrowser",
            exclude: [
                "Components",
                "Views",
                "JobsBrowserApp.swift"
            ],
            sources: [
                "Models",
                "Services",
                "ViewModels"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "JobsBrowserCoreTests",
            dependencies: ["JobsBrowserCore"],
            path: "Tests/JobsBrowserTests",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
