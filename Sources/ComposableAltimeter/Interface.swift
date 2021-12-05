// Interface.swift
// Copyright (c) 2021 Joe Blau

// ComposableWorkoutInterface.swift
// Copyright (c) 2020 Copilot
#if canImport(CoreMotion) && (os(iOS) || os(watchOS))
    import ComposableArchitecture
    import CoreMotion
    import Foundation

    public struct AltimeterManager {
        // MARK: - Variables

        var createImplementation: () -> Effect<Never, Never> = { _unimplemented("create") }

        var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

        var startRelativeAltitudeUpdatesImplementation: (OperationQueue) -> Effect<RelativeAltitudeData, Error> = { _ in
            _unimplemented("startRelativeAltitudeUpdates")
        }
        
        var stopRelativeAltitudeUpdatesImplementation: () -> Effect<Never, Never> = {
            _unimplemented("stopRelativeAltitudeUpdates")
        }
        
        public var authorizationStatus: () -> CMAuthorizationStatus = {
            _unimplemented("authorizationStatus")
        }
        
        public var isRelativeAltitudeAvailable: () -> Bool = {
            _unimplemented("isRelativeAltitudeAvailable")
        }

        // MARK: - Functions

        public func create() -> Effect<Never, Never> {
            createImplementation()
        }

        public func destroy() -> Effect<Never, Never> {
            destroyImplementation()
        }

        public func startRelativeAltitudeUpdates(to queue: OperationQueue = .main) -> Effect<RelativeAltitudeData, Error> {
            startRelativeAltitudeUpdatesImplementation(queue)
        }

        public func stopRelativeAltitudeUpdates() -> Effect<Never, Never> {
            stopRelativeAltitudeUpdatesImplementation()
        }

//    public init(
//        create: @escaping (AnyHashable) -> Effect<Never, Never>,
//        destroy: @escaping (AnyHashable) -> Effect<Never, Never>,
//        authorizationStatus: @escaping () -> CMAuthorizationStatus,
//        isRelativeAltitudeAvailable:  @escaping () -> Bool,
//        startRelativeAltitudeUpdates: @escaping (AnyHashable, OperationQueue) -> Effect<RelativeAltitudeData, Error>,
//        stopRelativeAltitudeUpdates: @escaping (AnyHashable) -> Effect<Never, Never>
//    ) {
//        self.create = create
//        self.destroy = destroy
//        self.authorizationStatus = authorizationStatus
//        self.isRelativeAltitudeAvailable = isRelativeAltitudeAvailable
//        self.startRelativeAltitudeUpdates = startRelativeAltitudeUpdates
//        self.stopRelativeAltitudeUpdates = stopRelativeAltitudeUpdates
//    }
    }
#endif
