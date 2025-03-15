//
//  AddItemView.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AddItemView: View {
    @Binding var items: [CapsuleItem]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedType: CapsuleItem.ItemType = .text
    @State private var title = ""
    @State private var text = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedAudioURL: URL?
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Type")) {
                    Picker("Type", selection: $selectedType) {
                        Text("Photo").tag(CapsuleItem.ItemType.photo)
                        Text("Text").tag(CapsuleItem.ItemType.text)
                        Text("Audio Recording").tag(CapsuleItem.ItemType.audio)
                        Text("Music").tag(CapsuleItem.ItemType.music)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    
                    switch selectedType {
                    case .photo:
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Label("Select Photo", systemImage: "photo")
                        }
                        
                        if let selectedPhotoItem {
                            Text("Photo selected: \(selectedPhotoItem.itemIdentifier ?? "Unknown")")
                                .font(.caption)
                        }
                        
                    case .text:
                        TextField("Your message", text: $text, axis: .vertical)
                            .lineLimit(5)
                        
                    case .audio:
                        Button {
                            if isRecording {
                                stopRecording()
                            } else {
                                startRecording()
                            }
                        } label: {
                            Label(isRecording ? "Stop Recording" : "Start Recording",
                                  systemImage: isRecording ? "stop.circle" : "mic.circle")
                        }
                        .tint(isRecording ? .red : .accentColor)
                        
                        if selectedAudioURL != nil {
                            Text("Recording saved")
                                .font(.caption)
                        }
                        
                    case .music:
                        Text("Music selection will be implemented in a future update")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Add") {
                        addItem()
                    }
                    .disabled(title.isEmpty || !canAddItem())
                }
                
                ToolbarItem(placement: .navigation) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onDisappear {
                if isRecording {
                    stopRecording()
                }
            }
        }
    }

    private func canAddItem() -> Bool {
        switch selectedType {
        case .photo:
            return selectedPhotoItem != nil
        case .text:
            return !text.isEmpty
        case .audio:
            return selectedAudioURL != nil
        case .music:
            return false // Not implemented yet
        }
    }

    private func addItem() {
        let item = CapsuleItem(type: selectedType, title: title)

        switch selectedType {
        case .photo:
            Task {
                if let data = try? await selectedPhotoItem?.loadTransferable(type: Data.self) {
                    item.imageData = data
                }
            }
        case .text:
            item.text = text
        case .audio:
            if let audioURL = selectedAudioURL {
                do {
                    let audioData = try Data(contentsOf: audioURL)
                    item.audioData = audioData
                } catch {
                    print("Error loading audio data: \(error)")
                }
            }
        case .music:
            // Not implemented yet
            break
        }
        
        items.append(item)
        dismiss()
    }

    private func startRecording() {
        #if os(iOS)
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
            return
        }
        #endif

        // Determine file storage path for each platform
        let documentPath: URL
        #if os(iOS)
        documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        #elseif os(macOS)
        documentPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Documents")
        #endif

        let audioFilename = documentPath.appendingPathComponent("\(UUID().uuidString).m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
            print("Recording started: \(audioFilename.path)")
        } catch {
            print("Could not start recording: \(error)")
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        selectedAudioURL = audioRecorder?.url
        
        #if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Failed to deactivate audio session: \(error)")
        }
        #endif
    }
}
