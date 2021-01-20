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

    var create: (AnyHashable) -> Effect<Action, Never> = { _ in _unimplemented("create") }

    var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }

    var record: (AnyHashable, URL, [String: Any]) -> Effect<Never, Never> = { _, _, _ in _unimplemented("record") }

    var stop: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("stop") }

    // MARK: - Functions

    public func create(id: AnyHashable) -> Effect<Action, Never> {
        create(id)
    }

    public func destroy(id: AnyHashable) -> Effect<Never, Never> {
        destroy(id)
    }

    func record(id: AnyHashable, url: URL, settings: [String: Any]) -> Effect<Never, Never> {
        record(id, url, settings)
    }

    func stop(id: AnyHashable) -> Effect<Never, Never> {
        stop(id)
    }
}
