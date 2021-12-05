// Interface.swift
// Copyright (c) 2021 Joe Blau

#if os(watchOS)
    import ComposableArchitecture
    import Foundation
    import HealthKit

    public struct WorkoutManager {
        public enum Action: Equatable {
            case workoutBuilder(workoutBuilder: HKLiveWorkoutBuilder, collectedTypes: Set<HKSampleType>)
            case workoutBuilderDidCollectEvent(workoutBuilder: HKLiveWorkoutBuilder)
        }

        public struct Error: Swift.Error, Equatable {
            public let error: NSError?

            public init(_ error: Swift.Error?) {
                self.error = error as NSError?
            }
        }

        // MARK: - Variables

        var createImplementation: (HKWorkoutConfiguration) -> Effect<Action, Never> = { _ in _unimplemented("create")
        }

        var destroyImplementation: () -> Effect<Never, Never> = { _unimplemented("destroy") }

        var startActivityImplementation: (Date) -> Effect<Never, Never> = { _ in _unimplemented("startActivity") }

        var pauseSessionImplementation: () -> Effect<Never, Never> = { _unimplemented("pauseSession") }

        var resumeSessionImplementation: () -> Effect<Never, Never> = { _unimplemented("resumeSession") }

        var discardWorkoutImplementation: (Date) -> Effect<Never, Never> = { _ in
            _unimplemented("discardWorkout")
        }

        var finishWorkoutImplementation: (Date) -> Effect<Never, Never> = { _ in
            _unimplemented("finishWorkout")
        }

        // MARK: - Functions

        public func create(workoutConfiguration: HKWorkoutConfiguration) -> Effect<Action, Never> {
            createImplementation(workoutConfiguration)
        }

        public func destroy() -> Effect<Never, Never> {
            destroyImplementation()
        }

        public func startActivity(date: Date) -> Effect<Never, Never> {
            startActivityImplementation(date)
        }

        public func pauseSession() -> Effect<Never, Never> {
            pauseSessionImplementation()
        }

        public func resumeSession() -> Effect<Never, Never> {
            resumeSessionImplementation()
        }

        public func discardWorkout(date: Date) -> Effect<Never, Never> {
            discardWorkoutImplementation(date)
        }

        public func finishWorkout(date: Date) -> Effect<Never, Never> {
            finishWorkoutImplementation(date)
        }
    }
#endif
