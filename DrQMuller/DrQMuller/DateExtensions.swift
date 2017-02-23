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
        formatter.locale = NSLocale.init(localeIdentifier: "en_EN") as Locale!
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self as Date)
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self as Date)
    }
    
    var shortDateVnFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
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
    
    var dateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:MM:ss"
        return formatter.string(from: self as Date)
    }
    
}
