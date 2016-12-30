//
//  PMHandleBooking.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /30/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class PMHandleBooking: NSObject, HTTPClientDelegate {
    private var httpClient: HTTPClient!
    private var dtoArrays: DTOStaticArrayDataSource!
    var counter = 1
    
    override init() {
        super.init()
        httpClient = HTTPClient()
        httpClient.delegate = self
        
        dtoArrays = DTOStaticArrayDataSource()
    }
    
    //=========LISTEN TO RESPONSE FROM GET REQUEST=========
    
    func onReceiveRequestResponse(data: AnyObject) {
//HANDLE COUNTRIES DATASOURCE
        var dropDownCountriesDataSource = [String]()
        if let arrayDataSource = data["Select_Countries"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownCountriesDataSource.append(dictItem["COUNTRY"]! as! String)
            }
            dtoArrays.dropDownCountriesDataSource = dropDownCountriesDataSource
        }
//HANDLE CITIES DATASOURCE
        var dropDownCitiesDataSource = [String]()
        if let arrayDataSource = data["Select_Cities"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownCitiesDataSource.append(dictItem["CITY"]! as! String)
            }
        }
//HANDLE DISTRICTS DATASOURCE
        var dropDownDistrictsDataSource = [String]()
        if let arrayDataSource = data["Select_Districts"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownDistrictsDataSource.append(dictItem["DISTRICT"]! as! String)
            }
        }
//HANDLE LOCATIONS DATASOURCE
        var dropDownLocationsDataSource = [String]()
        if let arrayDataSource = data["Select_Locations"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownLocationsDataSource.append(dictItem["LOCATION_NAME"]! as! String)
            }
        }
//HANDLE VOUCHERS DATASOURCE
        var dropDownVouchersDataSource = [String]()
        if let arrayDataSource = data["Select_Vouchers"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownVouchersDataSource.append(dictItem["VOUCHER"]! as! String)
            }
            dtoArrays.dropDownVouchersDataSource = dropDownVouchersDataSource
        }
//HANDLE TYPES DATASOURCE
        var dropDownTypesDataSource = [String]()
        if let arrayDataSource = data["Select_Types"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownTypesDataSource.append(dictItem["TYPE"]! as! String)
            }
            dtoArrays.dropDownTypesDataSource = dropDownTypesDataSource
        }
        
        
        if self.counter == 3 {
            var returnArrayDataSource = [String: DTOStaticArrayDataSource]()
            returnArrayDataSource["returnArrayDataSource"] = dtoArrays
            NotificationCenter.default.post(name: Notification.Name(rawValue: "arrayDataSource"), object: nil, userInfo: returnArrayDataSource)

            counter = 1
        }
        
        counter += 1
    }
    
    func getDropDownsDataSource() {
        httpClient.getRequest(url: "Select_Countries")
        httpClient.getRequest(url: "Select_Cities")
        httpClient.getRequest(url: "Select_Districts")
        httpClient.getRequest(url: "Select_Locations")
        httpClient.getRequest(url: "Select_Vouchers")
        httpClient.getRequest(url: "Select_Types")
    }
}
