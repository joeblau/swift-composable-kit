// Interface.swift
// Copyright (c) 2021 Joe Blau

import ComposableArchitecture
import Foundation
import WebKit

public struct FastManager {
    public enum Action: Equatable {
        case didReceive(message: WKScriptMessage)
    }

    var createImplementation: () -> Effect<Action, Never> = { _unimplemented("create") }

    var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

    var startTestImplementation: () -> Effect<Never, Never> = { _unimplemented("startTest") }

    var stopTestImplementation: () -> Effect<Never, Never> = { _unimplemented("stopTest") }

    public func create(queue _: DispatchQueue? = nil, options _: [String: Any]? = nil) -> Effect<Action, Never> {
        createImplementation()
    }

    public func destroy() -> Effect<Never, Never> {
        destroyImplementation()
    }

    public func startTest() -> Effect<Never, Never> {
        startTestImplementation()
    }

    public func stopTest() -> Effect<Never, Never> {
        stopTestImplementation()
    }
}
