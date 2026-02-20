//
//  AddEntryView.swift
//  TrainerWatch
//
//  Created by Ramone Hayes on 2/17/26.
//

import SwiftUI

/// View for adding calories or water entries
/// Design Principle: No big swipes or complex interactions required
struct AddEntryView: View {

    // MARK: - Properties
    @ObservedObject var viewModel: HealthViewModel
    let entryType: EntryType

    @State private var selectedAmount: Double = 0
    @Environment(\.dismiss) private var dismiss

    // MARK: - Quick Add Options
    /// Design Principle: Pre-defined options reduce input effort
    private var quickAddOptions: [Double] {
        entryType == .calories
            ? [100, 200, 300, 500, 1000]
            : [100, 250, 500, 750, 1000]
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Header with icon
                Image(systemName: entryType.icon)
                    .font(.system(size: 28))
                    .foregroundColor(entryType == .calories ? .orange : .cyan)

                Text("Add \(entryType == .calories ? "Calories" : "Water")")
                    .font(.system(size: 14, weight: .medium))

                // Current selection display
                Text(selectedAmount > 0 ? "\(Int(selectedAmount)) \(entryType.unit)" : "Select amount")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(selectedAmount > 0
                        ? (entryType == .calories ? .orange : .cyan)
                        : .gray)

                // Quick add buttons grid
              
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 10) {
                    ForEach(quickAddOptions, id: \.self) { amount in
                        Button {
                            viewModel.playClickHaptic()
                            selectedAmount = amount
                        } label: {
                            Text("+\(Int(amount))")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    selectedAmount == amount
                                        ? (entryType == .calories ? Color.orange : Color.cyan)
                                        : Color.gray.opacity(0.3)
                                )
                                .foregroundColor(selectedAmount == amount ? .black : .white)
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                // Fine-tune stepper
                // Design Principle: Fine control when needed
                HStack {
                    Button {
                        viewModel.playClickHaptic()
                        selectedAmount = max(0, selectedAmount - 50)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(selectedAmount > 0 ? .gray : .gray.opacity(0.3))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(selectedAmount == 0)

                    Spacer()

                    Text("Adjust ±50")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)

                    Spacer()

                    Button {
                        viewModel.playClickHaptic()
                        selectedAmount += 50
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 8)

                // Add button
                Button {
                    if selectedAmount > 0 {
                        if entryType == .calories {
                            viewModel.addCalories(selectedAmount)
                        } else {
                            viewModel.addWater(selectedAmount)
                        }
                        dismiss()
                    }
                } label: {
                    Text("Add \(selectedAmount > 0 ? "\(Int(selectedAmount)) \(entryType.unit)" : "")")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedAmount > 0
                                ? (entryType == .calories ? Color.orange : Color.cyan)
                                : Color.gray.opacity(0.3)
                        )
                        .foregroundColor(selectedAmount > 0 ? .black : .gray)
                        .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(selectedAmount == 0)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
        .navigationTitle(entryType == .calories ? "Calories" : "Water")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AddEntryView(viewModel: HealthViewModel(), entryType: .calories)
    }
}
