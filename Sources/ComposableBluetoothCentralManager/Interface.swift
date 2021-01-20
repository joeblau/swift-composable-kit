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

    var create: (AnyHashable, DispatchQueue?, [String: Any]?) -> Effect<Action, Never> = { _, _, _ in _unimplemented("create") }

    var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }

    var connect: (AnyHashable, CBPeripheral, [String: Any]?) -> Effect<Never, Never> = { _, _, _ in _unimplemented("connect") }

    var cancelPeripheralConnection: (AnyHashable, CBPeripheral) -> Effect<Never, Never> = { _, _ in _unimplemented("cancelPeripheralConnection") }

    var retrieveConnectedPeripherals: (AnyHashable, [CBUUID]) -> [CBPeripheral]? = { _, _ in _unimplemented("retrieveConnectedPeripherals") }

    var retrievePeripherals: (AnyHashable, [UUID]) -> [CBPeripheral]? = { _, _ in _unimplemented("retrievePeripherals") }

    var scanForPeripherals: (AnyHashable, [CBUUID]?, [String: Any]?) -> Effect<Never, Never> = { _, _, _ in _unimplemented("scanForPeripherals") }

    var stopScan: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("stopScan") }

    public var isScanning: (AnyHashable) -> Bool = { _ in _unimplemented("isScanning") }

    public var state: (AnyHashable) -> CBManagerState = { _ in _unimplemented("state") }

    @available(macOS, unavailable)
    var supports: (AnyHashable, CBCentralManager.Feature) -> Bool = { _, _ in _unimplemented("supports") }

    var registerForConnectionEvents: (AnyHashable, [CBConnectionEventMatchingOption: Any]?) -> Effect<Never, Never> = { _, _ in _unimplemented("registerForConnectionEvents") }

    public struct Error: Swift.Error, Equatable {
        public let error: NSError?

        public init(_ error: Swift.Error?) {
            self.error = error as NSError?
        }
    }

    // MARK: - Concrete

    public func create(id: AnyHashable, queue: DispatchQueue? = nil, options: [String: Any]? = nil) -> Effect<Action, Never> {
        create(id, queue, options)
    }

    public func destroy(id: AnyHashable) -> Effect<Never, Never> {
        destroy(id)
    }

    /// Establishing or Canceling Connections with Peripherals

    public func connect(id: AnyHashable, peripheral: CBPeripheral, options: [String: Any]?) -> Effect<Never, Never> {
        connect(id, peripheral, options)
    }

    public func cancelPeripheralConnection(id: AnyHashable, peripheral: CBPeripheral) -> Effect<Never, Never> {
        cancelPeripheralConnection(id, peripheral)
    }

    /// Retrieving Lists of Peripherals

    public func retrieveConnectedPeripherals(id: AnyHashable, withServices: [CBUUID]) -> [CBPeripheral]? {
        retrieveConnectedPeripherals(id, withServices)
    }

    public func retrievePeripherals(id: AnyHashable, withIdentifiers: [UUID]) -> [CBPeripheral]? {
        retrievePeripherals(id, withIdentifiers)
    }

    /// Scanning or Stopping Scans of Peripherals

    public func scanForPeripherals(id: AnyHashable, withServices: [CBUUID]?, options: [String: Any]?) -> Effect<Never, Never> {
        scanForPeripherals(id, withServices, options)
    }

    public func stopScan(id: AnyHashable) -> Effect<Never, Never> {
        stopScan(id)
    }

    public func isScanning(id: AnyHashable) -> Bool {
        isScanning(id)
    }

    public func state(id: AnyHashable) -> CBManagerState {
        state(id)
    }

    /// Inspecting Feature Support

    @available(macOS, unavailable)
    public func supports(id: AnyHashable, features: CBCentralManager.Feature) -> Bool {
        supports(id, features)
    }

    /// Receiving Connection Events

    public func registerForConnectionEvents(id: AnyHashable, options: [CBConnectionEventMatchingOption: Any]?) -> Effect<Never, Never> {
        registerForConnectionEvents(id, options)
    }

    // MARK: - Actions
}

// MARK: - Properties

public extension CentralManager {
    struct Properties: Equatable {
        public init() {}
    }
}
