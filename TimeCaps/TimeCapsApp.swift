//
//  TImeCapsApp.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI
import SwiftData

@main
struct TimeCapsApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            let schema = Schema([TimeCapsule.self, CapsuleItem.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to initialize model container: \(error)")
        }
    }
    
    var body: some Scene {
        #if os(macOS)
        Window("TimeCap", id: "Main") {
            ContentView()
        }
        .modelContainer(modelContainer)
        #else
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
        #endif
    }
}

