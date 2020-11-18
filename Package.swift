// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Draw",
  products: [
    .executable(
      name: "Draw",
      targets: ["Draw"]),
  ],
  dependencies: [
    .package(url: "https://github.com/jpsim/Yams", from: "4.0.0"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
  ],
  targets: [
    .target(
      name: "Draw",
      dependencies: [
        "Yams",
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]
    ),
    .testTarget(
      name: "DrawTests",
      dependencies: ["Draw"]
    ),
  ]
)
