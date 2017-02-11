//
//  APIHandleCustomerInformation.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /09/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class APIHandleCustomerInformation: NSObject {

    private var persistencyManager: PMHandleCustomerInformation!

    class var sharedInstance: APIHandleCustomerInformation {
        struct Singleton {
            static let instance = APIHandleCustomerInformation()
        }
        return Singleton.instance
    }
    
    override init() {
        self.persistencyManager = PMHandleCustomerInformation()
    }
    
    func handleCustomerInformation(step: String, httpBody: String) {
        self.persistencyManager.handleCustomerInformation(step: step, httpBody: httpBody)
    }
}
