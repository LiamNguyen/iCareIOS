//
//  LoginViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/11/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var TopNavBar: UINavigationBar!
    @IBOutlet weak var txt_Username: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var btn_Login: UIButton!
    @IBOutlet weak var btn_Register: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegating txtField
        
        self.txt_Username.delegate = self
        self.txt_Password.delegate = self
        
        //Delegating txtField
        
        
        btn_Login.layer.cornerRadius = 20
        btn_Register.layer.cornerRadius = 20
        
        txt_Username.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:)), for: UIControlEvents.editingChanged)
        
        txt_Username.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)

        txt_Password.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:)), for: UIControlEvents.editingChanged)
        
        txt_Password.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)
        
        print("Blahh")
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == txt_Username {
            txt_Username.borderStyle = UITextBorderStyle(rawValue: 3)!
        } else {
            txt_Password.borderStyle = UITextBorderStyle(rawValue: 3)!
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == txt_Username {
//            txt_Username.borderStyle = UITextBorderStyle(rawValue: 0)!
//        } else {
//            txt_Password.borderStyle = UITextBorderStyle(rawValue: 0)!
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("test")
        return true
    }
}

