//
//  ModelHandleCustomerInformation.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /09/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class ModelHandleCustomerInformation: NSObject {
    
    func handleCustomerInformation(step: String, httpBody: String) {
        APIHandleCustomerInformation.sharedInstance.handleCustomerInformation(step: step, httpBody: httpBody)
    }
}
