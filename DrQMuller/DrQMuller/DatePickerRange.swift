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
}
