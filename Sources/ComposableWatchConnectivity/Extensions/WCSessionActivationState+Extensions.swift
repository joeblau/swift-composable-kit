//
//  File.swift
//  
//
//  Created by Joe Blau on 11/5/20.
//

#if os(iOS) || os(watchOS)
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
