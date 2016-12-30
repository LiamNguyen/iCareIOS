//
//  DTOAuthentication.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation

public class DTOAuthentication: NSObject {
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
    
    func returnHttpBody() -> String! {
//        if _username.isEmpty || _username == nil || _password.isEmpty || _password == nil {
//            return ""
//        }
        if let username = _username, let password = _password {
            return "username=\(username)&password=\(password)"
        } else {
            return nil
        }
    }
}
