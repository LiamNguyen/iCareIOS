//
//  ModelHandleBookingStartEnd.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /07/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

class ModelHandelBookingStartEnd {
    //=========TRANSLATE DAYS OF WEEK=========
    
    func translateDaysOfWeek(en: String) -> String {
        var daysOfWeek = ["Monday":"Thứ hai",
                          "Tuesday":"Thứ ba",
                          "Wednesday":"Thứ tư",
                          "Thursday":"Thứ năm",
                          "Friday":"Thứ sáu",
                          "Saturday":"Thứ bảy",
                          "Sunday":"Chủ nhật"]
        return daysOfWeek[en]!
    }
}
