//
//  ToastManager.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /07/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import UIKit

//CREATE TOAST

struct ToastManager {
    static func alert(view: UIView, msg: String) {
        view.makeToast(message: msg, duration: 2.5, position: HRToastPositionTop as AnyObject)
    }
    
    static func message(view: UIView, msg: String, duration: Double) {
        view.makeToast(message: msg, duration: duration, position: HRToastPositionTop as AnyObject)
    }
}
