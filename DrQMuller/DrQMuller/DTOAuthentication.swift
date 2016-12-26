//
//  DTOAuthentication.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation

public class DTOAuthentication {
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
    
    func returnHttpBody() -> String {
        return "username\(_username)&password\(_password)"
    }
}
