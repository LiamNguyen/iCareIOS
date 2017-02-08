//
//  PMHandleRegister.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /08/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class PMHandleRegister: NSObject, HTTPClientDelegate {
    
    var httpClient: HTTPClient!
    
    override init() {
        super.init()
        httpClient = HTTPClient()
        httpClient.delegate = self
    }
    
    func handleRegister(username: String, password: String) {
        DTOAuthentication.sharedInstance.username = username
        DTOAuthentication.sharedInstance.password = password
        
        if let postStr = DTOAuthentication.sharedInstance.returnHttpBody() {
            httpClient.postRequest(url: "Insert_NewCustomer", body: postStr)
        } else {
            print("Missing body parameters")
        }
    }
    
    func onReceiveRequestResponse(data: AnyObject) {
        var status = [String: String]()
        var customer_ID: String?
        if let arrayResponse = data["Insert_NewCustomer"] as? NSArray {
            for arrayItem in arrayResponse {
                let arrayDict = arrayItem as? NSDictionary
                if let cus_id = arrayDict?["Customer_ID"] as? String {
                    customer_ID = cus_id
                }
                
                if let result = arrayDict?["Status"] as? String {
                    status["status"] = result
                    
                    if result == "1" {
                        status["status"] = result
                        if let cus_id = customer_ID {
                            UserDefaults.standard.set(cus_id, forKey: "Customer_ID")
                            print(UserDefaults.standard.string(forKey: "Customer_ID") ?? "Customer_ID not available")
                            DTOBookingInformation.sharedInstance.customerID = cus_id
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registerResponse"), object: nil, userInfo: status)
        }
    }
}
