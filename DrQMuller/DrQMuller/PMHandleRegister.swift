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
        if let arrayResponse = data["Insert_NewCustomer"] as? NSArray {
            for arrayItem in arrayResponse {
                let arrayDict = arrayItem as? NSDictionary

                if let token = arrayDict?["jwt"] as? String {
                    UserDefaults.standard.set(token, forKey: "CustomerInformation")
                    DTOCustomerInformation.sharedInstance.customerInformationDictionary = Functionality.jwtDictionarify(token: token)
                }
                
                if let result = arrayDict?["Status"] as? String {
                    status["status"] = result
                }
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registerResponse"), object: nil, userInfo: status)
        }
    }
}
