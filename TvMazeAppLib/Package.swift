// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TvMazeAppLib",
  platforms: [.iOS(.v13)],
  products: [
    .library(name: "ApiClient", targets: ["ApiClient"]),
    .library(name: "PaginationSink", targets: ["PaginationSink"]),
    .library(name: "TvMazeAppLib", targets: ["TvMazeAppLib"]),
  ],
  dependencies: [
    .package(
      name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      from: "1.8.1"),
    .package(url: "https://github.com/roberthein/TinyConstraints", from: "4.0.0"),
    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "6.0.0"),
  ],
  targets: [
    // ApiClient
    .target(name: "ApiClient"),
    .testTarget(
      name: "ApiClientTests",
      dependencies: ["ApiClient", "SnapshotTesting"]
    ),

    // PaginationSink
    .target(name: "PaginationSink"),
    .testTarget(name: "PaginationSinkTests", dependencies: ["PaginationSink", "TestSupport"]),

    // TestSupport
    .target(name: "TestSupport"),

    // TvMazeAppLib
    .target(
      name: "TvMazeAppLib",
      dependencies: [
        "ApiClient",
        "TinyConstraints",
        "Kingfisher",
      ]
    ),
    .testTarget(
      name: "TvMazeAppLibTests",
      dependencies: ["TvMazeAppLib"]),
  ]
)
