// Interface.swift
// Copyright (c) 2021 Joe Blau

import AVFoundation
import ComposableArchitecture

public struct AudioPlayerManager {
    public enum Action: Equatable {
        case decodeErrorDidOccur(Error?)
        case didFinishPlaying(successfully: Bool)
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

    var playImplementation: (URL) -> Effect<Never, Never> = { _ in _unimplemented("play") }

    var stopImplementation: () -> Effect<Never, Never> = { _unimplemented("stop") }

    // MARK: - Functions

    public func create() -> Effect<Action, Never> {
        createImplementation()
    }

    public func destroy() -> Effect<Never, Never> {
        destroyImplementation()
    }

    func play(url: URL) -> Effect<Never, Never> {
        playImplementation(url)
    }

    func stop() -> Effect<Never, Never> {
        stopImplementation()
    }
}
