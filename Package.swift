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
        .library(name: "ComposableAltimeter", targets: ["ComposableAltimeter"]),
        .library(name: "ComposableAudioPlayer", targets: ["ComposableAudioPlayer"]),
        .library(name: "ComposableAudioRecorder", targets: ["ComposableAudioRecorder"]),
        .library(name: "ComposableBluetoothCentralManager", targets: ["ComposableBluetoothCentralManager"]),
        .library(name: "ComposableBluetoothPeripheralManager", targets: ["ComposableBluetoothPeripheralManager"]),
        .library(name: "ComposableCoreLocation", targets: ["ComposableCoreLocation"]),
        .library(name: "ComposableCoreMotion", targets: ["ComposableCoreMotion"]),
        .library(name: "ComposableFast", targets: ["ComposableFast"]),
        .library(name: "ComposableHealthStore", targets: ["ComposableHealthStore"]),
        .library(name: "ComposableMediaPlayer", targets: ["ComposableMediaPlayer"]),
        .library(name: "ComposablePlayer", targets: ["ComposablePlayer"]),
        .library(name: "ComposableSpeechRecognizer", targets: ["ComposableSpeechRecognizer"]),
        .library(name: "ComposableSpeechSynthesizer", targets: ["ComposableSpeechSynthesizer"]),
        .library(name: "ComposableWatchConnectivity", targets: ["ComposableWatchConnectivity"]),
        .library(name: "ComposableWorkout", targets: ["ComposableWorkout"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.9.0"),
    ],
    targets: [
        .target(
            name: "ComposableAltimeter",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
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
            name: "ComposableCoreLocation",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "ComposableCoreMotion",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "ComposableFast",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposableHealthStore",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "ComposableMediaPlayer",
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
        .target(
            name: "ComposableWatchConnectivity",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposableWorkout",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(name: "ComposableAudioPlayerTests", dependencies: ["ComposableAudioPlayer"]),
        .testTarget(name: "ComposableAudioRecorderTests", dependencies: ["ComposableAudioRecorder"]),
        .testTarget(name: "ComposableBluetoothCentralManagerTests", dependencies: ["ComposableBluetoothCentralManager"]),
        .testTarget(name: "ComposableBluetoothPeripheralManagerTests", dependencies: ["ComposableBluetoothPeripheralManager"]),
        .testTarget(name: "ComposableCoreLocationTests", dependencies: ["ComposableCoreLocation"]),
        .testTarget(name: "ComposableCoreMotionTests", dependencies: ["ComposableCoreMotion"]),
        .testTarget(name: "ComposableFastTests", dependencies: ["ComposableFast"]),
        .testTarget(name: "ComposablePlayerTests", dependencies: ["ComposablePlayer"]),
        .testTarget(name: "ComposableSpeechRecognizerTests", dependencies: ["ComposableSpeechRecognizer"]),
        .testTarget(name: "ComposableSpeechSynthesizerTests", dependencies: ["ComposableSpeechSynthesizer"]),
    ]
)
