// Live.swift
// Copyright (c) 2021 Joe Blau

#if os(watchOS)
    import Combine
    import ComposableArchitecture
    import Foundation
    import HealthKit

    public extension WorkoutManager {
        static let live: WorkoutManager = { () -> WorkoutManager in

            var manager = WorkoutManager()

            manager.createImplementation = { workoutConfiguration in
                Effect.run { subscriber in
                    let healthStore = HKHealthStore()

                    var workoutSessionDelegate = WorkoutSessionDelegate(subscriber)
                    var liveWorkoutBuilderDelegate = LiveWorkoutBuilderDelegate(subscriber)

                    var workoutSession: HKWorkoutSession?
                    do {
                        workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
                    } catch {
                        return AnyCancellable {
                            dependencies = nil
                        }
                    }

                    var workoutBuilder = workoutSession?.associatedWorkoutBuilder()
                    workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutConfiguration)

                    workoutSession?.delegate = workoutSessionDelegate
                    workoutBuilder?.delegate = liveWorkoutBuilderDelegate

                    dependencies = Dependencies(
                        healthStore: healthStore,
                        workoutSession: workoutSession,
                        workoutBuilder: workoutBuilder,
                        liveWorkoutBuilderDelegate: liveWorkoutBuilderDelegate,
                        workoutSessionDelegate: workoutSessionDelegate,
                        subscriber: subscriber
                    )

                    return AnyCancellable {
                        dependencies = nil
                    }
                }
            }

            manager.startActivityImplementation = { date in
                .fireAndForget {
                    dependencies?.workoutBuilder?.beginCollection(withStart: date) { _, _ in }
                    dependencies?.workoutSession?.prepare()
                    dependencies?.workoutSession?.startActivity(with: date)
                }
            }

            manager.pauseSessionImplementation = {
                .fireAndForget {
                    dependencies?.workoutSession?.pause()
                }
            }

            manager.resumeSessionImplementation = {
                .fireAndForget {
                    dependencies?.workoutSession?.resume()
                }
            }

            manager.discardWorkoutImplementation = { _ in
                .fireAndForget {
                    dependencies?.workoutSession?.end()
                    dependencies?.workoutBuilder?.discardWorkout()
                }
            }

            manager.finishWorkoutImplementation = { date in
                .fireAndForget {
                    dependencies?.workoutSession?.end()
                    dependencies?.workoutBuilder?.endCollection(withEnd: date) { _, _ in
                        dependencies?.workoutBuilder?.finishWorkout { _, _ in }
                    }
                }
            }

            manager.destroyImplementation = {
                .fireAndForget {
                    dependencies?.subscriber.send(completion: .finished)
                    dependencies = nil
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

    private var dependencies: Dependencies?

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

        func workoutSession(_: HKWorkoutSession, didChangeTo _: HKWorkoutSessionState, from _: HKWorkoutSessionState, date _: Date) {}

        func workoutSession(_: HKWorkoutSession, didFailWithError _: Error) {}
    }

#endif
