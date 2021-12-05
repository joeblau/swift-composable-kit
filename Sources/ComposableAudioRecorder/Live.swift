// Live.swift
// Copyright (c) 2021 Joe Blau

import AVFoundation
import Combine
import ComposableArchitecture

public extension AudioRecorderManager {
    static let live: AudioRecorderManager = { () -> AudioRecorderManager in

        var manager = AudioRecorderManager()

        manager.createImplementation = {

            Effect.run { subscriber in
                let recorder = AVAudioRecorder()
                var delegate = AudioRecorderDelegate(subscriber)
                recorder.delegate = delegate

                dependencies = Dependencies(
                    delegate: delegate,
                    recorder: recorder,
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

        manager.recordImplementation = { url, settings in
            .fireAndForget {
                do {
                    let newRecorder = try AVAudioRecorder(url: url, settings: settings)
                    newRecorder.delegate = dependencies?.delegate
                    dependencies?.recorder = newRecorder
                    dependencies?.recorder.record()
                } catch {
                    return
                }
            }
        }

        manager.stopImplementation = {
            .fireAndForget {
                guard dependencies?.recorder != nil else { return }
                dependencies?.recorder.stop()
                dependencies?.recorder = nil
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

private var dependencies: Dependencies?

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
