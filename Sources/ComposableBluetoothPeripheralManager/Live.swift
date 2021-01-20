// Live.swift
// Copyright (c) 2021 Joe Blau

import Combine
import ComposableArchitecture
import CoreBluetooth

public extension PeripheralManager {
    static let live: PeripheralManager = { () -> PeripheralManager in
        var peripheral = PeripheralManager()

        peripheral.create = { id in
            Effect.run { subscriber in
                var delegate = PeripheralDelegate(subscriber)
                let peripherals = [CBPeripheral]()

                dependencies[id] = Dependencies(delegate: delegate,
                                                peripherals: peripherals,
                                                subscriber: subscriber)
                return AnyCancellable {
                    dependencies[id] = nil
                }
            }
        }

        peripheral.destroy = { id in
            .fireAndForget {
                dependencies[id]?.subscriber.send(completion: .finished)
                dependencies[id] = nil
            }
        }

        peripheral.addPeripheral = { id, peripheral, services in
            .fireAndForget {
                dependencies[id]?.peripherals.append(peripheral)
                peripheral.delegate = dependencies[id]?.delegate
                peripheral.discoverServices(services)
            }
        }

        return peripheral
    }()
}

private struct Dependencies {
    let delegate: CBPeripheralDelegate
    var peripherals: [CBPeripheral]
    let subscriber: Effect<PeripheralManager.Action, Never>.Subscriber
}

private var dependencies: [AnyHashable: Dependencies] = [:]

private class PeripheralDelegate: NSObject, CBPeripheralDelegate {
    let subscriber: Effect<PeripheralManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<PeripheralManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    /// Discovering Services

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        subscriber.send(.didDiscoverServices(peripheral, error: PeripheralManager.Error(error)))
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        subscriber.send(.didDiscoverIncludedServicesFor(peripheral, service: service, error: PeripheralManager.Error(error)))
    }

    /// Discovering Characteristics and their Descriptors

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        subscriber.send(.didDiscoverCharacteristicsFor(peripheral, service: service, error: PeripheralManager.Error(error)))
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        subscriber.send(.didDiscoverDescriptorsFor(peripheral, characteristic: characteristic, error: PeripheralManager.Error(error)))
    }

    /// Retrieving Characteristic and Descriptor Values

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        subscriber.send(.didUpdateCharacteristicValueFor(peripheral, characteristic: characteristic, error: PeripheralManager.Error(error)))
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        subscriber.send(.didUpdateDescriptorValueFor(peripheral, descriptor: descriptor, error: PeripheralManager.Error(error)))
    }

    /// Writing Characteristic and Descriptor Values

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        subscriber.send(.didWriteCharacteristicValueFor(peripheral, characteristic: characteristic, error: PeripheralManager.Error(error)))
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        subscriber.send(.didWriteDescriptorValueFor(peripheral, descriptor: descriptor, error: PeripheralManager.Error(error)))
    }

    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        subscriber.send(.peripheralIsReadyToSendWriteWithoutResponse(peripheral: peripheral))
    }

    /// Managing Notifications for a Characteristic’s Value

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        subscriber.send(.didUpdateNotificationStateFor(peripheral, characteristic: characteristic, error: PeripheralManager.Error(error)))
    }

    /// Retrieving a Peripheral’s RSSI Data

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        subscriber.send(.didReadRSSI(peripheral, rssi: RSSI, error: PeripheralManager.Error(error)))
    }

    /// Monitoring Changes to a Peripheral’s Name or Services

    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        subscriber.send(.peripheralDidUpdateName(peripheral))
    }

    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        subscriber.send(.didModifyServices(peripheral, services: invalidatedServices))
    }

    /// Monitoring L2CAP Channels

    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
        subscriber.send(.didOpen(peripheral, channel: channel, error: PeripheralManager.Error(error)))
    }
}
