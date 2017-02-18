//
//  ThirdTabCustomerInformationViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /20/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class ThirdTabCustomerInformationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var constraint_FirstTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraint_SecondTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraint_ThirdTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var btn_FirstTab: UIButton!
    @IBOutlet private weak var btn_SecondTab: UIButton!
    @IBOutlet private weak var btn_ThirdTab: UIButton!
    @IBOutlet private weak var view_FirstTabContainer: UIView!
    @IBOutlet private weak var view_SecondTabContainer: UIView!
    @IBOutlet private weak var view_ThirdTabContainer: UIView!
    @IBOutlet private weak var view_TopView: UIView!
    @IBOutlet private weak var txt_Email: UITextField!
    @IBOutlet private weak var txt_Phone: UITextField!
    @IBOutlet private weak var lbl_Title: UILabel!
    @IBOutlet private weak var btn_Next: UIButton!
    
    private var customerInformationController = CustomStyleCustomerInformation()
    private var networkViewManager = NetworkViewManager()
    private var networkCheckInRealTime: Timer!
    
    private var modelHandleCustomerInformation = ModelHandleCustomerInformation()
    
    private func updateUI() {
        lbl_Title.text = "CUSTOMER_INFO_PAGE_TITLE".localized()
        btn_FirstTab.setTitle("FIRST_TAB_BTN_TITLE".localized(), for: .normal)
        btn_SecondTab.setTitle("SECOND_TAB_BTN_TITLE".localized(), for: .normal)
        btn_ThirdTab.setTitle("THIRD_TAB_BTN_TITLE".localized(), for: .normal)
        
        txt_Email.placeholder = "EMAIL_PLACEHOLDER".localized()
        txt_Phone.placeholder = "PHONE_PLACEHOLDER".localized()
        btn_Next.setTitle("BTN_NEXT_TITLE".localized(), for: .normal)
    }
    
    private struct StoryBoard {
        static let SEGUE_TO_LOGIN = "segue_CustomerInformationThirdTabToLogin"
        static let SEGUE_TO_FIRST_TAB = "segue_CustomerInformationThirdTabToFirstTab"
        static let SEGUE_TO_SECOND_TAB = "segue_CustomerInformationThirdTabToSecondTab"
        static let SEGUE_TO_BOOKING_VC = "segue_CustomerInformationToBookingTabViewController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        
        //=========FILL CHOSEN INFORMATION=========
        
        fillInformation()
        
        let tupleDetectNetworkReachabilityResult = Reachability.detectNetworkReachabilityObserver(parentView: self.view)
        networkViewManager = tupleDetectNetworkReachabilityResult.network
        networkCheckInRealTime = tupleDetectNetworkReachabilityResult.timer
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        informMessage(message: "EMAIL_PHONE_ATTENTION_MESSAGE".localized())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//=========ENABLE TAB HEADERS=========
        
        self.txt_Email.delegate = self
        self.txt_Phone.delegate = self
        
//=========ENABLE TAB HEADERS=========
        
        customerInformationController.enableTab(firstTab: btn_FirstTab, secondTab: btn_SecondTab, thirdTab: btn_ThirdTab)
        
//=========UPDATE STYLE OF TAB HEADERS FOR DIFFERENT PHONE SIZE=========
        
        customerInformationController.tabHeadersStyleUpdate(FirstTabConstraint: constraint_FirstTabWidth,SecondTabConstraint: constraint_SecondTabWidth, ThirdTabConstraint: constraint_ThirdTabWidth)
        
//=========UPDATE ORIGIN OF TAB HEADERS FOR DIFFERENT PHONE SIZE=========
        
        customerInformationController.tabHeadersOriginUpdate(view_FirstTabContainer: view_FirstTabContainer,view_SecondTabContainer: view_SecondTabContainer, view_ThirdTabContainer: view_ThirdTabContainer)
        
//=========APPLY TAB HEADERS UNDERLINE=========
        
        customerInformationController.translateTabHeaderUnderline(view: self.view, view_TabContainer: view_ThirdTabContainer)
        
//=========TEXTFIELD ONLOAD AUTOFOCUS=========
        
        txt_Email.becomeFirstResponder()
        
//=========OBSERVING NOTIFICATION FROM PMHandleCustomerInformation=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "importantInfoResponse"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "importantInfoResponse"), object: nil, queue: nil) { (Notification) in
            if let userInfo = Notification.userInfo {
                if let isSuccess = userInfo["status"] as? Bool {
                    if isSuccess {
                        DispatchQueue.global(qos: .userInteractive).async {
                            let customerInformation = DTOCustomerInformation.sharedInstance.customerInformationDictionary
                            
                            if customerInformation["step"] as! String == "necessary" {
                                DTOCustomerInformation.sharedInstance.customerInformationDictionary["step"] = "important"
                            }
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: StoryBoard.SEGUE_TO_BOOKING_VC, sender: self)
                            }
                        }
                    } else {
                        ToastManager.alert(view: self.view_TopView, msg: "UPDATE_FAIL_MESSAGE".localized())
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        networkCheckInRealTime.invalidate()
    }
    
//=========BUTTON NEXT ONCLICK=========
    
    @IBAction func btn_Next_OnClick(_ sender: Any) {
        if !frontValidationPassed() {
            return
        }
        let step = "important"
        
        DTOCustomerInformation.sharedInstance.customerInformationDictionary["userEmail"] = txt_Email.text
        DTOCustomerInformation.sharedInstance.customerInformationDictionary["userPhone"] = txt_Phone.text
        
        modelHandleCustomerInformation.handleCustomerInformation(step: step, httpBody: DTOCustomerInformation.sharedInstance.returnHttpBody(step: step)!)
    }
    
    @IBAction func btn_Back_OnClick(_ sender: Any) {
        
//=========POP UP CONFIRM DIALOG=========
        
        hideKeyBoard()
        DialogManager.confirmLogout(sender: self, segueIdentifier: StoryBoard.SEGUE_TO_LOGIN)
        
    }
    
//=========TRANSITION TO FIRST INFO PAGE=========
    
    @IBAction func btn_FirstTab_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: StoryBoard.SEGUE_TO_FIRST_TAB, sender: self)
    }
    
//=========TRANSITION TO SECOND INFO PAGE=========
    
    @IBAction func btn_SecondTab_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: StoryBoard.SEGUE_TO_SECOND_TAB, sender: self)
    }
    
//=========TOUCH OUTSIDE CLOSE KEYBOARD=========
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//=========PRESS RETURN CLOSE KEYBOARD=========
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txt_Email {
            txt_Phone.becomeFirstResponder()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == StoryBoard.SEGUE_TO_BOOKING_VC){
            if let tabVC = segue.destination as? UITabBarController{
                Functionality.tabBarItemsLocalized(language: UserDefaults.standard.string(forKey: "lang") ?? "vi", tabVC: tabVC)
                tabVC.selectedIndex = 1
                tabVC.tabBar.items?[0].isEnabled = false
            }
        }
    }
    
    func frontValidationPassed() -> Bool {
        if let email = txt_Email.text, let phone = txt_Phone.text {
            if email.isEmpty {
                UIFunctionality.addShakyAnimation(elementToBeShake: txt_Email)
                ToastManager.alert(view: view_TopView, msg: "EMAIL_EMPTY_MESSAGE".localized())
                return false
            }
            
            if !email.contains("@") {
                ToastManager.alert(view: view_TopView, msg: "EMAIL_INVALID_FORMAT".localized())
                return false
            }
            
            if phone.isEmpty {
                UIFunctionality.addShakyAnimation(elementToBeShake: txt_Phone)
                ToastManager.alert(view: view_TopView, msg: "PHONE_EMPTY_MESSAGE".localized())
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    private func informMessage(message: String) {
        let confirmDialog = UIAlertController(title: "INFORMATION_TITLE".localized(), message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        confirmDialog.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in

        }))
        
        self.present(confirmDialog, animated: true, completion: nil)
    }
    
    private func fillInformation() {
        DispatchQueue.global(qos: .userInteractive).async {
            let customerInformation = DTOCustomerInformation.sharedInstance.customerInformationDictionary
            
            if let _ = customerInformation["userEmail"] as? NSNull, let _ = customerInformation["userPhone"] as? NSNull {
                return
            }
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.txt_Email.text = customerInformation["userEmail"] as! String?
                self.txt_Phone.text = customerInformation["userPhone"] as! String?
            }
        }
    }
    
    
    func hideKeyBoard() {
        txt_Email.resignFirstResponder()
        txt_Phone.resignFirstResponder()
    }
    
}
