// Region.swift
// Copyright (c) 2021 Joe Blau

import CoreLocation

/// A value type wrapper for `CLRegion`. This type is necessary so that we can do equality checks
/// and write tests against its values.
public struct Region: Hashable {
    public let rawValue: CLRegion?

    public var identifier: String
    public var notifyOnEntry: Bool
    public var notifyOnExit: Bool

    init(rawValue: CLRegion) {
        self.rawValue = rawValue

        identifier = rawValue.identifier
        notifyOnEntry = rawValue.notifyOnEntry
        notifyOnExit = rawValue.notifyOnExit
    }

    init(
        identifier: String,
        notifyOnEntry: Bool,
        notifyOnExit: Bool
    ) {
        rawValue = nil

        self.identifier = identifier
        self.notifyOnEntry = notifyOnEntry
        self.notifyOnExit = notifyOnExit
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier
            && lhs.notifyOnEntry == rhs.notifyOnEntry
            && lhs.notifyOnExit == rhs.notifyOnExit
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(notifyOnExit)
        hasher.combine(notifyOnEntry)
    }
}
