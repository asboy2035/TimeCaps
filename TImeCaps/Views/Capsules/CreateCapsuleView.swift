//
//  CreateCapsuleView.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI

struct DurationUnit {
    let title: String
    let systemImage: String

    init(_ title: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
    }
}

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
    
    let durations: [DurationUnit] = [
        DurationUnit("Minutes", systemImage: "hourglass"),
        DurationUnit("Hours", systemImage: "clock"),
        DurationUnit("Days", systemImage: "calendar.day.timeline.left"),
        DurationUnit("Months", systemImage: "calendar"),
        DurationUnit("Years", systemImage: "tree"),
    ]
    
    let durationUnits = ["Minutes", "Hours", "Days", "Months", "Years"]
    let durationIcons = ["hourglass", "clock", "calendar.day.timeline.left", "calendar", "tree"]
    
#if os(iOS)
    let buttonCornerRadius: CGFloat = 12
#else
    let buttonCornerRadius: CGFloat = 0
#endif
    
    var formattedOpenDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: calculateOpenDate())
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                detailsSection
                dateSection
                itemsSection
                Spacer()
                
                HStack {
                    Button(action: {
                        saveTimeCapsule()
                    }) {
                        Label("Save", systemImage: "checkmark")
                    }
                    .keyboardShortcut(.defaultAction)
                    .disabled(title.isEmpty)
                    .foregroundStyle(
                        title.isEmpty ? .secondary : Color.accentColor
                    )
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
                .buttonStyle(.borderless)
            }
            .buttonStyle(.borderedProminent)
            .textFieldStyle(.plain)
            .padding()
#if os(visionOS)
            .padding()
#endif
            .sheet(isPresented: $showingAddItemSheet) {
                AddItemView(items: $items)
            }
        }
    }
    
    var detailsSection: some View {
        Section {
            TextField("New Cap", text: $title)
                .font(.title)
                .onSubmit {
                    saveTimeCapsule()
                }
            TextField("Message to your future self", text: $message, axis: .vertical)
                .lineLimit(5)
        }
    }
    
    var dateSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Slider(value: $durationValue, in: 1...50, step: 1) {
                    Text("Duration")
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text("50")
                }
                
                Picker("", selection: $durationUnit) {
                    ForEach(durationUnits, id: \.self) { unit in
                        Text(unit)
                    }
                }
                .cornerRadius(buttonCornerRadius)
            }
            
            Text("Will open on: \(formattedOpenDate)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical)
    }
    
    var itemsSection: some View {
        VStack(alignment: .leading) {
            ForEach(items, id: \.id) { item in
                HStack {
                    Image(systemName: iconForType(item.type))
                    Text(item.title)
                    Spacer()
                }
            }
            
            Button(action: {
                showingAddItemSheet = true
            }) {
                Label("Add Item", systemImage: "plus")
                    .padding(4)
            }
            .cornerRadius(buttonCornerRadius)
        }
        .padding(.vertical)
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
        if title.isEmpty {
            return
        }
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

#Preview {
    CreateCapsuleView()
}
