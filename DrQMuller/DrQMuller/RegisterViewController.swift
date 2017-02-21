//
//  RegisterViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /27/11/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var txt_Username: CustomTxtField!
    @IBOutlet private weak var txt_Password: CustomTxtField!
    @IBOutlet private weak var txt_ConfirmPassword: CustomTxtField!
    @IBOutlet private weak var btn_Register: UIButton!
    @IBOutlet private weak var txtView: UIView!
    @IBOutlet private weak var btn_Back: UIButton!
    @IBOutlet private weak var constraint_BtnBackWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraint_BtnBackHeight: NSLayoutConstraint!
    @IBOutlet private weak var lbl_Welcome: UILabel!
    @IBOutlet private weak var constrant_TxtView_LoginView: NSLayoutConstraint!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var initialViewOrigin: CGFloat!
    private var initialTxtOrigin: CGFloat!
    private var initialConstraintConstant: CGFloat!
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!
    private var isIphone4 = false
    
    private var hasReceiveRegisterResponse = false
    
    private var networkViewManager: NetworkViewManager!
    private weak var networkCheckInRealTime: Timer?
    private var modelHandleRegister: ModelHandleRegister!
    
    private struct Storyboard {
        static let SEGUE_TO_LOGIN = "segue_RegisterToLogin"
        static let SEGUE_TO_FIRST_TAB = "segue_RegisterToContactInformation"
    }
    
    private func updateUI() {
        
        //=========TXTFIELD PLACEHOLDER=========
        
        txt_Username.placeholder = "USERNAME_PLACEHOLDER".localized()
        txt_Password.placeholder = "PASSWORD_PLACEHOLDER".localized()
        txt_ConfirmPassword.placeholder = "CONFIRM_PASSWORD_PLACEHOLDER".localized()
        
        //=========BUTTON TITLE=========
        
        btn_Register.setTitle("REGISTER_BTN_TITLE".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        
        wiredUpNetworkChecking()
        
        
        //=========OBSERVE FOR NOTIFICATION FROM PMHandleRegister=========
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(RegisterViewController.onReceiveRegisterResponse(notification:)),
            name: Notification.Name(rawValue: "registerResponse"),
            object: nil
        )
        
        revertToDefaultStyle()
    }
    
    deinit {
        print("Register VC: dead")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkViewManager = NetworkViewManager()
        self.modelHandleRegister = ModelHandleRegister()
        
//=========TXTFIELD DELEGATE=========
        
        self.txt_Username.delegate = self
        self.txt_Password.delegate = self
        self.txt_ConfirmPassword.delegate = self
        
//=========ASSIGN ORIGIN X SUBVIEW=========
        
        initialViewOrigin = loginView.frame.origin.y
        
//=========ASSIGN ORIGIN X VIEW CONTAINS TEXT FIELDS=========
        
        initialTxtOrigin = txtView.frame.origin.y
        
//=========ASSIGN CONSTANT CONSTRAINTS BTN_LOGIN_TXT_CONFIRM=========
        
        initialConstraintConstant = constrant_TxtView_LoginView.constant

//=========STYLE BUTTONS=========
        
        btn_Register.layer.cornerRadius = 10
        
//=========GET SCREEN SIZE=========
        
        screenHeight = UIScreen.main.bounds.height
        
//=========ASSIGN BOOLEAN VARIABLE FOR ISIPHONE4=========
        
        if screenHeight == 480 {
            isIphone4 = true
        }
        
//=========UPDATE FOR IPHONE 4S SCREEN ON LOAD=========
        
        updateLoadStyleForIphone4()
        
//=========INITIALIZE GESTURE RECOGNIZER=========
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)

//=========TEXTFIELD ONLOAD AUTOFOCUS=========
        
        txt_Username.becomeFirstResponder()

        self.activityIndicator.stopAnimating()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        self.networkCheckInRealTime?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//=========TEXT FIELD FOCUS CALL BACK FUNCTION=========
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btn_Back.isHidden = true

//=========IPHONE 6 AND HIGHER=========

        if screenHeight >= 667 {
            return
        }
        
        if !isIphone4 {
            adjustViewOrigin(y: 10)
            adjustTxtOrigin(y: 60)
            return
        }
        updateTxtFieldFocusStyleForIphone4()
    }

//=========OUTSIDE TOUCH CLOSE KEYBOARD=========
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        btn_Back.isHidden = false

//=========IPHONE 6 AND HIGHER=========

        if screenHeight >= 667 {
            return
        }
        
        if !isIphone4 {
            adjustViewOrigin(y: initialViewOrigin)
            adjustTxtOrigin(y: initialTxtOrigin)
            return
        }
        updateTxtFieldLoseFocusStyleForIphone4()
    }
    
//=========PRESS RETURN CLOSE KEYBOARD=========

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        switch textField {
        case txt_Username:
            txt_Password.becomeFirstResponder()
        case txt_Password:
            txt_ConfirmPassword.becomeFirstResponder()
        default:
            btn_Back.isHidden = false
            if !isIphone4 && textField == txt_ConfirmPassword {
                adjustViewOrigin(y: initialViewOrigin)
                adjustTxtOrigin(y: initialTxtOrigin)
                register()
                return true
            }
        }
        
        //=========IPHONE 6 AND HIGHER=========
        
        if screenHeight >= 667 {
            return true
        }
        
        if textField != txt_ConfirmPassword {
            return true
        }
        updateTxtFieldLoseFocusStyleForIphone4()
        return true
    }
    
//=========ADJUST VIEW ORIGIN Y=========

    private func adjustViewOrigin(y: CGFloat) {
        loginView.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.loginView.frame.origin = CGPoint(x: self.loginView.frame.origin.x, y: y)
        }
    }
    
//=========ADJUST VIEW CONTAIN TEXT FIELDS ORIGIN Y=========
    
    private func adjustTxtOrigin(y: CGFloat) {
        txtView.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.txtView.frame.origin = CGPoint(x: self.txtView.frame.origin.x, y: y)
        }
    }
    
//=========UPDATE UI FOR IPHONE 4S ON LOAD=========
    
    private func updateLoadStyleForIphone4() {
        if !isIphone4 {
            return
        }
        adjustViewOrigin(y: 35)
        constraint_BtnBackWidth.constant = 25
        constraint_BtnBackHeight.constant = 25
    }
    
//=========UPDATE UI FOR IPHONE 4 WHEN ON TXTFIELD FOCUS=========
    
    private func updateTxtFieldFocusStyleForIphone4() {
        adjustViewOrigin(y: 0)
        adjustTxtOrigin(y: 20)
        lbl_Welcome.isHidden = true
        constrant_TxtView_LoginView.constant = 0
    }
    
//=========REVERT UPDATE UI FOR IPHONE 4 ON TXTFIELD LOSE FOCUS=========
    
    private func updateTxtFieldLoseFocusStyleForIphone4() {
        adjustViewOrigin(y: 35)
        adjustTxtOrigin(y: initialTxtOrigin)
        lbl_Welcome.isHidden = false
        constrant_TxtView_LoginView.constant = initialConstraintConstant
    }
    
    private func revertToDefaultStyle() {
        if !isIphone4 {
            UIView.animate(withDuration: 0.4) { () -> Void in
                self.loginView.frame.origin = CGPoint(x: self.loginView.frame.origin.x, y: self.initialViewOrigin)
            }
            UIView.animate(withDuration: 0.4) { () -> Void in
                self.txtView.frame.origin = CGPoint(x: self.txtView.frame.origin.x, y: self.initialTxtOrigin)
            }
            return
        }
        updateTxtFieldLoseFocusStyleForIphone4()
    }
    
//=========SWIPE TO GET BACK=========

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                self.performSegue(withIdentifier: Storyboard.SEGUE_TO_LOGIN, sender: self)
            default:
                break
            }
        }
    }
    
    @IBAction func btn_Register_OnClick(_ sender: Any) {
        register()
        if !isIphone4 {
            adjustViewOrigin(y: initialViewOrigin)
            return
        }
        updateTxtFieldFocusStyleForIphone4()
    }
    
    private func register() {
        if !frontValidationPassed() {
            return
        }
        uiWaitingRegisterResponse(isDone: false)
        modelHandleRegister?.handleRegister(username: txt_Username.text!, password: txt_Password.text!)
        self.hasReceiveRegisterResponse = false
    }
    
//=========HANDLE REGISTER RESPONSE=========
    
    func onReceiveRegisterResponse(notification: Notification) {
        if hasReceiveRegisterResponse {
            return
        }
        if let userInfo = notification.userInfo {
            if let status = userInfo["status"] as? String {
                if status == "1" {
                    print("Register Success")
                    self.performSegue(withIdentifier: Storyboard.SEGUE_TO_FIRST_TAB, sender: self)
                } else if status == "2" {
                    print("Register Duplicated")
                    ToastManager.alert(view: loginView, msg: "USERNAME_EXISTED_MESSAGE".localized())
                } else {
                    print("Register Failed")
                    ToastManager.alert(view: loginView, msg: "CREDENTIAL_INVALID".localized())
                }
            }
        }
        uiWaitingRegisterResponse(isDone: true)
        self.hasReceiveRegisterResponse = true
    }
    
//=========VALIDATE TEXTFIELD=========
    
    private func frontValidationPassed() -> Bool {
        if let username = txt_Username.text, let password = txt_Password.text, let confirmPassword = txt_ConfirmPassword.text {
            if username.isEmpty {
                ToastManager.alert(view: loginView, msg: "USERNAME_EMPTY_MESSAGE".localized())
                return false
            }
            
            if password.isEmpty {
                ToastManager.alert(view: loginView, msg: "PASSWORD_EMPTY_MESSAGE".localized())
                return false
            }
            
            if confirmPassword.isEmpty {
                ToastManager.alert(view: loginView, msg: "CONFIRM_PASSWORD_EMPTY_MESSAGE".localized())
                return false
            }
            
            if confirmPassword != password {
                ToastManager.alert(view: loginView, msg: "CONFIRM_PASSWORD_UNMATCH_MESSAGE".localized())
                return false
            }
            return true
        }
        return false
    }
    
//=========LOCK UI ELEMENTS WAITING REGISTER RESPONSE=========
    
    private func uiWaitingRegisterResponse(isDone: Bool) {
        if !isDone {
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        } else {
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    private func wiredUpNetworkChecking() {
        let tupleDetectNetworkReachabilityResult = Reachability.detectNetworkReachabilityObserver(parentView: self.view)
        networkViewManager = tupleDetectNetworkReachabilityResult.network
        networkCheckInRealTime = tupleDetectNetworkReachabilityResult.timer
    }
    
    @IBAction func btn_Back_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: Storyboard.SEGUE_TO_LOGIN, sender: self)
    }
}




/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
