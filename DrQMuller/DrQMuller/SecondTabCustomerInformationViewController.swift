//
//  SecondTabCustomerInformationViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /20/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class SecondTabCustomerInformationViewController: UIViewController {

    @IBOutlet private weak var constraint_FirstTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraint_SecondTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraint_ThirdTabWidth: NSLayoutConstraint!
    @IBOutlet private weak var btn_FirstTab: UIButton!
    @IBOutlet private weak var btn_SecondTab: UIButton!
    @IBOutlet private weak var btn_ThirdTab: UIButton!
    @IBOutlet private weak var view_FirstTabContainer: UIView!
    @IBOutlet private weak var view_SecondTabContainer: UIView!
    @IBOutlet private weak var view_ThirdTabContainer: UIView!
    
    
    private var customerInformationController = CustomStyleCustomerInformation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //=========ENABLE TAB HEADERS=========
        
        customerInformationController.enableTab(firstTab: btn_FirstTab, secondTab: btn_SecondTab, thirdTab: btn_ThirdTab)
        
        //=========UPDATE STYLE OF TAB HEADERS FOR DIFFERENT PHONE SIZE=========
        
        customerInformationController.tabHeadersStyleUpdate(FirstTabConstraint: constraint_FirstTabWidth,SecondTabConstraint: constraint_SecondTabWidth, ThirdTabConstraint: constraint_ThirdTabWidth)
        
        //=========UPDATE ORIGIN OF TAB HEADERS FOR DIFFERENT PHONE SIZE=========
        
        customerInformationController.tabHeadersOriginUpdate(view_FirstTabContainer: view_FirstTabContainer,view_SecondTabContainer: view_SecondTabContainer, view_ThirdTabContainer: view_ThirdTabContainer)
        
        //=========APPLY TAB HEADERS UNDERLINE=========
        
        customerInformationController.translateTabHeaderUnderline(view: self.view, view_TabContainer: view_ThirdTabContainer)
    }
    
    @IBAction func btn_Back_OnClick(_ sender: Any) {
        
        //=========POP UP CONFIRM DIALOG=========
        
        confirmDialog()
    }
    
    //=========CREATE POP UP CONFIRM DIALOG=========
    
    private func confirmDialog() {
        let confirmDialog = UIAlertController(title: "Quý khách sẽ đăng thoát?", message: "Những thông tin chưa được xác nhận sẽ không được lưu trữ.", preferredStyle: UIAlertControllerStyle.alert)
        confirmDialog.addAction(UIAlertAction(title: "Đăng thoát", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "segue_CustomerInformationToLogin", sender: self)
        }))
        confirmDialog.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        present(confirmDialog, animated: true, completion: nil)
    }
    
}
