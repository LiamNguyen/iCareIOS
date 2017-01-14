//
//  LoginViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/11/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, HTTPClientDelegate {

    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var txtView: UIView!
    @IBOutlet private weak var txt_Username: CustomTxtField!
    @IBOutlet private weak var txt_Password: CustomTxtField!
    @IBOutlet private weak var btn_ResetPassword: UIButton!
    @IBOutlet private weak var btn_Login: UIButton!
    @IBOutlet private weak var btn_Register: UIButton!
    @IBOutlet private weak var constraint_BtnLogin_TxtConfirm: NSLayoutConstraint!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var initialViewOrigin: CGFloat!
    private var initialTxtOrigin: CGFloat!
    private var screenHeight: CGFloat!
    private var isIphone4 = false
    private var initialConstraintConstant: CGFloat!
    private var lineDrawer = LineDrawer()
    
    var testReturnArr = HTTPClient()
    private var modelHandleLogin = ModelHandleLogin()
    private var hasReceiveLoginResponse = false
    
    func onReceiveRequestResponse(data: AnyObject) {
        if let arrayResponse = data["Select_AllTime"] as? NSArray {
            for arrayItem in arrayResponse {
                let arrayDict = arrayItem as! NSDictionary
                if let result = arrayDict["TIME"] as? String {
                    print(result)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txt_Username.placeholder = "Your username"
        self.txt_Password.placeholder = "Your password"
        self.btn_Login.setTitle("Login", for: .normal)
        self.btn_Register.setTitle("Register", for: .normal)
        self.btn_ResetPassword.setTitle("Don't remember you username or password?", for: .normal)
        
        self.testReturnArr.delegate = self

        
        activityIndicator.stopAnimating()
        
//=========TXTFIELD DELEGATE=========
        
        self.txt_Username.delegate = self
        self.txt_Password.delegate = self
        
//=========STYLE FOR RESET PASSWORD LINK=========
        
        let attrString = NSAttributedString(string: "Quên mật khẩu hoặc tên đăng nhập?", attributes: [NSForegroundColorAttributeName:UIColor.white, NSUnderlineStyleAttributeName: 1])
        
        btn_ResetPassword.setAttributedTitle(attrString, for: .normal)
        
//=========STYLE BUTTONS=========
        
        btn_Login.layer.cornerRadius = 10
        btn_Register.layer.cornerRadius = 10
        
//=========ASSIGN ORIGIN X SUBVIEW=========
        
        initialViewOrigin = loginView.frame.origin.y
        
//=========ASSIGN ORIGIN X VIEW CONTAINS TEXT FIELDS=========
        
        initialTxtOrigin = txtView.frame.origin.y
        
//=========ASSIGN CONSTANT CONSTRAINTS BTN_LOGIN_TXT_CONFIRM=========

        initialConstraintConstant = constraint_BtnLogin_TxtConfirm.constant
        
//=========GET SCREEN SIZE=========
        
        screenHeight = UIScreen.main.bounds.height
        
//=========ASSIGN BOOLEAN VARIABLE FOR ISIPHONE4=========
        
        if screenHeight == 480 {
            isIphone4 = true
        }
        
//=========UPDATE FOR IPHONE 4S SCREEN ON LOAD=========
        
        updateLoadStyleForIphone4()
        
        
//=========OBSERVE FOR NOTIFICATION FROM PMHandleLogin=========
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "postRequestStatus"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "postRequestStatus"), object: nil, queue: nil, using: handleView)

        
//        //=========DRAW LINE=========
//
//        let firstPoint = CGPoint(x: 0, y: 480)
//        let secondPoint = CGPoint(x: UIScreen.main.bounds.width, y: 480)
//        
//        lineDrawer.addLine(fromPoint: firstPoint, toPoint: secondPoint, lineWidth: 2, color: UIColor(netHex: 0x8F00B3), view: self.view)
//        
//        let thirdPoint = CGPoint(x: 0, y: 480 - 216)
//        let fourthPoint = CGPoint(x: UIScreen.main.bounds.width, y: 480 - 216)
//        
//        lineDrawer.addLine(fromPoint: thirdPoint, toPoint: fourthPoint, lineWidth: 2, color: UIColor.red, view: self.view)
        
//=========TOAST SET UP COLOR=========
        
        UIView.hr_setToastThemeColor(color: ToastColorAlert)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
//=========TEXT FIELD FOCUS CALL BACK FUNCTION=========
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isIphone4 {
            adjustViewOrigin(y: 20)
            return
        }
        updateTxtFieldFocusStyleForIphone4()
    }
    
//=========OUTSIDE TOUCH CLOSE KEYBOARD=========
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if !isIphone4 {
            adjustViewOrigin(y: initialViewOrigin)
            return
        }
        updateTxtFieldLoseFocusStyleForIphone4()
    }
    
//=========PRESS RETURN CLOSE KEYBOARD=========
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == txt_Username {
            txt_Password.becomeFirstResponder()
        }
        
        if !isIphone4 && textField == txt_Password {
            adjustViewOrigin(y: initialViewOrigin)
            login()
            return true
        }

        if textField != txt_Password {
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

//=========ADJUST LOGIN BUTTON ORIGIN Y=========
    
    private func adjustBtnOrigin(y: CGFloat) {
        btn_Login.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.btn_Login.frame.origin = CGPoint(x: self.btn_Login.frame.origin.x, y: y)
        }
    }
    
//=========UPDATE UI FOR IPHONE 4S ON LOAD=========

    private func updateLoadStyleForIphone4() {
        if !isIphone4 {
            return
        }
        adjustViewOrigin(y: 10)
    }
    
//=========UPDATE UI FOR IPHONE 4 WHEN ON TXTFIELD FOCUS=========
    
    private func updateTxtFieldFocusStyleForIphone4() {
        adjustTxtOrigin(y: 60)
        constraint_BtnLogin_TxtConfirm.constant = 20
        btn_ResetPassword.isHidden = true
    }
    
//=========REVERT UPDATE UI FOR IPHONE 4 ON TXTFIELD LOSE FOCUS=========

    private func updateTxtFieldLoseFocusStyleForIphone4() {
        adjustTxtOrigin(y: initialTxtOrigin)
        constraint_BtnLogin_TxtConfirm.constant = initialConstraintConstant
        btn_ResetPassword.isHidden = false
    }
    
    
    @IBAction func btn_Login_OnClick(_ sender: Any) {
        login()
        
        if !isIphone4 {
            adjustViewOrigin(y: initialViewOrigin)
            return
        }
        updateTxtFieldLoseFocusStyleForIphone4()
    }
    
    private func login() {
        if !frontValidationPassed() {
            return
        }
        uiWaitingLoginResponse(isDone: false)
        modelHandleLogin.handleLogin(username: txt_Username.text!, password: txt_Password.text!)
        self.hasReceiveLoginResponse = false
    }
    
//=========HANDLE LOGIN PROCEDURE=========
    
    func handleView(notification: Notification) {
        if hasReceiveLoginResponse {
            return
        }
        if let userInfo = notification.userInfo {
            let isOk = userInfo["status"] as? Bool
            if isOk! {
                print("Login Success")
                self.performSegue(withIdentifier: "segue_LoginToBookingTabViewController", sender: self)
            } else {
                print("Login Failed")
                ToastManager.sharedInstance.alert(view: loginView, msg: "Tên đăng nhập và mật khẩu không hợp lệ")
            }
        }
        uiWaitingLoginResponse(isDone: true)
        self.hasReceiveLoginResponse = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue_LoginToBookingTabViewController"){
            if let tabVC = segue.destination as? UITabBarController{
                tabVC.selectedIndex = 1
            }
        }
    }

    
//=========VALIDATE TEXTFIELD=========
    
    private func frontValidationPassed() -> Bool {
        if let username = txt_Username.text, let password = txt_Password.text {
            if username.isEmpty {
                ToastManager.sharedInstance.alert(view: loginView, msg: "Tên đăng nhập trống")
                return false
            }
            
            if password.isEmpty {
                ToastManager.sharedInstance.alert(view: loginView, msg: "Mật khẩu trống")
                return false
            }
            return true
        }
        return false
    }
    
//=========LOCK UI ELEMENTS WAITING LOGIN RESPONSE=========
    
    private func uiWaitingLoginResponse(isDone: Bool) {
        if !isDone {
            self.activityIndicator.startAnimating()
            self.txt_Username.isEnabled = false
            self.txt_Password.isEnabled = false
            self.btn_ResetPassword.isEnabled = false
            self.btn_Login.isEnabled = false
            self.btn_Register.isEnabled = false
        } else {
            self.activityIndicator.stopAnimating()
            self.txt_Username.isEnabled = true
            self.txt_Password.isEnabled = true
            self.btn_ResetPassword.isEnabled = true
            self.btn_Login.isEnabled = true
            self.btn_Register.isEnabled = true
        }
    }
    
    
}

