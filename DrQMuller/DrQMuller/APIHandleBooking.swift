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

        self.persistencyManager = PMHandleBooking()
    }
    
    func getDropDownsDataSource() {
        self.persistencyManager.getDropDownsDataSource()
    }
    
    func pulledStaticArrayFromUserDefaults() -> DTOStaticArrayDataSource? {
        return Functionality.pulledStaticArrayFromUserDefaults(forKey: "arrayDataSourceOffline") as! DTOStaticArrayDataSource?
    }
    
    func getSelectedTimeDataSource(selectedDayOfWeek_ID: String, location_ID: String, machine_ID: String) {
        self.persistencyManager.getSelectedTimeDataSource(selectedDayOfWeek_ID: selectedDayOfWeek_ID, location_ID: location_ID, machine_ID: machine_ID)
    }
    
    func checkBookingTime(time: [String: String]) {
        self.persistencyManager.checkBookingTime(time: time)
    }
    
    func insertNewAppointment() {
        self.persistencyManager.insertNewAppointment()
    }
    
    func getMachinesByLocationID(locationID: String) {
        self.persistencyManager.getMachinesByLocationID(locationID: locationID)
    }
    
    func validateCode(appointment_ID: String) {
        self.persistencyManager.validateCode(appointment_ID: appointment_ID)
    }
    
    func cancelAppointment(appointment_ID: String) {
        self.persistencyManager.cancelAppointment(appointment_ID: appointment_ID)
    }
    
    func validateAppointment() {
        self.persistencyManager.validateAppointment()
    }
}
