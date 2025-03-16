//
//  GradientLabel.swift
//  TImeCaps
//
//  Created by ash on 3/16/25.
//

import SwiftUI

struct GradientLabel: View {
    let title: LocalizedStringKey
    let systemImage: String
    var imageColor: Color = .secondary
    @State private var animationValue: Int = 0
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [imageColor, imageColor.opacity(0.3)]
                        ),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(
                    .bounce,
                    value: animationValue
                )
                .onTapGesture {
                    animationValue += 1
                }
                .frame(width: 16)
            
            Text(title)
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
