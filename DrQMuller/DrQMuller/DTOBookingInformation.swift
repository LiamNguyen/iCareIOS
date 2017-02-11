//
//  DTOBookingInformation.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /01/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class DTOBookingInformation: NSObject, NSCoding {
    
    class var sharedInstance: DTOBookingInformation {
        struct Singleton {
            static let instance = DTOBookingInformation()
        }
        return Singleton.instance
    }
    
    private var _appointmentID: String!
    var appointmentID: String {
        get {
            return _appointmentID
        }
        
        set(newVal) {
            _appointmentID = newVal
        }
    }
    
    private var _verificationCode: String!
    var verificationCode: String {
        get {
            return _verificationCode
        }
    }
    
    private var _country: String!
    var country: String {
        get {
            return _country
        }
        
        set (newVal) {
            _country = newVal
        }
    }

    private var _city: String!
    var city: String {
        get {
            return _city
        }
        
        set (newVal) {
            _city = newVal
        }
    }
    
    private var _district: String!
    var district: String {
        get {
            return _district
        }
        
        set (newVal) {
            _district = newVal
        }
    }
    
    private var _location: String!
    var location: String {
        get {
            return _location
        }
        
        set (newVal) {
            _location = newVal
        }
    }
    
    private var _voucher: String!
    var voucher: String {
        get {
            return _voucher
        }
        
        set (newVal) {
            _voucher = newVal
        }
    }
    
    private var _type: String!
    var type: String {
        get {
            return _type
        }
        
        set (newVal) {
            _type = newVal
        }
    }
    
    private var _machinesDataSource: [String: String]!
    var machinesDataSource: [String: String] {
        get {
            return _machinesDataSource
        }
        
        set (newVal) {
            _machinesDataSource = newVal
        }
    }
    
    private var _machine: String!
    var machine: String {
        get {
            return _machine
        }
        
        set (newVal) {
            _machine = newVal
        }
    }
    
    private var _startDate: String!
    var startDate: String {
        get {
            return _startDate
        }
        
        set (newVal) {
            _startDate = newVal
        }
    }
    
    private var _endDate: String!
    var endDate: String {
        get {
            return _endDate
        }
        
        set (newVal) {
            _endDate = newVal
        }
    }
    
    private var _exactDate: String!
    var exactDate: String {
        get {
            return _exactDate
        }
        
        set (newVal) {
            _exactDate = newVal
        }
    }
    
    private var _exactDayOfWeek: String!
    var exactDayOfWeek: String {
        get {
            return _exactDayOfWeek
        }
        
        set (newVal) {
            _exactDayOfWeek = newVal
        }
    }
    
    private var _bookingTime: [[String]]!
    var bookingTime: [[String]] {
        get {
            if _bookingTime == nil {
                return [[String]]()
            }
            return _bookingTime
        }
        
        set (newVal) {
            _bookingTime = newVal
        }
    }
    
    func clearAllDTOBookingInfo() {
        self._country = nil
        self._city = nil
        self._district = nil
        self._location = nil
        self._voucher = nil
        self._type = nil
        self._startDate = nil
        self._endDate = nil
        self._exactDate = nil
        self._exactDayOfWeek = nil
        self._bookingTime = nil
    }
    
    func returnHttpBody() -> String? {
        let dtoArrays = APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()!
        
        let typesDataSource = dtoArrays.dropDownTypesDataSource
        let vouchersDataSource = dtoArrays.dropDownVouchersDataSource
        let locationsDataSource = dtoArrays.dropDownLocationsDataSource
        
        let machine_ID = Functionality.findKeyFromValue(dictionary: DTOBookingInformation.sharedInstance.machinesDataSource, value: DTOBookingInformation.sharedInstance.machine)
        
        let customerInformation = DTOCustomerInformation.sharedInstance.customerInformationDictionary

        var result = ""
        
        if _type == "Tự do" {
            if let exactDate = _exactDate {
                result += "start_date=1111-11-11&expire_date=\(exactDate)&"
            }
        } else {
            if let startDate = _startDate, let endDate = _endDate {
                result += "start_date=\(startDate)&expire_date=\(endDate)&"
            }
        }

        if let type = _type, let customerID = customerInformation["userId"], let location = _location, let voucher = _voucher, let bookingTime = _bookingTime {
            self._verificationCode = generateVerificationCode(length: 10)
            result += "type_id=\(Functionality.findKeyFromValue(dictionary: typesDataSource, value: type))&" +
                        "customer_id=\(customerID)&" +
                        "location_id=\(Functionality.findKeyFromValue(dictionary: locationsDataSource, value: location))&" +
                        "voucher_id=\(Functionality.findKeyFromValue(dictionary: vouchersDataSource, value: voucher))&" +
                        "bookingTime=\(Functionality.jsonStringify(obj: bookingTime as AnyObject))&" +
                        "code=\(self._verificationCode!)&" +
                        "machine_id=\(machine_ID)"
        } else {
            return ""
        }
        
        return result
    }
    
    func generateVerificationCode(length: Int) -> String {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self._appointmentID = aDecoder.decodeObject(forKey: "appointmentID") as? String ?? ""
        self._verificationCode = aDecoder.decodeObject(forKey: "veriCode") as? String ?? ""
        self._country = aDecoder.decodeObject(forKey: "country") as? String ?? ""
        self._city = aDecoder.decodeObject(forKey: "city") as? String ?? ""
        self._district = aDecoder.decodeObject(forKey: "district") as? String ?? ""
        self._location = aDecoder.decodeObject(forKey: "location") as? String ?? ""
        self._voucher = aDecoder.decodeObject(forKey: "voucher") as? String ?? ""
        self._type = aDecoder.decodeObject(forKey: "type") as? String ?? ""
        self._machinesDataSource = aDecoder.decodeObject(forKey: "machinesDS") as? [String: String] ?? [String: String]()
        self._machine = aDecoder.decodeObject(forKey: "machine") as? String ?? ""
        self._startDate = aDecoder.decodeObject(forKey: "startDate") as? String ?? ""
        self._endDate = aDecoder.decodeObject(forKey: "endDate") as? String ?? ""
        self._exactDate = aDecoder.decodeObject(forKey: "exactDate") as? String ?? ""
        self._exactDayOfWeek = aDecoder.decodeObject(forKey: "exactDayOfWeed") as? String ?? ""
        self._bookingTime = aDecoder.decodeObject(forKey: "bookingTime") as? [[String]] ?? [[String]]()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_appointmentID, forKey: "appointmentID")
        aCoder.encode(_verificationCode, forKey: "veriCode")
        aCoder.encode(_country, forKey: "country")
        aCoder.encode(_city, forKey: "city")
        aCoder.encode(_district, forKey: "district")
        aCoder.encode(_location, forKey: "location")
        aCoder.encode(_voucher, forKey: "voucher")
        aCoder.encode(_type, forKey: "type")
        aCoder.encode(_machinesDataSource, forKey: "machinesDS")
        aCoder.encode(_machine, forKey: "machine")
        aCoder.encode(_startDate, forKey: "startDate")
        aCoder.encode(_endDate, forKey: "endDate")
        aCoder.encode(_exactDate, forKey: "exactDate")
        aCoder.encode(_exactDayOfWeek, forKey: "exactDayOfWeed")
        aCoder.encode(_bookingTime, forKey: "bookingTime")
    }
    
    
    
    
    
    
    
    
    
    
}
