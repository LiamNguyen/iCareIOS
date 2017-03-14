//
//  Error.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /12/03/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

struct Error {
    struct Backend {
        static let serverError = "SERVER_ERROR"
        static let customerExisted = "USERNAME_EXISTED"
    }
    
    struct Pattern {
        static let username = "USERNAME_PATTERN_FAIL"
        static let password = "PASSWORD_PATTERN_FAIL"
        static let customerName = "CUSTOMER_NAME_PATTERN_FAIL"
        static let address = "ADDRESS_PATTERN_FAIL"
        static let email = "EMAIL_PATTERN_FAIL"
        static let phone = "PHONE_PATTERN_FAIL"
    }
    
    struct Empty {
        static let username = "USERNAME_EMPTY"
        static let password = "PASSWORD_EMPTY"
        static let confirmPassword = "CONFRIM_PASSWORD_EMPTY"
        static let customerName = "CUSTOMER_NAME_EMPTY"
        static let address = "ADDRESS_EMPTY"
        static let email = "EMAIL_EMPTY"
        static let phone = "PHONE_EMPTY"
    }
    
    struct Register {
        static let confirmPasswordUnMatch = "CONFIRM_PASSWORD_UNMATCH"
        static let registerFail = "REGISTER_FAILED"
    }
}
