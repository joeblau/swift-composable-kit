// Live.swift
// Copyright (c) 2021 Joe Blau

import AVFoundation
import Combine
import ComposableArchitecture
import Foundation

public extension AudioPlayerManager {
    static let live: AudioPlayerManager = { () -> AudioPlayerManager in

        var manager = AudioPlayerManager()

        manager.create = { id in

            Effect.run { subscriber in
                let delegate = AudioPlayerManagerDelegate(subscriber)

                let player = AVAudioPlayer()
                player.delegate = delegate

                dependencies[id] = Dependencies(
                    delegate: delegate,
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
                guard let player = try? AVAudioPlayer(contentsOf: url) else { return }
                dependencies[id]?.player = player
                dependencies[id]?.player.play()
            }
        }

        manager.stop = { id in
            .fireAndForget { dependencies[id]?.player.pause() }
        }

        return manager
    }()
}

private struct Dependencies {
    var delegate: AVAudioPlayerDelegate
    var player: AVAudioPlayer
    let subscriber: Effect<AudioPlayerManager.Action, Never>.Subscriber
    let queue: OperationQueue
}

private var dependencies: [AnyHashable: Dependencies] = [:]

private class AudioPlayerManagerDelegate: NSObject, AVAudioPlayerDelegate {
    let subscriber: Effect<AudioPlayerManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<AudioPlayerManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    func audioPlayerDecodeErrorDidOccur(_: AVAudioPlayer, error: Error?) {
        subscriber.send(.decodeErrorDidOccur(AudioPlayerManager.Error(error)))
    }

    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully flag: Bool) {
        subscriber.send(.didFinishPlaying(successfully: flag))
    }
}
