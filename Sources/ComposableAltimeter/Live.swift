// Live.swift
// Copyright (c) 2021 Joe Blau

#if canImport(CoreMotion) && (os(iOS) || os(watchOS))
    import Combine
    import ComposableArchitecture
    import CoreMotion
    import Foundation

    extension AltimeterManager {
        public static let live = AltimeterManager(
            createImplementation: {
                .fireAndForget {
                    if manager != nil {
                        return
                    }
                    manager = CMAltimeter()
                }
            },
            destroyImplementation: {
                .fireAndForget { manager = nil }
            },
            startRelativeAltitudeUpdatesImplementation: { queue in
                Effect.run { subscriber in
                    guard let manager = requireAltimeterManager else {
                        return AnyCancellable {}
                    }
                    
                    guard deviceRelativeAltitudeUpdatesSubscriber == nil else {
                        return AnyCancellable {}
                    }
                    
                    deviceRelativeAltitudeUpdatesSubscriber = subscriber
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
            }, stopRelativeAltitudeUpdatesImplementation: {
                .fireAndForget {
                    guard let manager = manager
                    else {
                        couldNotFindAltimeterManager()
                        return
                    }
                    manager.stopRelativeAltitudeUpdates()
                    deviceRelativeAltitudeUpdatesSubscriber?.send(completion: .finished)
                    deviceRelativeAltitudeUpdatesSubscriber = nil
                }
            }, authorizationStatus: {
                CMAltimeter.authorizationStatus()
            },
            isRelativeAltitudeAvailable: {
                CMAltimeter.isRelativeAltitudeAvailable()
            }
        )

        private static var manager: CMAltimeter?

        private static var requireAltimeterManager: CMAltimeter? {
            if manager == nil {
                couldNotFindAltimeterManager()
            }
            return manager
        }
    }

    private var deviceRelativeAltitudeUpdatesSubscriber: Effect<RelativeAltitudeData, Error>.Subscriber?

    private func couldNotFindAltimeterManager() {
        assertionFailure(
            """
            A altimeter manager could not be found. This is considered a programmer error. \
            You should not invoke methods on a altimeter manager before it has been created or after it \
            has been destroyed. Refactor your code to make sure there is a altimeter manager created by the \
            time you invoke this endpoint.
            """)
    }

#endif
