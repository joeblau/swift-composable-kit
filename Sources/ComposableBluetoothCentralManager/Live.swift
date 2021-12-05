// Live.swift
// Copyright (c) 2021 Joe Blau

import Combine
import ComposableArchitecture
import CoreBluetooth

public extension CentralManager {
    static let live: CentralManager = { () -> CentralManager in
        var manager = CentralManager()

        manager.createImplementation = { queue, options in
            Effect.run { subscriber in
                var delegate = CentralManagerDelegate(subscriber)
                let manager = CBCentralManager(delegate: delegate, queue: queue, options: options)

                dependencies = Dependencies(delegate: delegate,
                                                manager: manager,
                                                subscriber: subscriber)
                return AnyCancellable {
                    dependencies = nil
                }
            }
        }

        manager.destroyImplementation = {
            .fireAndForget {
                dependencies?.subscriber.send(completion: .finished)
                dependencies = nil
            }
        }

        manager.connectImplementation = { peripheral, options in
            .fireAndForget {
                dependencies?.manager.connect(peripheral, options: options)
            }
        }

        manager.cancelPeripheralConnectionImplementation = { peripheral in
            .fireAndForget {
                dependencies?.manager.cancelPeripheralConnection(peripheral)
            }
        }

        manager.retrieveConnectedPeripheralsImplementation = { services in
            dependencies?.manager.retrieveConnectedPeripherals(withServices: services)
        }

        manager.retrievePeripheralsImplementation = { identifiers in
            dependencies?.manager.retrievePeripherals(withIdentifiers: identifiers)
        }

        manager.scanForPeripheralsImplementation = { services, options in
            .fireAndForget {
                dependencies?.manager.scanForPeripherals(withServices: services, options: options)
            }
        }

        manager.stopScanImplementation = {
            .fireAndForget {
                dependencies?.manager.stopScan()
            }
        }

        #if os(iOS) || os(tvOS) || os(watchOS) || targetEnvironment(macCatalyst)
            manager.registerForConnectionEventsImplementation = { options in
                .fireAndForget {
                    dependencies?.manager.registerForConnectionEvents(options: options)
                }
            }
        #endif

        manager.stateImplementation = {
            guard let dependency = dependencies else { preconditionFailure("invalid dependency") }
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

private var dependencies: Dependencies?

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
