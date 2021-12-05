// Interface.swift
// Copyright (c) 2021 Joe Blau

import Combine
import ComposableArchitecture

public struct AudioRecorderManager {
    public enum Action: Equatable {
        case encodeErrorDidOccur(Error?)
        case didFinishRecording(successfully: Bool)
    }

    public struct Error: Swift.Error, Equatable {
        public let error: NSError?

        public init(_ error: Swift.Error?) {
            self.error = error as NSError?
        }
    }

    // MARK: - Variables

    var createImplementation: () -> Effect<Action, Never> = { _unimplemented("create") }

    var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

    var recordImplementation: (URL, [String: Any]) -> Effect<Never, Never> = { _, _ in
        _unimplemented("record")
    }

    var stopImplementation: () -> Effect<Never, Never> = { _unimplemented("stop") }

    // MARK: - Functions

    public func create() -> Effect<Action, Never> {
        createImplementation()
    }

    public func destroy() -> Effect<Never, Never> {
        destroyImplementation()
    }

    func record(url: URL, settings: [String: Any]) -> Effect<Never, Never> {
        recordImplementation(url, settings)
    }

    func stop() -> Effect<Never, Never> {
        stopImplementation()
    }
}
