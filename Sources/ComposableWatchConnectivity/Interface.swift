// Interface.swift
// Copyright (c) 2021 Joe Blau

#if canImport(WatchConnectivity)
    import ComposableArchitecture
    import Foundation
    import WatchConnectivity

    public struct WatchConnectivityManager {
        public enum Action: Equatable {
            case activationDidCompleteWith(activationState: WCSessionActivationState, error: Error?)
            case didReceiveMessage(message: NSDictionary)
            case didReceiveApplicationContext(applicationContext: NSDictionary)

            #if os(iOS)
                case sessionDidBecomeInactive
                case sessionDidDeactivate
                case sessionWatchStateDidChange
                case sessionReachabilityDidChange
            #endif
        }

        public struct Error: Swift.Error, Equatable {
            public let error: NSError?

            public init(_ error: Swift.Error?) {
                self.error = error as NSError?
            }
        }

        // MARK: - Variables

        var createImplementation: () -> Effect<Action, Never> = { _unimplemented("create") }

        var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

        var updateApplicationContextImplementation: ([String: Any]) -> Effect<Never, Never> = { _ in _unimplemented("updateApplicationContext")
        }

        var sendMessageImplementation: ([String: Any], (([String: Any]) -> Void)?) -> Effect<Never, Never> = { _, _ in
            _unimplemented("sendMessage")
        }

        var isReachableImplementation: () -> Bool = { _unimplemented("isReachable") }

        var isPairedImplementation: () -> Bool = { _unimplemented("isPaired") }

        var isWatchAppInstalledImplementation: () -> Bool = { _unimplemented("isWatchAppInstalled") }

        var validReachableSessionImplementation: () -> Bool = { _unimplemented("validReachableSession") }

        // MARK: - Functions

        public func create() -> Effect<Action, Never> {
            createImplementation()
        }

        public func destroy() -> Effect<Never, Never> {
            destroyImplementation()
        }

        public func updateApplicationContext(applicationContext: [String: Any]) -> Effect<Never, Never> {
            updateApplicationContextImplementation(applicationContext)
        }

        public func sendMessage(message: [String: Any], replyHandler: (([String: Any]) -> Void)?) -> Effect<Never, Never> {
            sendMessageImplementation(message, replyHandler)
        }

        public func isReachable() -> Bool {
            isReachableImplementation()
        }

        #if os(iOS)
            public func isPaired() -> Bool {
                isPairedImplementation()
            }

            public func isWatchAppInstalled() -> Bool {
                isWatchAppInstalledImplementation()
            }
        #endif

        public func validReachableSession() -> Bool {
            validReachableSessionImplementation()
        }
    }
#endif
