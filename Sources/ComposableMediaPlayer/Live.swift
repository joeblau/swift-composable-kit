// Live.swift
// Copyright (c) 2021 Joe Blau

#if canImport(MediaPlayer) && os(iOS)
    import Combine
    import ComposableArchitecture
    import Foundation
    import MediaPlayer

    public extension MediaPlayerManager {
        static let live: MediaPlayerManager = { () -> MediaPlayerManager in

            var manager = MediaPlayerManager()

            manager.createImplementation = {

                Effect.run { subscriber in
                    let systemMediaPlayer = MPMusicPlayerController.systemMusicPlayer
                    let notificationCenter = NotificationCenter.default
                    let delegate = WatchConnectivityDelegate(subscriber)

                    notificationCenter.addObserver(delegate,
                                                   selector: #selector(delegate.handleMusicPlayerControllerNowPlayingItemDidChange),
                                                   name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                                   object: systemMediaPlayer)

                    notificationCenter.addObserver(delegate,
                                                   selector: #selector(delegate.handleMusicPlayerControllerPlaybackStateDidChange),
                                                   name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                                   object: systemMediaPlayer)

                    dependencies = Dependencies(
                        systemMediaPlayer: systemMediaPlayer,
                        notificationCenter: notificationCenter,
                        delegate: delegate,
                        subscriber: subscriber
                    )

                    systemMediaPlayer.beginGeneratingPlaybackNotifications()

                    return AnyCancellable {
                        dependencies = nil
                    }
                }
            }

            manager.destroyImplementation = {
                .fireAndForget {
                    dependencies?.systemMediaPlayer.endGeneratingPlaybackNotifications()
                    dependencies?.subscriber.send(completion: .finished)
                    dependencies = nil
                }
            }

            return manager
        }()
    }

    private struct Dependencies {
        var systemMediaPlayer: MPMusicPlayerController
        var notificationCenter: NotificationCenter
        let delegate: WatchConnectivityDelegate
        let subscriber: Effect<MediaPlayerManager.Action, Never>.Subscriber
    }

    private var dependencies: Dependencies?

    private class WatchConnectivityDelegate: NSObject {
        let subscriber: Effect<MediaPlayerManager.Action, Never>.Subscriber

        init(_ subscriber: Effect<MediaPlayerManager.Action, Never>.Subscriber) {
            self.subscriber = subscriber
        }

        @objc func handleMusicPlayerControllerNowPlayingItemDidChange() {
            subscriber.send(.nowPlayingItemDidChange)
        }

        @objc func handleMusicPlayerControllerPlaybackStateDidChange() {
            subscriber.send(.playbackStateDidChange)
        }
    }
#endif
