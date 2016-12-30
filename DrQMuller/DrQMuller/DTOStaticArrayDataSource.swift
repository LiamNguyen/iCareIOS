//
//  DTOStaticArrayDataSource.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /30/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class DTOStaticArrayDataSource: NSObject {
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
}
