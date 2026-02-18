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
    /// Shared ViewModel across all views
    @StateObject private var viewModel = HealthViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            MainDashboardView(viewModel: viewModel)
        }
        .onAppear {
            // Refresh data when app becomes visible
            viewModel.refreshTodayData()
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
