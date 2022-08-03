// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
// https://developer.apple.com/documentation/swift_packages/package

let package = Package(
    name: "hncli",

    defaultLocalization: "en",

    platforms: [
        .macOS(.v12),
//        .macOS(.v13)
    ],

    products: [
        .executable(
            name: "hncli",
            targets: ["hncli"]
        ),
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.2"),
        .package(url: "https://github.com/genedelisa/GDTerminalColor.git", from: "0.1.16"),
        //.package(url: "https://github.com/genedelisa/GDTerminalColor.git", from: "0.1.12"),

    ],

    targets: [
        .executableTarget(
            name: "hncli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "GDTerminalColor", package: "GDTerminalColor"),

            ],
            resources: [
                .process("Resources/help.txt"),
            ],

            swiftSettings: [
                // @main bug
                // https://bugs.swift.org/browse/SR-12683
                // [path]/main.swift:11:1: 'main' attribute cannot be used in a module that contains top-level code
                .unsafeFlags(["-parse-as-library"]),
                // .unsafeFlags(["-parse-as-library", "-Onone"])
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate", "-Xlinker", "__TEXT", "-Xlinker", "__info_plist", "-Xlinker",
                    "./SupportingFiles/hncli/Info.plist",
                ]),
            ]
        ),

        .testTarget(
            name: "hncliTests",
            dependencies: ["hncli"]
        ),

    ], // targets
    swiftLanguageVersions: [.v5]
)

#if swift(>=5.6)
    package.dependencies += [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ]
#endif
