//
//  File.swift
//  
//
//  Created by Joe Blau on 2/28/21.
//

import Foundation

import Combine
import ComposableArchitecture
import Foundation
import MapKit

public extension LocalSearchManager {
    static let live: LocalSearchManager = { () -> LocalSearchManager in

        var manager = LocalSearchManager()

        manager.createImplementation = { resultTypes in
            .run { subscriber in
                let localSearchCompleter = MKLocalSearchCompleter()
                let delegate = LocalSearchManagerDelegate(subscriber)
                localSearchCompleter.resultTypes = resultTypes
                localSearchCompleter.delegate = delegate

                dependencies = Dependencies(delegate: delegate,
                                                localSearchCompleter: localSearchCompleter,
                                                subscriber: subscriber)
                return AnyCancellable {
                    dependencies = nil
                }
            }
        }
        
        manager.queryImplementation = { fragment in
            .fireAndForget {
                dependencies?.localSearchCompleter.queryFragment = fragment
            }
        }
        
        return manager
    }()
}

private struct Dependencies {
    let delegate: LocalSearchManagerDelegate
    let localSearchCompleter: MKLocalSearchCompleter
    let subscriber: Effect<LocalSearchManager.Action, Never>.Subscriber
}


private var dependencies: Dependencies?

// MARK: - Delegate

private class LocalSearchManagerDelegate: NSObject, MKLocalSearchCompleterDelegate {
    let subscriber: Effect<LocalSearchManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<LocalSearchManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        subscriber.send(.completerDidUpdateResults(completer: completer))
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        subscriber.send(.completer(completer, didFailWithError: LocalSearchManager.Error(error)))
    }

}
