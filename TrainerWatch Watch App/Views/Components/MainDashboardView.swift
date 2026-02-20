//
//  MainDashboardView.swift
//  TrainerWatch
//
//  Created by Ramone Hayes on 2/17/26.
//

import SwiftUI

/// Main dashboard showing today's progress
/// Design Principle: Minimalistic interface with essential information
struct MainDashboardView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: HealthViewModel
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                // Design Principle: Keep it simple - clear, minimal header
                Text("Today")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                
                // Progress Rings Row
                // Design Principle: Visual feedback at a glance
                HStack(spacing: 20) {
                    // Calories Ring
                    VStack(spacing: 6) {
                        ProgressRingView(
                            progress: viewModel.caloriesProgress,
                            icon: "flame.fill",
                            color: .orange,
                            size: 55
                        )
                        
                        Text("\(Int(viewModel.todayCalories))")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.orange)
                        
                        Text("/ \(Int(viewModel.goals.dailyCaloriesGoal)) kcal")
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                    }
                    
                    // Water Ring
                    VStack(spacing: 6) {
                        ProgressRingView(
                            progress: viewModel.waterProgress,
                            icon: "drop.fill",
                            color: .cyan,
                            size: 55
                        )
                        
                        Text("\(Int(viewModel.todayWater))")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.cyan)
                        
                        Text("/ \(Int(viewModel.goals.dailyWaterGoal)) ml")
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                    }
                }
                
                // Quick Add Buttons
                // Design Principle: Limited functionality - focused actions
                HStack(spacing: 12) {
                    NavigationLink(destination: AddEntryView(viewModel: viewModel, entryType: .calories)) {
                        QuickAddButton(
                            icon: "plus",
                            label: "Calories",
                            color: .orange
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: AddEntryView(viewModel: viewModel, entryType: .water)) {
                        QuickAddButton(
                            icon: "plus",
                            label: "Water",
                            color: .cyan
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Settings Link
                NavigationLink(destination: GoalsSettingsView(viewModel: viewModel)) {
                    HStack {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 12))
                        Text("Goals")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 4)
            }
            .padding(.vertical, 8)
        }
        // Quote Overlay
        .overlay {
            if viewModel.showQuoteOverlay {
                QuoteOverlayView(
                    quote: viewModel.currentQuote,
                    isLoading: viewModel.isLoadingQuote,
                    onDismiss: {
                        viewModel.showQuoteOverlay = false
                    }
                )
            }
        }
    }
}



