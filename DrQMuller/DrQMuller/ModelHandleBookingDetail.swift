//
//  ModelHandleBookingDetail.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /04/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

class ModelHandleBookingDetail {
    
//MARK: PROPERTIES
    private var allTimeDataSource: Dictionary<String, String>!
    private var allTimeDisplayArray: [String]!
    private var ecoTimeDataSource: Dictionary<String, String>!
    private var ecoTimeDisplayArray: [String]!
    
    private var selectedTimeDataSourceWithID: Dictionary<String, String>!
    
    private var freeTimeDataSource: [String]!
    private var freeTimeDataSourceWithID: Dictionary<String, String>!
    
    private var daysOfWeekDisplayArray: [String]!
    
    private var staticArrayFromUserDefaults: DTOStaticArrayDataSource!
    private var isEco: Bool!
    private var exactDate: String!
    
    private var dataHasReturn = false
    
    init(isEco: Bool) {
        staticArrayFromUserDefaults = APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()
        
        allTimeDataSource = Dictionary<String, String>()
        allTimeDisplayArray = [String]()
        ecoTimeDataSource = Dictionary<String, String>()
        ecoTimeDisplayArray = [String]()
        
        selectedTimeDataSourceWithID = Dictionary<String, String>()
        
        freeTimeDataSource = [String]()
        freeTimeDataSourceWithID = Dictionary<String, String>()
        
        daysOfWeekDisplayArray = staticArrayFromUserDefaults.daysOfWeekDisplayArray
        
        self.isEco = isEco
        bindTimeDataSource(isEco: isEco)
        
        self.exactDate = DTOBookingInformation.sharedInstance.exactDate
        
//OBSERVING NOTIFICATION FROM PMHandleBooking FOR SELECTED TIME DATASOURCE
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "selectedTimeDataSource"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "selectedTimeDataSource"), object: nil, queue: nil, using: setFreeTimeDataSource)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//INITIALIZE ALLTIME AND ECOTIME DATASOURCE
    
    private func bindTimeDataSource(isEco: Bool) {
        switch isEco {
        case true:
            ecoTimeDataSource = staticArrayFromUserDefaults.ecoTimeDataSource
            ecoTimeDisplayArray = staticArrayFromUserDefaults.ecoTimeDisplayArray
        default:
            allTimeDataSource = staticArrayFromUserDefaults.allTimeDataSource
            allTimeDisplayArray = staticArrayFromUserDefaults.allTimeDisplayArray
        }
    }
    
//MAKE GET REQUEST FOR SELECTED TIME DATASOURCE TO HANDLE IN MODEL AND RETURN FREE TIME DATASOURCE
    
    func bindFreeTimeDataSource(selectedDayOfWeek_ID: String, location_ID: String, machine_ID: String) {
        APIHandleBooking.sharedInstace.getSelectedTimeDataSource(selectedDayOfWeek_ID: selectedDayOfWeek_ID, location_ID: location_ID, machine_ID: machine_ID)
        self.dataHasReturn = false
    }
    
//SET FREE TIME DATASOURCE AFTER RECEIVED RESPONSE
    
    func setFreeTimeDataSource(notification: Notification) {
        if dataHasReturn {
            return
        }
        freeTimeDataSourceWithID = Dictionary<String, String>() //CLEAR DICTIONARY
        freeTimeDataSource = [String]()                         //CLEAR ARRAY
        
        if let userInfo = notification.userInfo {
            
            let receivedSelectedTimeDataSource = userInfo["returnArrayDataSource"]! as? Dictionary<String, String>
            selectedTimeDataSourceWithID = receivedSelectedTimeDataSource
            
            switch isEco {
            case true:
                if selectedTimeDataSourceWithID.isEmpty {
                    
                    if self.exactDate == Functionality.getCurrentDate() {
                        freeTimeDataSource = Functionality.filterTimeSmallerThanCurrentTimeInArray(array: ecoTimeDisplayArray)
                        freeTimeDataSourceWithID = Functionality.filterTimeSmallerThanCurrentTimeInDictionary(dictionary: ecoTimeDataSource)
                    } else {
                        freeTimeDataSource = ecoTimeDisplayArray
                        freeTimeDataSourceWithID = ecoTimeDataSource
                    }

                } else {
                
                    for (ecoTimeID, ecoTimeItem) in ecoTimeDataSource {
                        if !selectedTimeDataSourceWithID.values.contains(ecoTimeItem) {
                            freeTimeDataSourceWithID[ecoTimeID] = ecoTimeItem
                        }
                    }
                    
                    for displayItem in ecoTimeDisplayArray {
                        if !selectedTimeDataSourceWithID.values.contains(displayItem) {
                            if self.exactDate == Functionality.getCurrentDate() {
                                if Functionality.isGreaterThanCurrentTime(time: displayItem) {
                                    freeTimeDataSource.insert(displayItem, at: freeTimeDataSource.count)
                                }
                            } else {
                                freeTimeDataSource.insert(displayItem, at: freeTimeDataSource.count)
                            }
                        }
                    }
                    
                }
            default:
                if selectedTimeDataSourceWithID.isEmpty {
                    
                    if self.exactDate == Functionality.getCurrentDate() {
                        freeTimeDataSource = Functionality.filterTimeSmallerThanCurrentTimeInArray(array: allTimeDisplayArray)
                        freeTimeDataSourceWithID = Functionality.filterTimeSmallerThanCurrentTimeInDictionary(dictionary: allTimeDataSource)
                    } else {
                        freeTimeDataSource = allTimeDisplayArray
                        freeTimeDataSourceWithID = allTimeDataSource
                    }
                    
                } else {
                    
                    for (allTimeID, allTimeItem) in allTimeDataSource {
                        if !selectedTimeDataSourceWithID.values.contains(allTimeItem) {
                            freeTimeDataSourceWithID[allTimeID] = allTimeItem
                        }
                    }
                    
                    for displayItem in allTimeDisplayArray {
                        if !selectedTimeDataSourceWithID.values.contains(displayItem) {
                            if self.exactDate == Functionality.getCurrentDate() {
                                if Functionality.isGreaterThanCurrentTime(time: displayItem) {
                                    freeTimeDataSource.insert(displayItem, at: freeTimeDataSource.count)
                                }
                            } else {
                                freeTimeDataSource.insert(displayItem, at: freeTimeDataSource.count)
                            }
                        }
                    }
                    
                }
            }
            
            var returnArrayDataSource = [String: Any]()
            returnArrayDataSource["returnArrayDataSource"] = freeTimeDataSource
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "freeTimeDataSource"), object: nil, userInfo: returnArrayDataSource)
            
            NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "selectedTimeDataSource"), object: nil)
            dataHasReturn = true
        }
    }
    
//RETURN SELECTED DAY FOR TYPE FREE
    
    func returnPreSelectedDayIDForTypeFree() -> String {
        var selectedDay_ID: Int!
        selectedDay_ID = daysOfWeekDisplayArray.index(of: DTOBookingInformation.sharedInstance.exactDayOfWeek)! + 1
        return String(selectedDay_ID)
    }
    
//MAKE GET REQUEST FOR CHECKING BOOKING TIME EXISTENCY
    
    func checkBookingTime(time: [String: String]) {
        APIHandleBooking.sharedInstace.checkBookingTime(time: time)
    }
    
//INSERT NEW APPOINTMENT
    
    func insertNewAppointment() {
        APIHandleBooking.sharedInstace.insertNewAppointment()
    }
    
//GET TIME STRING TO RETURN TIME ID
    
    func returnTimeID(chosenTime: String) -> String {
        var time_ID = ""
        
        switch isEco {
        case true:
            print("Eco - Model : chosenTime \(chosenTime)")
            for item in ecoTimeDataSource {
                if item.value == chosenTime {
                    time_ID = item.key
                }
            }
        default:
            print("All - Model: chosenTime \(chosenTime)")
            for item in allTimeDataSource {
                if item.value == chosenTime {
                    time_ID = item.key
                }
            }
        }
        print(time_ID)
        return time_ID
    }
    
//RELEASE TIME IN TEMPORARY BOOK TBL
    
    func releaseTime(time: [[String: String]]) {
        APIHandleReleaseTime.sharedInstace.releaseTime(time: time)
    }
    
//BIND MACHINES DATASOURCE
    
    func bindMachinesDataSource() {
        let dictionary_Location = (APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()?.dropDownLocationsDataSource)!
        let locationID = Functionality.findKeyFromValue(dictionary: dictionary_Location, value: DTOBookingInformation.sharedInstance.location)
        
        APIHandleBooking.sharedInstace.getMachinesByLocationID(locationID: locationID)
    }
    
}
