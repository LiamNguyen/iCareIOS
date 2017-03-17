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
    
    func releaseTime(time: [[String: String]]) {
        let requestBody = DTOBookingInformation.sharedInstance.getRequestBodyForReleasingTime(time: time)
        let sessionToken = DTOCustomerInformation.sharedInstance.customerInformationDictionary[JsonPropertyName.sessionToken] as! String
        
        httpClient.postRequest(url: "Update_ReleaseTime", body: requestBody, sessionToken: sessionToken)
    }
    
    func onReceiveRequestResponse(data: AnyObject) {
        var isOk = [String: Bool]()
        if let arrayResponse = data["Update_ReleaseTime"] as? NSArray {
            for arrayItem in arrayResponse {
                let arrayDict = arrayItem as! NSDictionary
                if let result = arrayDict["status"] as? String {
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
    
    func onReceivePostRequestResponse(data: AnyObject, statusCode: Int) {
        
    }
    
    
}
