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
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "selectedTimeDataSource"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "selectedTimeDataSource"), object: nil, queue: nil, using: setFreeTimeDataSource)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
    
    func bindFreeTimeDataSource(selectedDayOfWeek_ID: String) {
        APIHandleBooking.sharedInstace.getSelectedTimeDataSource(selectedDayOfWeek_ID: selectedDayOfWeek_ID)
    }
    
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
                    freeTimeDataSource = ecoTimeDisplayArray
                    freeTimeDataSourceWithID = ecoTimeDataSource
                } else {
                
                    for (ecoTimeID, ecoTimeItem) in ecoTimeDataSource {
                        if !selectedTimeDataSourceWithID.values.contains(ecoTimeItem) {
                            freeTimeDataSourceWithID[ecoTimeID] = ecoTimeItem
                        }
                    }
                    
                    for displayItem in ecoTimeDisplayArray {
                        if !selectedTimeDataSourceWithID.values.contains(displayItem) {
                            freeTimeDataSource.insert(displayItem, at: freeTimeDataSource.count)
                        }
                    }
                    
                }
            default:
                if selectedTimeDataSourceWithID.isEmpty {
                    
                    freeTimeDataSource = allTimeDisplayArray
                    freeTimeDataSourceWithID = allTimeDataSource
                    
                } else {
                    
                    for (allTimeID, allTimeItem) in allTimeDataSource {
                        if !selectedTimeDataSourceWithID.values.contains(allTimeItem) {
                            freeTimeDataSourceWithID[allTimeID] = allTimeItem
                        }
                    }
                    
                    for displayItem in allTimeDisplayArray {
                        if !selectedTimeDataSourceWithID.values.contains(displayItem) {
                            freeTimeDataSource.insert(displayItem, at: freeTimeDataSource.count)
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
    
    func returnPreSelectedDayIDForTypeFree() -> Int {
        let selectedDayID: Int!
        selectedDayID = daysOfWeekDisplayArray.index(of: DTOBookingInformation.sharedInstance.exactDate)! + 1
        return selectedDayID
    }
    
    
}
