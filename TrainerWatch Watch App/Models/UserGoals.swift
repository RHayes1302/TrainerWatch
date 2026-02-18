//
//  UserGoals.swift
//  TrainerWatch
//
//  Created by Ramone Hayes on 2/12/26.
//

import Foundation

/// User's daily health goals
/// Design Principle: Providing value - personalized goals give purpose
struct UserGoals: Codable {
    var dailyCaloriesGoal: Double
    var dailyWaterGoal: Double // in ml
    
    /// Default goals based on general health recommendations
    static let defaultGoals = UserGoals(
        dailyCaloriesGoal: 2000,
        dailyWaterGoal: 2000 // 2 liters
    )
}
