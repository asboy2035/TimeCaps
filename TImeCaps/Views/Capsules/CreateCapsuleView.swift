//
//  CreateCapsuleView.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI

struct CreateCapsuleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var message = ""
    @State private var selectedDate = Date()
    @State private var durationUnit = "Days"
    @State private var durationValue = 1.0
    @State private var showingAddItemSheet = false
    @State private var items: [CapsuleItem] = []
    
    let durationUnits = ["Minutes", "Hours", "Days", "Months", "Years"]
    
    var formattedOpenDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: calculateOpenDate())
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    TextField("Message to your future self", text: $message, axis: .vertical)
                        .lineLimit(5)
                }
                
                Section(header: Text("Open Date")) {
                    Picker("Duration Unit", selection: $durationUnit) {
                        ForEach(durationUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Text("Amount")
                        Slider(value: $durationValue, in: 1...100, step: 1) {
                            Text("Duration")
                        } minimumValueLabel: {
                            Text("1")
                        } maximumValueLabel: {
                            Text("100")
                        }
                    }
                    
                    Text("Will open on: \(formattedOpenDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Items")) {
                    ForEach(items, id: \.id) { item in
                        HStack {
                            Image(systemName: iconForType(item.type))
                            Text(item.title)
                            Spacer()
                        }
                    }
                    
                    Button("Add Item") {
                        showingAddItemSheet = true
                    }
                }
            }
            .navigationTitle("New Cap")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Save") {
                        saveTimeCapsule()
                    }
                    .disabled(title.isEmpty)
                }
                
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddItemSheet) {
                AddItemView(items: $items)
            }
        }
    }
    
    private func calculateOpenDate() -> Date {
        let calendar = Calendar.current
        let now = Date()
        
        switch durationUnit {
        case "Minutes":
            return calendar.date(byAdding: .minute, value: Int(durationValue), to: now)!
        case "Hours":
            return calendar.date(byAdding: .hour, value: Int(durationValue), to: now)!
        case "Days":
            return calendar.date(byAdding: .day, value: Int(durationValue), to: now)!
        case "Months":
            return calendar.date(byAdding: .month, value: Int(durationValue), to: now)!
        case "Years":
            return calendar.date(byAdding: .year, value: Int(durationValue), to: now)!
        default:
            return calendar.date(byAdding: .day, value: Int(durationValue), to: now)!
        }
    }
    
    private func saveTimeCapsule() {
        let capsule = TimeCapsule(title: title, message: message, openDate: calculateOpenDate())
        capsule.items = items
        
        modelContext.insert(capsule)
        try? modelContext.save()
        
        dismiss()
    }
    
    private func iconForType(_ type: CapsuleItem.ItemType) -> String {
        switch type {
        case .photo:
            return "photo"
        case .text:
            return "doc.text"
        case .audio:
            return "mic"
        case .music:
            return "music.note"
        }
    }
}
