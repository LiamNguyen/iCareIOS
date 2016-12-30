//
//  ModelHandleBookingGeneral.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /30/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class ModelHandleBookingGeneral {
    
//=========SEND REQUEST TO GET DROPDOWNS DATASOURCE=========
    
    func getDropDownsDataSource() {
        APIHandleBooking.sharedInstace.getDropDownsDataSource()
    }
    


}
