//
//  APIHandleLogin.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class APIHandleLogin: NSObject {
    
    private var persistencyManager: PMHandleLogin!
    
    class var sharedInstace: APIHandleLogin {
        struct Singleton {
            static let instance = APIHandleLogin()
        }
        return Singleton.instance
    }
    
    override init() {
        self.persistencyManager = PMHandleLogin()
    }
    
    func handleLogin(username: String, password: String) {
        self.persistencyManager.handleLogin(username: username, password: password)
    }
}
