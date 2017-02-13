//
//  ModelHandleBookingManagerDetail.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /12/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class ModelHandleBookingManagerDetail: NSObject {
    func cancelAppointment(appointment_ID: String) {
        APIHandleBooking.sharedInstace.cancelAppointment(appointment_ID: appointment_ID)
    }
    
    func removeAppointmentFromUserDefault(appointment_ID: String) {
        
        let customerId = DTOCustomerInformation.sharedInstance.customerInformationDictionary["userId"] as! String
        var savedAppointments = [String: DTOBookingInformation]()
        
        //Get saved appointment from user default
        
        if let savedUserInfo = Functionality.pulledStaticArrayFromUserDefaults(forKey: customerId) as? DTOCustomerInformation {
            savedAppointments = savedUserInfo.customerAppointmentsDictionary
        }
        //Bind new appointment to the list
    
        savedAppointments.removeValue(forKey: appointment_ID)
        DTOCustomerInformation.sharedInstance.customerAppointmentsDictionary = savedAppointments
        
        //Push to user default latest appointments
        
        Functionality.pushToUserDefaults(arrayDataSourceObj: DTOCustomerInformation.sharedInstance, forKey: customerId)
        
    }
    
    func returnTupleOfArrayFromArrayOfDictionary(array: [[String]]) -> [(day: String, time: String)] {
        var returnTuple = [(day: String, time: String)]()
        if let staticArrayFromUserDefaults = APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults() {
            let allTime = staticArrayFromUserDefaults.allTimeDataSource
            let dayOfWeek = staticArrayFromUserDefaults.daysOfWeekDisplayArray
            
            for item in array {
                var tuple: (day: String, time: String)
                tuple.day = dayOfWeek[Int(item[0])! - 1]
                tuple.time = allTime[item[1]]!
                returnTuple.append(tuple)
            }
        }
        return returnTuple
    }
}
