// RelativeAltitudeData.swift
// Copyright (c) 2021 Joe Blau

#if canImport(CoreMotion) && (os(iOS) || os(watchOS))
    import CoreMotion

    /// Measurements of the Earth's magnetic field relative to the device.
    ///
    /// See the documentation for `CMMagnetometerData` for more info.
    public struct RelativeAltitudeData: Hashable, Equatable {
        public var relativeAltitude: NSNumber
        public var pressure: NSNumber

        public init(_ altitudeData: CMAltitudeData) {
            relativeAltitude = altitudeData.relativeAltitude
            pressure = altitudeData.pressure
        }

        public init(
            relativeAltitude: NSNumber,
            pressure: NSNumber
        ) {
            self.relativeAltitude = relativeAltitude
            self.pressure = pressure
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.relativeAltitude == rhs.relativeAltitude
                && lhs.pressure == rhs.pressure
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(relativeAltitude)
            hasher.combine(pressure)
        }
    }
#endif
