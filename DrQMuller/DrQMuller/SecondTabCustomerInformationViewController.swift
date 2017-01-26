//
//  SecondTabCustomerInformationViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /20/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class SecondTabCustomerInformationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, SlideButtonDelegate {

    @IBOutlet private weak var constraint_FirstTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraint_SecondTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraint_ThirdTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var btn_FirstTab: UIButton!
    @IBOutlet private weak var btn_SecondTab: UIButton!
    @IBOutlet private weak var btn_ThirdTab: UIButton!
    @IBOutlet private weak var view_FirstTabContainer: UIView!
    @IBOutlet private weak var view_SecondTabContainer: UIView!
    @IBOutlet private weak var view_ThirdTabContainer: UIView!
    @IBOutlet weak var picker_Gender: UIPickerView!
    @IBOutlet weak var picker_Date: UIDatePicker!
    @IBOutlet weak var slideBtn_Next: MMSlidingButton!
    @IBOutlet weak var lbl_Title: UILabel!
    
    private var customerInformationController = CustomStyleCustomerInformation()
    private var picker_GenderDataSource = [String]()
    private let datePickerRange = DatePickerRange()
    private var language: String!
    
    private func handleLanguageChanged() {
        self.language = UserDefaults.standard.string(forKey: "lang")
        
        lbl_Title.text = "CUSTOMER_INFO_PAGE_TITLE".localized(lang: self.language)
        btn_FirstTab.setTitle("FIRST_TAB_BTN_TITLE".localized(lang: self.language), for: .normal)
        btn_SecondTab.setTitle("SECOND_TAB_BTN_TITLE".localized(lang: self.language), for: .normal)
        btn_ThirdTab.setTitle("THIRD_TAB_BTN_TITLE".localized(lang: self.language), for: .normal)
        
        picker_GenderDataSource = ["GENDER_MALE".localized(lang: self.language), "GENDER_FEMALE".localized(lang: self.language)]
        
        //picker_Date.locale = NSLocale.localeIdentifier(fromWindowsLocaleCode: "vi")
        
        self.slideBtn_Next.buttonText = "BTN_NEXT_TITLE".localized(lang: self.language)
        
        self.slideBtn_Next.buttonUnlockedText = "SLIDE_BTN_UNLOCKED_TITLE".localized(lang: UserDefaults.standard.string(forKey: "lang")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleLanguageChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//=========DATE PICKER SET MAX=========

        datePickerRange.datePickerConstraintMax(MaxRangeFromCurrentDate: -13, DatePicker: self.picker_Date)
        
//=========ENABLE TAB HEADERS=========
        
        customerInformationController.enableTab(firstTab: btn_FirstTab, secondTab: btn_SecondTab, thirdTab: btn_ThirdTab)
        
//=========UPDATE STYLE OF TAB HEADERS FOR DIFFERENT PHONE SIZE=========
        
        customerInformationController.tabHeadersStyleUpdate(FirstTabConstraint: constraint_FirstTabWidth,SecondTabConstraint: constraint_SecondTabWidth, ThirdTabConstraint: constraint_ThirdTabWidth)
        
//=========UPDATE ORIGIN OF TAB HEADERS FOR DIFFERENT PHONE SIZE=========
        
        customerInformationController.tabHeadersOriginUpdate(view_FirstTabContainer: view_FirstTabContainer,view_SecondTabContainer: view_SecondTabContainer, view_ThirdTabContainer: view_ThirdTabContainer)
        
//=========APPLY TAB HEADERS UNDERLINE=========
        
        customerInformationController.translateTabHeaderUnderline(view: self.view, view_TabContainer: view_SecondTabContainer)
        
//=========DELEGATING VIEW PICKER=========
        
        self.picker_Gender.dataSource = self
        self.picker_Gender.delegate = self
        

        
//=========DELEGATING slideBtn_Next=========
        
        self.slideBtn_Next.delegate  = self
        self.slideBtn_Next.reset()
    }
    
    @IBAction func btn_Back_OnClick(_ sender: Any) {
        
//=========POP UP CONFIRM DIALOG=========
        
        DialogManager.confirmLogout(sender: self)
    }
    
//=========TRANSITION TO FIRST INFO PAGE=========
    
    @IBAction func btn_FirstTab_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_CustomerInformationSecondTabToFirstTab", sender: self)
    }
    
    
//=========TRANSITION TO THIRD INFO PAGE=========

    @IBAction func btn_ThirdTab_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_CustomerInformationSecondTabToThirdTab", sender: self)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker_GenderDataSource.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker_GenderDataSource[row]
    }
    
//=========TRANSITION TO THIRD INFO PAGE WITH slideBtn_Next=========
    
    func buttonStatus(_ status:String, sender:MMSlidingButton) {
        self.performSegue(withIdentifier: "segue_CustomerInformationSecondTabToThirdTab", sender: self)
    }
    
//=========TOUCH OUTSIDE CLOSE KEYBOARD=========
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//=========PRESS RETURN CLOSE KEYBOARD=========
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    
    
    
}
