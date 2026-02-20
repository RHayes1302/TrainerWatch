//
//  ContentView.swift
//  TrainerWatch Watch App
//
//  Created by Ramone Hayes on 2/12/26.
//

import SwiftUI

/// Main content view - Navigation container
/// Design Principle: Simple navigation hierarchy
struct ContentView: View {

    // MARK: - State
    @StateObject private var viewModel = HealthViewModel()

    // MARK: - Body
    var body: some View {
        NavigationStack {
            MainDashboardView(viewModel: viewModel)
        }
        // Removed redundant .onAppear { viewModel.refreshTodayData() }
        // HealthViewModel.init() already calls refreshTodayData()
        // If you need to refresh when foregrounded, use .onChange(of: scenePhase) instead
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
