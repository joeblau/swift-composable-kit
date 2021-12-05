// Interface.swift
// Copyright (c) 2021 Joe Blau

import Combine
import ComposableArchitecture
import CoreBluetooth

public struct CentralManager {
    public enum Action: Equatable {
        case didConnect(peripheral: CBPeripheral)
        case didDisconnect(peripheral: CBPeripheral, error: Error?)
        case didFailToConnect(peripheral: CBPeripheral, error: Error?)
        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
            case connectionEventDidOccur(event: CBConnectionEvent, peripheral: CBPeripheral)
        #endif

        case didDiscover(peripheral: CBPeripheral, advertisementData: BluetoothAdvertisementData, rssi: NSNumber)

        case centralManagerDidUpdateState
        case willRestore(state: StateRestorationOptions)

        case didUpdateANCSAuthorizationFor(peripheral: CBPeripheral)
    }

    var createImplementation: (DispatchQueue?, [String: Any]?) -> Effect<Action, Never> = { _, _ in _unimplemented("create") }

    var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

    var connectImplementation: (CBPeripheral, [String: Any]?) -> Effect<Never, Never> = { _, _ in _unimplemented("connect") }

    var cancelPeripheralConnectionImplementation: (CBPeripheral) -> Effect<Never, Never> = { _ in
        _unimplemented("cancelPeripheralConnection")
    }

    var retrieveConnectedPeripheralsImplementation: ([CBUUID]) -> [CBPeripheral]? = { _ in
        _unimplemented("retrieveConnectedPeripherals")
    }

    var retrievePeripheralsImplementation: ([UUID]) -> [CBPeripheral]? = { _ in _unimplemented("retrievePeripherals") }

    var scanForPeripheralsImplementation: ([CBUUID]?, [String: Any]?) -> Effect<Never, Never> = { _, _ in
        _unimplemented("scanForPeripherals")
    }

    var stopScanImplementation: () -> Effect<Never, Never> = { _unimplemented("stopScan") }

    var isScanningImplementation: () -> Bool = { _unimplemented("isScanning") }

    var stateImplementation: () -> CBManagerState = { _unimplemented("state") }

    @available(macOS, unavailable)
    var supportsImplementation: (CBCentralManager.Feature) -> Bool = { _ in _unimplemented("supports") }

    var registerForConnectionEventsImplementation: ([CBConnectionEventMatchingOption: Any]?) -> Effect<Never, Never> = { _ in
        _unimplemented("registerForConnectionEvents")
    }

    public struct Error: Swift.Error, Equatable {
        public let error: NSError?

        public init(_ error: Swift.Error?) {
            self.error = error as NSError?
        }
    }

    // MARK: - Concrete

    public func create(queue: DispatchQueue? = nil, options: [String: Any]? = nil) -> Effect<Action, Never> {
        createImplementation(queue, options)
    }

    public func destroy() -> Effect<Never, Never> {
        destroyImplementation()
    }

    /// Establishing or Canceling Connections with Peripherals

    public func connect(peripheral: CBPeripheral, options: [String: Any]?) -> Effect<Never, Never> {
        connectImplementation(peripheral, options)
    }

    public func cancelPeripheralConnection(peripheral: CBPeripheral) -> Effect<Never, Never> {
        cancelPeripheralConnectionImplementation(peripheral)
    }

    /// Retrieving Lists of Peripherals

    public func retrieveConnectedPeripherals(withServices services: [CBUUID]) -> [CBPeripheral]? {
        retrieveConnectedPeripheralsImplementation(services)
    }

    public func retrievePeripherals(withIdentifiers identifiers: [UUID]) -> [CBPeripheral]? {
        retrievePeripheralsImplementation(identifiers)
    }

    /// Scanning or Stopping Scans of Peripherals

    public func scanForPeripherals(withServices services: [CBUUID]?, options: [String: Any]?) -> Effect<Never, Never> {
        scanForPeripheralsImplementation(services, options)
    }

    public func stopScan() -> Effect<Never, Never> {
        stopScanImplementation()
    }

    public func isScanning() -> Bool {
        isScanningImplementation()
    }

    public func state() -> CBManagerState {
        stateImplementation()
    }

    /// Inspecting Feature Support

    @available(macOS, unavailable)
    public func supports(features: CBCentralManager.Feature) -> Bool {
        supportsImplementation(features)
    }

    /// Receiving Connection Events

    public func registerForConnectionEvents(options: [CBConnectionEventMatchingOption: Any]?) -> Effect<Never, Never> {
        registerForConnectionEventsImplementation(options)
    }

    // MARK: - Actions
}

// MARK: - Properties

public extension CentralManager {
    struct Properties: Equatable {
        public init() {}
    }
}
