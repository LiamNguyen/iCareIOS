//
//  FirstTabCustomerInformationViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /19/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class FirstTabCustomerInformationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var constraint_FirstTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraint_SecondTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraint_ThirdTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var btn_FirstTab: UIButton!
    @IBOutlet private weak var btn_SecondTab: UIButton!
    @IBOutlet private weak var btn_ThirdTab: UIButton!
    @IBOutlet private weak var view_FirstTabContainer: UIView!
    @IBOutlet private weak var view_SecondTabContainer: UIView!
    @IBOutlet private weak var view_ThirdTabContainer: UIView!
    @IBOutlet private weak var txt_Name: UITextField!
    @IBOutlet private weak var txt_Address: UITextField!
    
    private var customerInformationController = CustomStyleCustomerInformation()
    private var message = Messages()

    override func viewDidLoad() {
        super.viewDidLoad()

//=========DELEGATING TEXTFIELD=========
        
        self.txt_Name.delegate = self
        self.txt_Address.delegate = self
        
//=========ENABLE TAB HEADERS=========

        customerInformationController.enableTab(firstTab: btn_FirstTab, secondTab: btn_SecondTab, thirdTab: btn_ThirdTab)
        
//=========UPDATE STYLE OF TAB HEADERS FOR DIFFERENT PHONE SIZE=========

        customerInformationController.tabHeadersStyleUpdate(FirstTabConstraint: constraint_FirstTabWidth,SecondTabConstraint: constraint_SecondTabWidth, ThirdTabConstraint: constraint_ThirdTabWidth)
        
//=========UPDATE ORIGIN OF TAB HEADERS FOR DIFFERENT PHONE SIZE=========

        customerInformationController.tabHeadersOriginUpdate(view_FirstTabContainer: view_FirstTabContainer,view_SecondTabContainer: view_SecondTabContainer, view_ThirdTabContainer: view_ThirdTabContainer)
        
//=========APPLY TAB HEADERS UNDERLINE=========

        customerInformationController.translateTabHeaderUnderline(view: self.view, view_TabContainer: view_FirstTabContainer)
        
//=========TEXTFIELD ONLOAD AUTOFOCUS=========

        txt_Name.becomeFirstResponder()
    }
    
    @IBAction func btn_Back_OnClick(_ sender: Any) {
        
//=========POP UP CONFIRM DIALOG=========

        message.confirmDialog(sender: self)
    }

    
//=========TRANSITION TO SECOND INFO PAGE=========
    
    @IBAction func btn_SecondTab_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_CustomerInformationFirstTabToSecondTab", sender: self)
    }
    
//=========TRANSITION TO THIRD INFO PAGE=========
    
    @IBAction func btn_ThirdTab_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_CustomerInformationFirstTabToThirdTab", sender: self)
    }
    
//=========TOUCH OUTSIDE CLOSE KEYBOARD=========
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//=========PRESS RETURN CLOSE KEYBOARD=========
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txt_Name {
            txt_Address.becomeFirstResponder()
        }
        return true
    }
    
    
    
    
    
    
    
}
