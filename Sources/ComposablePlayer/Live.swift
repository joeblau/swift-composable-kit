// Live.swift
// Copyright (c) 2021 Joe Blau

import AVFoundation
import Combine
import ComposableArchitecture
import Foundation

public extension AudioPlayer {
    static let live: AudioPlayer = { () -> AudioPlayer in

        var manager = AudioPlayer()

        manager.create = { id in

            Effect.run { subscriber in
                let player = AVPlayer()

                dependencies[id] = Dependencies(
                    player: player,
                    subscriber: subscriber,
                    queue: OperationQueue.main
                )

                return AnyCancellable {
                    dependencies[id] = nil
                }
            }
        }

        manager.destroy = { id in
            .fireAndForget {
                dependencies[id]?.subscriber.send(completion: .finished)
                dependencies[id] = nil
            }
        }

        manager.play = { id, url in
            .fireAndForget {
                dependencies[id]?.player = AVPlayer(url: url)
                dependencies[id]?.player.play()
            }
        }

        manager.pause = { id in
            .fireAndForget { dependencies[id]?.player.pause() }
        }

        return manager
    }()
}

private struct Dependencies {
    var player: AVPlayer
    let subscriber: Effect<AudioPlayer.Action, Never>.Subscriber
    let queue: OperationQueue
}

private var dependencies: [AnyHashable: Dependencies] = [:]
