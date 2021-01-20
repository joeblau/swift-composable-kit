// AccelerometerData.swift
// Copyright (c) 2021 Joe Blau

#if canImport(CoreMotion)
    import CoreMotion

    /// A data sample from the device's three accelerometers.
    ///
    /// See the documentation for `CMAccelerometerData` for more info.
    public struct AccelerometerData: Hashable {
        public var acceleration: CMAcceleration

        public init(_ accelerometerData: CMAccelerometerData) {
            acceleration = accelerometerData.acceleration
        }

        public init(acceleration: CMAcceleration) {
            self.acceleration = acceleration
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.acceleration.x == rhs.acceleration.x
                && lhs.acceleration.y == rhs.acceleration.y
                && lhs.acceleration.z == rhs.acceleration.z
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(acceleration.x)
            hasher.combine(acceleration.y)
            hasher.combine(acceleration.z)
        }
    }
#endif
