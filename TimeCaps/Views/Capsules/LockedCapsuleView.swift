//
//  LockedCapsuleView.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI

struct LockedCapsuleView: View {
    let capsule: TimeCapsule
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.fill")
                .font(.system(size: 70))
                .foregroundStyle(.gray)
            
            Text("Cap Locked")
                .font(.title)
                .fontWeight(.bold)
            
            Text(capsule.title)
                .font(.headline)
            
            Text("This capsule will open on:")
                .foregroundStyle(.secondary)
            
            Text(formattedDate(capsule.openDate))
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(capsule.timeRemaining)
                .padding()
                .background(Color.secondary)
                .cornerRadius(10)
            
            Button("Close") {
                dismiss()
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
