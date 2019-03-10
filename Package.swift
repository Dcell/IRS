// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRS",
    products: [
        .executable(name: "IRS", targets: ["IRS"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.1.1"),
        .package(url: "https://github.com/jatoben/CommandLine.git", from: "3.0.0-pre1"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "IRS_GUI",
            dependencies: []),
        .target(
            name: "IRSProcess",
            dependencies: []),
        .target(
            name: "IRSSecurity",
            dependencies: ["IRSProcess"]),
        .target(
            name: "IRS",
            dependencies: ["IRSSecurity","Rainbow","CommandLine","IRSProcess","Yams"]),
    ]
)
