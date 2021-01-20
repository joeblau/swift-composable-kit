// Interface.swift
// Copyright (c) 2021 Joe Blau

import ComposableArchitecture
import Foundation
import WebKit

public struct FastManager {
    public enum Action: Equatable {
        case didReceive(message: WKScriptMessage)
    }

    var create: (AnyHashable) -> Effect<Action, Never> = { _ in _unimplemented("create") }

    var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }

    var startTest: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("startTest") }

    var stopTest: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("stopTest") }

    public func create(id: AnyHashable, queue _: DispatchQueue? = nil, options _: [String: Any]? = nil) -> Effect<Action, Never> {
        create(id)
    }

    public func destroy(id: AnyHashable) -> Effect<Never, Never> {
        destroy(id)
    }

    public func startTest(id: AnyHashable) -> Effect<Never, Never> {
        startTest(id)
    }

    public func stopTest(id: AnyHashable) -> Effect<Never, Never> {
        stopTest(id)
    }
}
