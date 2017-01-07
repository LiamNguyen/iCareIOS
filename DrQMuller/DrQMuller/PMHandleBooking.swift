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
        var allTimeDisplayArray = [String]()
        if let arrayDataSource = data["Select_AllTime"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                allTimeDisplayArray.append((dictItem["TIME"] as? String)!)
                allTimeDataSource[(dictItem["TIME_ID"] as? String)!] = (dictItem["TIME"] as? String)!
            }
            //let sortedArray = sortDictionary(dictionary: allTimeDataSource)
            //dtoStaticArrayDataSource.allTimeDisplayArray = sortedArray
            dtoStaticArrayDataSource.allTimeDisplayArray = allTimeDisplayArray
            dtoStaticArrayDataSource.allTimeDataSource = allTimeDataSource
        }
        
//HANDLE ECO TIME DATASOURCE
        var ecoTimeDataSource = Dictionary<String, String>()
        var ecoTimeDisplayArray = [String]()
        if let arrayDataSource = data["Select_EcoTime"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                ecoTimeDisplayArray.append((dictItem["TIME"] as? String)!)
                ecoTimeDataSource[(dictItem["TIME_ID"] as? String)!] = dictItem["TIME"]! as? String
            }
            //let sortedArray = sortDictionary(dictionary: ecoTimeDataSource)
            //dtoStaticArrayDataSource.ecoTimeDisplayArray = sortedArray
            dtoStaticArrayDataSource.ecoTimeDisplayArray = ecoTimeDisplayArray
            dtoStaticArrayDataSource.ecoTimeDataSource = ecoTimeDataSource
        }
        
//HANDLE DAYS OF WEEK DATASOURCE

        //var daysOfWeekDataSource = Dictionary<String, String>()
        var daysOfWeekDisplayArray = [String]()
        if let arrayDataSource = data["Select_DaysOfWeek"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                //daysOfWeekDataSource[(dictItem["DAY_ID"] as? String)!] = dictItem["DAY"]! as? String
                daysOfWeekDisplayArray.append((dictItem["DAY"] as? String)!)
            }
            //dtoStaticArrayDataSource.daysOfWeekDataSource = daysOfWeekDataSource
            dtoStaticArrayDataSource.daysOfWeekDisplayArray = daysOfWeekDisplayArray
        }
        
//HANDLE SELECTED TIME DATASOURCE
        var selectedTimeDataSource = Dictionary<String, String>()
        if let arrayDataSource = data["Select_SelectedTime"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                selectedTimeDataSource[(dictItem["TIME_ID"]! as? String)!] = dictItem["TIME"]! as? String
            }
        }
        
//PASS SELECTED TIME DATASOURCE
        
        var returnArrayDataSource = [String: Any]()
        returnArrayDataSource["returnArrayDataSource"] = selectedTimeDataSource
        NotificationCenter.default.post(name: Notification.Name(rawValue: "selectedTimeDataSource"), object: nil, userInfo: returnArrayDataSource)
        
//PASS AND SAVE STATIC ARRAY DATASOURCE
        
        if staticArrayDataSourceIsCompletelySet() {
            var returnArrayDataSource = [String: DTOStaticArrayDataSource]()
            returnArrayDataSource["returnArrayDataSource"] = dtoStaticArrayDataSource
            NotificationCenter.default.post(name: Notification.Name(rawValue: "arrayDataSource"), object: nil, userInfo: returnArrayDataSource)
            pushToUserDefaults(arrayDataSourceObj: dtoStaticArrayDataSource)
        }
    }

//MAKE GET REQUEST FOR STATIC ARRAY DATASOURCE
    
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
        httpClient.getRequest(url: "Select_DaysOfWeek", parameter: "")
    }
    
    func getSelectedTimeDataSource(selectedDayOfWeek_ID: String) {
        httpClient.getRequest(url: "Select_SelectedTime", parameter: "?day_id=\(selectedDayOfWeek_ID)")
    }
    
    private func staticArrayDataSourceHasExisted() -> Bool {
        let pulledDtoArrays = pulledStaticArrayFromUserDefaults() as? DTOStaticArrayDataSource
        
        if pulledDtoArrays != nil {
            var returnArrayDataSourceOffline = [String: DTOStaticArrayDataSource]()
            returnArrayDataSourceOffline["returnArrayDataSourceOffline"] = pulledDtoArrays
            NotificationCenter.default.post(name: Notification.Name(rawValue: "arrayDataSourceOffline"), object: nil, userInfo: returnArrayDataSourceOffline)
            return true
        } else {
            return false
        }
    }
    
//=========PUSH STATIC ARRAY DATASOURCE TO USER DEFAULT==========
    
    private func pushToUserDefaults(arrayDataSourceObj: Any) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: arrayDataSourceObj)
        userDefaults.set(encodedData, forKey: "arrayDataSourceOffline")
        if userDefaults.synchronize() {
            print("Array DataSource Stored")
        }
    }
    
//=========PULL STATIC ARRAY DATASOURCE TO USER DEFAULT==========
    
    func pulledStaticArrayFromUserDefaults() -> Any? {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.object(forKey: "arrayDataSourceOffline") == nil {
            return nil
        }
        
        let decodedData = userDefaults.object(forKey: "arrayDataSourceOffline") as! Data
        let pulledDtoArrays = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as! DTOStaticArrayDataSource
        return pulledDtoArrays
    }
    
//=========CHECK IF ALL STATIC ARRAY DATASOURCE IS COMPLETELY SET==========
    
    private func staticArrayDataSourceIsCompletelySet() -> Bool {
        if dtoStaticArrayDataSource.dropDownCountriesDataSource.isEmpty {
            return false
        }
        if dtoStaticArrayDataSource.dropDownCitiesDataSource.isEmpty {
            return false
        }
        if dtoStaticArrayDataSource.dropDownDistrictsDataSource.isEmpty {
            return false
        }
        if dtoStaticArrayDataSource.dropDownLocationsDataSource.isEmpty {
            return false
        }
        if dtoStaticArrayDataSource.dropDownVouchersDataSource.isEmpty {
            return false
        }
        if dtoStaticArrayDataSource.dropDownTypesDataSource.isEmpty {
            return false
        }
        if dtoStaticArrayDataSource.allTimeDataSource.isEmpty {
            return false
        }
        if dtoStaticArrayDataSource.ecoTimeDataSource.isEmpty {
            return false
        }
        if dtoStaticArrayDataSource.daysOfWeekDisplayArray.isEmpty {
            return false
        }
        return true
    }
    
//=========SORT DICTIONARY KEYS OR VALUES AND RETURN ARRAY=========
   
//    func sortDictionary(dictionary: [String: String]) -> [String] {
//        var sortedArr = [String]()
//        
//        for key in dictionary.values {
//            let convertedKeyStr = key.replacingOccurrences(of: ":", with: "")
//            let convertedKey = Int(convertedKeyStr)!
//            if sortedArr.isEmpty {
//                sortedArr.append(key)
//                continue
//            }
//            for item in sortedArr {
//                if convertedKey < Int(item.replacingOccurrences(of: ":", with: ""))! {
//                    sortedArr.insert(key, at: sortedArr.index(of: item)!)
//                    break
//                }
//                
//                if sortedArr.index(of: item) == sortedArr.count - 1 {
//                    sortedArr.insert(key, at: sortedArr.count)
//                }
//            }
//        }
//
//        return sortedArr
//    }
}
