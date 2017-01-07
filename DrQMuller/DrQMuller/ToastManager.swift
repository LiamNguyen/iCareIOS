//
//  ToastManager.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /01/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import UIKit

class ToastManager {
    
    class var sharedInstance: ToastManager {
        struct Singleton {
            static let instance = ToastManager()
        }
        return Singleton.instance
    }
    
    func alert(view: UIView, msg: String) {
        view.makeToast(message: msg, duration: 2.5, position: HRToastPositionTop as AnyObject)
    }
    
    func message(view: UIView, msg: String, duration: Double) {
        view.makeToast(message: msg, duration: duration, position: HRToastPositionTop as AnyObject)
    }
    
//    func alertError(view: UIView) -> <#return type#> {
//        <#function body#>
//    }
}
