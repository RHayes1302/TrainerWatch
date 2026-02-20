//
//  QuickAddButton.swift
//  TrainerWatch
//
//  Created by Ramone Hayes on 2/19/26.
//

import SwiftUI

struct QuickAddButton: View {
    let icon: String
    let label: String
    let color: Color
    
    
    var body: some View {
        VStack (spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
            Text(label)
                .font(.system(size: 10))
        }
        .foregroundColor(color)
        .frame(width: 70, height: 50)
        .background(color.opacity(0.2))
        .cornerRadius(12)
        
    }
}

#Preview {
    QuickAddButton(icon: "plus", label: "Water", color: .cyan)
}
