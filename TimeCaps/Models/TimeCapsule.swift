//
//  TimeCapsule.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftUI
import SwiftData

@Model
final class TimeCapsule {
    var id: UUID
    var title: String
    var message: String
    var creationDate: Date
    var openDate: Date
    var isOpened: Bool
    var items: [CapsuleItem]
    
    init(title: String, message: String, openDate: Date) {
        self.id = UUID()
        self.title = title
        self.message = message
        self.creationDate = Date()
        self.openDate = openDate
        self.isOpened = false
        self.items = []
    }
    
    var canOpen: Bool {
        return Date() >= openDate || isOpened
    }
    
    var timeRemaining: String {
        if isOpened {
            return "Opened"
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(), to: openDate)
        
        if let years = components.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s") remaining"
        } else if let months = components.month, months > 0 {
            return "\(months) month\(months == 1 ? "" : "s") remaining"
        } else if let days = components.day, days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") remaining"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") remaining"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") remaining"
        } else if let seconds = components.second, seconds > 0 {
            return "\(seconds) second\(seconds == 1 ? "" : "s") remaining"
        } else {
            return "Ready to open"
        }
    }
}
