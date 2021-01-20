// Visit.swift
// Copyright (c) 2021 Joe Blau

import CoreLocation

/// A value type wrapper for `CLVisit`. This type is necessary so that we can do equality checks
/// and write tests against its values.
@available(iOS 8, macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct Visit: Hashable {
    public let rawValue: CLVisit?

    public var arrivalDate: Date
    public var coordinate: CLLocationCoordinate2D
    public var departureDate: Date
    public var horizontalAccuracy: CLLocationAccuracy

    init(visit: CLVisit) {
        rawValue = nil

        arrivalDate = visit.arrivalDate
        coordinate = visit.coordinate
        departureDate = visit.departureDate
        horizontalAccuracy = visit.horizontalAccuracy
    }

    public init(
        arrivalDate: Date,
        coordinate: CLLocationCoordinate2D,
        departureDate: Date,
        horizontalAccuracy: CLLocationAccuracy
    ) {
        rawValue = nil

        self.arrivalDate = arrivalDate
        self.coordinate = coordinate
        self.departureDate = departureDate
        self.horizontalAccuracy = horizontalAccuracy
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.arrivalDate == rhs.arrivalDate
            && lhs.coordinate.latitude == rhs.coordinate.latitude
            && lhs.coordinate.longitude == rhs.coordinate.longitude
            && lhs.departureDate == rhs.departureDate
            && lhs.horizontalAccuracy == rhs.horizontalAccuracy
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(arrivalDate)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
        hasher.combine(departureDate)
        hasher.combine(horizontalAccuracy)
    }
}
