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
    }
    
    struct Login {
        static let usernamePatternFail = "";
        static let passwordPatternFail = "";
    }
}
