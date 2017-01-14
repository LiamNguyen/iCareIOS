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
    
//    func returnHttpBody() -> String! {
//        if let bookingTime = jsonStringify(obj: _bookingTime) {
//            return ""
//        }
//    }
    
    func jsonStringify(obj: AnyObject) -> String {
        let data = try! JSONSerialization.data(withJSONObject: obj, options: [])
        
        let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
        
        return jsonString
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
