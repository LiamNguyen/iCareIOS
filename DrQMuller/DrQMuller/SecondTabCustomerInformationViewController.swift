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
    @IBOutlet weak var slideBtn_Next: MMSlidingButton!
    
    private var customerInformationController = CustomStyleCustomerInformation()
    var picker_GenderDataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//=========BIND DATASOURCE FOR GENDER PICKER=========

        picker_GenderDataSource = ["Nam", "Nữ"]
        
//=========DELEGATING VIEW PICKER=========
        
        self.slideBtn_Next.delegate  = self
        self.slideBtn_Next.reset()
    }
    
    @IBAction func btn_Back_OnClick(_ sender: Any) {
        
//=========POP UP CONFIRM DIALOG=========
        
        confirmDialog()
    }
    
//=========CREATE POP UP CONFIRM DIALOG=========
    
    private func confirmDialog() {
        let confirmDialog = UIAlertController(title: "Quý khách sẽ đăng thoát?", message: "Những thông tin chưa được xác nhận sẽ không được lưu trữ.", preferredStyle: UIAlertControllerStyle.alert)
        confirmDialog.addAction(UIAlertAction(title: "Đăng thoát", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "segue_CustomerInformationSecondTabToLogin", sender: self)
        }))
        confirmDialog.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        present(confirmDialog, animated: true, completion: nil)
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
