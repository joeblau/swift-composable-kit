// Live.swift
// Copyright (c) 2020 Joe Blau

import Combine
import ComposableArchitecture
import Foundation
import os.log
import Speech

extension SpeechRecognizerManager {
    public static let live: SpeechRecognizerManager = { () -> SpeechRecognizerManager in
        var manager = SpeechRecognizerManager()

        manager.create = { id in
            Effect.run { subscriber in
                let delegate = SpeechSpeechRecognizerDelegate(subscriber)
                let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
                speechRecognizer.delegate = delegate

                dependencies[id] = Dependencies(delegate: delegate,
                                                speechRecognizer: speechRecognizer,
                                                recognitionRequest: nil,
                                                recognitionTask: nil,
                                                audioEngine: AVAudioEngine(),
                                                subscriber: subscriber)
                return AnyCancellable {
                    dependencies[id] = nil
                }
            }
        }

        manager.destroy = { id in
            .fireAndForget {
                dependencies[id]?.subscriber.send(completion: .finished)
                dependencies[id] = nil
            }
        }

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.requestAuthorization = { id in
                .fireAndForget {
                    SFSpeechRecognizer.requestAuthorization { authStatus in
                        dependencies[id]?.subscriber.send(.authorizationStatus(authStatus))
                    }
                }
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.startListening = { id in
                .future { _ in

                    do {
                        dependencies[id]?.recognitionTask?.cancel()
                        dependencies[id]?.recognitionTask = nil

                        // Configure the audio session for the app.
                        try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                        let inputNode = dependencies[id]?.audioEngine.inputNode

                        // Create and configure the speech recognition request.
                        dependencies[id]?.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                        guard let recognitionRequest = dependencies[id]?.recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
                        recognitionRequest.shouldReportPartialResults = true

                        // Keep speech recognition data on device
                        recognitionRequest.requiresOnDeviceRecognition = false

                        // Create a recognition task for the speech recognition session.
                        // Keep a reference to the task so that it can be canceled.
                        dependencies[id]!.recognitionTask = dependencies[id]?.speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                            dependencies[id]?.subscriber.send(.speechRecognitionResult(result))

                            guard let isFinal = result?.isFinal,
                                error == nil, isFinal else { return }

                            // Stop recognizing speech if there is a problem.
                            dependencies[id]?.audioEngine.stop()
                            inputNode?.removeTap(onBus: 0)

                            dependencies[id]?.recognitionRequest = nil
                            dependencies[id]?.recognitionTask = nil
                        }

                        // Configure the microphone input.
                        let recordingFormat = inputNode?.outputFormat(forBus: 0)
                        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, _: AVAudioTime) in
                            dependencies[id]?.recognitionRequest?.append(buffer)
                        }

                        dependencies[id]?.audioEngine.prepare()
                        try dependencies[id]?.audioEngine.start()
                    } catch {
                        os_log("%@", error.localizedDescription)
                    }
                }
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.stopListening = { id in
                .fireAndForget {
                    dependencies[id]?.audioEngine.stop()
                    dependencies[id]?.audioEngine.inputNode.removeTap(onBus: 0)
                    dependencies[id]?.recognitionRequest?.endAudio()
                    dependencies[id]?.recognitionTask?.cancel()
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

private var dependencies: [AnyHashable: Dependencies] = [:]

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
