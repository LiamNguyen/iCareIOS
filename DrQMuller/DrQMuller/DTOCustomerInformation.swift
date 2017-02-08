//
//  DTOCustomerInformation.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /08/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class DTOCustomerInformation: NSObject {
    class var sharedInstance: DTOCustomerInformation {
        struct Singleton {
            static let instance = DTOCustomerInformation()
        }
        return Singleton.instance
    }
    
    private var _customerInformationDictionary: [String: String]!
    var customerInformationDictionary: [String: String] {
        get {
            return _customerInformationDictionary
        }
        
        set {
            _customerInformationDictionary = newValue
        }
    }
    
    func returnHttpBody() -> String? {
        if let customerInformationDictionary = _customerInformationDictionary {
            return Functionality.jsonStringify(obj: customerInformationDictionary as AnyObject)
        } else {
            return nil
        }
    }
}
