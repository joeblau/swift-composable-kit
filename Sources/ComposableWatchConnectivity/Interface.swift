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

        var create: (AnyHashable) -> Effect<Action, Never> = { _ in _unimplemented("create") }

        var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }

        var updateApplicationContext: (AnyHashable, [String: Any]) -> Effect<Never, Never> = { _, _ in _unimplemented("updateApplicationContext") }

        var sendMessage: (AnyHashable, [String: Any], (([String: Any]) -> Void)?) -> Effect<Never, Never> = { _, _, _ in _unimplemented("sendMessage") }

        var isReachable: (AnyHashable) -> Bool = { _ in _unimplemented("isReachable") }

        var isPaired: (AnyHashable) -> Bool = { _ in _unimplemented("isPaired") }

        var isWatchAppInstalled: (AnyHashable) -> Bool = { _ in _unimplemented("isWatchAppInstalled") }

        var validReachableSession: (AnyHashable) -> Bool = { _ in _unimplemented("validReachableSession") }

        // MARK: - Functions

        public func create(id: AnyHashable) -> Effect<Action, Never> {
            create(id)
        }

        public func destroy(id: AnyHashable) -> Effect<Never, Never> {
            destroy(id)
        }

        public func updateApplicationContext(id: AnyHashable, applicationContext: [String: Any]) -> Effect<Never, Never> {
            updateApplicationContext(id, applicationContext)
        }

        public func sendMessage(id: AnyHashable, message: [String: Any], replyHandler: (([String: Any]) -> Void)?) -> Effect<Never, Never> {
            sendMessage(id, message, replyHandler)
        }

        public func isReachable(id: AnyHashable) -> Bool {
            isReachable(id)
        }

        #if os(iOS)
            public func isPaired(id: AnyHashable) -> Bool {
                isPaired(id)
            }

            public func isWatchAppInstalled(id: AnyHashable) -> Bool {
                isWatchAppInstalled(id)
            }
        #endif

        public func validReachableSession(id: AnyHashable) -> Bool {
            validReachableSession(id)
        }
    }
#endif
