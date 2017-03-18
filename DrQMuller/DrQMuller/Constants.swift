//
//  Constants.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /18/03/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

struct Constants {
    struct JsonPropertyName {
        static let errorCode = "errorCode"
        static let error = "error"
        static let statusCode = "statusCode"
        
        static let messageCode = "messageCode"
        
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
    
    
    struct HttpStatusCode {
        
        //    2XX Sucess
        
        static let success = 200
        static let created = 201
        static let accepted = 202
        static let noContent = 204
        
        //    4XX Client Error
        
        static let badRequest = 400
        static let unauthorized = 401
        static let forbidden = 403
        static let notFound = 404
        static let methodNotAllowed = 405
        static let notAcceptable = 406
        static let conflict = 409
        
        //    5XX Server Error
        
        static let internalServerError = 500
        static let notImplemented = 501
        static let badGateway = 502
        static let gatewayTimeout = 504
        
    }
    
    struct UserDefaultsKey {
        static let language = "lang"
        static let customerInformation = "CustomerInformation"
    }
    
    struct NotificationName {
        static let loginResponse = "loginResponse"
        static let registerResponse = "registerResponse"
        static let basicInfoResponse = "basicInfoResponse"
        static let necessaryInfoResponse = "necessaryInfoResponse"
        static let importantInfoResponse = "importantInfoResponse"
        static let notifyBookingResponse = "notifyBookingResponse"
    }
}
