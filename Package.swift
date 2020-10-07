// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-composable-kit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "ComposableAudioPlayer", targets: ["ComposableAudioPlayer"]),
        .library(name: "ComposableAudioRecorder", targets: ["ComposableAudioRecorder"]),
        .library(name: "ComposableBluetoothCentralManager", targets: ["ComposableBluetoothCentralManager"]),
        .library(name: "ComposableBluetoothPeripheralManager", targets: ["ComposableBluetoothPeripheralManager"]),
        .library(name: "ComposableFast", targets: ["ComposableFast"]),
        .library(name: "ComposablePlayer", targets: ["ComposablePlayer"]),
        .library(name: "ComposableSpeechRecognizer", targets: ["ComposableSpeechRecognizer"]),
        .library(name: "ComposableSpeechSynthesizer", targets: ["ComposableSpeechSynthesizer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "ComposableAudioPlayer",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposableAudioRecorder",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposableBluetoothCentralManager",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposableBluetoothPeripheralManager",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposableFast",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposablePlayer",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposableSpeechRecognizer",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposableSpeechSynthesizer",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "ComposableAudioPlayerTests",
            dependencies: ["ComposableAudioPlayer"]
        ),
        .testTarget(
            name: "ComposableAudioRecorderTests",
            dependencies: ["ComposableAudioRecorder"]
        ),
        .testTarget(
            name: "ComposableBluetoothCentralManagerTests",
            dependencies: ["ComposableBluetoothCentralManager"]
        ),
        .testTarget(
            name: "ComposableBluetoothPeripheralManagerTests",
            dependencies: ["ComposableBluetoothPeripheralManager"]
        ),
        .testTarget(
            name: "ComposableFastTests",
            dependencies: ["ComposableFast"]
        ),
        .testTarget(
            name: "ComposablePlayerTests",
            dependencies: ["ComposablePlayer"]
        ),
        .testTarget(
            name: "ComposableSpeechRecognizerTests",
            dependencies: ["ComposableSpeechRecognizer"]
        ),
        .testTarget(
            name: "ComposableSpeechSynthesizerTests",
            dependencies: ["ComposableSpeechSynthesizer"]
        ),
    ]
)
