// Interface.swift
// Copyright (c) 2021 Joe Blau

import ComposableArchitecture
import Foundation
import Speech

public struct SpeechRecognizerManager {
    public enum Action: Equatable {
        case availiblityDidChange(Bool)
        case speechRecognitionResult(SFSpeechRecognitionResult?)
        case authorizationStatus(SFSpeechRecognizerAuthorizationStatus)
    }

    var createImplementation: () -> Effect<Action, Never> = { _unimplemented("create") }

    var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

    @available(macOS, unavailable)
    var requestAuthorizationImplementation: () -> Effect<Never, Never> = { _unimplemented("requestAuthorization") }

    @available(macOS, unavailable)
    var startListeningImplementation: () -> Effect<Never, Never> = { _unimplemented("startListening") }

    @available(macOS, unavailable)
    var stopListeningImplementation: () -> Effect<Never, Never> = { _unimplemented("stopListening") }

    public func create(queue _: DispatchQueue? = nil, options _: [String: Any]? = nil) -> Effect<Action, Never> {
        createImplementation()
    }

    public func destroy() -> Effect<Never, Never> {
        destroyImplementation()
    }

    @available(macOS, unavailable)
    public func requestAuthorization() -> Effect<Never, Never> {
        requestAuthorizationImplementation()
    }

    @available(macOS, unavailable)
    public func startListening() -> Effect<Never, Never> {
        startListeningImplementation()
    }

    @available(macOS, unavailable)
    public func stopListening() -> Effect<Never, Never> {
        stopListeningImplementation()
    }
}
