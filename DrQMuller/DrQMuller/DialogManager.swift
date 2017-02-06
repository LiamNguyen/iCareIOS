//
//  DialogManager.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /07/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import UIKit

//CREATE DIALOG

struct DialogManager {
    //=========CREATE POP UP CONFIRM DIALOG=========
    
    static func confirmLogout(sender: UIViewController, segueIdentifier: String) {
        let confirmDialog = UIAlertController(title: "CONFIRM_LOGOUT_TITLE".localized(), message: "CONFIRM_LOGOUT_MESSAGE".localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        confirmDialog.addAction(UIAlertAction(title: "LOGOUT_EXECUTE_TITLE".localized(), style: .default, handler: { (action: UIAlertAction!) in
            sender.performSegue(withIdentifier: segueIdentifier, sender: sender)
        }))
        confirmDialog.addAction(UIAlertAction(title: "DIALOG_CANCEL_TITLE".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        sender.present(confirmDialog, animated: true, completion: nil)
    }
    
    static func errorMessage(sender: UIViewController, msg: String) {
        let confirmDialog = UIAlertController(title: "Thông báo!", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        confirmDialog.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        sender.present(confirmDialog, animated: true, completion: nil)
    }
}
