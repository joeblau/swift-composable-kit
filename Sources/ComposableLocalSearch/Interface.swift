//
//  File.swift
//  
//
//  Created by Joe Blau on 2/28/21.
//

import ComposableArchitecture
import Foundation
import MapKit

public struct LocalSearchManager {
    
    public enum Action: Equatable {
        case completerDidUpdateResults(completer: MKLocalSearchCompleter)
        case completer(MKLocalSearchCompleter, didFailWithError: Error)
    }
    
    public struct Error: Swift.Error, Equatable {
        public let error: NSError?

        public init(_ error: Swift.Error?) {
            self.error = error as NSError?
        }
    }

    var create: (AnyHashable, MKLocalSearchCompleter.ResultType) -> Effect<Action, Never> = { _, _ in _unimplemented("create") }

    var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }

    var query: (AnyHashable, String) -> Effect<Never, Never> = { _, _ in _unimplemented("query") }

    public func create(id: AnyHashable, resultTypes: MKLocalSearchCompleter.ResultType) -> Effect<Action, Never> {
        create(id, resultTypes)
    }

    public func destroy(id: AnyHashable) -> Effect<Never, Never> {
        destroy(id)
    }

    public func query(id: AnyHashable, fragment: String) -> Effect<Never, Never> {
        query(id, fragment)
    }
}

