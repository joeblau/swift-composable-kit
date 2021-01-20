// StateRestorationOptions.swift
// Copyright (c) 2021 Joe Blau

import CoreBluetooth
import Foundation

public struct StateRestorationOptions: Equatable {
    public let peripherals: [CBPeripheral]?
    public let scanServices: [CBUUID]?
    public let scanOptions: PeripheralScanningOptions?
}

extension StateRestorationOptions {
    init(restoreState: [String: Any]) {
        peripherals = restoreState[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral]
        scanServices = restoreState[CBCentralManagerRestoredStateScanServicesKey] as? [CBUUID]

        let options = restoreState[CBCentralManagerRestoredStateScanOptionsKey] as? [String: Any]
        scanOptions = PeripheralScanningOptions(peripheralScanningOptions: options)
    }
}
