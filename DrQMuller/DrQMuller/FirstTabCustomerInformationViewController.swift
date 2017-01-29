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
    @IBOutlet private weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_Next: UIButton!
    
    private var customerInformationController = CustomStyleCustomerInformation()
    private var language: String!

    private func handleLanguageChanged() {
        self.language = UserDefaults.standard.string(forKey: "lang")
        
        lbl_Title.text = "CUSTOMER_INFO_PAGE_TITLE".localized(lang: self.language)
        btn_FirstTab.setTitle("FIRST_TAB_BTN_TITLE".localized(lang: self.language), for: .normal)
        btn_SecondTab.setTitle("SECOND_TAB_BTN_TITLE".localized(lang: self.language), for: .normal)
        btn_ThirdTab.setTitle("THIRD_TAB_BTN_TITLE".localized(lang: self.language), for: .normal)
        
        txt_Name.placeholder = "FULLNAME_PLACEHOLDER".localized(lang: self.language)
        txt_Address.placeholder = "ADDRESS_PLACEHOLDER".localized(lang: self.language)
        
        btn_Next.setTitle("BTN_NEXT_TITLE".localized(lang: self.language), for: .normal)
    }
    
    private struct Storyboard {
        static let SEGUE_TO_LOGIN = "segue_CustomerInformationToLogin"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleLanguageChanged()
    }
    
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

        DialogManager.confirmLogout(sender: self, segueIdentifier: Storyboard.SEGUE_TO_LOGIN)
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
