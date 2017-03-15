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
    
    func onReceiveRequestResponse(data: AnyObject) {}
    
    func onReceivePostRequestResponse(data: AnyObject, statusCode: Int) {
        var dataToSend = [String: Any]()
        
        dataToSend[JsonPropertyName.statusCode] = statusCode
        dataToSend[JsonPropertyName.errorCode] = String()
        
//        Status code 500 or 501
        if statusCode == HttpStatusCode.internalServerError || statusCode == HttpStatusCode.notImplemented {
            dataToSend[JsonPropertyName.errorCode] = Error.Backend.serverError
            postNotification(withData: dataToSend)
            
            return
        }
        
        if let response = data["Insert_NewCustomer"] as? NSArray {
            for item in response {
                let responseObj = item as? NSDictionary
                
//                Status code 400
                if statusCode == HttpStatusCode.badRequest {
                    if (responseObj?[JsonPropertyName.error] as! String).contains("username") {
                        dataToSend[JsonPropertyName.errorCode] = Error.Pattern.username
                    } else {
                        dataToSend[JsonPropertyName.errorCode] = Error.Pattern.password
                    }
                    
                    postNotification(withData: dataToSend)
                    
                    return
                }
                
//                Status code 409
                if statusCode == HttpStatusCode.conflict {
                    dataToSend[JsonPropertyName.errorCode] = Error.Backend.customerExisted
                    postNotification(withData: dataToSend)
                }
                
                if statusCode == HttpStatusCode.created {
                    if let jwt = responseObj?[JsonPropertyName.jwt] as? String {
                        UserDefaults.standard.set(jwt, forKey: UserDefaultKeys.customerInformation)
                        DTOCustomerInformation.sharedInstance.customerInformationDictionary = Functionality.jwtDictionarify(token: jwt)
                        postNotification(withData: dataToSend)
                    
                    } else {
                        print("Error while getting JWT")
                    }
                }
            }
        }
    }
    
    private func postNotification(withData: [String: Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserDefaultKeys.registerResponse), object: nil, userInfo: withData)
        }
    }
    
    
    
    
    
    
}
