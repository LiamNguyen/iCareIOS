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
    
    private var viewController: UIViewController!
    private var message: Messages!
    
    init() {
        message = Messages()
//OBSERVE FOR NOTIFICATION FROM PMHandleBooking
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "postRequestStatus"), object: nil, queue: nil, using: handleView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleLogin(username: String, password: String, viewController: UIViewController) {
        self.viewController = viewController
        APIHandleLogin.sharedInstace.handleLogin(username: username, password: password)
    }
    
//=========HANDLE LOGIN PROCEDURE=========
    
    func handleView(notification: Notification) {
        if let userInfo = notification.userInfo {
            let isOk = userInfo["status"] as? Bool
            if isOk! {
                print("Login Success")
                viewController.performSegue(withIdentifier: "segue_LoginToBookingTabViewController", sender: viewController)
            } else {
                print("Login Failed")
                message.errorMessage(sender: viewController, msg: "Tên đăng nhập và mật khẩu không hợp lệ")
            }
        }
    }
}
