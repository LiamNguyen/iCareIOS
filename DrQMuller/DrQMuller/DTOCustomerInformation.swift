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
    
    func returnHttpBody(step: String) -> String? {
        if let customerInformationDictionary = _customerInformationDictionary {
            var tempDict = [String: String]()
            
            tempDict["userId"] = DTOCustomerInformation.sharedInstance.customerInformationDictionary["userId"]
            //tempDict["updatedAt"] =
            
            switch step {
            case "basic":
                tempDict["userName"] = customerInformationDictionary["userName"]
                tempDict["userAddress"] = customerInformationDictionary["userAddress"]
                
            case "necessary":
                tempDict["userDob"] = customerInformationDictionary["userDob"]
                tempDict["userGender"] = customerInformationDictionary["userGender"]
                
            default:
                tempDict["userEmail"] = customerInformationDictionary["userEmail"]
                tempDict["userPhone"] = customerInformationDictionary["userPhone"]
            }
            
            return Functionality.jsonStringify(obj: tempDict as AnyObject)
        } else {
            return nil
        }
    }
}
