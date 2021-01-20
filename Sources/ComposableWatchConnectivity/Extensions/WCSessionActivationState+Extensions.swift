// WCSessionActivationState+Extensions.swift
// Copyright (c) 2021 Joe Blau

#if canImport(WatchConnectivity)
    import Foundation
    import WatchConnectivity

    extension WCSessionActivationState: CustomStringConvertible {
        public var description: String {
            switch self {
            case .notActivated: return "Not Activated"
            case .inactive: return "Inactive"
            case .activated: return "Activated"
            @unknown default: return "Unknown"
            }
        }
    }
#endif
