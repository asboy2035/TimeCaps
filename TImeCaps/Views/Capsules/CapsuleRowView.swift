//
//  CapsuleRowView.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI

struct CapsuleRowView: View {
    let capsule: TimeCapsule
    let currentTime: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(capsule.title)
                    .font(.headline)
                Text(capsule.canOpen ? "Available to open" : capsule.timeRemaining)
                    .font(.subheadline)
                    .foregroundStyle(capsule.canOpen ? Color.accentColor : .secondary)
            }
            
            Spacer()
            
            if capsule.isOpened {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.blue)
            } else if capsule.canOpen {
                Image(systemName: "lock.open.fill")
                    .foregroundStyle(Color.accentColor)
            } else {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
