//
//  ContentView.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI
import SwiftData

enum CurrentPlatform: String {
    case iOS, macOS, watchOS, tvOS
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var capsules: [TimeCapsule]
    @State private var showingNewCapsuleSheet = false
    @State private var selectedCapsule: TimeCapsule?
    @State private var currentTime = Date() // Keeps track of current time and updates dynamically
#if os(macOS)
    let currentPlatform: CurrentPlatform = .macOS
#endif
#if os(iOS)
    let currentPlatform: CurrentPlatform = .iOS
#endif

    var body: some View {
        NavigationStack {
            ZStack {
                if capsules.isEmpty {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("No Caps Yet")
                                .font(.title2)
                            Text("Create your first Cap by tapping the '+' button.")
                                .foregroundStyle(.secondary)
                            
                            Button(action: {
                                showingNewCapsuleSheet = true
                            }) {
                                Label("Create Cap", systemImage: "plus")
                                    .padding(
                                        currentPlatform == .iOS ?
                                        4 : 2
                                    )
                            }
                            .buttonStyle(.borderedProminent)
#if os(iOS)
                            .cornerRadius(12)
#endif
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(24)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                } else {
                    List {
                        ForEach(capsules) { capsule in
                            CapsuleRowView(capsule: capsule, currentTime: currentTime)
                                .onTapGesture {
                                    selectedCapsule = capsule
                                }
                        }
                        .onDelete(perform: deleteCapsules)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
#if os(macOS)
            .frame(minWidth: 450, minHeight: 500)
            .background(
                VisualEffectView(
                    material: .menu,
                    blendingMode: .behindWindow
                ).ignoresSafeArea()
            )
#endif
            .onAppear {
                startTimer() // Start updating time when the view appears
                
#if os(macOS)
                if let window = NSApplication.shared.windows.first {
                    window.titlebarAppearsTransparent = true
                    window.isOpaque = false
                    window.backgroundColor = .clear // Set the background color to clear
                    
                    window.styleMask.insert(.fullSizeContentView)
                }
#endif
            }
            .navigationTitle("TimeCaps")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showingNewCapsuleSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewCapsuleSheet) {
                CreateCapsuleView()
            }
            .sheet(item: $selectedCapsule) { capsule in
                if capsule.canOpen {
                    CapsuleDetailView(capsule: capsule)
                } else {
                    LockedCapsuleView(capsule: capsule)
                }
            }
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            currentTime = Date()
        }
    }
    
    private func deleteCapsules(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(capsules[index])
            }
            do {
                try modelContext.save()
            } catch {
                print("Error deleting capsule: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
