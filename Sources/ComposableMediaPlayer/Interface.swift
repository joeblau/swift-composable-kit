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

        var create: (AnyHashable) -> Effect<Action, Never> = { _ in _unimplemented("create") }

        var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }

        // MARK: - Functions

        public func create(id: AnyHashable) -> Effect<Action, Never> {
            create(id)
        }

        public func destroy(id: AnyHashable) -> Effect<Never, Never> {
            destroy(id)
        }
    }
#endif
