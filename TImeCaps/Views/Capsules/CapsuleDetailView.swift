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
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(capsule.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Created on \(formattedDate(capsule.creationDate))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "hourglass.bottomhalf.filled")
                            .font(.system(size: 40))
                            .foregroundColor(.accentColor)
                    }
                    .padding(.bottom, 10)
                    
                    if !capsule.message.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Message to yourself:")
                                .font(.headline)
                            
                            Text(capsule.message)
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }
                    }
                    
                    if !capsule.items.isEmpty {
                        Text("Capsule Items")
                            .font(.headline)
                            .padding(.top)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 15) {
                            ForEach(Array(capsule.items.enumerated()), id: \.element.id) { index, item in
                                Button {
                                    selectedItemIndex = index
                                } label: {
                                    CapsuleItemView(item: item)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Cap")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        markAsOpened()
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
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
