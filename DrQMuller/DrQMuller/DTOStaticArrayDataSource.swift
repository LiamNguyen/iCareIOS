//
//  DTOStaticArrayDataSource.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /30/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class DTOStaticArrayDataSource: NSObject, NSCoding {
    
    class var sharedInstance: DTOStaticArrayDataSource {
        struct Singleton {
            static let instance = DTOStaticArrayDataSource()
        }
        return Singleton.instance
    }
    
    private var _dropDownCountriesDataSource: [String]!
    var dropDownCountriesDataSource: [String] {
        get {
            return _dropDownCountriesDataSource
        }
        
        set (newVal) {
            _dropDownCountriesDataSource = newVal
        }
    }
    
    private var _dropDownCitiesDataSource: [String]!
    var dropDownCitiesDataSource: [String] {
        get {
            return _dropDownCitiesDataSource
        }
        
        set (newVal) {
            _dropDownCitiesDataSource = newVal
        }
    }
    
    private var _dropDownDistrictsDataSource: [String]!
    var dropDownDistrictsDataSource: [String] {
        get {
            return _dropDownDistrictsDataSource
        }
        
        set (newVal) {
            _dropDownDistrictsDataSource = newVal
        }
    }
    
    private var _dropDownLocationsDataSource: [String]!
    var dropDownLocationsDataSource: [String] {
        get {
            return _dropDownLocationsDataSource
        }
        
        set (newVal) {
            _dropDownLocationsDataSource = newVal
        }
    }
    
    private var _dropDownVouchersDataSource: [String]!
    var dropDownVouchersDataSource: [String] {
        get {
            return _dropDownVouchersDataSource
        }
        
        set (newVal) {
            _dropDownVouchersDataSource = newVal
        }
    }
    
    private var _dropDownTypesDataSource: [String]!
    var dropDownTypesDataSource: [String] {
        get {
            return _dropDownTypesDataSource
        }
        
        set (newVal) {
            _dropDownTypesDataSource = newVal
        }
    }
    
    private var _allTimeDataSource: [String]!
    var allTimeDataSource: [String] {
        get {
            return _allTimeDataSource
        }
        
        set (newVal) {
            _allTimeDataSource = newVal
        }
    }
    
    private var _ecoTimeDataSource: [String]!
    var ecoTimeDataSource: [String] {
        get {
            return _ecoTimeDataSource
        }
        
        set(newVal) {
            _ecoTimeDataSource = newVal
        }
    }
    
    override init() {
        
    }
    
    required init(coder decoder: NSCoder) {
        self._dropDownCountriesDataSource = decoder.decodeObject(forKey: "countries") as? [String] ?? [""]
        self._dropDownCitiesDataSource = decoder.decodeObject(forKey: "cities") as? [String] ?? [""]
        self._dropDownDistrictsDataSource = decoder.decodeObject(forKey: "districts") as? [String] ?? [""]
        self._dropDownLocationsDataSource = decoder.decodeObject(forKey: "locations") as? [String] ?? [""]
        self._dropDownVouchersDataSource = decoder.decodeObject(forKey: "vouchers") as? [String] ?? [""]
        self._dropDownTypesDataSource = decoder.decodeObject(forKey: "types") as? [String] ?? [""]
        self._allTimeDataSource = decoder.decodeObject(forKey: "allTime") as? [String] ?? [""]
        self._ecoTimeDataSource = decoder.decodeObject(forKey: "ecoTime") as? [String] ?? [""]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(_dropDownCountriesDataSource, forKey: "countries")
        coder.encode(_dropDownCitiesDataSource, forKey: "cities")
        coder.encode(_dropDownDistrictsDataSource, forKey: "districts")
        coder.encode(_dropDownLocationsDataSource, forKey: "locations")
        coder.encode(_dropDownVouchersDataSource, forKey: "vouchers")
        coder.encode(_dropDownTypesDataSource, forKey: "types")
        coder.encode(_allTimeDataSource, forKey: "allTime")
        coder.encode(_ecoTimeDataSource, forKey: "ecoTime")
    }
}
