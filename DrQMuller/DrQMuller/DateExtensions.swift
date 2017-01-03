//
//  DateExtensions.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /01/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

extension Date {
    // returns weekday name (Sunday-Saturday) as String
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self as Date)
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self as Date)
    }
    
    var day: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return Int(formatter.string(from: self as Date))!
    }
    
    var month: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return Int(formatter.string(from: self as Date))!
    }
    
    var year: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return Int(formatter.string(from: self as Date))!
    }
    
}
