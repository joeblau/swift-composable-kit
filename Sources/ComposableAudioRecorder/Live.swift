// Live.swift
// Copyright (c) 2021 Joe Blau

import AVFoundation
import Combine
import ComposableArchitecture

public extension AudioRecorderManager {
    static let live: AudioRecorderManager = { () -> AudioRecorderManager in

        var manager = AudioRecorderManager()

        manager.create = { id in

            Effect.run { subscriber in
                let recorder = AVAudioRecorder()
                var delegate = AudioRecorderDelegate(subscriber)
                recorder.delegate = delegate

                dependencies[id] = Dependencies(
                    delegate: delegate,
                    recorder: recorder,
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

        manager.record = { id, url, settings in
            .fireAndForget {
                do {
                    let newRecorder = try AVAudioRecorder(url: url, settings: settings)
                    newRecorder.delegate = dependencies[id]?.delegate
                    dependencies[id]?.recorder = newRecorder
                    dependencies[id]?.recorder.record()
                } catch {
                    return
                }
            }
        }

        manager.stop = { id in
            .fireAndForget {
                guard dependencies[id]?.recorder != nil else { return }
                dependencies[id]?.recorder.stop()
                dependencies[id]?.recorder = nil
            }
        }

        return manager
    }()
}

private struct Dependencies {
    let delegate: AudioRecorderDelegate
    var recorder: AVAudioRecorder!
    let subscriber: Effect<AudioRecorderManager.Action, Never>.Subscriber
    let queue: OperationQueue
}

private var dependencies: [AnyHashable: Dependencies] = [:]

private class AudioRecorderDelegate: NSObject, AVAudioRecorderDelegate {
    let subscriber: Effect<AudioRecorderManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<AudioRecorderManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    func audioRecorderEncodeErrorDidOccur(_: AVAudioRecorder, error: Error?) {
        subscriber.send(.encodeErrorDidOccur(AudioRecorderManager.Error(error)))
    }

    func audioRecorderDidFinishRecording(_: AVAudioRecorder, successfully flag: Bool) {
        subscriber.send(.didFinishRecording(successfully: flag))
    }
}
