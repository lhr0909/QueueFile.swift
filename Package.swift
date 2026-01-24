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
    let releaseTag = "0.1.2"
    let releaseChecksum = "24fc0eff75a343b06433c931a16a98447de25e82406dfecde8634144f4baf876"
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
