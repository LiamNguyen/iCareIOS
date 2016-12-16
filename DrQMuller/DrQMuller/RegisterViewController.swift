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
    @IBOutlet weak var btn_ResetPassword: UIButton!
    @IBOutlet weak var btn_Login: UIButton!
    @IBOutlet weak var btn_Register: UIButton!
    var initialViewOrigin: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //=========TXTFIELD DELEGATE=========
        
        self.txt_Username.delegate = self
        self.txt_Password.delegate = self
        
        //=========ASSIGN ORIGIN X SUBVIEW=========
        
        initialViewOrigin = loginView.frame.origin.y

        //=========STYLE FOR RESET PASSWORD LINK=========
        
        let attrString = NSAttributedString(string: "Quên mật khẩu hoặc tên đăng nhập?", attributes: [NSForegroundColorAttributeName:UIColor.white, NSUnderlineStyleAttributeName: 1])
        
        btn_ResetPassword.setAttributedTitle(attrString, for: .normal)
        
        //=========STYLE BUTTONS=========

        btn_Login.layer.cornerRadius = 10
        btn_Register.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        adjustViewOrigin(y: 50)
    }

    //=========OUTSIDE TOUCH CLOSE KEYBOARD=========
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        adjustViewOrigin(y: initialViewOrigin)
    }
    
    //=========PRESS RETURN CLOSE KEYBOARD=========

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        adjustViewOrigin(y: initialViewOrigin)
        return true
    }
    
    //=========ADJUST VIEW ORIGIN Y=========

    func adjustViewOrigin(y: CGFloat) {
        loginView.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.loginView.frame.origin = CGPoint(x: self.loginView.frame.origin.x, y: y)
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
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
