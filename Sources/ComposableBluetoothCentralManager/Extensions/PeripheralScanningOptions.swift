// PeripheralScanningOptions.swift
// Copyright (c) 2021 Joe Blau

import CoreBluetooth
import Foundation

public struct PeripheralScanningOptions: Equatable {
    public let allowDuplicates: Bool?
    public let serviceUUIDs: [CBUUID]?
}

extension PeripheralScanningOptions {
    init(peripheralScanningOptions: [String: Any]?) {
        allowDuplicates = peripheralScanningOptions?[CBCentralManagerScanOptionAllowDuplicatesKey] as? Bool
        serviceUUIDs = peripheralScanningOptions?[CBCentralManagerScanOptionSolicitedServiceUUIDsKey] as? [CBUUID]
    }
}
