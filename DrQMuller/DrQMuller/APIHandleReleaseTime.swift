//
//  APIHandleReleaseTime.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /19/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class APIHandleReleaseTime: NSObject {
    
    private var persistencyManager: PMHandleReleaseTime!
    
    class var sharedInstace: APIHandleReleaseTime {
        struct Singleton {
            static let instance = APIHandleReleaseTime()
        }
        return Singleton.instance
    }
    
    override init() {
        self.persistencyManager = PMHandleReleaseTime()
    }
    
    func releaseTime(timeObj: [[String]]) {
        self.persistencyManager.releaseTime(timeObj: timeObj)
    }
}
