//
//  Date+Shift.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation

extension Date {
    func shiftedToToday() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        var componentsMessageUpdated = gregorian.dateComponents([.year, .month, .day], from: self)
        var componentsMessageNow = gregorian.dateComponents([.year, .month, .day], from: Date())
        
        // Change the time to 9:30:00 in your locale
        componentsMessageUpdated.year = componentsMessageNow.year
        componentsMessageUpdated.month = componentsMessageNow.month
        componentsMessageUpdated.day = componentsMessageNow.day
        
        guard let shiftedDate = gregorian.date(from: componentsMessageUpdated) else {
            return self
        }

        return shiftedDate
    }
    
    func shiftedToThisHour() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        var componentsMessageUpdated = gregorian.dateComponents([.year, .month, .day, .hour], from: self)
        var componentsMessageNow = gregorian.dateComponents([.year, .month, .day, .hour], from: Date())
        
        // Change the time to 9:30:00 in your locale
        componentsMessageUpdated.year = componentsMessageNow.year
        componentsMessageUpdated.month = componentsMessageNow.month
        componentsMessageUpdated.day = componentsMessageNow.day
        componentsMessageUpdated.hour = componentsMessageNow.hour
        
        guard let shiftedDate = gregorian.date(from: componentsMessageUpdated) else {
            return self
        }
        
        return shiftedDate
    }
}
