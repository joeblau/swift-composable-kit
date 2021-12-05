// Interface.swift
// Copyright (c) 2021 Joe Blau

import AVFoundation
import ComposableArchitecture
//
//  Interface.swift
//  Check
//
//  Created by Joe Blau on 10/4/20.
//
import Foundation

public struct SpeechSynthesizerManager {
    public enum Action: Equatable {
        case didContinue(utterance: AVSpeechUtterance)
        case didFinsih(utterance: AVSpeechUtterance)
        case didPause(utterance: AVSpeechUtterance)
        case didStart(utterance: AVSpeechUtterance)
        case willSepakRangeOfSpeachString(NSRange, utterance: AVSpeechUtterance)
    }

    var createImplementation: () -> Effect<Action, Never> = { _unimplemented("create") }

    var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

    @available(macOS, unavailable)
    var speakImplementation: (AVSpeechUtterance) -> Effect<Never, Never> = { _ in _unimplemented("speak") }

    @available(macOS, unavailable)
    var continueSpeakingImplementation: () -> Effect<Bool, Never> = { _unimplemented("continueSpeaking") }

    @available(macOS, unavailable)
    var pauseSpeakingImplementation: (AVSpeechBoundary) -> Effect<Never, Never> = { _ in
        _unimplemented("pauseSpeaking")
    }

    @available(macOS, unavailable)
    public var isPausedImplementation: () -> Bool? = { _unimplemented("isPaused") }

    @available(macOS, unavailable)
    public var isSpeakingImplementation: () -> Bool? = { _unimplemented("isSpeaking") }

    @available(macOS, unavailable)
    var stopSpeakingImplementation: (AVSpeechBoundary) -> Effect<Never, Never> = { _ in
        _unimplemented("stopSpeaking")
    }

    public func create(queue _: DispatchQueue? = nil, options _: [String: Any]? = nil) -> Effect<Action, Never> {
        createImplementation()
    }

    public func destroy() -> Effect<Never, Never> {
        destroyImplementation()
    }

    @available(macOS, unavailable)
    public func speak(utterance: AVSpeechUtterance) -> Effect<Never, Never> {
        speakImplementation(utterance)
    }

    @available(macOS, unavailable)
    public func continueSpeaking() -> Effect<Bool, Never> {
        continueSpeakingImplementation()
    }

    @available(macOS, unavailable)
    public func pauseSpeaking(at: AVSpeechBoundary) -> Effect<Never, Never> {
        pauseSpeakingImplementation(at)
    }

    @available(macOS, unavailable)
    public func isPaused() -> Bool? {
        isPausedImplementation()
    }

    @available(macOS, unavailable)
    public func isSpeaking() -> Bool? {
        isSpeakingImplementation()
    }

    @available(macOS, unavailable)
    public func stopSpeaking(at: AVSpeechBoundary) -> Effect<Never, Never> {
        stopSpeakingImplementation(at)
    }
}
