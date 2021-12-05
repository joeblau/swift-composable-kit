// Live.swift
// Copyright (c) 2021 Joe Blau

import Combine
import ComposableArchitecture
import Foundation
import os.log
import Speech

public extension SpeechRecognizerManager {
    static let live: SpeechRecognizerManager = { () -> SpeechRecognizerManager in
        var manager = SpeechRecognizerManager()

        manager.createImplementation = {
            Effect.run { subscriber in
                let delegate = SpeechSpeechRecognizerDelegate(subscriber)
                let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
                speechRecognizer.delegate = delegate

                dependencies = Dependencies(delegate: delegate,
                                                speechRecognizer: speechRecognizer,
                                                recognitionRequest: nil,
                                                recognitionTask: nil,
                                                audioEngine: AVAudioEngine(),
                                                subscriber: subscriber)
                return AnyCancellable {
                    dependencies = nil
                }
            }
        }

        manager.destroyImplementation = {
            .fireAndForget {
                dependencies?.subscriber.send(completion: .finished)
                dependencies = nil
            }
        }

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.requestAuthorizationImplementation = {
                .fireAndForget {
                    SFSpeechRecognizer.requestAuthorization { authStatus in
                        dependencies?.subscriber.send(.authorizationStatus(authStatus))
                    }
                }
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.startListeningImplementation = {
                .future { _ in

                    do {
                        dependencies?.recognitionTask?.cancel()
                        dependencies?.recognitionTask = nil

                        // Configure the audio session for the app.
                        try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                        let inputNode = dependencies?.audioEngine.inputNode

                        // Create and configure the speech recognition request.
                        dependencies?.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                        guard let recognitionRequest = dependencies?.recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
                        recognitionRequest.shouldReportPartialResults = true

                        // Keep speech recognition data on device
                        recognitionRequest.requiresOnDeviceRecognition = false

                        // Create a recognition task for the speech recognition session.
                        // Keep a reference to the task so that it can be canceled.
                        dependencies!.recognitionTask = dependencies?.speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                            dependencies?.subscriber.send(.speechRecognitionResult(result))

                            guard let isFinal = result?.isFinal,
                                  error == nil, isFinal else { return }

                            // Stop recognizing speech if there is a problem.
                            dependencies?.audioEngine.stop()
                            inputNode?.removeTap(onBus: 0)

                            dependencies?.recognitionRequest = nil
                            dependencies?.recognitionTask = nil
                        }

                        // Configure the microphone input.
                        let recordingFormat = inputNode?.outputFormat(forBus: 0)
                        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, _: AVAudioTime) in
                            dependencies?.recognitionRequest?.append(buffer)
                        }

                        dependencies?.audioEngine.prepare()
                        try dependencies?.audioEngine.start()
                    } catch {
                        os_log("%@", error.localizedDescription)
                    }
                }
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.stopListeningImplementation = {
                .fireAndForget {
                    dependencies?.audioEngine.stop()
                    dependencies?.audioEngine.inputNode.removeTap(onBus: 0)
                    dependencies?.recognitionRequest?.endAudio()
                    dependencies?.recognitionTask?.cancel()
                }
            }
        #endif

        return manager
    }()
}

// MARK: - Dependencies

private struct Dependencies {
    let delegate: SFSpeechRecognizerDelegate
    let speechRecognizer: SFSpeechRecognizer
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine: AVAudioEngine
    let subscriber: Effect<SpeechRecognizerManager.Action, Never>.Subscriber
}

private var dependencies: Dependencies?

// MARK: - Delegate

private class SpeechSpeechRecognizerDelegate: NSObject, SFSpeechRecognizerDelegate {
    let subscriber: Effect<SpeechRecognizerManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<SpeechRecognizerManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    func speechRecognizer(_: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        subscriber.send(.availiblityDidChange(available))
    }
}
