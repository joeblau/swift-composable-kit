// ComposableWorkoutInterface.swift
// Copyright (c) 2020 Copilot

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

    var create: (AnyHashable, HKWorkoutConfiguration) -> Effect<Action, Never> = { _, _ in _unimplemented("create") }

    var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }
    
    var startActivity: (AnyHashable, Date) -> Effect<Never, Never> = { _, _ in _unimplemented("startActivity") }

    var pauseSession: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("pauseSession") }
    
    var resumeSession: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("resumeSession") }
    
    var discardWorkout: (AnyHashable, Date) -> Effect<Never, Never> = { _, _ in _unimplemented("discardWorkout") }
    
    var finishWorkout: (AnyHashable, Date) -> Effect<Never, Never> = { _, _ in _unimplemented("finishWorkout") }

    // MARK: - Functions

    public func create(id: AnyHashable, workoutConfiguration: HKWorkoutConfiguration) -> Effect<Action, Never> {
        create(id, workoutConfiguration)
    }

    public func destroy(id: AnyHashable) -> Effect<Never, Never> {
        destroy(id)
    }
    
    public func startActivity(id: AnyHashable, date: Date) -> Effect<Never, Never> {
        startActivity(id, date)
    }
    
    public func pauseSession(id: AnyHashable) -> Effect<Never, Never> {
        pauseSession(id)
    }
    
    public func resumeSession(id: AnyHashable) -> Effect<Never, Never> {
        resumeSession(id)
    }
    
    public func discardWorkout(id: AnyHashable, date: Date) -> Effect<Never, Never> {
        discardWorkout(id, date)
    }
    
    public func finishWorkout(id: AnyHashable, date: Date) -> Effect<Never, Never> {
        finishWorkout(id, date)
    }
}
#endif
