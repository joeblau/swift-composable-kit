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

            manager.createImplementation = {

                Effect.run { subscriber in
                    guard WCSession.isSupported() else {
                        return AnyCancellable {
                            dependencies = nil
                        }
                    }

                    var delegate = WatchConnectivityDelegate(subscriber)
                    let session = WCSession.default
                    session.delegate = delegate
                    session.activate()

                    dependencies = Dependencies(
                        session: session,
                        watchConnectivityDelegate: delegate,
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

            manager.updateApplicationContextImplementation = { applicationContext in
                .fireAndForget {
                    try? dependencies?.session.updateApplicationContext(applicationContext)
                }
            }

            manager.sendMessageImplementation = { message, replyHandler in
                .fireAndForget {
                    dependencies?.session.sendMessage(message, replyHandler: replyHandler)
                }
            }

            manager.isReachableImplementation = {
                dependencies?.session.isReachable ?? false
            }

            #if os(iOS)
                manager.isPairedImplementation = {
                    dependencies?.session.isPaired ?? false
                }

                manager.isWatchAppInstalledImplementation = {
                    dependencies?.session.isWatchAppInstalled ?? false
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

    private var dependencies: Dependencies?

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
