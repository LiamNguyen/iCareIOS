//
//  DTOAuthentication.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation

class DTOAuthentication: NSObject {
    
    class var sharedInstance: DTOAuthentication {
        struct Singleton {
            static let instance = DTOAuthentication()
        }
        return Singleton.instance
    }
    
    private var _username: String!
    var username: String {
        get {
            return _username
        }
        
        set (newVal) {
            _username = newVal
        }
    }
    
    private var _password: String!
    var password: String {
        get {
            return _password
        }
        
        set (newVal) {
            _password = newVal
        }
    }
    
    func returnHttpBody() -> String? {
        if let username = _username, let password = _password {
            let json = ["username": username, "password": password]
            print("Request Body: \(Functionality.jsonStringify(obj: json as AnyObject))")
            
            return (Functionality.jsonStringify(obj: json as AnyObject))
        } else {
            return nil
        }
    }
}
