//
//  ItemDetailView.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI
import AVFAudio

struct ItemDetailView: View {
    let item: CapsuleItem
    @Environment(\.dismiss) private var dismiss
    @State private var isPlaying = false
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        NavigationStack {
            VStack {
                switch item.type {
                case .photo:
                    if let imageData = item.imageData {
                        #if os(iOS)
                        if let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        } else {
                            Text("Unable to load image")
                                .foregroundColor(.secondary)
                        }
                        #elseif os(macOS)
                        if let nsImage = NSImage(data: imageData) {
                            Image(nsImage: nsImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        } else {
                            Text("Unable to load image")
                                .foregroundColor(.secondary)
                        }
                        #endif
                    } else {
                        Text("Unable to load image")
                            .foregroundColor(.secondary)
                    }
                    
                case .text:
                    if let text = item.text {
                        ScrollView {
                            Text(text)
                                .padding()
                        }
                    } else {
                        Text("No text content")
                            .foregroundColor(.secondary)
                    }
                    
                case .audio:
                    VStack {
                        Image(systemName: "waveform")
                            .font(.system(size: 80))
                            .foregroundColor(.accentColor)
                            .padding()
                        
                        Button {
                            if isPlaying {
                                stopAudio()
                            } else {
                                playAudio()
                            }
                        } label: {
                            Text(isPlaying ? "Stop" : "Play")
                                .font(.headline)
                                .padding()
                                .frame(width: 120)
                                .background(isPlaying ? Color.red : Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .onAppear {
                        setupAudioPlayer()
                    }
                    .onDisappear {
                        stopAudio()
                    }
                    
                case .music:
                    Text("Music playback not implemented yet")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle(item.title)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func setupAudioPlayer() {
        guard let audioData = item.audioData else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error creating audio player: \(error)")
        }
    }
    
    private func playAudio() {
        audioPlayer?.play()
        isPlaying = true
    }
    
    private func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false
    }
}
