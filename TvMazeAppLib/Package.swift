// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TvMazeAppLib",
  platforms: [.iOS(.v13)],
  products: [
    .library(name: "PaginationSink", targets: ["PaginationSink"]),
    .library(name: "TvMazeAppLib", targets: ["TvMazeAppLib"]),
    .library(name: "TvMazeApiClient", targets: ["TvMazeApiClient"]),
  ],
  dependencies: [
    .package(
      name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      from: "1.8.1"),
    .package(url: "https://github.com/roberthein/TinyConstraints", from: "4.0.0"),
    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "6.0.0"),
  ],
  targets: [
    // PaginationSink
    .target(name: "PaginationSink"),
    .testTarget(name: "PaginationSinkTests", dependencies: ["PaginationSink", "TestSupport"]),

    // TestSupport
    .target(name: "TestSupport"),

    .target(
      name: "TvMazeAppLib",
      dependencies: [
        "TvMazeApiClient",
        "TinyConstraints",
        "Kingfisher",
      ]
    ),
    .testTarget(
      name: "TvMazeAppLibTests",
      dependencies: ["TvMazeAppLib"]),

    // TvMazeApiClient
    .target(name: "TvMazeApiClient"),
    .testTarget(
      name: "TvMazeApiClientTests",
      dependencies: ["TvMazeApiClient", "SnapshotTesting"]
    ),
  ]
)
