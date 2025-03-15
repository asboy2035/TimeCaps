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
                    .foregroundColor(capsule.canOpen ? .green : .gray)
            }
            
            Spacer()
            
            if capsule.isOpened {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else if capsule.canOpen {
                Image(systemName: "lock.open.fill")
                    .foregroundColor(.accentColor)
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}
