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

        var create: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("create") }

        var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }

        public var authorizationStatus: () -> CMAuthorizationStatus = { _unimplemented("authorizationStatus") }
        public var isRelativeAltitudeAvailable: () -> Bool = { _unimplemented("isRelativeAltitudeAvailable") }

        var startRelativeAltitudeUpdates: (AnyHashable, OperationQueue) -> Effect<RelativeAltitudeData, Error> = { _, _ in _unimplemented("startRelativeAltitudeUpdates") }
        var stopRelativeAltitudeUpdates: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("stopRelativeAltitudeUpdates") }

        // MARK: - Functions

        public func create(id: AnyHashable) -> Effect<Never, Never> {
            create(id)
        }

        public func destroy(id: AnyHashable) -> Effect<Never, Never> {
            destroy(id)
        }

        public func startRelativeAltitudeUpdates(id: AnyHashable, to queue: OperationQueue = .main) -> Effect<RelativeAltitudeData, Error> {
            startRelativeAltitudeUpdates(id, queue)
        }

        public func stopRelativeAltitudeUpdates(id: AnyHashable) -> Effect<Never, Never> {
            stopRelativeAltitudeUpdates(id)
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
