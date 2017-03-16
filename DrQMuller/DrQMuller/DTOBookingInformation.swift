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
            if _appointmentID == nil {
                return String()
            }
            return _appointmentID
        }
        
        set(newVal) {
            _appointmentID = newVal
        }
    }
    
    private var _verificationCode: String!
    var verificationCode: String {
        get {
            if _verificationCode == nil {
                return String()
            }
            return _verificationCode
        }
    }
    
    private var _country: String!
    var country: String {
        get {
            if _country == nil {
                return String()
            }
            return _country
        }
        
        set (newVal) {
            _country = newVal
        }
    }

    private var _city: String!
    var city: String {
        get {
            if _city == nil {
                return String()
            }
            return _city
        }
        
        set (newVal) {
            _city = newVal
        }
    }
    
    private var _district: String!
    var district: String {
        get {
            if _district == nil {
                return String()
            }
            return _district
        }
        
        set (newVal) {
            _district = newVal
        }
    }
    
    private var _location: String!
    var location: String {
        get {
            if _location == nil {
                return String()
            }
            return _location
        }
        
        set (newVal) {
            _location = newVal
        }
    }
    
    private var _voucher: String!
    var voucher: String {
        get {
            if _voucher == nil {
                return String()
            }
            return _voucher
        }
        
        set (newVal) {
            _voucher = newVal
        }
    }
    
    private var _type: String!
    var type: String {
        get {
            if _type == nil {
                return String()
            }
            return _type
        }
        
        set (newVal) {
            _type = newVal
        }
    }
    
    private var _machinesDataSource: [String: String]!
    var machinesDataSource: [String: String] {
        get {
            if _machinesDataSource == nil {
                return [String: String]()
            }
            return _machinesDataSource
        }
        
        set (newVal) {
            _machinesDataSource = newVal
        }
    }
    
    private var _machine: String!
    var machine: String {
        get {
            if _machine == nil {
                return String()
            }
            return _machine
        }
        
        set (newVal) {
            _machine = newVal
        }
    }
    
    private var _startDate: String!
    var startDate: String {
        get {
            if _startDate == nil {
                return String()
            }
            return _startDate
        }
        
        set (newVal) {
            _startDate = newVal
        }
    }
    
    private var _endDate: String!
    var endDate: String {
        get {
            if _endDate == nil {
                return String()
            }
            return _endDate
        }
        
        set (newVal) {
            _endDate = newVal
        }
    }
    
    private var _exactDate: String!
    var exactDate: String {
        get {
            if _exactDate == nil {
                return String()
            }
            return _exactDate
        }
        
        set (newVal) {
            _exactDate = newVal
        }
    }
    
    private var _exactDayOfWeek: String!
    var exactDayOfWeek: String {
        get {
            if _exactDayOfWeek == nil {
                return String()
            }
            return _exactDayOfWeek
        }
        
        set (newVal) {
            _exactDayOfWeek = newVal
        }
    }
    
    private var _bookingTime: [[String: String]]!
    var bookingTime: [[String: String]] {
        get {
            if _bookingTime == nil {
                return [[String: String]]()
            }
            return _bookingTime
        }
        
        set (newVal) {
            _bookingTime = newVal
        }
    }
    
    private var _isConfirmed: String!
    var isConfirmed: String {
        get {
            if _isConfirmed == nil {
                return String()
            }
            return _isConfirmed
        }
        
        set (newVal) {
            _isConfirmed = newVal
        }
    }
    
    func clearAllDTOBookingInfo() {
        self._appointmentID = nil
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
        self._isConfirmed = nil
        self._verificationCode = nil
    }
    
    func returnJsonAppointmentInfo() -> String {
        var appointmentInfoDictionary = [String: Any]()
        
        appointmentInfoDictionary["userId"] = DTOCustomerInformation.sharedInstance.customerInformationDictionary[JsonPropertyName.userId] as? String ?? String()
        appointmentInfoDictionary["userName"] = DTOCustomerInformation.sharedInstance.customerInformationDictionary[JsonPropertyName.userName] as? String ?? String()
        appointmentInfoDictionary["createdAt"] = Functionality.getCurrentDateTime()
        appointmentInfoDictionary["appointmentId"] = self._appointmentID
        appointmentInfoDictionary["location"] = self._location
        appointmentInfoDictionary["voucher"] = self._voucher
        appointmentInfoDictionary["type"] = self._type
        appointmentInfoDictionary["startDate"] = self._startDate
        appointmentInfoDictionary["endDate"] = self._endDate
        appointmentInfoDictionary["exactDate"] = self._exactDate
        appointmentInfoDictionary["verificationCode"] = self.verificationCode
        appointmentInfoDictionary["bookingTime"] = returnBookingTimeForEmailTemplate()
        
        return Functionality.jsonStringify(obj: appointmentInfoDictionary as AnyObject)
    }
    
    private func returnBookingTimeForEmailTemplate() -> String {
        var result = String()
        let dtoArrays = APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()
        
        let allTime = dtoArrays?.allTimeDataSource

        result = "\(self.exactDayOfWeek) - \((allTime?[self.bookingTime[0]["timeId"]!])!)"
        
        return result
    }
    
    func printBookingInfo() {
        print("\nAppointment ID: \(self.appointmentID)\nCountry: \(self.country)\nCity: \(self.city)\nDistrict: \(self.district)\nLocation: \(self.location)\nVoucher: \(self.voucher)\nType: \(self.type)\nStart: \(self.startDate)\nEnd: \(self.endDate)\nExact: \(self.exactDate)\nDay Of Week: \(self.exactDayOfWeek)\nBooking Time: \(self.bookingTime)\nMachine: \(self.machine)\nStatus: \(self.isConfirmed)\nVerification Code: \(self.verificationCode)\n")
    }
    
    func getRequestBodyForCreateAppointment() -> String {
        
        let dtoArrays = APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()!
        let customerInformation = DTOCustomerInformation.sharedInstance.customerInformationDictionary
        
        self._verificationCode = generateVerificationCode(length: 8)
        
        let locationId = Functionality.findKeyFromValue(dictionary: dtoArrays.dropDownLocationsDataSource, value: _location)
        let voucherId = Functionality.findKeyFromValue(dictionary: dtoArrays.dropDownVouchersDataSource, value: _voucher)
        let typeId = Functionality.findKeyFromValue(dictionary: dtoArrays.dropDownTypesDataSource, value: _type)
        let customerId = customerInformation[JsonPropertyName.userId] as! String
        var startDate = String()
        var expiredDate = String()
        
        if self.startDate.isEmpty {
            startDate = "1111-11-11"
            expiredDate = self.exactDate
        } else {
            startDate = self.startDate
            expiredDate = self.endDate
        }
        
        let dict: [String: Any] = [
            "startDate": startDate,
            "expiredDate": expiredDate,
            "typeId": typeId,
            "userId": customerId,
            "voucherId": voucherId,
            "verificationCode": self.verificationCode,
            "locationId": locationId,
            "time": self.bookingTime
        ]
                
        return Functionality.jsonStringify(obj: dict as AnyObject)
        
    }
    
    func getRequestBodyForBookingTransaction(time: [String: String]) -> String {
        let timeArray = [time]

        let dtoArrays = APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()!
        
        let locationId = Functionality.findKeyFromValue(dictionary: dtoArrays.dropDownLocationsDataSource, value: _location)
        
        let dict: [String: Any] = [
            "locationId": locationId,
            "time": timeArray
        ]
        
        return Functionality.jsonStringify(obj: dict as AnyObject)
    }
    
    func getRequestBodyForReleasingTime(time: [[String: String]]) -> String {
        
        let dtoArrays = APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()!
        
        let locationId = Functionality.findKeyFromValue(dictionary: dtoArrays.dropDownLocationsDataSource, value: _location)
        
        let dict: [String: Any] = [
            "locationId": locationId,
            "time": time
        ]
        
        return Functionality.jsonStringify(obj: dict as AnyObject)
    }
    
    func getRequestBodyForCancelAppointment(appointmentId: String) -> String {
        let customerId = DTOCustomerInformation.sharedInstance.customerInformationDictionary[JsonPropertyName.userId] as! String
        
        let dict: [String: Any] = [
            "userId": customerId,
            "appointmentId": appointmentId
        ]
        
        return Functionality.jsonStringify(obj: dict as AnyObject)
    }
    
    func generateVerificationCode(length: Int) -> String {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = String()
        
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
        
        self._appointmentID = aDecoder.decodeObject(forKey: "appointmentID") as? String ?? String()
        self._verificationCode = aDecoder.decodeObject(forKey: "veriCode") as? String ?? String()
        self._country = aDecoder.decodeObject(forKey: "country") as? String ?? String()
        self._city = aDecoder.decodeObject(forKey: "city") as? String ?? String()
        self._district = aDecoder.decodeObject(forKey: "district") as? String ?? String()
        self._location = aDecoder.decodeObject(forKey: "location") as? String ?? String()
        self._voucher = aDecoder.decodeObject(forKey: "voucher") as? String ?? String()
        self._type = aDecoder.decodeObject(forKey: "type") as? String ?? String()
        self._machinesDataSource = aDecoder.decodeObject(forKey: "machinesDS") as? [String: String] ?? [String: String]()
        self._machine = aDecoder.decodeObject(forKey: "machine") as? String ?? String()
        self._startDate = aDecoder.decodeObject(forKey: "startDate") as? String ?? String()
        self._endDate = aDecoder.decodeObject(forKey: "endDate") as? String ?? String()
        self._exactDate = aDecoder.decodeObject(forKey: "exactDate") as? String ?? String()
        self._exactDayOfWeek = aDecoder.decodeObject(forKey: "exactDayOfWeed") as? String ?? String()
        self._bookingTime = aDecoder.decodeObject(forKey: "bookingTime") as? [[String: String]] ?? [[String: String]]()
        self._isConfirmed = aDecoder.decodeObject(forKey: "isConfirmed") as? String ?? String()
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
        aCoder.encode(_isConfirmed, forKey: "isConfirmed")
    }
}
