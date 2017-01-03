//
//  DatePickerRange.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /23/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation
import UIKit

class DatePickerRange {
    
    let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    let currentDate: NSDate = NSDate()
    let components: NSDateComponents = NSDateComponents()
    let date = Date()
    let calendar = NSCalendar.current
    var currentDay: Int!
    var currentMonth: Int!
    var currentYear: Int!
    
    init() {
        currentDay = self.calendar.component(.day, from: date as Date)
        currentMonth = self.calendar.component(.month, from: date as Date)
        currentYear = self.calendar.component(.year, from: date as Date)
    }
    
    func datePickerConstraintMax(MaxRangeFromCurrentDate: Int, DatePicker: UIDatePicker) {
        components.year = MaxRangeFromCurrentDate
        let maxDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        DatePicker.maximumDate = maxDate as Date
    }
    
    func datePickerConstraintMin(MinRangeFromCurrentDate: Int, DatePicker: UIDatePicker) {
        components.year = MinRangeFromCurrentDate
        
        let minDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        DatePicker.minimumDate = minDate as Date
    }
    
    func startEndRangeDatePickerConstraintMin(startYear: Int, startMonth: Int, startDay: Int, DatePicker: UIDatePicker) {
        components.year = startYear - currentYear
        
        if (DatePicker.date.year - startYear) == 0 {
            components.month = startMonth - currentMonth
        }
        
        if (DatePicker.date.month - startMonth) == 0 {
            components.day = startDay - currentDay + 1
        }
        
        let minDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        DatePicker.minimumDate = minDate as Date
    }
}
