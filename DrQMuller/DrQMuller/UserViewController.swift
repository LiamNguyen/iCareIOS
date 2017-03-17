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
    @IBOutlet weak var btn_ChangeLanguage: UIButton!
    
    private var networkViewManager: NetworkViewManager!
    private weak var networkCheckInRealTime: Timer?
    
    func updateUI() {
        lbl_Title.text = "USER_PAGE_TITLE".localized()
        btn_ChangeLanguage.setTitle("BTN_CHOOSE_LANGUAGE".localized(), for: .normal)
    }
    
    private struct Storyboard {
        static let SEGUE_TO_LOGIN = "segue_UserToLogin"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        wiredUpNetworkChecking()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.networkViewManager = NetworkViewManager()
        
        updateUI()
        
        nameLblCustomStyle()
        
        changeLanguageBtnCustomStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.networkCheckInRealTime?.invalidate()
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
    
    @IBAction func btn_ChangeLanguage_OnClick(_ sender: Any) {
        handleLanguageChange()
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
    
    private func nameLblCustomStyle() {
        lbl_UserName.text = DTOCustomerInformation.sharedInstance.customerInformationDictionary[JsonPropertyName.userName] as? String ?? ""
        lbl_UserName.layer.cornerRadius = 10

    }
    
    private func changeLanguageBtnCustomStyle() {
        let radius = min(btn_ChangeLanguage.frame.size.width, btn_ChangeLanguage.frame.size.height) / 2.0
        btn_ChangeLanguage.layer.cornerRadius = radius
    }
    
    private func handleLanguageChange() {
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.language) == "vi" {
            UserDefaults.standard.set("en", forKey: UserDefaultKeys.language)
        } else {
            UserDefaults.standard.set("vi", forKey: UserDefaultKeys.language)
        }
        
        updateUI()
    }
    
    private func clearUserToken() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.customerInformation)
    }
    
    private func wiredUpNetworkChecking() {
        let tupleDetectNetworkReachabilityResult = Reachability.detectNetworkReachabilityObserver(parentView: self.view)
        networkViewManager = tupleDetectNetworkReachabilityResult.network
        networkCheckInRealTime = tupleDetectNetworkReachabilityResult.timer
    }
}
