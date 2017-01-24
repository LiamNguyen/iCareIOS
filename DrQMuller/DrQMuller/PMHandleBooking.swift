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
    
    override init() {
        super.init()
        
        self.httpClient = HTTPClient()
        self.httpClient.delegate = self
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
            DTOStaticArrayDataSource.sharedInstance.dropDownCountriesDataSource = dropDownCountriesDataSource
        }
        
//HANDLE CITIES DATASOURCE
        var dropDownCitiesDataSource = [String]()
        if let arrayDataSource = data["Select_Cities"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownCitiesDataSource.append(dictItem["CITY"]! as! String)
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownCitiesDataSource = dropDownCitiesDataSource
        }
        
//HANDLE DISTRICTS DATASOURCE
        var dropDownDistrictsDataSource = [String]()
        if let arrayDataSource = data["Select_Districts"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownDistrictsDataSource.append(dictItem["DISTRICT"]! as! String)
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownDistrictsDataSource = dropDownDistrictsDataSource
        }
        
//HANDLE LOCATIONS DATASOURCE
        var dropDownLocationsDataSource = [String: String]()
        if let arrayDataSource = data["Select_Locations"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownLocationsDataSource[(dictItem["LOCATION_ID"] as? String)!] = (dictItem["ADDRESS"] as? String)!
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownLocationsDataSource = dropDownLocationsDataSource
        }
        
//HANDLE VOUCHERS DATASOURCE
        var dropDownVouchersDataSource = [String: String]()
        if let arrayDataSource = data["Select_Vouchers"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownVouchersDataSource[(dictItem["VOUCHER_ID"] as? String)!] = (dictItem["VOUCHER"] as? String)!
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownVouchersDataSource = dropDownVouchersDataSource
        }
        
//HANDLE TYPES DATASOURCE
        var dropDownTypesDataSource = [String: String]()
        if let arrayDataSource = data["Select_Types"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownTypesDataSource[(dictItem["TYPE_ID"] as? String)!] = (dictItem["TYPE"] as? String)!
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownTypesDataSource = dropDownTypesDataSource
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
            //DTOStaticArrayDataSource.sharedInstance.allTimeDisplayArray = sortedArray
            DTOStaticArrayDataSource.sharedInstance.allTimeDisplayArray = allTimeDisplayArray
            DTOStaticArrayDataSource.sharedInstance.allTimeDataSource = allTimeDataSource
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
            //DTOStaticArrayDataSource.sharedInstance.ecoTimeDisplayArray = sortedArray
            DTOStaticArrayDataSource.sharedInstance.ecoTimeDisplayArray = ecoTimeDisplayArray
            DTOStaticArrayDataSource.sharedInstance.ecoTimeDataSource = ecoTimeDataSource
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
            //DTOStaticArrayDataSource.sharedInstance.daysOfWeekDataSource = daysOfWeekDataSource
            DTOStaticArrayDataSource.sharedInstance.daysOfWeekDisplayArray = daysOfWeekDisplayArray
        }
        
//HANDLE SELECTED TIME DATASOURCE
        var selectedTimeDataSource = Dictionary<String, String>()
        if let arrayDataSource = data["Select_SelectedTime"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                selectedTimeDataSource[(dictItem["TIME_ID"]! as? String)!] = dictItem["TIME"]! as? String
            }
        //PASS SELECTED TIME DATASOURCE
            
            var returnArrayDataSource = [String: Any]()
            returnArrayDataSource["returnArrayDataSource"] = selectedTimeDataSource
            NotificationCenter.default.post(name: Notification.Name(rawValue: "selectedTimeDataSource"), object: nil, userInfo: returnArrayDataSource)
        }
        
//HANDLE REPONSE OF NEW APPOINTMENT'S INSERTION
        
        var isOk = [String: Bool]()
        var appointment_ID: String?
        if let arrayResponse = data["Insert_NewAppointment"]! as? NSArray {
            for arrayItem in arrayResponse {
                let arrayDict = arrayItem as? NSDictionary
                if let app_ID = arrayDict?["Appointment_ID"] as? String {
                    appointment_ID = app_ID
                }

                if let result = arrayDict?["Status"] as? String {
                    if result == "1" {
                        isOk["status"] = true
                        if let app_ID = appointment_ID {
                            DTOBookingInformation.sharedInstance.appointmentID = app_ID
                        }
                    } else {
                        isOk["status"] = false
                    }
                }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "insertAppointmentResponse"), object: nil, userInfo: isOk)
        }
    
//PASS AND SAVE STATIC ARRAY DATASOURCE
        
        if staticArrayDataSourceIsCompletelySet() && !staticArrayDataSourceHasExisted() {
            var returnArrayDataSource = [String: DTOStaticArrayDataSource]()
            returnArrayDataSource["returnArrayDataSource"] = DTOStaticArrayDataSource.sharedInstance
            NotificationCenter.default.post(name: Notification.Name(rawValue: "arrayDataSource"), object: nil, userInfo: returnArrayDataSource)
            pushToUserDefaults(arrayDataSourceObj: DTOStaticArrayDataSource.sharedInstance)
        }
        
//HANDLE CHECKING BOOKING TIME EXISTENCY

        var returnExistencyResult = [String: String]()
        var existency: String!
        if let arrayDataSource = data["BookingTransaction"]! as? NSArray {
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                existency = dictItem["existency"]! as! String
            }
        //PASS CHECKING EXISTENCY RESULT

            returnExistencyResult["returnExistencyResult"] = existency
            NotificationCenter.default.post(name: Notification.Name(rawValue: "existencyResult"), object: nil, userInfo: returnExistencyResult)
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
 
//MAKE GET REQUEST FOR SELECTED TIME

    func getSelectedTimeDataSource(selectedDayOfWeek_ID: String) {
        httpClient.getRequest(url: "Select_SelectedTime", parameter: "?day_id=\(selectedDayOfWeek_ID)")
    }
    
//MAKE GET REQUEST FOR CHECKING EXISTENCE OF BOOKING TIME
    
    func checkBookingTime(day_ID: String, time_ID: String) {
        httpClient.getRequest(url: "BookingTransaction", parameter: "?day_id=\(day_ID)&time_id=\(time_ID)")
    }
    
//INSERT NEW APPOINTMENT
    
    func insertNewAppointment() {
        httpClient.postRequest(url: "Insert_NewAppointment", body: DTOBookingInformation.sharedInstance.returnHttpBody()!)
    }
    
//CHECK EXISTENCE OF STATIC ARRAYS DATASOURCE ON USER DEFAULT
    
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
        if DTOStaticArrayDataSource.sharedInstance.dropDownCountriesDataSource.isEmpty {
            return false
        }
        if DTOStaticArrayDataSource.sharedInstance.dropDownCitiesDataSource.isEmpty {
            return false
        }
        if DTOStaticArrayDataSource.sharedInstance.dropDownDistrictsDataSource.isEmpty {
            return false
        }
        if DTOStaticArrayDataSource.sharedInstance.dropDownLocationsDataSource.isEmpty {
            return false
        }
        if DTOStaticArrayDataSource.sharedInstance.dropDownVouchersDataSource.isEmpty {
            return false
        }
        if DTOStaticArrayDataSource.sharedInstance.dropDownTypesDataSource.isEmpty {
            return false
        }
        if DTOStaticArrayDataSource.sharedInstance.allTimeDataSource.isEmpty {
            return false
        }
        if DTOStaticArrayDataSource.sharedInstance.ecoTimeDataSource.isEmpty {
            return false
        }
        if DTOStaticArrayDataSource.sharedInstance.daysOfWeekDisplayArray.isEmpty {
            return false
        }
        return true
    }
}
