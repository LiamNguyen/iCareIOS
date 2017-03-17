//
//  DTOBookingTime.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /15/03/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

struct DTOBookingTime {
    private let dayId: String!
    private let timeId: String!
    private let machineId: String!
    
    init(dayId: String, timeId: String, machineId: String) {
        self.dayId = dayId
        self.timeId = timeId
        self.machineId = machineId
    }
    
    func getDictionary() -> [String: String] {
        
        if let dayId = self.dayId, let timeId = self.timeId, let machineId = self.machineId {
            return [
                "dayId": dayId,
                "timeId": timeId,
                "machineId": machineId
            ]
        } else {
            return [String: String]()
        }
    }
}
