// Mock.swift
// Copyright (c) 2020 Joe Blau

import Foundation

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
