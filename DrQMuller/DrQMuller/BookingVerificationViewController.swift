//
//  BookingVerificationViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /12/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class BookingVerificationViewController: UIViewController {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet weak var view_TopView: UIView!
    @IBOutlet weak var txtView_Message: UITextView!
    @IBOutlet weak var txt_VerificationCode: UITextField!
    @IBOutlet weak var btn_Confirm: UIButton!

    private var borderBottom: UIView!
    private var modelHandleBookingVerification = ModelHandleBookingVerification()
    var dtoBookingInformation: DTOBookingInformation!
    
    private var activityIndicator: UIActivityIndicatorView!
    
    private func updateUI() {
        self.lbl_Title.text? = "BOOKING_VERIFICATION_PAGE_TITLE".localized()
        self.txtView_Message.text? = "VERIFICATION_MESSAGE".localized()
        self.txt_VerificationCode.placeholder = "CODE_PLACEHOLDER".localized()
        self.btn_Confirm.setTitle("CONFIRM_TITLE".localized(), for: .normal)
    }
    
    private struct Storyboard {
        static let SEGUE_TO_BOOKING_MANAGER = "segue_BookingVerificationToBookingManager"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createTxtFieldBorder()
        
        txt_VerificationCode.becomeFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        UIView.hr_setToastThemeColor(color: UIColor.red)
        
        self.activityIndicator = UIFunctionality.createActivityIndicator(view: self.view)
        self.activityIndicator.stopAnimating()
        
        //=========OBSERVING NOTIFICATION FROM ModelHandleBookingDetail=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "validateCode"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "validateCode"), object: nil, queue: nil, using: onReceiveVerifificationCodeResponse)
        
        print("\nBooking Verifification VC ONLOAD: ")
        dtoBookingInformation.printBookingInfo()
    }
    
    func onReceiveVerifificationCodeResponse(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let isOk = userInfo["status"] as? Bool {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
                if isOk {
                    DispatchQueue.main.async {
                        self.dtoBookingInformation.isConfirmed = "1"
                        self.modelHandleBookingVerification.saveAppointmentToUserDefault(dtoBookingInformation: self.dtoBookingInformation)
                        
                        let confirmDialog = UIAlertController(title: "INFORMATION_TITLE".localized(), message: "VERIFY_BOOKING_SUCCESS_MESSAGE".localized(), preferredStyle: UIAlertControllerStyle.alert)
                        
                        confirmDialog.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            self.performSegue(withIdentifier: Storyboard.SEGUE_TO_BOOKING_MANAGER, sender: self)
                        }))
                        
                        self.present(confirmDialog, animated: true, completion: nil)
                    }
                } else {
                    ToastManager.alert(view: view_TopView, msg: "VALIDATE_CODE_FAIL_MESSAGE".localized())
                }
            }
        }
    }
    
    @IBAction func btn_Back_OnClick(_ sender: Any) {
        let confirmDialog = UIAlertController(title: "INFORMATION_TITLE".localized(), message: "WARNING_BOOKING_UNVERIFIED".localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        confirmDialog.addAction(UIAlertAction(title: "LEAVE_EXECUTE_TITLE".localized(), style: .default, handler: { (action: UIAlertAction!) in
            self.dtoBookingInformation.isConfirmed = "0"
            self.modelHandleBookingVerification.saveAppointmentToUserDefault(dtoBookingInformation: self.dtoBookingInformation)
            self.performSegue(withIdentifier: Storyboard.SEGUE_TO_BOOKING_MANAGER, sender: self)
        }))
        confirmDialog.addAction(UIAlertAction(title: "DIALOG_CANCEL_TITLE".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        self.present(confirmDialog, animated: true, completion: nil)
    }
    
    @IBAction func btn_Confirm_OnClick(_ sender: Any) {
        submitCode()
    }
    
    private func submitCode() {
        if (txt_VerificationCode.text?.isEmpty)! {
            ToastManager.alert(view: self.view_TopView, msg: "INVALID_VERIFICATION_CODE".localized())
            UIFunctionality.addShakyAnimation(elementToBeShake: self.txt_VerificationCode)
            return
        }
        
        if txt_VerificationCode.text != dtoBookingInformation.verificationCode {
            ToastManager.alert(view: view_TopView, msg: "INVALID_VERIFICATION_CODE".localized())
            return
        }
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        modelHandleBookingVerification.validateCode(appointment_ID: dtoBookingInformation.appointmentID)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        submitCode()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.SEGUE_TO_BOOKING_MANAGER {
            if let tabVC = segue.destination as? UITabBarController {
                Functionality.tabBarItemsLocalized(language: UserDefaults.standard.string(forKey: "lang") ?? "vi", tabVC: tabVC)
                tabVC.tabBar.items?[0].isEnabled = false
                tabVC.selectedIndex = 1
            }
        }
    }
    
    private func createTxtFieldBorder() {
        self.borderBottom = UIView(frame: CGRect(x: 0, y: self.txt_VerificationCode.bounds.height - 10, width: UIScreen.main.bounds.width - 56, height: 2.5))
        self.borderBottom.backgroundColor = ThemeColor
        
        self.txt_VerificationCode.addSubview(self.borderBottom)
    }
}
