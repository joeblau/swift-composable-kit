// Mock.swift
// Copyright (c) 2021 Joe Blau

#if canImport(HealthKit)
    import ComposableArchitecture

    #if DEBUG
        public extension HealthStoreManager {
            static func unimplemented() -> Self {
                Self()
            }
        }

    #endif

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
