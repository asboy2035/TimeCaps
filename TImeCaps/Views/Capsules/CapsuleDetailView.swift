//
//  CapsuleDetailView.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI

struct CapsuleDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedItemIndex: Int?
    
    var capsule: TimeCapsule
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(capsule.title)
                                .font(.title)
                            
                            Text("Created on \(formattedDate(capsule.creationDate))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "hourglass.bottomhalf.filled")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.accentColor)
                    }
                    
                    if !capsule.message.isEmpty {
                        Text(capsule.message)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                    
                    if !capsule.items.isEmpty {
                        Text("Capsule Items")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 15) {
                            ForEach(Array(capsule.items.enumerated()), id: \.element.id) { index, item in
                                Button {
                                    selectedItemIndex = index
                                } label: {
                                    CapsuleItemView(item: item)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                    Spacer()
                    
                    Button {
                        markAsOpened()
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark")
                    }
                    .keyboardShortcut(.defaultAction)
                    .buttonStyle(.borderless)
                }
                .padding()
#if os(visionOS)
                .padding()
#endif
            }
            .sheet(isPresented: .init(
                get: { selectedItemIndex != nil },
                set: { if !$0 { selectedItemIndex = nil } }
            )) {
                if let index = selectedItemIndex, index < capsule.items.count {
                    ItemDetailView(item: capsule.items[index])
                }
            }
            .onAppear {
                markAsOpened()
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func markAsOpened() {
        if !capsule.isOpened {
            capsule.isOpened = true
            try? modelContext.save()
        }
    }
}

#Preview {
    let testCap = TimeCapsule(title: "Test Cap", message: "This is a test.", openDate: Date())
    
    CapsuleDetailView(capsule: testCap)
}
