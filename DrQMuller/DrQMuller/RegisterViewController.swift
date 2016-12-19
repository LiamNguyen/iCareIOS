//
//  RegisterViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /27/11/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var txt_Username: CustomTxtField!
    @IBOutlet weak var txt_Password: CustomTxtField!
    @IBOutlet weak var txt_ConfirmPassword: CustomTxtField!
    @IBOutlet weak var btn_Register: UIButton!
    @IBOutlet weak var txtView: UIView!
    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet weak var constraint_BtnBackWidth: NSLayoutConstraint!
    @IBOutlet weak var constraint_BtnBackHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_Welcome: UILabel!
    @IBOutlet weak var constrant_TxtView_LoginView: NSLayoutConstraint!
    
    var initialViewOrigin: CGFloat!
    var initialTxtOrigin: CGFloat!
    var initialConstraintConstant: CGFloat!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var isIphone4 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        btn_Back.isHidden = false

        //=========IPHONE 6 AND HIGHER=========
        
        if screenHeight >= 667 {
            return true
        }

        if !isIphone4 {
            adjustViewOrigin(y: initialViewOrigin)
            adjustTxtOrigin(y: initialTxtOrigin)
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
        adjustViewOrigin(y: 0)
        constraint_BtnBackWidth.constant = 25
        constraint_BtnBackHeight.constant = 25
    }
    
    //=========UPDATE UI FOR IPHONE 4 WHEN ON TXTFIELD FOCUS=========
    
    func updateTxtFieldFocusStyleForIphone4() {
        adjustViewOrigin(y: 10)
        adjustTxtOrigin(y: 20)
        lbl_Welcome.isHidden = true
        constrant_TxtView_LoginView.constant = 0
    }
    
    //=========REVERT UPDATE UI FOR IPHONE 4 ON TXTFIELD LOSE FOCUS=========
    
    func updateTxtFieldLoseFocusStyleForIphone4() {
        adjustViewOrigin(y: 30)
        adjustTxtOrigin(y: initialTxtOrigin)
        lbl_Welcome.isHidden = false
        constrant_TxtView_LoginView.constant = initialConstraintConstant
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
    
    //=========SWIPE TO GET BACK=========

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("swipe right")
                self.performSegue(withIdentifier: "segue_RegisterToLogin", sender: self)
            default:
                break
            }
        }
    }
    
    @IBAction func btn_Register_OnClick(_ sender: Any) {
        let registerSuccess = true
        
        if (registerSuccess) {
            self.performSegue(withIdentifier: "segue_RegisterToContactInformation", sender: self)
        } else {
            print("Register Failed")
        }
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
