//
//  PMHandleReleaseTime.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /18/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class PMHandleReleaseTime: NSObject, HTTPClientDelegate {
    
    private var httpClient: HTTPClient!
    
    override init() {
        super.init()
        self.httpClient = HTTPClient()
        self.httpClient.delegate = self
    }
    
    func releaseTime(timeObj: [[String]]) {
        let jsonString = "bookingTime=\(Functionality.jsonStringify(obj: timeObj as AnyObject))"
        let location_ID = Functionality.findKeyFromValue(dictionary: APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()!.dropDownLocationsDataSource, value: DTOBookingInformation.sharedInstance.location)
        let machine_ID = Functionality.findKeyFromValue(dictionary: DTOBookingInformation.sharedInstance.machinesDataSource, value: DTOBookingInformation.sharedInstance.machine)
        
        let httpBody = "\(jsonString)&location_id=\(location_ID)&machine_id=\(machine_ID)"
        
        httpClient.postRequest(url: "Update_UnchosenTime", body: httpBody)
    }
    
    func onReceiveRequestResponse(data: AnyObject) {
        var isOk = [String: Bool]()
        if let arrayResponse = data["Update_UnchosenTime"] as? NSArray {
            for arrayItem in arrayResponse {
                let arrayDict = arrayItem as! NSDictionary
                if let result = arrayDict["Status"] as? String {
                    if result == "1" {
                        isOk["status"] = true
                    } else {
                        isOk["status"] = false
                    }
                }
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "releaseTimeResponse"), object: nil, userInfo: isOk)
        }
    }
    
}
