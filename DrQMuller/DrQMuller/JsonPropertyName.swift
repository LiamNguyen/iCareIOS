//
//  JsonPropertyName.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /15/03/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

struct JsonPropertyName {
    static let errorCode = "errorCode"
    static let error = "error"
    static let statusCode = "statusCode"
 
    static let userId = "userId"
    static let userName = "userName"
    static let userAddress = "userAddress"
    static let userDob = "userDob"
    static let userGender = "userGender"
    static let userPhone = "userPhone"
    static let userEmail = "userEmail"
    static let sessionToken = "sessionToken"
    static let jwt = "jwt"
    static let uiFillStep = "step"
    struct UiFillStep {
        static let none = "none"
        static let basic = "basic"
        static let necessary = "necessary"
        static let important = "important"
    }
}
