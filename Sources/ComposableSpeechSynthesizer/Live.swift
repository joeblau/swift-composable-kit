// Live.swift
// Copyright (c) 2021 Joe Blau

import AVFoundation
import Combine
import ComposableArchitecture
import Foundation
import os.log

public extension SpeechSynthesizerManager {
    static let live: SpeechSynthesizerManager = { () -> SpeechSynthesizerManager in
        var manager = SpeechSynthesizerManager()

        manager.create = { id in
            Effect.run { subscriber in
                let delegate = SpeechSynthesizerManagerDelegate(subscriber)
                let speechSynthesizer = AVSpeechSynthesizer()
                speechSynthesizer.delegate = delegate

                dependencies[id] = Dependencies(delegate: delegate,
                                                speechSynthesizer: speechSynthesizer,
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
            manager.speak = { id, utterance in
                .fireAndForget {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .mixWithOthers)
                        dependencies[id]?.speechSynthesizer.speak(utterance)
                    } catch {
                        os_log("%@", error.localizedDescription)
                    }
                }
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.continueSpeaking = { id in
                .fireAndForget {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .mixWithOthers)
                        dependencies[id]?.speechSynthesizer.continueSpeaking()
                    } catch {
                        os_log("%@", error.localizedDescription)
                    }
                }
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.pauseSpeaking = { id, boundary in
                .fireAndForget {
                    dependencies[id]?.speechSynthesizer.pauseSpeaking(at: boundary)
                }
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.isPaused = { id in
                dependencies[id]?.speechSynthesizer.isPaused
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.isSpeaking = { id in
                dependencies[id]?.speechSynthesizer.isSpeaking
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.stopSpeaking = { id, boundary in
                .fireAndForget {
                    dependencies[id]?.speechSynthesizer.stopSpeaking(at: boundary)
                }
            }
        #endif

        return manager
    }()
}

// MARK: - Dependencies

private struct Dependencies {
    let delegate: AVSpeechSynthesizerDelegate
    let speechSynthesizer: AVSpeechSynthesizer
    let subscriber: Effect<SpeechSynthesizerManager.Action, Never>.Subscriber
}

private var dependencies: [AnyHashable: Dependencies] = [:]

// MARK: - Delegate

private class SpeechSynthesizerManagerDelegate: NSObject, AVSpeechSynthesizerDelegate {
    let subscriber: Effect<SpeechSynthesizerManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<SpeechSynthesizerManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        subscriber.send(.didContinue(utterance: utterance))
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        subscriber.send(.didFinsih(utterance: utterance))
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        subscriber.send(.didPause(utterance: utterance))
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        subscriber.send(.didStart(utterance: utterance))
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        subscriber.send(.willSepakRangeOfSpeachString(characterRange, utterance: utterance))
    }
}
