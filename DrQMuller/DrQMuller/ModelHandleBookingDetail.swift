//
//  ModelHandleBookingDetail.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /04/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

class ModelHandleBookingDetail {
    private var allTimeDataSource: [String]!
    private var ecoTimeDataSource: [String]!
    private var selectedTimeDataSource: [String]!
    private var freeTimeDataSource: [String]!
    
    private var staticArrayFromUserDefaults: DTOStaticArrayDataSource!
    private var isEco: Bool!
    
    init(isEco: Bool) {
        staticArrayFromUserDefaults = APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()
        
        allTimeDataSource = [String]()
        ecoTimeDataSource = [String]()
        selectedTimeDataSource = [String]()
        freeTimeDataSource = [String]()
        
        self.isEco = isEco
        bindTimeDataSource(isEco: isEco)
    }
    
    private func bindTimeDataSource(isEco: Bool) {
        switch isEco {
        case true:
            for item in staticArrayFromUserDefaults.ecoTimeDataSource {
                ecoTimeDataSource.append(item.value)
            }
        default:
            for item in staticArrayFromUserDefaults.allTimeDataSource {
                allTimeDataSource.append(item.value)
            }
        }
    }
    
    func bindFreeTimeDataSource(selectedDayOfWeek_ID: String) -> [String] {
        APIHandleBooking.sharedInstace.getSelectedTimeDataSource(selectedDayOfWeek_ID: selectedDayOfWeek_ID)
        setFreeTimeDataSource(selectedDayOfWeek_ID: selectedDayOfWeek_ID)
        return freeTimeDataSource
    }
    
    func setFreeTimeDataSource(selectedDayOfWeek_ID: String) {
        switch isEco {
        case true:
            for allTimeItem in allTimeDataSource {
                for selectedTimeItem in selectedTimeDataSource {
                    if selectedTimeItem != allTimeItem {
                        freeTimeDataSource.append(selectedTimeItem)
                    }
                }
            }
        default:
            for ecoTimeItem in ecoTimeDataSource {
                for selectedTimeItem in selectedTimeDataSource {
                    if selectedTimeItem != ecoTimeItem {
                        freeTimeDataSource.append(selectedTimeItem)
                    }
                }
            }
        }
    }
}
