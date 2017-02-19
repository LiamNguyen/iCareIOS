//
//  PMHandleCustomerInformation.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /09/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class PMHandleCustomerInformation: NSObject, HTTPClientDelegate {

    var httpClient: HTTPClient!
    
    override init() {
        super.init()
        httpClient = HTTPClient()
        httpClient.delegate = self
    }
    
    func handleCustomerInformation(step: String, httpBody: String) {
        switch step {
        case "basic":
            httpClient.postRequest(url: "Update_BasicInfo", body: httpBody)
        case "necessary":
            httpClient.postRequest(url: "Update_NecessaryInfo", body: httpBody)
        case "important":
            httpClient.postRequest(url: "Update_ImportantInfo", body: httpBody)
        default:
            return
        }
    }
    
    func onReceiveRequestResponse(data: AnyObject) {
        handleReponseFromServer(responseHeader: "Update_BasicInfo", notificationName: "basicInfoResponse", data: data)
        handleReponseFromServer(responseHeader: "Update_NecessaryInfo", notificationName: "necessaryInfoResponse", data: data)
        handleReponseFromServer(responseHeader: "Update_ImportantInfo", notificationName: "importantInfoResponse", data: data)
    }
    
    private func handleReponseFromServer(responseHeader: String, notificationName: String, data: AnyObject) {
        if let arrayResponse = data[responseHeader] as? NSArray {
            var isSuccess = [String: Bool]()
            
            for arrayItem in arrayResponse {
                let arrayDict = arrayItem as? NSDictionary
                if let result = arrayDict?["Status"] as? String {
                    if result == "1" {
                        isSuccess["status"] = true
                    } else {
                        isSuccess["status"] = false
                    }
                }
                
                if let token = arrayDict?["jwt"] as? String {
                    UserDefaults.standard.set(token, forKey: "CustomerInformation")
                    DTOCustomerInformation.sharedInstance.customerInformationDictionary = Functionality.jwtDictionarify(token: token)
                }
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationName), object: nil, userInfo: isSuccess)
        }
    }
}
