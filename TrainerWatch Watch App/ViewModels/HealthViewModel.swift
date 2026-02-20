//
//  HealthViewModel.swift
//  TrainerWatch
//
//  Created by Ramone Hayes on 2/12/26.
//

import Foundation
import Combine

/// Main ViewModel for the Health Tracker
/// Design Principle: Single source of truth for UI state
@MainActor
class HealthViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var goals: UserGoals
    @Published var todayCalories: Double = 0
    @Published var todayWater: Double = 0
    @Published var currentQuote: MotivationalQuote?
    @Published var isLoadingQuote: Bool = false
    @Published var showQuoteOverlay: Bool = false

    // MARK: - Services
    private let storage = StorageManager.shared
    private let quoteService = MotivationalQuoteService.shared
    private let haptics = HapticManager.shared

    // MARK: - Private State
    private var quoteFetchTask: Task<Void, Never>?

    // MARK: - Computed Properties

    var caloriesProgress: Double {
        min(todayCalories / goals.dailyCaloriesGoal, 1.0)
    }

    var waterProgress: Double {
        min(todayWater / goals.dailyWaterGoal, 1.0)
    }

    var caloriesGoalMet: Bool {
        todayCalories >= goals.dailyCaloriesGoal
    }

    var waterGoalMet: Bool {
        todayWater >= goals.dailyWaterGoal
    }

    // MARK: - Initialization

    init() {
        self.goals = StorageManager.shared.loadGoals()
        refreshTodayData()
        // Fetch a quote once on launch so it's ready when the user first adds an entry
        Task { await prefetchQuote() }
    }

    // MARK: - Public Methods

    func refreshTodayData() {
        todayCalories = storage.getTodayTotal(for: .calories)
        todayWater = storage.getTodayTotal(for: .water)
    }

    func addCalories(_ amount: Double) {
        let entry = DiaryEntry(type: .calories, value: amount)
        storage.addEntry(entry)
        todayCalories += amount
        haptics.playDirectionUp()
        if caloriesGoalMet { haptics.playNotification() }
        showQuoteOverlay(after: entry)
    }

    func addWater(_ amount: Double) {
        let entry = DiaryEntry(type: .water, value: amount)
        storage.addEntry(entry)
        todayWater += amount
        haptics.playDirectionUp()
        if waterGoalMet { haptics.playNotification() }
        showQuoteOverlay(after: entry)
    }

    func updateGoals(calories: Double, water: Double) {
        goals = UserGoals(dailyCaloriesGoal: calories, dailyWaterGoal: water)
        storage.saveGoals(goals)
        haptics.playSuccess()
    }

    func playClickHaptic() {
        haptics.playClick()
    }

    // MARK: - Quote Logic

    /// Show the overlay using a cached quote if available, otherwise fetch live
    private func showQuoteOverlay(after entry: DiaryEntry) {
        // Cancel any in-flight dismiss task
        quoteFetchTask?.cancel()

        showQuoteOverlay = true

        if currentQuote != nil {
            // Quote already cached — show immediately then refresh for next time
            scheduleDismiss()
            Task { await prefetchQuote() }
        } else {
            // No cached quote — fetch now and show when ready
            isLoadingQuote = true
            quoteFetchTask = Task {
                currentQuote = await quoteService.fetchQuote()
                isLoadingQuote = false
                scheduleDismiss()
            }
        }
    }

    /// Pre-fetch and cache a quote silently
    private func prefetchQuote() async {
        let quote = await quoteService.fetchQuote()
        currentQuote = quote
    }

    /// Auto-dismiss overlay after 3 seconds
    private func scheduleDismiss() {
        quoteFetchTask = Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            guard !Task.isCancelled else { return }
            showQuoteOverlay = false
        }
    }
}
