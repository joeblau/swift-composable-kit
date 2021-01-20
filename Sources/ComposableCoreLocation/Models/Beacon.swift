// Beacon.swift
// Copyright (c) 2021 Joe Blau

import CoreLocation

/// A value type wrapper for `CLBeacon`. This type is necessary so that we can do equality checks
/// and write tests against its values.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct Beacon: Hashable {
    public var accuracy: CLLocationAccuracy
    public var major: NSNumber
    public var minor: NSNumber
    public var proximity: CLProximity
    public var rssi: Int
    public var timestamp: Date
    public var uuid: UUID

    public init(rawValue: CLBeacon) {
        accuracy = rawValue.accuracy
        major = rawValue.major
        minor = rawValue.minor
        proximity = rawValue.proximity
        rssi = rawValue.rssi
        timestamp = rawValue.timestamp
        uuid = rawValue.uuid
    }

    public init(
        accuracy: CLLocationAccuracy,
        major: NSNumber,
        minor: NSNumber,
        proximity: CLProximity,
        rssi: Int,
        timestamp: Date,
        uuid: UUID
    ) {
        self.accuracy = accuracy
        self.major = major
        self.minor = minor
        self.proximity = proximity
        self.rssi = rssi
        self.timestamp = timestamp
        self.uuid = uuid
    }
}
