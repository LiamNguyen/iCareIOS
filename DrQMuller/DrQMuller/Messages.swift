//
//  Messages.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /27/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation
import UIKit

class Messages {
    //=========CREATE POP UP CONFIRM DIALOG=========
    
    func confirmDialog(sender: UIViewController) {
        let confirmDialog = UIAlertController(title: "Quý khách sẽ đăng thoát?", message: "Những thông tin chưa được xác nhận sẽ không được lưu trữ.", preferredStyle: UIAlertControllerStyle.alert)
        confirmDialog.addAction(UIAlertAction(title: "Đăng thoát", style: .default, handler: { (action: UIAlertAction!) in
            sender.performSegue(withIdentifier: "segue_CustomerInformationToLogin", sender: sender)
        }))
        confirmDialog.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        sender.present(confirmDialog, animated: true, completion: nil)
    }
    
    func errorMessage(sender: UIViewController, msg: String) {
        let confirmDialog = UIAlertController(title: "Thông báo!", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        confirmDialog.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        sender.present(confirmDialog, animated: true, completion: nil)
    }
}
