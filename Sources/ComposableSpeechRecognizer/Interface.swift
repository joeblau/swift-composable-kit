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

    var create: (AnyHashable) -> Effect<Action, Never> = { _ in _unimplemented("create") }

    var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }

    @available(macOS, unavailable)
    var requestAuthorization: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("requestAuthorization") }

    @available(macOS, unavailable)
    var startListening: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("startListening") }

    @available(macOS, unavailable)
    var stopListening: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("stopListening") }

    public func create(id: AnyHashable, queue _: DispatchQueue? = nil, options _: [String: Any]? = nil) -> Effect<Action, Never> {
        create(id)
    }

    public func destroy(id: AnyHashable) -> Effect<Never, Never> {
        destroy(id)
    }

    @available(macOS, unavailable)
    public func requestAuthorization(id: AnyHashable) -> Effect<Never, Never> {
        requestAuthorization(id)
    }

    @available(macOS, unavailable)
    public func startListening(id: AnyHashable) -> Effect<Never, Never> {
        startListening(id)
    }

    @available(macOS, unavailable)
    public func stopListening(id: AnyHashable) -> Effect<Never, Never> {
        stopListening(id)
    }
}
