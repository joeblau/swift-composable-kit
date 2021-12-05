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

        var createImplementation: () -> Effect<Action, Never> = { _unimplemented("create") }

        var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

        var requestAuthorizationImplementation: (Set<HKSampleType>?, Set<HKObjectType>?) -> Effect<Never, Never> = { _, _ in _unimplemented("requestAuthorization") }

        var isHealthAuthorizedForImplementation: (Set<HKSampleType>, Set<HKObjectType>) -> Effect<Bool, Never> = { _, _ in _unimplemented("isHealthAuthorizedFor") }

        var startWatchAppImplementation: (HKWorkoutConfiguration) -> Effect<Bool, Never> = { _ in _unimplemented("startWatchApp") }

        // MARK: - Functions

        public func create(id: AnyHashable) -> Effect<Action, Never> {
            createImplementation()
        }

        public func destroy(id: AnyHashable) -> Effect<Never, Never> {
            destroyImplementation()
        }

        public func requestAuthorization(id: AnyHashable, typesToShare: Set<HKSampleType>?, typesToRead: Set<HKObjectType>?) -> Effect<Never, Never> {
            requestAuthorizationImplementation(typesToShare, typesToRead)
        }

        public func isHealthAuthorizedFor(id: AnyHashable, typesToShare: Set<HKSampleType>, typesToRead: Set<HKObjectType>) -> Effect<Bool, Never> {
            isHealthAuthorizedForImplementation(typesToShare, typesToRead)
        }

        public func startWatchApp(id: AnyHashable, configuration: HKWorkoutConfiguration) -> Effect<Bool, Never> {
            startWatchAppImplementation(configuration)
        }
    }
#endif
