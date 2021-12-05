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

        manager.createImplementation = {
            Effect.run { subscriber in
                let delegate = SpeechSynthesizerManagerDelegate(subscriber)
                let speechSynthesizer = AVSpeechSynthesizer()
                speechSynthesizer.delegate = delegate

                dependencies = Dependencies(delegate: delegate,
                                                speechSynthesizer: speechSynthesizer,
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
            manager.speakImplementation = { utterance in
                .fireAndForget {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .mixWithOthers)
                        dependencies?.speechSynthesizer.speak(utterance)
                    } catch {
                        os_log("%@", error.localizedDescription)
                    }
                }
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.continueSpeakingImplementation = {
                .fireAndForget {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .mixWithOthers)
                        dependencies?.speechSynthesizer.continueSpeaking()
                    } catch {
                        os_log("%@", error.localizedDescription)
                    }
                }
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.pauseSpeakingImplementation = { boundary in
                .fireAndForget {
                    dependencies?.speechSynthesizer.pauseSpeaking(at: boundary)
                }
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.isPausedImplementation = {
                dependencies?.speechSynthesizer.isPaused
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.isSpeakingImplementation = {
                dependencies?.speechSynthesizer.isSpeaking
            }
        #endif

        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.stopSpeakingImplementation = { boundary in
                .fireAndForget {
                    dependencies?.speechSynthesizer.stopSpeaking(at: boundary)
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

private var dependencies: Dependencies?

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
