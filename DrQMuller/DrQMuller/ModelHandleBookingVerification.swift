//
//  ModelHandleBookingVerification.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /12/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class ModelHandleBookingVerification: NSObject {
    func validateCode(appointment_ID: String) {
        APIHandleBooking.sharedInstace.validateCode(appointment_ID: appointment_ID)
    }
    
    //=========SAVE APPOINTMENT INFORMATION TO USER DEFAULT=========
    
    func saveAppointmentToUserDefault(dtoBookingInformation: DTOBookingInformation) {
        print("\nBefore saving to User default: ")
        dtoBookingInformation.printBookingInfo()
        
        let customerId = DTOCustomerInformation.sharedInstance.customerInformationDictionary[JsonPropertyName.userId] as! String
        var savedAppointments = [String: DTOBookingInformation]()
        
        //Get saved appointment from user default
        
        if let savedUserInfo = Functionality.pulledStaticArrayFromUserDefaults(forKey: customerId) as? DTOCustomerInformation {
            savedAppointments = savedUserInfo.customerAppointmentsDictionary
        }
        
        //Bind new appointment to the list
        
        savedAppointments[dtoBookingInformation.appointmentID] = dtoBookingInformation
        DTOCustomerInformation.sharedInstance.customerAppointmentsDictionary = savedAppointments
        
        //Push to user default latest appointments
        
        Functionality.pushToUserDefaults(arrayDataSourceObj: DTOCustomerInformation.sharedInstance, forKey: customerId)
    }
}
