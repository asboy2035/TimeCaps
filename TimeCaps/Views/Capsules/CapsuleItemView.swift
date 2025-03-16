//
//  CapsuleItemView.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI

struct CapsuleItemView: View {
    let item: CapsuleItem
    
    var body: some View {
        VStack(alignment: .leading) {
            switch item.type {
            case .photo: photoView
            case .text: placeholderImage(systemName: "doc.text", color: .accentColor)
            case .audio: placeholderImage(systemName: "mic", color: .red)
            case .music: placeholderImage(systemName: "music.note", color: .purple)
            }
            
            Text(item.title)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: 120)
        }
    }
    
    var photoView: some View {
        VStack {
            if let imageData = item.imageData {
#if os(iOS) || os(visionOS)
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 120, minHeight: 120)
                        .cornerRadius(10)
                        .clipped()
                } else {
                    placeholderImage(systemName: "photo")
                }
#elseif os(macOS)
                if let nsImage = NSImage(data: imageData) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 120, minHeight: 120)
                        .cornerRadius(10)
                        .clipped()
                } else {
                    placeholderImage(systemName: "photo")
                }
#endif
            } else {
                placeholderImage(systemName: "photo")
            }
        }
    }
    
    private func placeholderImage(systemName: String, color: Color = .gray) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 40))
            .foregroundStyle(color)
            .frame(minWidth: 120, minHeight: 120)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
    }
}
