//
//  APIHandleRegister.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /08/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class APIHandleRegister: NSObject {

    private var persistencyManager: PMHandleRegister!
    
    class var sharedInstace: APIHandleRegister {
        struct Singleton {
            static let instance = APIHandleRegister()
        }
        return Singleton.instance
    }
    
    override init() {
        self.persistencyManager = PMHandleRegister()
    }
    
    func handleRegister(username: String, password: String) {
        self.persistencyManager.handleRegister(username: username, password: password)
    }
}
