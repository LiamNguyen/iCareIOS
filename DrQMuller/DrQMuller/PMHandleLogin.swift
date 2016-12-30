//
//  PMHandleLogin.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class PMHandleLogin: NSObject {
    
    var dtoAuth: DTOAuthentication!
    var httpClient: HTTPClient!
    
    override init() {
        dtoAuth = DTOAuthentication()
        httpClient = HTTPClient()
    }
    
    func handleLogin(username: String, password: String) {
        var isOk = [String: Bool]()
        dtoAuth.username = username
        dtoAuth.password = password
        
        if let postStr = dtoAuth.returnHttpBody() {
            httpClient.postRequest(url: "Select_ToAuthenticate", body: postStr) { (_ success: Bool, _ msg: String) -> () in
                if (success) {
                    isOk["status"] = true
                } else {
                    isOk["status"] = false
                }
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postRequestStatus"), object: nil, userInfo: isOk)
                }
        }
        } else {
            print("Missing body parameters")
        }
    }
}
