//
//  PMHandleGetCurrentVersion.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /19/03/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

class PMHandleGetCurrentVersion: NSObject, HTTPClientDelegate {
    var httpClient: HTTPClient!
    
    override init() {
        super.init()
        httpClient = HTTPClient()
        httpClient.delegate = self
    }

    func onReceiveRequestResponse(data: AnyObject) {
        if let response = data["Select_LatestBuild"] as? NSArray {
            
            var dataToSend = [String: Any]()
            
            dataToSend[Constants.JsonPropertyName.errorCode] = String()
            
            for item in response {
                let responseObj = item as? NSDictionary
                
                if let build = responseObj?[Constants.JsonPropertyName.build] as? Int {
                    dataToSend[Constants.JsonPropertyName.build] = build
                    postNotification(withData: dataToSend)
                } else {
                    print("Error while getting build")
                }
            }
        }
    }
    
    func onReceivePostRequestResponse(data: AnyObject, statusCode: Int) {}
    
    func checkVersion() {
        httpClient.getRequest(url: "Select_LatestBuild", parameter: "ios")
    }
    
    private func postNotification(withData: [String: Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.versionResponse), object: nil, userInfo: withData)
        }
    }
}
