# SwiftComposableKit

[![CI](https://github.com/joeblau/swift-composable-kit/workflows/CI/badge.svg)](https://github.com/joeblau/swift-composable-kit/actions?query=workflow%3ACI)

Composable implementation of existing Apple frameworks. To understand how the composable architecture works, I higly recommend watching the four part series on [Point Free](https://www.pointfree.co/collections/composable-architecture/a-tour-of-the-composable-architecture/ep100-a-tour-of-the-composable-architecture-part-1)


## Install

Add this line to your `Package.swift`

```swift
.package(url: "https://github.com/joeblau/swift-composable-kit", from: "0.1.0"),
```

## Libraries

- **ComposableAudioPlayer** - AVAudioPlayer
- **ComposableAudioRecorder** - AVAudioRecorder
- **ComposableBluetoothCentralManager** - CBCentralManager
- **ComposableBluetoothPeripheralManager** - CBPeripheralManager
- **[ComposableFast](./Sources/ComposableFast)** - https://fast.com
- **ComposableSpeechRecognizer** - SFSpeechRecognizer
- **ComposableSpeechSynthesizer** - AVSpeechSynthesizer
