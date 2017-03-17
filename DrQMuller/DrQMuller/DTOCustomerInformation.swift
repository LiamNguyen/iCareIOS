//
//  DTOCustomerInformation.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /08/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class DTOCustomerInformation: NSObject, NSCoding {
    class var sharedInstance: DTOCustomerInformation {
        struct Singleton {
            static let instance = DTOCustomerInformation()
        }
        return Singleton.instance
    }
    
    private var _customerInformationDictionary = [String: Any]()
    var customerInformationDictionary: [String: Any] {
        get {
            return _customerInformationDictionary
        }
        
        set {
            _customerInformationDictionary = newValue
        }
    }
    
    private var _customerAppointmentsDictionary = [String: DTOBookingInformation]()
    var customerAppointmentsDictionary: [String: DTOBookingInformation] {
        get {
            return _customerAppointmentsDictionary
        }
        
        set {
            _customerAppointmentsDictionary = newValue
        }
    }
    
    func returnHttpBody(step: String) -> String? {
        var tempDict = [String: Any]()
        
        tempDict["userId"] = DTOCustomerInformation.sharedInstance.customerInformationDictionary["userId"]
        
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
    }
    
    override init() {
    
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        
        self._customerInformationDictionary = decoder.decodeObject(forKey: "information") as? [String: Any] ?? [String: Any]()
        self._customerAppointmentsDictionary = decoder.decodeObject(forKey: "appointments") as? [String: DTOBookingInformation] ?? [String: DTOBookingInformation]()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_customerInformationDictionary, forKey: "information")
        aCoder.encode(_customerAppointmentsDictionary, forKey: "appointments")
    }

}
