//
//  UserViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /16/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_Logout: UIButton!
    @IBOutlet weak var lbl_UserName: UILabel!
    
    func updateUI() {
        lbl_Title.text = "USER_PAGE_TITLE".localized()
    }
    
    private struct Storyboard {
        static let SEGUE_TO_LOGIN = "segue_UserToLogin"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
        lbl_UserName.text = DTOCustomerInformation.sharedInstance.customerInformationDictionary["userName"] as? String ?? ""
        lbl_UserName.layer.cornerRadius = 10
    }
    
    deinit {
        print("User VC: dead")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func logout_OnClick(_ sender: Any) {
        logout()
    }

    @IBAction func logoutIcon_OnClick(_ sender: Any) {
        logout()
    }
    
    func logout() {
        let confirmDialog = UIAlertController(title: "", message: "CONFIRM_LOGOUT_TITLE".localized(), preferredStyle: UIAlertControllerStyle.actionSheet)
        
        confirmDialog.addAction(UIAlertAction(title: "LOGOUT_EXECUTE_TITLE".localized(), style: .destructive, handler: { (action: UIAlertAction!) in
            self.clearUserToken()
            self.performSegue(withIdentifier: Storyboard.SEGUE_TO_LOGIN, sender: self)
        }))
        confirmDialog.addAction(UIAlertAction(title: "DIALOG_CANCEL_TITLE".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        self.present(confirmDialog, animated: true, completion: nil)
    }
    
    private func clearUserToken() {
        UserDefaults.standard.removeObject(forKey: "CustomerInformation")
    }
}
