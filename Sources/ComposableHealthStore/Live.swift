// ComposableHealthStoreLive.swift
// Copyright (c) 2020 Copilot

#if canImport(HealthKit)
import Combine
import ComposableArchitecture
import Foundation
import HealthKit

public extension HealthStoreManager {
    static let live: HealthStoreManager = { () -> HealthStoreManager in

        var manager = HealthStoreManager()

        manager.create = { id in
            Effect.run { subscriber in
                dependencies[id] = Dependencies(
                    healthStore: HKHealthStore(),
                    subscriber: subscriber
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

        manager.requestAuthorization = { id, typesToShare, typeToRead in
            .fireAndForget {
                guard HKHealthStore.isHealthDataAvailable() else { return }
                dependencies[id]?.healthStore.requestAuthorization(toShare: typesToShare, read: typeToRead) { _, _ in
                }
            }
        }

        manager.startWatchApp = { id, configuration in
            .future { futureCompletion in
                dependencies[id]?.healthStore.startWatchApp(with: configuration, completion: { success, error in
                    switch error {
                    case .some:
                        return futureCompletion(.success(false))
                    case .none:
                        return futureCompletion(.success(true))
                    }
                })
            }
        }
        
        return manager
    }()
}

private struct Dependencies {
    var healthStore: HKHealthStore
    let subscriber: Effect<HealthStoreManager.Action, Never>.Subscriber
}

private var dependencies: [AnyHashable: Dependencies] = [:]
#endif
