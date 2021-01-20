// BluetoothAdvertisementData.swift
// Copyright (c) 2021 Joe Blau

import CoreBluetooth
import Foundation

public struct BluetoothAdvertisementData: Equatable {
    public let localName: String?
    public let manufacturerData: Data?
    public let serviceData: [CBUUID: Data]?
    public let serviceUUIDs: [CBUUID]?
    public let overflowServiceUUIDs: [CBUUID]?
    public let powerLevel: NSNumber?
    public let isConnectable: Bool?
    public let solicitedServiceUUIDs: [CBUUID]?
}

extension BluetoothAdvertisementData {
    init(advertisementData: [String: Any]) {
        localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        manufacturerData = advertisementData[CBAdvertisementDataLocalNameKey] as? Data
        serviceData = advertisementData[CBAdvertisementDataLocalNameKey] as? [CBUUID: Data]
        serviceUUIDs = advertisementData[CBAdvertisementDataLocalNameKey] as? [CBUUID]
        overflowServiceUUIDs = advertisementData[CBAdvertisementDataLocalNameKey] as? [CBUUID]
        powerLevel = advertisementData[CBAdvertisementDataLocalNameKey] as? NSNumber
        isConnectable = advertisementData[CBAdvertisementDataLocalNameKey] as? Bool
        solicitedServiceUUIDs = advertisementData[CBAdvertisementDataLocalNameKey] as? [CBUUID]
    }
}
