// ComposableWorkoutLive.swift
// Copyright (c) 2020 Copilot

#if os(watchOS)
import Combine
import ComposableArchitecture
import Foundation
import HealthKit

public extension WorkoutManager {
    static let live: WorkoutManager = { () -> WorkoutManager in

        var manager = WorkoutManager()

        manager.create = { id, workoutConfiguration in
            Effect.run { subscriber in
                let healthStore = HKHealthStore()
                
                var workoutSessionDelegate = WorkoutSessionDelegate(subscriber)
                var liveWorkoutBuilderDelegate = LiveWorkoutBuilderDelegate(subscriber)
                
                var workoutSession: HKWorkoutSession?
                do {
                    workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
                } catch {
                    return AnyCancellable {
                        dependencies[id] = nil
                    }
                }
                
                var workoutBuilder = workoutSession?.associatedWorkoutBuilder()
                workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutConfiguration)

                workoutSession?.delegate = workoutSessionDelegate
                workoutBuilder?.delegate = liveWorkoutBuilderDelegate
                                
                dependencies[id] = Dependencies(
                    healthStore: healthStore,
                    workoutSession: workoutSession,
                    workoutBuilder: workoutBuilder,
                    liveWorkoutBuilderDelegate: liveWorkoutBuilderDelegate,
                    workoutSessionDelegate: workoutSessionDelegate,
                    subscriber: subscriber
                )

                return AnyCancellable {
                    dependencies[id] = nil
                }
            }
        }
        
        manager.startActivity = { id, date in
            .fireAndForget {
                dependencies[id]?.workoutBuilder?.beginCollection(withStart: date) { (_, _) in }
                dependencies[id]?.workoutSession?.prepare()
                dependencies[id]?.workoutSession?.startActivity(with: date)
            }
        }
        
        manager.pauseSession = { id in
            .fireAndForget {
                dependencies[id]?.workoutSession?.pause()
            }
        }
        
        manager.resumeSession = { id in
            .fireAndForget {
                dependencies[id]?.workoutSession?.resume()
            }
        }
        
        manager.discardWorkout = { id, date in
            .fireAndForget {
                dependencies[id]?.workoutSession?.end()
                dependencies[id]?.workoutBuilder?.discardWorkout()
            }
        }
        
        manager.finishWorkout = { id, date in
            .fireAndForget {
                dependencies[id]?.workoutSession?.end()
                dependencies[id]?.workoutBuilder?.endCollection(withEnd: date) { (success, error) in
                    dependencies[id]?.workoutBuilder?.finishWorkout { (workout, error) in }
                }
            }
        }

        manager.destroy = { id in
            .fireAndForget {
                dependencies[id]?.subscriber.send(completion: .finished)
                dependencies[id] = nil
            }
        }

        return manager
    }()
}

private struct Dependencies {
    let healthStore: HKHealthStore
    let workoutSession: HKWorkoutSession?
    let workoutBuilder: HKWorkoutBuilder?
    let liveWorkoutBuilderDelegate: LiveWorkoutBuilderDelegate
    let workoutSessionDelegate: WorkoutSessionDelegate
    let subscriber: Effect<WorkoutManager.Action, Never>.Subscriber
}

private var dependencies: [AnyHashable: Dependencies] = [:]

// MARK: - HKLiveWorkoutBuilderDelegate

private class LiveWorkoutBuilderDelegate: NSObject, HKLiveWorkoutBuilderDelegate {
    let subscriber: Effect<WorkoutManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<WorkoutManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        subscriber.send(.workoutBuilderDidCollectEvent(workoutBuilder: workoutBuilder))
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        DispatchQueue.main.async {
            self.subscriber.send(.workoutBuilder(workoutBuilder: workoutBuilder, collectedTypes: collectedTypes))
        }
    }
}

// MARK: - HKWorkoutSessionDelegate

private class WorkoutSessionDelegate: NSObject, HKWorkoutSessionDelegate {
    let subscriber: Effect<WorkoutManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<WorkoutManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
    }
    
}

#endif
