// XCTestManifests.swift
// Copyright (c) 2020 Joe Blau

import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(ComposableBluetoothCentralManagerTests.allTests),
        ]
    }
#endif
