//
//  ModelHandleBookingManager.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /14/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class ModelHandleBookingManager: NSObject {
    
    func validateAppointment() {
        APIHandleBooking.sharedInstace.validateAppointment()
    }
}
