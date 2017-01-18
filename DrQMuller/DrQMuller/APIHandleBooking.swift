//
//  APIHandleBooking.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /30/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class APIHandleBooking: NSObject {
    private var persistencyManager: PMHandleBooking!
    
    class var sharedInstace: APIHandleBooking {
        struct Singleton {
            static let instance = APIHandleBooking()
        }
        return Singleton.instance
    }
    
    override init() {

        persistencyManager = PMHandleBooking()
    }
    
    func getDropDownsDataSource() {
        persistencyManager.getDropDownsDataSource()
    }
    
    func pulledStaticArrayFromUserDefaults() -> DTOStaticArrayDataSource? {
        return persistencyManager.pulledStaticArrayFromUserDefaults() as! DTOStaticArrayDataSource?
    }
    
    func getSelectedTimeDataSource(selectedDayOfWeek_ID: String) {
        persistencyManager.getSelectedTimeDataSource(selectedDayOfWeek_ID: selectedDayOfWeek_ID)
    }
    
    func checkBookingTime(day_ID: String, time_ID: String) {
        persistencyManager.checkBookingTime(day_ID: day_ID, time_ID: time_ID)
    }
}
