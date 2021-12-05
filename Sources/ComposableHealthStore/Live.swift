// Live.swift
// Copyright (c) 2021 Joe Blau

#if canImport(HealthKit)
    import Combine
    import ComposableArchitecture
    import Foundation
    import HealthKit

    public extension HealthStoreManager {
        static let live: HealthStoreManager = { () -> HealthStoreManager in

            var manager = HealthStoreManager()

            manager.createImplementation = {
                Effect.run { subscriber in
                    dependencies = Dependencies(
                        healthStore: HKHealthStore(),
                        subscriber: subscriber
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

            manager.requestAuthorizationImplementation = { typesToShare, typeToRead in
                .fireAndForget {
                    guard HKHealthStore.isHealthDataAvailable() else { return }
                    dependencies?.healthStore.requestAuthorization(toShare: typesToShare, read: typeToRead) { _, _ in
                    }
                }
            }

            manager.isHealthAuthorizedForImplementation = { typesToShare, typesToRead in
                .future { futureCompletion in
                    dependencies?.healthStore.getRequestStatusForAuthorization(toShare: typesToShare, read: typesToRead, completion: { status, error in
                        switch error {
                        case .some:
                            break
                        case .none:
                            switch status {
                            case .unnecessary: return futureCompletion(.success(true))
                            default: return futureCompletion(.success(false))
                            }
                        }
                    })
                }
            }

            manager.startWatchAppImplementation = { configuration in
                .future { futureCompletion in
                    dependencies?.healthStore.startWatchApp(with: configuration, completion: { _, error in
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

    private var dependencies: Dependencies?
#endif
