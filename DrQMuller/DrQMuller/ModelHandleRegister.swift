//
//  ModelHandleRegister.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /08/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class ModelHandleRegister: NSObject {
    
    func handleRegister(username: String, password: String) {
        APIHandleRegister.sharedInstace.handleRegister(username: username, password: password)
    }
}
