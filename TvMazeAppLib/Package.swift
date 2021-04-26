// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TvMazeAppLib",
  platforms: [.iOS(.v13)],
  products: [
    .library(name: "ApiClient", targets: ["ApiClient"]),
    .library(name: "TvMazeAppLib", targets: ["TvMazeAppLib"]),
  ],
  dependencies: [
    .package(
      name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      from: "1.8.1"),
    .package(name: "Tagged", url: "https://github.com/pointfreeco/swift-tagged", from: "0.5.0"),
    .package(url: "https://github.com/roberthein/TinyConstraints", from: "4.0.0"),
    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "6.0.0"),
    .package(url: "https://github.com/apple/swift-log", from: "1.4.2"),
  ],
  targets: [
    // ApiClient
    .target(
      name: "ApiClient", dependencies: [.product(name: "Logging", package: "swift-log"), "Models"]),
    .testTarget(
      name: "ApiClientTests",
      dependencies: ["ApiClient", "SnapshotTesting"],
      exclude: [
        "__Snapshots__"
      ]
    ),

    // AppEnvironment
    .target(name: "AppEnvironment", dependencies: ["ApiClient"]),

    // Helpers
    .target(name: "Helpers"),

    // Models
    .target(name: "Models", dependencies: ["Tagged"]),

    // ShowFeature
    .target(
      name: "ShowFeature",
      dependencies: [
        "ApiClient",
        "AppEnvironment",
        "TinyConstraints",
        "Kingfisher",
      ]
    ),
    .testTarget(
      name: "ShowFeatureTests",
      dependencies: ["TvMazeAppLib", "TestSupport"]
    ),

    // TestSupport
    .target(name: "TestSupport", dependencies: ["TvMazeAppLib", "ApiClient"]),

    // TvMazeAppLib
    .target(
      name: "TvMazeAppLib",
      dependencies: [
        "ShowFeature",
        "ApiClient",
        "TinyConstraints",
        "Kingfisher",
        "Helpers",
      ]
    ),
    //        .testTarget(
    //            name: "TvMazeAppLibTests",
    //            dependencies: ["TvMazeAppLib", "TestSupport"]),
  ]
)
