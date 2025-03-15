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
    let cloudKitManager: CloudKitSyncManager
    
    init() {
        do {
            let schema = Schema([TimeCapsule.self, CapsuleItem.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            cloudKitManager = CloudKitSyncManager(containerIdentifier: "iCloud.com.ash.TimeCaps")
        } catch {
            fatalError("Failed to initialize model container: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        _ = await cloudKitManager.requestPermissions()
                    }
                }
        }
        .modelContainer(modelContainer)
    }
}

