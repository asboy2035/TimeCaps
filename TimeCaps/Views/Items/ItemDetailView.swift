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
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.title)
                
                switch item.type {
                case .photo: photoView
                case .text: textView
                case .audio: audioView
                case .music:
                    Text("Music playback not implemented yet")
                        .foregroundStyle(.secondary)
                }
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Label("Done", systemImage: "checkmark")
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderless)
            }
            .padding()
#if os(visionOS)
            .padding()
#endif
            Spacer()
        }
#if os(macOS)
        .frame(minWidth: 350)
#endif
    }
    
    // -MARK: Preview types
    var photoView: some View {
        VStack {
            if let imageData = item.imageData {
#if os(iOS) || os(visionOS)
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(16)
                } else {
                    Text("Unable to load image")
                        .foregroundStyle(.secondary)
                }
#elseif os(macOS)
                if let nsImage = NSImage(data: imageData) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(16)
                } else {
                    Text("Unable to load image")
                        .foregroundStyle(.secondary)
                }
#endif
            } else {
                Text("Unable to load image")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var textView: some View {
        VStack {
            if let text = item.text {
                ScrollView {
                    Text(text)
                }
            } else {
                Text("No text content")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var audioView: some View {
        VStack(alignment: .leading) {
            Image(systemName: "waveform")
                .font(.system(size: 80))
                .foregroundStyle(Color.accentColor)
                .padding()
            
            Button {
                if isPlaying {
                    stopAudio()
                } else {
                    playAudio()
                }
            } label: {
                Label(
                    isPlaying ? "Stop" : "Play",
                    systemImage: isPlaying ? "square" : "play"
                )
            }
        }
        .padding()
        .onAppear {
            setupAudioPlayer()
        }
        .onDisappear {
            stopAudio()
        }
    }
    
    // -MARK: Funcs
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
