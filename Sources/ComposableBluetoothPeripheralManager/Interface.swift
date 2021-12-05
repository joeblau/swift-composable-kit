// Interface.swift
// Copyright (c) 2021 Joe Blau

import Combine
import ComposableArchitecture
import CoreBluetooth

public struct PeripheralManager {
    public enum Action: Equatable {
        /// Discovering Services
        case didDiscoverServices(_ peripheral: CBPeripheral, error: Error?)
        case didDiscoverIncludedServicesFor(_ peripheral: CBPeripheral, service: CBService, error: Error?)

        /// Discovering Characteristics and their Descriptors
        case didDiscoverCharacteristicsFor(_ peripheral: CBPeripheral, service: CBService, error: Error?)
        case didDiscoverDescriptorsFor(_ peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)

        /// Retrieving Characteristic and Descriptor Values
        case didUpdateCharacteristicValueFor(_ peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)
        case didUpdateDescriptorValueFor(_ peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?)

        /// Writing Characteristic and Descriptor Values
        case didWriteCharacteristicValueFor(_ peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)
        case didWriteDescriptorValueFor(_ peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?)
        case peripheralIsReadyToSendWriteWithoutResponse(peripheral: CBPeripheral)

        /// Managing Notifications for a Characteristic’s Value
        case didUpdateNotificationStateFor(_ peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)

        /// Retrieving a Peripheral’s RSSI Data
        case didReadRSSI(_ peripheral: CBPeripheral, rssi: NSNumber, error: Error?)

        /// Monitoring Changes to a Peripheral’s Name or Services

        case peripheralDidUpdateName(_ peripheral: CBPeripheral)
        case didModifyServices(_ peripheral: CBPeripheral, services: [CBService])

        /// Monitoring L2CAP Channels
        case didOpen(_ peripheral: CBPeripheral, channel: CBL2CAPChannel?, error: Error?)
    }

    var createImplementation: () -> Effect<Action, Never> = { _unimplemented("create") }

    var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

    var addPeripheralImplementation: (CBPeripheral, [CBUUID]?) -> Effect<Never, Never> = { _, _ in
        _unimplemented("addPeripheral")
    }

    public struct Error: Swift.Error, Equatable {
        public let error: NSError?

        public init(_ error: Swift.Error?) {
            self.error = error as NSError?
        }
    }

    // MARK: - Concrete

    public func create() -> Effect<Action, Never> {
        createImplementation()
    }

    public func destroy() -> Effect<Never, Never> {
        destroyImplementation()
    }

    public func addPeriphal(peripheral: CBPeripheral, services: [CBUUID]?) -> Effect<Never, Never> {
        addPeripheralImplementation(peripheral, services)
    }
}
