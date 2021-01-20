// Live.swift
// Copyright (c) 2021 Joe Blau

#if canImport(CoreMotion) && (os(iOS) || os(watchOS))
    import Combine
    import ComposableArchitecture
    import CoreMotion
    import Foundation

    extension AltimeterManager {
        public static let live = AltimeterManager(
            create: { id in
                .fireAndForget {
                    if managers[id] != nil {
                        return
                    }
                    managers[id] = CMAltimeter()
                }
            },
            destroy: { id in
                .fireAndForget { managers[id] = nil }
            },
            authorizationStatus: {
                CMAltimeter.authorizationStatus()
            },
            isRelativeAltitudeAvailable: {
                CMAltimeter.isRelativeAltitudeAvailable()
            },
            startRelativeAltitudeUpdates: { id, queue in
                Effect.run { subscriber in
                    guard let manager = requireAltimeterManager(id: id) else {
                        return AnyCancellable {}
                    }

                    guard deviceRelativeAltitudeUpdatesSubscribers[id] == nil else {
                        return AnyCancellable {}
                    }

                    deviceRelativeAltitudeUpdatesSubscribers[id] = subscriber
                    manager.startRelativeAltitudeUpdates(to: queue) { data, error in
                        if let data = data {
                            subscriber.send(.init(data))
                        } else if let error = error {
                            subscriber.send(completion: .failure(error))
                        }
                    }

                    return AnyCancellable {
                        manager.stopRelativeAltitudeUpdates()
                    }
                }
            },
            stopRelativeAltitudeUpdates: { id -> Effect<Never, Never> in
                .fireAndForget {
                    guard let manager = managers[id]
                    else {
                        couldNotFindAltimeterManager(id: id)
                        return
                    }
                    manager.stopRelativeAltitudeUpdates()
                    deviceRelativeAltitudeUpdatesSubscribers[id]?.send(completion: .finished)
                    deviceRelativeAltitudeUpdatesSubscribers[id] = nil
                }
            }
        )

        private static var managers: [AnyHashable: CMAltimeter] = [:]

        private static func requireAltimeterManager(id: AnyHashable) -> CMAltimeter? {
            if managers[id] == nil {
                couldNotFindAltimeterManager(id: id)
            }
            return managers[id]
        }
    }

    private var deviceRelativeAltitudeUpdatesSubscribers: [AnyHashable: Effect<RelativeAltitudeData, Error>.Subscriber] = [:]

    private func couldNotFindAltimeterManager(id: Any) {
        assertionFailure(
            """
            A altimeter manager could not be found with the id \(id). This is considered a programmer error. \
            You should not invoke methods on a altimeter manager before it has been created or after it \
            has been destroyed. Refactor your code to make sure there is a altimeter manager created by the \
            time you invoke this endpoint.
            """)
    }

#endif
