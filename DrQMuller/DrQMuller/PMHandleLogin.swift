//
//  PMHandleLogin.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class PMHandleLogin: NSObject, HTTPClientDelegate {
    
    var httpClient: HTTPClient!
    
    override init() {
        super.init()
        httpClient = HTTPClient()
        httpClient.delegate = self
    }
    
    func handleLogin(username: String, password: String) {
        DTOAuthentication.sharedInstance.username = username
        DTOAuthentication.sharedInstance.password = password
        
        if let postStr = DTOAuthentication.sharedInstance.returnHttpBody() {
            httpClient.postRequest(url: "Select_ToAuthenticate", body: postStr)
        } else {
            print("Missing body parameters")
        }
    }
    
    func onReceiveRequestResponse(data: AnyObject) {}
    
    func onReceivePostRequestResponse(data: AnyObject, statusCode: Int) {
        if let response = data["Select_ToAuthenticate"] as? NSArray {

            var dataToSend = [String: Any]()
            
            dataToSend[Constants.JsonPropertyName.statusCode] = statusCode
            dataToSend[Constants.JsonPropertyName.errorCode] = String()
            
    //        Status code 500 or 501
            if statusCode == Constants.HttpStatusCode.internalServerError || statusCode == Constants.HttpStatusCode.notImplemented {
                dataToSend[Constants.JsonPropertyName.errorCode] = Error.Backend.serverError
                postNotification(withData: dataToSend)

                return
            }
        
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
                
//                Status code 401
                if statusCode == Constants.HttpStatusCode.unauthorized {
                    dataToSend[Constants.JsonPropertyName.errorCode] = responseObj?[Constants.JsonPropertyName.errorCode] as? String
                    postNotification(withData: dataToSend)

                    return
                }
                
                if statusCode == Constants.HttpStatusCode.success {
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.loginResponse), object: nil, userInfo: withData)
        }
    }
    
}
