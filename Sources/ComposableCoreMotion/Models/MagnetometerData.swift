// MagnetometerData.swift
// Copyright (c) 2021 Joe Blau

#if canImport(CoreMotion)
    import CoreMotion

    /// Measurements of the Earth's magnetic field relative to the device.
    ///
    /// See the documentation for `CMMagnetometerData` for more info.
    public struct MagnetometerData: Hashable {
        public var magneticField: CMMagneticField
        public var timestamp: TimeInterval

        public init(_ magnetometerData: CMMagnetometerData) {
            magneticField = magnetometerData.magneticField
            timestamp = magnetometerData.timestamp
        }

        public init(
            magneticField: CMMagneticField,
            timestamp: TimeInterval
        ) {
            self.magneticField = magneticField
            self.timestamp = timestamp
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.magneticField.x == rhs.magneticField.x
                && lhs.magneticField.y == rhs.magneticField.y
                && lhs.magneticField.z == rhs.magneticField.z
                && lhs.timestamp == rhs.timestamp
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(magneticField.x)
            hasher.combine(magneticField.y)
            hasher.combine(magneticField.z)
            hasher.combine(timestamp)
        }
    }
#endif
