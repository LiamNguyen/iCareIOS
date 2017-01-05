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
    private var counter = 1
    private var dtoStaticArrayDataSource: DTOStaticArrayDataSource!
    
    override init() {
        super.init()
        
        self.httpClient = HTTPClient()
        self.httpClient.delegate = self
        self.dtoStaticArrayDataSource = DTOStaticArrayDataSource()
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
            dtoStaticArrayDataSource.dropDownCountriesDataSource = dropDownCountriesDataSource
        }
//HANDLE CITIES DATASOURCE
        var dropDownCitiesDataSource = [String]()
        if let arrayDataSource = data["Select_Cities"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownCitiesDataSource.append(dictItem["CITY"]! as! String)
            }
            dtoStaticArrayDataSource.dropDownCitiesDataSource = dropDownCitiesDataSource
        }
//HANDLE DISTRICTS DATASOURCE
        var dropDownDistrictsDataSource = [String]()
        if let arrayDataSource = data["Select_Districts"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownDistrictsDataSource.append(dictItem["DISTRICT"]! as! String)
            }
            dtoStaticArrayDataSource.dropDownDistrictsDataSource = dropDownDistrictsDataSource
        }
//HANDLE LOCATIONS DATASOURCE
        var dropDownLocationsDataSource = [String]()
        if let arrayDataSource = data["Select_Locations"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownLocationsDataSource.append(dictItem["ADDRESS"]! as! String)
            }
            dtoStaticArrayDataSource.dropDownLocationsDataSource = dropDownLocationsDataSource
        }
//HANDLE VOUCHERS DATASOURCE
        var dropDownVouchersDataSource = [String]()
        if let arrayDataSource = data["Select_Vouchers"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownVouchersDataSource.append(dictItem["VOUCHER"]! as! String)
            }
            dtoStaticArrayDataSource.dropDownVouchersDataSource = dropDownVouchersDataSource
        }
//HANDLE TYPES DATASOURCE
        var dropDownTypesDataSource = [String]()
        if let arrayDataSource = data["Select_Types"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownTypesDataSource.append(dictItem["TYPE"]! as! String)
            }
            dtoStaticArrayDataSource.dropDownTypesDataSource = dropDownTypesDataSource
        }
        
//HANDLE ALL TIME DATASOURCE
        var allTimeDataSource = Dictionary<String, String>()
        if let arrayDataSource = data["Select_AllTime"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                allTimeDataSource[(dictItem["TIME_ID"]! as? String)!] = dictItem["TIME"]! as? String
            }
            dtoStaticArrayDataSource.allTimeDataSource = allTimeDataSource
        }
        
//HANDLE ECO TIME DATASOURCE
        var ecoTimeDataSource = Dictionary<String, String>()
        if let arrayDataSource = data["Select_EcoTime"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                ecoTimeDataSource[(dictItem["TIME_ID"]! as? String)!] = dictItem["TIME"]! as? String
            }
            dtoStaticArrayDataSource.ecoTimeDataSource = ecoTimeDataSource
        }
        
        if counter == 8 {
            var returnArrayDataSource = [String: DTOStaticArrayDataSource]()
            returnArrayDataSource["returnArrayDataSource"] = dtoStaticArrayDataSource
            NotificationCenter.default.post(name: Notification.Name(rawValue: "arrayDataSource"), object: nil, userInfo: returnArrayDataSource)
            pushToUserDefaults(arrayDataSourceObj: dtoStaticArrayDataSource)
        }
        
        counter += 1
        
    }

    func getDropDownsDataSource() {
        if staticArrayDataSourceHasExisted() {
            return
        }
        httpClient.getRequest(url: "Select_Countries", parameter: "")
        httpClient.getRequest(url: "Select_Cities", parameter: "?country_id=235")
        httpClient.getRequest(url: "Select_Districts", parameter: "?city_id=58")
        httpClient.getRequest(url: "Select_Locations", parameter: "?district_id=630")
        httpClient.getRequest(url: "Select_Vouchers", parameter: "")
        httpClient.getRequest(url: "Select_Types", parameter: "")
        
//DOWNLOAD OTHER NECCESSARY ARRAY DATASOURCE
        
        httpClient.getRequest(url: "Select_AllTime", parameter: "")
        httpClient.getRequest(url: "Select_EcoTime", parameter: "")
    }
    
    func getSelectedTimeDataSource(selectedDayOfWeek_ID: String) {
        httpClient.getRequest(url: "Select_SelectedTime", parameter: "?day_id=\(selectedDayOfWeek_ID)")
    }
    
    private func staticArrayDataSourceHasExisted() -> Bool {
        let pulledDtoArrays = pulledStaticArrayFromUserDefaults()
        
        if pulledDtoArrays != nil {
            var returnArrayDataSourceOffline = [String: DTOStaticArrayDataSource]()
            returnArrayDataSourceOffline["returnArrayDataSourceOffline"] = pulledDtoArrays
            NotificationCenter.default.post(name: Notification.Name(rawValue: "arrayDataSourceOffline"), object: nil, userInfo: returnArrayDataSourceOffline)
            return true
        } else {
            return false
        }
    }
    
    private func pushToUserDefaults(arrayDataSourceObj: DTOStaticArrayDataSource) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: arrayDataSourceObj)
        userDefaults.set(encodedData, forKey: "arrayDataSourceOffline")
        if userDefaults.synchronize() {
            print("Array DataSource Stored")
        }
    }
    
    func pulledStaticArrayFromUserDefaults() -> DTOStaticArrayDataSource? {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.object(forKey: "arrayDataSourceOffline") == nil {
            return nil
        }
        
        let decodedData = userDefaults.object(forKey: "arrayDataSourceOffline") as! Data
        let pulledDtoArrays = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as! DTOStaticArrayDataSource
        return pulledDtoArrays
    }
}
