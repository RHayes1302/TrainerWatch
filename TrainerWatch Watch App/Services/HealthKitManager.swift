//
//  HealthKitManager.swift
//  TrainerWatch
//
//  Created by Ramone Hayes on 2/17/26.
//

import Foundation
import HealthKit

/// Manages HealthKit interactions for heart rate data
/// Design Principle: Single responsibility - only handles HealthKit
class HealthKitManager {

    // MARK: - Singleton
    static let shared = HealthKitManager()
    private init() {}

    // MARK: - Properties
    let healthStore = HKHealthStore()

    let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)! 
    let heartRateUnit = HKUnit(from: "count/min")

    var isHealthDataAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    // MARK: - Authorization

    func requestAuthorization() async throws {
        let typesToRead: Set<HKObjectType> = [heartRateType]
        let typesToWrite: Set<HKSampleType> = []

        try await healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead)
    }

    func checkAuthorizationStatus() -> HKAuthorizationStatus {
        healthStore.authorizationStatus(for: heartRateType)
    }

    // MARK: - Heart Rate

    /// Fetch the most recent heart rate sample
    func fetchLatestHeartRate() async throws -> HeartRateSample? {
        return try await withCheckedThrowingContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(
                key: HKSampleSortIdentifierStartDate,
                ascending: false
            )

            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let sample = samples?.first as? HKQuantitySample else {
                    continuation.resume(returning: nil)
                    return
                }

                let bpm = sample.quantity.doubleValue(for: self.heartRateUnit) // Fixed: was sample.quanity
                continuation.resume(returning: HeartRateSample(value: Int(bpm)))
            }

            healthStore.execute(query) 
        }
    }
}

/// Simple heart rate sample model
struct HeartRateSample {
    let value: Int
    let timestamp: Date

    init(value: Int, timestamp: Date = Date()) {
        self.value = value
        self.timestamp = timestamp
    }
}
