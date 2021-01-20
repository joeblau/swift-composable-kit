// Interface.swift
// Copyright (c) 2021 Joe Blau

#if canImport(HealthKit)
    import ComposableArchitecture
    import Foundation
    import HealthKit

    public enum HealthStoreError: Error {
        case healthDataNotAvailable
        case authorizationError
        case startWatchAppFailure
    }

    public struct HealthStoreManager {
        public enum Action: Equatable {}

        public struct Error: Swift.Error, Equatable {
            public let error: NSError?

            public init(_ error: Swift.Error?) {
                self.error = error as NSError?
            }
        }

        // MARK: - Variables

        var create: (AnyHashable) -> Effect<Action, Never> = { _ in _unimplemented("create") }

        var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }

        var requestAuthorization: (AnyHashable, Set<HKSampleType>?, Set<HKObjectType>?) -> Effect<Never, Never> = { _, _, _ in _unimplemented("requestAuthorization") }

        var isHealthAuthorizedFor: (AnyHashable, Set<HKSampleType>, Set<HKObjectType>) -> Effect<Bool, Never> = { _, _, _ in _unimplemented("isHealthAuthorizedFor") }

        var startWatchApp: (AnyHashable, HKWorkoutConfiguration) -> Effect<Bool, Never> = { _, _ in _unimplemented("startWatchApp") }

        // MARK: - Functions

        public func create(id: AnyHashable) -> Effect<Action, Never> {
            create(id)
        }

        public func destroy(id: AnyHashable) -> Effect<Never, Never> {
            destroy(id)
        }

        public func requestAuthorization(id: AnyHashable, typesToShare: Set<HKSampleType>?, typesToRead: Set<HKObjectType>?) -> Effect<Never, Never> {
            requestAuthorization(id, typesToShare, typesToRead)
        }

        public func isHealthAuthorizedFor(id: AnyHashable, typesToShare: Set<HKSampleType>, typesToRead: Set<HKObjectType>) -> Effect<Bool, Never> {
            isHealthAuthorizedFor(id, typesToShare, typesToRead)
        }

        public func startWatchApp(id: AnyHashable, configuration: HKWorkoutConfiguration) -> Effect<Bool, Never> {
            startWatchApp(id, configuration)
        }
    }
#endif
