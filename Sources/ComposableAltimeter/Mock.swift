// Mock.swift
// Copyright (c) 2021 Joe Blau

// ComposableWorkoutMock.swift
// Copyright (c) 2020 Copilot
#if canImport(CoreMotion) && (os(iOS) || os(watchOS))
    import ComposableArchitecture
    import CoreMotion

    public extension AltimeterManager {
        static func umimplemented(
            create: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("create") },
            destroy: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") },
            authorizationStatus: @escaping () -> CMAuthorizationStatus = {
                _unimplemented("authorizationStatus")
            },
            isRelativeAltitudeAvailable: @escaping () -> Bool = {
                _unimplemented("isRelativeAltitudeAvailable")
            },
            startRelativeAltitudeUpdates: @escaping (AnyHashable, OperationQueue) -> Effect<RelativeAltitudeData, Error> = { _, _ in
                _unimplemented("startRelativeAltitudeUpdates")

            },
            stopRelativeAltitudeUpdates: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
                _unimplemented("stopRelativeAltitudeUpdates")
            }
        ) -> AltimeterManager {
            Self(
                create: create,
                destroy: destroy,
                authorizationStatus: authorizationStatus,
                isRelativeAltitudeAvailable: isRelativeAltitudeAvailable,
                startRelativeAltitudeUpdates: startRelativeAltitudeUpdates,
                stopRelativeAltitudeUpdates: stopRelativeAltitudeUpdates
            )
        }
    }

    public func _unimplemented(
        _ function: StaticString, file: StaticString = #file, line: UInt = #line
    ) -> Never {
        fatalError(
            """
            `\(function)` was called but is not implemented. Be sure to provide an implementation for
            this endpoint when creating the mock.
            """,
            file: file,
            line: line
        )
    }
#endif
