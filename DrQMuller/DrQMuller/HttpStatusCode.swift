//
//  HttpStatusCode.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /12/03/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

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
