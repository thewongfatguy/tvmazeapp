// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TvMazeAppLib",
  platforms: [.iOS(.v13)],
  products: [
    .library(name: "ApiClient", targets: ["ApiClient"]),
    .library(name: "EpisodesFeature", targets: ["EpisodesFeature"]),
    .library(name: "ShowFeature", targets: ["ShowFeature"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
  ],
  dependencies: [
    .package(
      name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      from: "1.8.1"),
    .package(
      name: "swift-tagged", url: "https://github.com/pointfreeco/swift-tagged", from: "0.5.0"),
    .package(url: "https://github.com/roberthein/TinyConstraints", from: "4.0.0"),
    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "6.0.0"),
    .package(url: "https://github.com/apple/swift-log", from: "1.4.2"),
  ],
  targets: [
    // ApiClient
    .target(
      name: "ApiClient",
      dependencies: [
        .product(name: "Logging", package: "swift-log"),
        "Models",
        "Helpers",
      ]
    ),
    .testTarget(
      name: "ApiClientTests",
      dependencies: ["ApiClient", "SnapshotTesting"],
      exclude: [
        "__Snapshots__"
      ]
    ),

    // AppEnvironment
    .target(name: "AppEnvironment", dependencies: ["ApiClient"]),

    // AppFeature
    .target(
      name: "AppFeature",
      dependencies: [
        "L10n",
        "ShowFeature",
        "EpisodesFeature",
        "ApiClient",
        "TinyConstraints",
        "Kingfisher",
        "Helpers",
      ]
    ),

    // EpisodesFeature
    .target(
      name: "EpisodesFeature",
      dependencies: [
        "L10n",
        "ApiClient",
        "AppEnvironment",
        "TinyConstraints",
        "Kingfisher",
        "Helpers",
      ]
    ),

    // Helpers
    .target(
      name: "Helpers",
      dependencies: [
        "TinyConstraints",
        .product(name: "Logging", package: "swift-log"),
      ]
    ),
    .testTarget(name: "HelpersTests", dependencies: ["Helpers"]),

    .target(
      name: "L10n",
      resources: [
        .process("L10n.strings")
      ]
    ),

    // Models
    .target(
      name: "Models",
      dependencies: [
        .product(name: "Tagged", package: "swift-tagged")
      ]
    ),

    // ShowFeature
    .target(
      name: "ShowFeature",
      dependencies: [
        "L10n",
        "ApiClient",
        "AppEnvironment",
        "TinyConstraints",
        "Kingfisher",
        "Helpers",
      ]
    ),
    .testTarget(
      name: "ShowFeatureTests",
      dependencies: ["ShowFeature", "TestSupport", "AppEnvironment"]
    ),

    // TestSupport
    .target(name: "TestSupport", dependencies: ["ApiClient"]),
  ]
)
