//
//  LoginViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/11/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

//=========EXTENSION CUSTOM COLOR=========

//extension UIColor {
//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }
//    
//    convenience init(netHex:Int) {
//        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
//    }
//}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var txtView: UIView!
    @IBOutlet weak var txt_Username: CustomTxtField!
    @IBOutlet weak var txt_Password: CustomTxtField!
    @IBOutlet weak var btn_ResetPassword: UIButton!
    @IBOutlet weak var btn_Login: UIButton!
    @IBOutlet weak var btn_Register: UIButton!
    @IBOutlet weak var constraint_BtnLogin_TxtConfirm: NSLayoutConstraint!
    
    var initialViewOrigin: CGFloat!
    var initialTxtOrigin: CGFloat!
    var screenHeight: CGFloat!
    var isIphone4 = false
    var initialConstraintConstant: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //=========DRAW LINE=========

        let firstPoint = CGPoint(x: 0, y: 480)
        
        let secondPoint = CGPoint(x: UIScreen.main.bounds.width, y: 480)
        
        addLine(fromPoint: firstPoint, toPoint: secondPoint)
        
        let thirdPoint = CGPoint(x: 0, y: 480 - 216)
        let fourthPoint = CGPoint(x: UIScreen.main.bounds.width, y: 480 - 216)
        
        addLine(fromPoint: thirdPoint, toPoint: fourthPoint)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        if !isIphone4 {
            adjustViewOrigin(y: initialViewOrigin)
            return true
        }
        updateTxtFieldLoseFocusStyleForIphone4()
        
        return true
    }
    
    //=========ADJUST VIEW ORIGIN Y=========
    
    func adjustViewOrigin(y: CGFloat) {
        loginView.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.loginView.frame.origin = CGPoint(x: self.loginView.frame.origin.x, y: y)
        }
    }
    
    //=========ADJUST VIEW CONTAIN TEXT FIELDS ORIGIN Y=========
    
    func adjustTxtOrigin(y: CGFloat) {
        txtView.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.txtView.frame.origin = CGPoint(x: self.txtView.frame.origin.x, y: y)
        }
    }

    //=========ADJUST LOGIN BUTTON ORIGIN Y=========
    
    func adjustBtnOrigin(y: CGFloat) {
        btn_Login.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.btn_Login.frame.origin = CGPoint(x: self.btn_Login.frame.origin.x, y: y)
        }
    }
    
    //=========LOCK ROTATION=========
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    //=========UPDATE UI FOR IPHONE 4S ON LOAD=========

    func updateLoadStyleForIphone4() {
        if !isIphone4 {
            return
        }
        adjustViewOrigin(y: 30)
    }
    
    //=========UPDATE UI FOR IPHONE 4 WHEN ON TXTFIELD FOCUS=========
    
    func updateTxtFieldFocusStyleForIphone4() {
        adjustViewOrigin(y: 10)
        adjustTxtOrigin(y: 60)
        constraint_BtnLogin_TxtConfirm.constant = 20
        btn_ResetPassword.isHidden = true
    }
    
    //=========REVERT UPDATE UI FOR IPHONE 4 ON TXTFIELD LOSE FOCUS=========

    func updateTxtFieldLoseFocusStyleForIphone4() {
        adjustViewOrigin(y: 30)
        adjustTxtOrigin(y: initialTxtOrigin)
        constraint_BtnLogin_TxtConfirm.constant = initialConstraintConstant
        btn_ResetPassword.isHidden = false
    }
    
    //=========CREATE LINE=========
    
    func addLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 2
        line.lineJoin = kCALineJoinRound
        self.view.layer.addSublayer(line)
    }
}

