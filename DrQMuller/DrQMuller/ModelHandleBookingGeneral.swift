//
//  ModelHandleBookingGeneral.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /30/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class ModelHandleBookingGeneral: HTTPClientDelegate {
    private var httpClient: HTTPClient!
    var btn_CountriesDropDown: NiceButton! {
        get {
            return btn_CountriesDropDown
        }
        
        set (newVal) {
            btn_CountriesDropDown = newVal
        }
    }
    
    
//=========MARK: PROPERTIES=========
    
    private let dropDown_Countries = DropDown()
    private let dropDown_Cites = DropDown()
    private let dropDown_Districts = DropDown()
    private let dropDown_Locations = DropDown()
    private let dropDown_Vouchers = DropDown()
    private let dropDown_Types = DropDown()
    
//=========ARRAY OF ALL DROPDOWNS=========
    
    lazy var dropDowns: [DropDown] = {
        return [self.dropDown_Countries,
                self.dropDown_Cites,
                self.dropDown_Districts,
                self.dropDown_Locations,
                self.dropDown_Vouchers,
                self.dropDown_Types]
    }()
    
    init() {
        httpClient = HTTPClient()
        self.httpClient.delegate = self
        
        self.httpClient.getRequest(url: "Select_Countries")
        self.httpClient.getRequest(url: "Select_Cities")
        self.httpClient.getRequest(url: "Select_Districts")
        self.httpClient.getRequest(url: "Select_Locations")
        self.httpClient.getRequest(url: "Select_Vouchers")
        self.httpClient.getRequest(url: "Select_Types")
    }
    
//=========LISTEN TO RESPONSE FROM GET REQUEST=========
    
    func onReceiveRequestResponse(data: AnyObject) {
        var dropDownCountriesDataSource = [String]()
        if let arrayDataSource = data["Select_Countries"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownCountriesDataSource.append(dictItem["COUNTRY"]! as! String)
                if dictItem["COUNTRY"] as! String == "Vietnam" {
                    print("ID=\(dictItem["COUNTRY_ID"]!)")
                }
            }
        }
        dropDownCountriesWiredUp(dataSource: dropDownCountriesDataSource)
        
        DispatchQueue.main.async {
            self.btn_CountriesDropDown.setTitle(self.dropDown_Countries.selectedItem, for: .normal)
        }
    }
    
//=========WIRED UP dropDown_Countries=========
    
    func dropDownCountriesWiredUp(dataSource: [String]) {
        dropDown_Countries.anchorView = btn_CountriesDropDown
        
        //dropDown_Countries.bottomOffset = CGPoint(x: 0, y: btn_CountriesDropDown.bounds.height)
        
        dropDown_Countries.dataSource = dataSource
        dropDown_Countries.selectRow(at: 234)
        
        dropDown_Countries.selectionAction = { [unowned self] (index, item) in
            self.btn_CountriesDropDown.setTitle(item, for: .normal)
        }
    }
    
    
    

//=========WIRED UP dropDown_Cities=========


//=========WIRED UP dropDown_Districts=========


//=========WIRED UP dropDown_Locations=========


//=========WIRED UP dropDown_Vouchers=========


//=========WIRED UP dropDown_Types=========
    
    

    
//=========DEFAULT DROPDOWN STYLE=========
    
    func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            $0.customCellConfiguration = nil
        }
        
        dropDowns.forEach { $0.dismissMode = .automatic }
        dropDowns.forEach { $0.direction = .any }
    }
}
