//
//  StatCard.swift
//  TImeCaps
//
//  Created by ash on 3/16/25.
//

import SwiftUI

struct StatCard: View {
    let title: LocalizedStringKey
    let value: Int
    let systemImage: String
    var iconColor: Color = Color.primary
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [iconColor, iconColor.opacity(0.3)]
                        ),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading) {
                Text(title)
                Text(String(value))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
#if os(visionOS)
        .cornerRadius(18)
#endif
    }
}

#Preview {
    StatCard(
        title: "Test Card",
        value: 69,
        systemImage: "book.pages.fill",
        iconColor: Color.accentColor
    )
}
