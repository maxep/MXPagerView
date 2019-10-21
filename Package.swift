// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "MXPagerView",
    platforms: [.iOS(.v7)],
    products: [
        .library(name: "MXPagerView",
                 targets: ["MXPagerView"])
    ],
    targets: [
        .target(
            name: "MXPagerView",
            path: "MXPagerView"
        )
    ],
    swiftLanguageVersions: [.v5,.v4]
)
