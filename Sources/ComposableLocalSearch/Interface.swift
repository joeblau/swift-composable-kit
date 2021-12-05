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

    var createImplementation: (MKLocalSearchCompleter.ResultType) -> Effect<Action, Never> = { _ in _unimplemented("create") }

    var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

    var queryImplementation: (String) -> Effect<Never, Never> = { _ in _unimplemented("query") }

    public func create(resultTypes: MKLocalSearchCompleter.ResultType) -> Effect<Action, Never> {
        createImplementation(resultTypes)
    }

    public func destroy() -> Effect<Never, Never> {
        destroyImplementation()
    }

    public func query(fragment: String) -> Effect<Never, Never> {
        queryImplementation(fragment)
    }
}

