// swift-tools-version: 6.0

import PackageDescription

let useLocalFramework = false
let binaryTarget: Target

if useLocalFramework {
    binaryTarget = .binaryTarget(
        name: "QueueFileRS",
        path: "./build/libqueuefile-rs.xcframework"
    )
} else {
    let releaseTag = "0.1.3"
    let releaseChecksum = "cb0714a9c2d72e8aae6a88ee2bf64cdd3b91e0160fd741c99a35dff52ceb9ea0"
    binaryTarget = .binaryTarget(
        name: "QueueFileRS",
        url:
        "https://github.com/lhr0909/QueueFile.swift/releases/download/\(releaseTag)/libqueuefile-rs.xcframework.zip",
        checksum: releaseChecksum
    )
}

let package = Package(
    name: "QueueFileSwift",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "QueueFileSwift",
            targets: ["QueueFileSwift"]
        ),
    ],
    targets: [
        binaryTarget,
        .target(
            name: "QueueFileSwift",
            dependencies: ["QueueFileFFI"]
        ),
        .target(
            name: "QueueFileFFI",
            dependencies: ["QueueFileRS"]
        ),
        .testTarget(
            name: "QueueFileSwiftTests",
            dependencies: ["QueueFileSwift"]
        ),
    ]
)
