//
//  DTOStaticArrayDataSource.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /30/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class DTOStaticArrayDataSource: NSObject, NSCoding {
    
    private var _dropDownCountriesDataSource: [String]!
    var dropDownCountriesDataSource: [String] {
        get {
            if _dropDownCountriesDataSource == nil {
                return [String]()
            }
            return _dropDownCountriesDataSource
        }
        
        set (newVal) {
            _dropDownCountriesDataSource = newVal
        }
    }
    
    private var _dropDownCitiesDataSource: [String]!
    var dropDownCitiesDataSource: [String] {
        get {
            if _dropDownCitiesDataSource == nil {
                return [String]()
            }
            return _dropDownCitiesDataSource
        }
        
        set (newVal) {
            _dropDownCitiesDataSource = newVal
        }
    }
    
    private var _dropDownDistrictsDataSource: [String]!
    var dropDownDistrictsDataSource: [String] {
        get {
            if _dropDownDistrictsDataSource == nil {
                return [String]()
            }
            return _dropDownDistrictsDataSource
        }
        
        set (newVal) {
            _dropDownDistrictsDataSource = newVal
        }
    }
    
    private var _dropDownLocationsDataSource: [String]!
    var dropDownLocationsDataSource: [String] {
        get {
            if _dropDownLocationsDataSource == nil {
                return [String]()
            }
            return _dropDownLocationsDataSource
        }
        
        set (newVal) {
            _dropDownLocationsDataSource = newVal
        }
    }
    
    private var _dropDownVouchersDataSource: [String]!
    var dropDownVouchersDataSource: [String] {
        get {
            if _dropDownVouchersDataSource == nil {
                return [String]()
            }
            return _dropDownVouchersDataSource
        }
        
        set (newVal) {
            _dropDownVouchersDataSource = newVal
        }
    }
    
    private var _dropDownTypesDataSource: [String]!
    var dropDownTypesDataSource: [String] {
        get {
            if _dropDownTypesDataSource == nil {
                return [String]()
            }
            return _dropDownTypesDataSource
        }
        
        set (newVal) {
            _dropDownTypesDataSource = newVal
        }
    }
    
    private var _allTimeDisplayArray: [String]!
    var allTimeDisplayArray: [String] {
        get {
            if _allTimeDisplayArray == nil {
                return [String]()
            }
            return _allTimeDisplayArray
        }
        
        set (newVal) {
            _allTimeDisplayArray = newVal
        }
    }
    
    private var _allTimeDataSource: Dictionary<String, String>!
    var allTimeDataSource: Dictionary<String, String> {
        get {
            if _allTimeDataSource == nil {
                return Dictionary<String, String>()
            }
            return _allTimeDataSource
        }
        
        set (newVal) {
            _allTimeDataSource = newVal
        }
    }
    
    private var _ecoTimeDisplayArray: [String]!
    var ecoTimeDisplayArray: [String] {
        get {
            if _ecoTimeDisplayArray == nil {
                return [String]()
            }
            return _ecoTimeDisplayArray
        }
        
        set (newVal) {
            _ecoTimeDisplayArray = newVal
        }
    }
    
    private var _ecoTimeDataSource: Dictionary<String, String>!
    var ecoTimeDataSource: Dictionary<String, String> {
        get {
            if _ecoTimeDataSource == nil {
                return Dictionary<String, String>()
            }
            return _ecoTimeDataSource
        }
        
        set(newVal) {
            _ecoTimeDataSource = newVal
        }
    }
    
    private var _daysOfWeekDisplayArray: [String]!
    var daysOfWeekDisplayArray: [String] {
        get {
            if _daysOfWeekDisplayArray == nil {
                return [String]()
            }
            return _daysOfWeekDisplayArray
        }
        
        set (newVal) {
            _daysOfWeekDisplayArray = newVal
        }
    }
    
//    private var _daysOfWeekDataSource: Dictionary<String, String>!
//    var daysOfWeekDataSource: Dictionary<String, String> {
//        get {
//            if _daysOfWeekDataSource == nil {
//                return Dictionary<String, String>()
//            }
//            return _daysOfWeekDataSource
//        }
//        
//        set(newVal) {
//            _daysOfWeekDataSource = newVal
//        }
//    }
    
    override init() {
        
    }
    
    required init(coder decoder: NSCoder) {
        self._dropDownCountriesDataSource = decoder.decodeObject(forKey: "countries") as? [String] ?? [""]
        self._dropDownCitiesDataSource = decoder.decodeObject(forKey: "cities") as? [String] ?? [""]
        self._dropDownDistrictsDataSource = decoder.decodeObject(forKey: "districts") as? [String] ?? [""]
        self._dropDownLocationsDataSource = decoder.decodeObject(forKey: "locations") as? [String] ?? [""]
        self._dropDownVouchersDataSource = decoder.decodeObject(forKey: "vouchers") as? [String] ?? [""]
        self._dropDownTypesDataSource = decoder.decodeObject(forKey: "types") as? [String] ?? [""]
        self._allTimeDisplayArray = decoder.decodeObject(forKey: "allTimeDisplay") as? [String] ?? [""]
        self._allTimeDataSource = decoder.decodeObject(forKey: "allTime") as? Dictionary<String, String> ?? Dictionary<String, String>()
        self._ecoTimeDisplayArray = decoder.decodeObject(forKey: "ecoTimeDisplay") as? [String] ?? [""]
        self._ecoTimeDataSource = decoder.decodeObject(forKey: "ecoTime") as? Dictionary<String, String> ?? Dictionary<String, String>()
        self._daysOfWeekDisplayArray = decoder.decodeObject(forKey: "daysDisplay") as? [String] ?? [""]
        //self._daysOfWeekDataSource = decoder.decodeObject(forKey: "days") as? Dictionary<String, String> ?? Dictionary<String, String>()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(_dropDownCountriesDataSource, forKey: "countries")
        coder.encode(_dropDownCitiesDataSource, forKey: "cities")
        coder.encode(_dropDownDistrictsDataSource, forKey: "districts")
        coder.encode(_dropDownLocationsDataSource, forKey: "locations")
        coder.encode(_dropDownVouchersDataSource, forKey: "vouchers")
        coder.encode(_dropDownTypesDataSource, forKey: "types")
        coder.encode(_allTimeDisplayArray, forKey: "allTimeDisplay")
        coder.encode(_allTimeDataSource, forKey: "allTime")
        coder.encode(ecoTimeDisplayArray, forKey: "ecoTimeDisplay")
        coder.encode(_ecoTimeDataSource, forKey: "ecoTime")
        coder.encode(_daysOfWeekDisplayArray, forKey: "daysDisplay")
        //coder.encode(_daysOfWeekDataSource, forKey: "days")
    }
}
