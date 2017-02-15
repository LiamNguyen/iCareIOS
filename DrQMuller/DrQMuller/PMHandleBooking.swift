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
        
        if let arrayDataSource = data["Select_Countries"]! as? NSArray {
            var dropDownCountriesDataSource = [String]()
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownCountriesDataSource.append(dictItem["COUNTRY"]! as! String)
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownCountriesDataSource = dropDownCountriesDataSource
        }
        
//HANDLE CITIES DATASOURCE
        
        if let arrayDataSource = data["Select_Cities"]! as? NSArray {
            var dropDownCitiesDataSource = [String]()
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownCitiesDataSource.append(dictItem["CITY"]! as! String)
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownCitiesDataSource = dropDownCitiesDataSource
        }
        
//HANDLE DISTRICTS DATASOURCE
        
        if let arrayDataSource = data["Select_Districts"]! as? NSArray {
            var dropDownDistrictsDataSource = [String]()
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownDistrictsDataSource.append(dictItem["DISTRICT"]! as! String)
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownDistrictsDataSource = dropDownDistrictsDataSource
        }
        
//HANDLE LOCATIONS DATASOURCE

        if let arrayDataSource = data["Select_Locations"]! as? NSArray {
            var dropDownLocationsDataSource = [String: String]()
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownLocationsDataSource[(dictItem["LOCATION_ID"] as? String)!] = (dictItem["ADDRESS"] as? String)!
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownLocationsDataSource = dropDownLocationsDataSource
        }
        
//HANDLE VOUCHERS DATASOURCE

        if let arrayDataSource = data["Select_Vouchers"]! as? NSArray {
            var dropDownVouchersDataSource = [String: String]()
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownVouchersDataSource[(dictItem["VOUCHER_ID"] as? String)!] = (dictItem["VOUCHER"] as? String)!
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownVouchersDataSource = dropDownVouchersDataSource
        }
        
//HANDLE TYPES DATASOURCE

        if let arrayDataSource = data["Select_Types"]! as? NSArray {
            var dropDownTypesDataSource = [String: String]()
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                dropDownTypesDataSource[(dictItem["TYPE_ID"] as? String)!] = (dictItem["TYPE"] as? String)!
            }
            DTOStaticArrayDataSource.sharedInstance.dropDownTypesDataSource = dropDownTypesDataSource
        }
        
//HANDLE ALL TIME DATASOURCE
        
        if let arrayDataSource = data["Select_AllTime"]! as? NSArray {
            var allTimeDataSource = Dictionary<String, String>()
            var allTimeDisplayArray = [String]()
            
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
        
        if let arrayDataSource = data["Select_EcoTime"]! as? NSArray {
            var ecoTimeDataSource = Dictionary<String, String>()
            var ecoTimeDisplayArray = [String]()
            
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

        if let arrayDataSource = data["Select_DaysOfWeek"]! as? NSArray {
            //var daysOfWeekDataSource = Dictionary<String, String>()
            var daysOfWeekDisplayArray = [String]()
            for arrayItem in arrayDataSource {
                let dictItem = arrayItem as! NSDictionary
                //daysOfWeekDataSource[(dictItem["DAY_ID"] as? String)!] = dictItem["DAY"]! as? String
                daysOfWeekDisplayArray.append((dictItem["DAY"] as? String)!)
            }
            //DTOStaticArrayDataSource.sharedInstance.daysOfWeekDataSource = daysOfWeekDataSource
            DTOStaticArrayDataSource.sharedInstance.daysOfWeekDisplayArray = daysOfWeekDisplayArray
        }
        
//HANDLE SELECTED TIME DATASOURCE
        
        if let arrayDataSource = data["Select_SelectedTime"]! as? NSArray {
            var selectedTimeDataSource = Dictionary<String, String>()
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
        
        if let arrayResponse = data["Insert_NewAppointment"]! as? NSArray {
            var isOk = [String: Bool]()
            var appointment_ID: String?
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
        
//HANDLE REPONSE OF VALIDATING VERIFICATION CODE
        
        if let arrayResponse = data["Update_Appointment"]! as? NSArray {
            var isOk = [String: Bool]()
            for arrayItem in arrayResponse {
                let arrayDict = arrayItem as? NSDictionary
                
                if let result = arrayDict?["Status"] as? String {
                    if result == "1" {
                        isOk["status"] = true
                    } else {
                        isOk["status"] = false
                    }
                }
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "validateCode"), object: nil, userInfo: isOk)
        }
        
//HANDLE REPONSE OF CANCELING APPOINTMENT
        
        if let arrayResponse = data["Update_CancelAppointment"]! as? NSArray {
            var isOk = [String: Bool]()
            for arrayItem in arrayResponse {
                let arrayDict = arrayItem as? NSDictionary
                
                if let result = arrayDict?["Status"] as? String {
                    if result == "1" {
                        isOk["status"] = true
                    } else {
                        isOk["status"] = false
                    }
                }
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cancelAppointment"), object: nil, userInfo: isOk)
        }
        
//HANDLE RESPONSE OF VALIDATING APPOINTMENT
        
        if let arrayResponse = data["Update_ValidateAppointment"]! as? NSArray {
            for arrayItem in arrayResponse {
                let arrayDict = arrayItem as? NSDictionary
                
                if let result = arrayDict?["Status"] as? String {
                    if result == "1" {
                        print("Appointment validated")
                    } else {
                        print("Appointment failed to be validated")
                    }
                }
            }
        }
        
//HANDLE RESPONSE OF GET MACHINES DATASOURCE
        
        if let arrayResponse = data["Select_Machines"]! as? NSArray {
            var machinesDataSource = [String: String]()
            for arrayItem in arrayResponse {
                let dictItem = arrayItem as! NSDictionary
                machinesDataSource[dictItem["MACHINE_ID"] as! String] = (dictItem["MACHINE_NAME"] as! String)
            }
            DTOBookingInformation.sharedInstance.machinesDataSource = machinesDataSource
            
            var returnArrayDataSource = [String: Any]()
            returnArrayDataSource["returnArrayDataSource"] = machinesDataSource
            NotificationCenter.default.post(name: Notification.Name(rawValue: "machinesDataSource"), object: nil, userInfo: returnArrayDataSource)
        }
    
//PASS AND SAVE STATIC ARRAY DATASOURCE
        
        if staticArrayDataSourceIsCompletelySet() && !staticArrayDataSourceHasExisted() {
            var returnArrayDataSource = [String: DTOStaticArrayDataSource]()
            returnArrayDataSource["returnArrayDataSource"] = DTOStaticArrayDataSource.sharedInstance
            NotificationCenter.default.post(name: Notification.Name(rawValue: "arrayDataSource"), object: nil, userInfo: returnArrayDataSource)
            Functionality.pushToUserDefaults(arrayDataSourceObj: DTOStaticArrayDataSource.sharedInstance, forKey: "arrayDataSourceOffline")
        }
        
//HANDLE CHECKING BOOKING TIME EXISTENCY

        if let arrayDataSource = data["BookingTransaction"]! as? NSArray {
            var returnExistencyResult = [String: String]()
            var existency: String!
            
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

    func getSelectedTimeDataSource(selectedDayOfWeek_ID: String, location_ID: String, machine_ID: String) {
        httpClient.getRequest(url: "Select_SelectedTime", parameter: "?day_id=\(selectedDayOfWeek_ID)&location_id=\(location_ID)&machine_id=\(machine_ID)")
    }
    
//MAKE GET REQUEST FOR MACHINES DATASOURCE
    
    func getMachinesByLocationID(locationID: String) {
        httpClient.getRequest(url: "Select_Machines", parameter: "?location_id=\(locationID)")
    }
    
//MAKE GET REQUEST FOR CHECKING EXISTENCE OF BOOKING TIME
    
    func checkBookingTime(day_ID: String, time_ID: String, chosenMachineID: String) {
        let location_ID = Functionality.findKeyFromValue(dictionary: APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()!.dropDownLocationsDataSource, value: DTOBookingInformation.sharedInstance.location)
        
        httpClient.postRequest(url: "BookingTransaction", body: "day_id=\(day_ID)&time_id=\(time_ID)&location_id=\(location_ID)&machine_id=\(chosenMachineID)")
    }
    
//INSERT NEW APPOINTMENT
    
    func insertNewAppointment() {
        httpClient.postRequest(url: "Insert_NewAppointment", body: DTOBookingInformation.sharedInstance.returnHttpBody()!)
    }
    
//CHECK VERIFICATION CODE
    
    func validateCode(appointment_ID: String) {
        httpClient.postRequest(url: "Update_Appointment", body: "appointmentId=\(appointment_ID)")
    }
    
//CANCEL APPOINTMENT
    
    func cancelAppointment(appointment_ID: String) {
        httpClient.postRequest(url: "Update_CancelAppointment", body: "appointmentId=\(appointment_ID)")
    }
    
//VALIDATE APPOINTMENT

    func validateAppointment() {
        httpClient.postRequest(url: "Update_ValidateAppointment", body: "")
    }
    
//CHECK EXISTENCE OF STATIC ARRAYS DATASOURCE ON USER DEFAULT
    
    private func staticArrayDataSourceHasExisted() -> Bool {
        let pulledDtoArrays = Functionality.pulledStaticArrayFromUserDefaults(forKey: "arrayDataSourceOffline") as? DTOStaticArrayDataSource
        
        if pulledDtoArrays != nil {
            var returnArrayDataSourceOffline = [String: DTOStaticArrayDataSource]()
            returnArrayDataSourceOffline["returnArrayDataSourceOffline"] = pulledDtoArrays
            NotificationCenter.default.post(name: Notification.Name(rawValue: "arrayDataSourceOffline"), object: nil, userInfo: returnArrayDataSourceOffline)
            return true
        } else {
            return false
        }
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
