// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HelloWorldCore",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "HelloWorldCore",
            targets: ["HelloWorldCore", "HelloWorldCoreFFI"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "HelloWorldCoreRS",
            path: "./rust/target/ios/libhelloworld-rs.xcframework"
        ),
        .target(
            name: "HelloWorldCoreFFI",
            dependencies: [.target(name: "HelloWorldCoreRS")],
            path: "Sources/HelloWorldFFI"
        ),
        .target(
            name: "HelloWorldCore",
            dependencies: [.target(name: "HelloWorldCoreFFI")],
            path: "Sources/HelloWorldCore"
        ),
    ]
)
