//
//  ModelHandleLogin.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /27/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation
import UIKit

class ModelHandleLogin {
    
    func handleLogin(username: String, password: String) {
        APIHandleLogin.sharedInstace.handleLogin(username: username, password: password)
    }
}
