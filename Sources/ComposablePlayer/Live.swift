// Live.swift
// Copyright (c) 2021 Joe Blau

import AVFoundation
import Combine
import ComposableArchitecture
import Foundation

public extension AudioPlayer {
    static let live: AudioPlayer = { () -> AudioPlayer in

        var manager = AudioPlayer()

        manager.createImplementation = {

            Effect.run { subscriber in
                let player = AVPlayer()

                dependencies = Dependencies(
                    player: player,
                    subscriber: subscriber,
                    queue: OperationQueue.main
                )

                return AnyCancellable {
                    dependencies = nil
                }
            }
        }

        manager.destroyImplementation = {
            .fireAndForget {
                dependencies?.subscriber.send(completion: .finished)
                dependencies = nil
            }
        }

        manager.playImplementation = { url in
            .fireAndForget {
                dependencies?.player = AVPlayer(url: url)
                dependencies?.player.play()
            }
        }

        manager.pauseImplementation = {
            .fireAndForget { dependencies?.player.pause() }
        }

        return manager
    }()
}

private struct Dependencies {
    var player: AVPlayer
    let subscriber: Effect<AudioPlayer.Action, Never>.Subscriber
    let queue: OperationQueue
}

private var dependencies: Dependencies?
