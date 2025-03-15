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
        VStack {
            switch item.type {
            case .photo:
                if let imageData = item.imageData {
                    #if os(iOS)
                    if let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
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
                            .frame(width: 120, height: 120)
                            .cornerRadius(10)
                            .clipped()
                    } else {
                        placeholderImage(systemName: "photo")
                    }
                    #endif
                } else {
                    placeholderImage(systemName: "photo")
                }
                
            case .text:
                placeholderImage(systemName: "doc.text", color: .accentColor)
                
            case .audio:
                placeholderImage(systemName: "mic", color: .red)
                
            case .music:
                placeholderImage(systemName: "music.note", color: .purple)
            }
            
            Text(item.title)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 120)
        }
    }
    
    private func placeholderImage(systemName: String, color: Color = .gray) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 40))
            .foregroundColor(color)
            .frame(width: 120, height: 120)
            .background(Color.secondary)
            .cornerRadius(10)
    }
}
