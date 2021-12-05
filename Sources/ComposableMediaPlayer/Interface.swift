// Interface.swift
// Copyright (c) 2021 Joe Blau

#if canImport(MediaPlayer) && os(iOS)
    import ComposableArchitecture
    import Foundation
    import MediaPlayer

    public struct MediaPlayerManager {
        public enum Action: Equatable {
            case nowPlayingItemDidChange
            case playbackStateDidChange
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

        // MARK: - Functions

        public func create() -> Effect<Action, Never> {
            createImplementation()
        }

        public func destroy() -> Effect<Never, Never> {
            destroyImplementation()
        }
    }
#endif
