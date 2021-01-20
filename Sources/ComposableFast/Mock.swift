// Mock.swift
// Copyright (c) 2021 Joe Blau

#if DEBUG
    import Foundation

    public extension FastManager {
        static func mock() -> Self { Self() }
    }

#endif

// MARK: - Unimplemented

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
