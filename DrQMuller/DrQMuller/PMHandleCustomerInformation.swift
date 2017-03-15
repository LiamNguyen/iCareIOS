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
        let sessionToken = DTOCustomerInformation.sharedInstance.customerInformationDictionary[JsonPropertyName.sessionToken] as! String
        
        switch step {
        case JsonPropertyName.UiFillStep.basic:
            httpClient.putRequest(url: "Update_BasicInfo", body: httpBody, sessionToken: sessionToken)
        case JsonPropertyName.UiFillStep.necessary:
            httpClient.putRequest(url: "Update_NecessaryInfo", body: httpBody, sessionToken: sessionToken)
        case JsonPropertyName.UiFillStep.important:
            httpClient.putRequest(url: "Update_ImportantInfo", body: httpBody, sessionToken: sessionToken)
        default:
            return
        }
    }
    
    func onReceiveRequestResponse(data: AnyObject) {}
    
    func onReceivePostRequestResponse(data: AnyObject, statusCode: Int) {
        handleReponseFromServer(responseHeader: "Update_BasicInfo", notificationName: UserDefaultKeys.basicInfoResponse, data: data, statusCode: statusCode)
        handleReponseFromServer(responseHeader: "Update_NecessaryInfo", notificationName: UserDefaultKeys.necessaryInfoResponse, data: data, statusCode: statusCode)
        handleReponseFromServer(responseHeader: "Update_ImportantInfo", notificationName: UserDefaultKeys.importantInfoResponse, data: data, statusCode: statusCode)
    }
    
    private func handleReponseFromServer(responseHeader: String, notificationName: String, data: AnyObject, statusCode: Int) {
        var dataToSend = [String: Any]()
        
        dataToSend[JsonPropertyName.statusCode] = statusCode
        dataToSend[JsonPropertyName.errorCode] = String()
        
        //        Status code 500 or 501
        if statusCode == HttpStatusCode.internalServerError || statusCode == HttpStatusCode.notImplemented {
            dataToSend[JsonPropertyName.errorCode] = Error.Backend.serverError
            postNotification(withData: dataToSend, notificationName: notificationName)
            
            return
        }
        
        if let response = data[responseHeader] as? NSArray {
            for item in response {
                let responseObj = item as? NSDictionary
                
                //                Status code 400
                if statusCode == HttpStatusCode.badRequest {
                    let serverErrorResponse = responseObj?[JsonPropertyName.error] as! String
                    
                    if serverErrorResponse.contains("customerName") {
                        dataToSend[JsonPropertyName.errorCode] = Error.Pattern.customerName
                    } else if serverErrorResponse.contains("address") {
                        dataToSend[JsonPropertyName.errorCode] = Error.Pattern.address
                    } else if serverErrorResponse.contains("phone") {
                        dataToSend[JsonPropertyName.errorCode] = Error.Pattern.phone
                    } else if serverErrorResponse.contains("email") {
                        dataToSend[JsonPropertyName.errorCode] = Error.Pattern.email
                    }
                    postNotification(withData: dataToSend, notificationName: notificationName)
                    
                    return
                }
                
                //                Status code 401
                if statusCode == HttpStatusCode.unauthorized {
                    dataToSend[JsonPropertyName.errorCode] = responseObj?[JsonPropertyName.errorCode] as? String
                    postNotification(withData: dataToSend, notificationName: notificationName)
                    
                    return
                }
                
                if statusCode == HttpStatusCode.success {
                    if let jwt = responseObj?[JsonPropertyName.jwt] as? String {
                        UserDefaults.standard.set(jwt, forKey: UserDefaultKeys.customerInformation)
                        DTOCustomerInformation.sharedInstance.customerInformationDictionary = Functionality.jwtDictionarify(token: jwt)
                        postNotification(withData: dataToSend, notificationName: notificationName)
                        
                    } else {
                        print("Error while getting JWT")
                    }
                }
            }
        }
    }
    
    private func postNotification(withData: [String: Any], notificationName: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil, userInfo: withData)
        }
    }
}
