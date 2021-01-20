// Live.swift
// Copyright (c) 2021 Joe Blau

import Combine
import ComposableArchitecture
import CoreBluetooth

public extension CentralManager {
    static let live: CentralManager = { () -> CentralManager in
        var manager = CentralManager()

        manager.create = { id, queue, options in
            Effect.run { subscriber in
                var delegate = CentralManagerDelegate(subscriber)
                let manager = CBCentralManager(delegate: delegate, queue: queue, options: options)

                dependencies[id] = Dependencies(delegate: delegate,
                                                manager: manager,
                                                subscriber: subscriber)
                return AnyCancellable {
                    dependencies[id] = nil
                }
            }
        }

        manager.destroy = { id in
            .fireAndForget {
                dependencies[id]?.subscriber.send(completion: .finished)
                dependencies[id] = nil
            }
        }

        manager.connect = { id, peripheral, options in
            .fireAndForget {
                dependencies[id]?.manager.connect(peripheral, options: options)
            }
        }

        manager.cancelPeripheralConnection = { id, peripheral in
            .fireAndForget {
                dependencies[id]?.manager.cancelPeripheralConnection(peripheral)
            }
        }

        manager.retrieveConnectedPeripherals = { id, services in
            dependencies[id]?.manager.retrieveConnectedPeripherals(withServices: services)
        }

        manager.retrievePeripherals = { id, identifiers in
            dependencies[id]?.manager.retrievePeripherals(withIdentifiers: identifiers)
        }

        manager.scanForPeripherals = { id, services, options in
            .fireAndForget {
                dependencies[id]?.manager.scanForPeripherals(withServices: services, options: options)
            }
        }

        manager.stopScan = { id in
            .fireAndForget {
                dependencies[id]?.manager.stopScan()
            }
        }

        #if os(iOS) || os(tvOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.registerForConnectionEvents = { id, options in
                .fireAndForget {
                    dependencies[id]?.manager.registerForConnectionEvents(options: options)
                }
            }
        #endif

        manager.state = { id in
            guard let dependency = dependencies[id] else { preconditionFailure("invalid dependency") }
            return dependency.manager.state
        }

        return manager
    }()
}

private struct Dependencies {
    let delegate: CBCentralManagerDelegate
    let manager: CBCentralManager
    let subscriber: Effect<CentralManager.Action, Never>.Subscriber
}

private var dependencies: [AnyHashable: Dependencies] = [:]

private class CentralManagerDelegate: NSObject, CBCentralManagerDelegate {
    let subscriber: Effect<CentralManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<CentralManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    /// Monitoring Connections with Peripherals

    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
        subscriber.send(.didConnect(peripheral: peripheral))
    }

    func centralManager(_: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        subscriber.send(.didDisconnect(peripheral: peripheral, error: CentralManager.Error(error)))
    }

    func centralManager(_: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        subscriber.send(.didFailToConnect(peripheral: peripheral, error: CentralManager.Error(error)))
    }

    #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
        func centralManager(_: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
            subscriber.send(.connectionEventDidOccur(event: event, peripheral: peripheral))
        }
    #endif

    /// Discovering and Retrieving Peripherals

    func centralManager(_: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let data = BluetoothAdvertisementData(advertisementData: advertisementData)
        subscriber.send(.didDiscover(peripheral: peripheral, advertisementData: data, rssi: RSSI))
    }

    /// Monitoring the Central Manager’s State

    func centralManagerDidUpdateState(_: CBCentralManager) {
        subscriber.send(.centralManagerDidUpdateState)
    }

    func centralManager(_: CBCentralManager, willRestoreState dict: [String: Any]) {
        let data = StateRestorationOptions(restoreState: dict)
        subscriber.send(.willRestore(state: data))
    }
}
