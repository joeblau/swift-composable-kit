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

    var create: (AnyHashable) -> Effect<Action, Never> = { _ in _unimplemented("create") }

    var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }

    @available(macOS, unavailable)
    var speak: (AnyHashable, AVSpeechUtterance) -> Effect<Never, Never> = { _, _ in _unimplemented("speak") }

    @available(macOS, unavailable)
    var continueSpeaking: (AnyHashable) -> Effect<Bool, Never> = { _ in _unimplemented("continueSpeaking") }

    @available(macOS, unavailable)
    var pauseSpeaking: (AnyHashable, AVSpeechBoundary) -> Effect<Never, Never> = { _, _ in _unimplemented("pauseSpeaking") }

    @available(macOS, unavailable)
    public var isPaused: (AnyHashable) -> Bool? = { _ in _unimplemented("isPaused") }

    @available(macOS, unavailable)
    public var isSpeaking: (AnyHashable) -> Bool? = { _ in _unimplemented("isSpeaking") }

    @available(macOS, unavailable)
    var stopSpeaking: (AnyHashable, AVSpeechBoundary) -> Effect<Never, Never> = { _, _ in _unimplemented("stopSpeaking") }

    public func create(id: AnyHashable, queue _: DispatchQueue? = nil, options _: [String: Any]? = nil) -> Effect<Action, Never> {
        create(id)
    }

    public func destroy(id: AnyHashable) -> Effect<Never, Never> {
        destroy(id)
    }

    @available(macOS, unavailable)
    public func speak(id: AnyHashable, utterance: AVSpeechUtterance) -> Effect<Never, Never> {
        speak(id, utterance)
    }

    @available(macOS, unavailable)
    public func continueSpeaking(id: AnyHashable) -> Effect<Bool, Never> {
        continueSpeaking(id)
    }

    @available(macOS, unavailable)
    public func pauseSpeaking(id: AnyHashable, at: AVSpeechBoundary) -> Effect<Never, Never> {
        pauseSpeaking(id, at)
    }

    @available(macOS, unavailable)
    public func isPaused(id: AnyHashable) -> Bool? {
        isPaused(id)
    }

    @available(macOS, unavailable)
    public func isSpeaking(id: AnyHashable) -> Bool? {
        isSpeaking(id)
    }

    @available(macOS, unavailable)
    public func stopSpeaking(id: AnyHashable, at: AVSpeechBoundary) -> Effect<Never, Never> {
        stopSpeaking(id, at)
    }
}
