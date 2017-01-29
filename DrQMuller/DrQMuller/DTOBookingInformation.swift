//
//  DTOBookingInformation.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /01/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class DTOBookingInformation: NSObject {
    
    class var sharedInstance: DTOBookingInformation {
        struct Singleton {
            static let instance = DTOBookingInformation()
        }
        return Singleton.instance
    }
    
    private var _customerID: String!
    var customerID: String {
        get {
            return _customerID
        }
        
        set (newVal) {
            _customerID = newVal
        }
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

        if let type = _type, let customerID = _customerID, let location = _location, let voucher = _voucher, let bookingTime = _bookingTime {
            self._verificationCode = generateVerificationCode(length: 10)
            result += "type_id=\(Functionality.findKeyFromValue(dictionary: typesDataSource, value: type))&" +
                        "customer_id=\(customerID)&" +
                        "location_id=\(Functionality.findKeyFromValue(dictionary: locationsDataSource, value: location))&" +
                        "voucher_id=\(Functionality.findKeyFromValue(dictionary: vouchersDataSource, value: voucher))&" +
                        "bookingTime=\(Functionality.jsonStringify(obj: bookingTime as AnyObject))&" +
                        "code=\(self._verificationCode!)"
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
        
    
    
    
    
    
    
    
    
    
    
    
    
}
