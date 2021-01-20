// Live.swift
// Copyright (c) 2021 Joe Blau

#if canImport(WatchConnectivity)
    import Combine
    import ComposableArchitecture
    import Foundation
    import WatchConnectivity

    public extension WatchConnectivityManager {
        static let live: WatchConnectivityManager = { () -> WatchConnectivityManager in

            var manager = WatchConnectivityManager()

            manager.create = { id in

                Effect.run { subscriber in
                    guard WCSession.isSupported() else {
                        return AnyCancellable {
                            dependencies[id] = nil
                        }
                    }

                    var delegate = WatchConnectivityDelegate(subscriber)
                    let session = WCSession.default
                    session.delegate = delegate
                    session.activate()

                    dependencies[id] = Dependencies(
                        session: session,
                        watchConnectivityDelegate: delegate,
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

            manager.updateApplicationContext = { id, applicationContext in
                .fireAndForget {
                    try? dependencies[id]?.session.updateApplicationContext(applicationContext)
                }
            }

            manager.sendMessage = { id, message, replyHandler in
                .fireAndForget {
                    dependencies[id]?.session.sendMessage(message, replyHandler: replyHandler)
                }
            }

            manager.isReachable = { id in
                dependencies[id]?.session.isReachable ?? false
            }

            #if os(iOS)
                manager.isPaired = { id in
                    dependencies[id]?.session.isPaired ?? false
                }

                manager.isWatchAppInstalled = { id in
                    dependencies[id]?.session.isWatchAppInstalled ?? false
                }
            #endif

            return manager
        }()
    }

    private struct Dependencies {
        var session: WCSession
        let watchConnectivityDelegate: WatchConnectivityDelegate
        let subscriber: Effect<WatchConnectivityManager.Action, Never>.Subscriber
    }

    private var dependencies: [AnyHashable: Dependencies] = [:]

    // MARK: - WCSessionDelegate

    private class WatchConnectivityDelegate: NSObject, WCSessionDelegate {
        let subscriber: Effect<WatchConnectivityManager.Action, Never>.Subscriber

        init(_ subscriber: Effect<WatchConnectivityManager.Action, Never>.Subscriber) {
            self.subscriber = subscriber
        }

        func session(_: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
            DispatchQueue.main.async {
                self.subscriber.send(.activationDidCompleteWith(activationState: activationState, error: WatchConnectivityManager.Error(error)))
            }
        }

        func session(_: WCSession, didReceiveMessage message: [String: Any]) {
            DispatchQueue.main.async {
                self.subscriber.send(.didReceiveMessage(message: NSDictionary(dictionary: message)))
            }
        }

        #if os(iOS)
            func sessionDidBecomeInactive(_: WCSession) {
                DispatchQueue.main.async {
                    self.subscriber.send(.sessionDidBecomeInactive)
                }
            }

            func sessionDidDeactivate(_: WCSession) {
                DispatchQueue.main.async {
                    self.subscriber.send(.sessionDidDeactivate)
                }
            }

            func sessionWatchStateDidChange(_: WCSession) {
                DispatchQueue.main.async {
                    self.subscriber.send(.sessionWatchStateDidChange)
                }
            }

            func sessionReachabilityDidChange(_: WCSession) {
                DispatchQueue.main.async {
                    self.subscriber.send(.sessionReachabilityDidChange)
                }
            }
        #endif

        func session(_: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
            DispatchQueue.main.async {
                self.subscriber.send(.didReceiveApplicationContext(applicationContext: NSDictionary(dictionary: applicationContext)))
            }
        }
    }
#endif
