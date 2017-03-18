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
        
        dataToSend[Constants.JsonPropertyName.statusCode] = statusCode
        dataToSend[Constants.JsonPropertyName.errorCode] = String()
        
//        Status code 500 or 501
        if statusCode == Constants.HttpStatusCode.internalServerError || statusCode == Constants.HttpStatusCode.notImplemented {
            dataToSend[Constants.JsonPropertyName.errorCode] = Error.Backend.serverError
            postNotification(withData: dataToSend)
            
            return
        }
        
        if let response = data["Insert_NewCustomer"] as? NSArray {
            for item in response {
                let responseObj = item as? NSDictionary
                
//                Status code 400
                if statusCode == Constants.HttpStatusCode.badRequest {
                    if (responseObj?[Constants.JsonPropertyName.error] as! String).contains("username") {
                        dataToSend[Constants.JsonPropertyName.errorCode] = Error.Pattern.username
                    } else {
                        dataToSend[Constants.JsonPropertyName.errorCode] = Error.Pattern.password
                    }
                    
                    postNotification(withData: dataToSend)
                    
                    return
                }
                
//                Status code 409
                if statusCode == Constants.HttpStatusCode.conflict {
                    dataToSend[Constants.JsonPropertyName.errorCode] = Error.Backend.customerExisted
                    postNotification(withData: dataToSend)
                }
                
                if statusCode == Constants.HttpStatusCode.created {
                    if let jwt = responseObj?[Constants.JsonPropertyName.jwt] as? String {
                        UserDefaults.standard.set(jwt, forKey: Constants.UserDefaultsKey.customerInformation)
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.registerResponse), object: nil, userInfo: withData)
        }
    }
    
    
    
    
    
    
}
