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
    @IBOutlet private weak var view_TopView: UIView!
    @IBOutlet private weak var picker_Gender: UIPickerView!
    @IBOutlet private weak var picker_Date: UIDatePicker!
    @IBOutlet private weak var slideBtn_Next: MMSlidingButton!
    @IBOutlet private weak var lbl_Title: UILabel!
    
    private var customerInformationController: CustomStyleCustomerInformation!
    private var picker_GenderDataSource = [String]()
    private var datePickerRange: DatePickerRange!
    private var networkViewManager: NetworkViewManager!
    private weak var networkCheckInRealTime: Timer?
    
    private var modelHandelCustomerInformation: ModelHandleCustomerInformation!
    
    private func updateUI() {
        lbl_Title.text = "CUSTOMER_INFO_PAGE_TITLE".localized()
        btn_FirstTab.setTitle("FIRST_TAB_BTN_TITLE".localized(), for: .normal)
        btn_SecondTab.setTitle("SECOND_TAB_BTN_TITLE".localized(), for: .normal)
        btn_ThirdTab.setTitle("THIRD_TAB_BTN_TITLE".localized(), for: .normal)
        
        picker_GenderDataSource = ["GENDER_MALE".localized(), "GENDER_FEMALE".localized()]
        
        picker_Date.locale = NSLocale.init(localeIdentifier: Functionality.getDatePickerLocale(language: UserDefaults.standard.string(forKey: "lang") ?? "vi")) as Locale
        
        self.slideBtn_Next.buttonText = "BTN_NEXT_TITLE".localized()
        
        self.slideBtn_Next.buttonUnlockedText = "SLIDE_BTN_UNLOCKED_TITLE".localized()
    }
    
    private struct StoryBoard {
        static let SEGUE_TO_LOGIN = "segue_CustomerInformationSecondTabToLogin"
        static let SEGUE_TO_FIRST_TAB = "segue_CustomerInformationSecondTabToFirstTab"
        static let SEGUE_TO_THIRD_TAB = "segue_CustomerInformationSecondTabToThirdTab"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        
        //=========FILL CHOSEN INFORMATION=========
        
        fillInformation()
        
        wiredUpNetworkChecking()
        
        //=========OBSERVING NOTIFICATION FROM PMHandleCustomerInformation=========
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SecondTabCustomerInformationViewController.onReceiveNecessaryInfoResponse(notification:)),
            name: Notification.Name(rawValue: "necessaryInfoResponse"),
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        informMessage(message: "OPTIONAL_INFO_MESSAGE".localized())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customerInformationController = CustomStyleCustomerInformation()
        self.networkViewManager = NetworkViewManager()
        self.modelHandelCustomerInformation = ModelHandleCustomerInformation()
        self.datePickerRange = DatePickerRange()
        
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
        
        self.slideBtn_Next.delegate = self
        self.slideBtn_Next.reset()

    }
    
    deinit {
        print("Second tab VC: Dead")
    }
    
    func onReceiveNecessaryInfoResponse(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let statusCode = userInfo[JsonPropertyName.statusCode] as? Int, let errorCode = userInfo[JsonPropertyName.errorCode] as? String {
                if statusCode != HttpStatusCode.success {
                    ToastManager.alert(view: view_TopView, msg: errorCode.localized())
                } else {
                    self.performSegue(withIdentifier: StoryBoard.SEGUE_TO_THIRD_TAB, sender: self)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        self.networkCheckInRealTime?.invalidate()
    }
    
    @IBAction func btn_Back_OnClick(_ sender: Any) {
        
//=========POP UP CONFIRM DIALOG=========
        
        DialogManager.confirmLogout(sender: self, segueIdentifier: StoryBoard.SEGUE_TO_LOGIN)
    }
    
//=========TRANSITION TO FIRST INFO PAGE=========
    
    @IBAction func btn_FirstTab_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: StoryBoard.SEGUE_TO_FIRST_TAB, sender: self)
    }
    
    
//=========TRANSITION TO THIRD INFO PAGE=========

    @IBAction func btn_ThirdTab_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: StoryBoard.SEGUE_TO_THIRD_TAB, sender: self)
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
        saveInfo()
    }
    
    private func saveInfo() {
        let step = JsonPropertyName.UiFillStep.necessary
        var gender = String()
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.language) == "vi" {
            gender = Functionality.translateGender(tranlate: picker_GenderDataSource[picker_Gender.selectedRow(inComponent: 0)], to: .EN)
        } else  {
            gender = picker_GenderDataSource[picker_Gender.selectedRow(inComponent: 0)]
        }
        
        DTOCustomerInformation.sharedInstance.customerInformationDictionary[JsonPropertyName.userDob] = picker_Date.date.shortDate
        DTOCustomerInformation.sharedInstance.customerInformationDictionary[JsonPropertyName.userGender] = gender
        
        modelHandelCustomerInformation.handleCustomerInformation(step: step, httpBody: DTOCustomerInformation.sharedInstance.returnHttpBody(step: step)!)
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

    private func fillInformation() {
        DispatchQueue.global(qos: .userInteractive).async {
            let customerInformation = DTOCustomerInformation.sharedInstance.customerInformationDictionary
            
            if let _ = customerInformation[JsonPropertyName.userDob] as? NSNull, let _ = customerInformation[JsonPropertyName.userGender] as? NSNull {
                return
            }
            
            let chosenDob = Functionality.convertDateFormatFromStringToDate(str: customerInformation[JsonPropertyName.userDob] as! String)!
            var gender = String()
            if UserDefaults.standard.string(forKey: UserDefaultKeys.language) == "vi" {
                gender = Functionality.translateGender(tranlate: customerInformation[JsonPropertyName.userGender] as! String, to: .VI)
            } else {
                gender = customerInformation[JsonPropertyName.userGender] as! String
            }
            DispatchQueue.main.async {
                self.picker_Gender.selectRow(self.picker_GenderDataSource.index(of: gender)!, inComponent: 0, animated: true)
                self.picker_Date.setDate(chosenDob, animated: true)
            }
        }
    }
    
    private func wiredUpNetworkChecking() {
        let tupleDetectNetworkReachabilityResult = Reachability.detectNetworkReachabilityObserver(parentView: self.view)
        networkViewManager = tupleDetectNetworkReachabilityResult.network
        networkCheckInRealTime = tupleDetectNetworkReachabilityResult.timer
    }
    
    private func informMessage(message: String) {
        let confirmDialog = UIAlertController(title: "INFORMATION_TITLE".localized(), message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        confirmDialog.addAction(UIAlertAction(title: "SKIP_TITLE".localized(), style: .default, handler: { (action: UIAlertAction!) in
            self.saveInfo()
        }))
        
        confirmDialog.addAction(UIAlertAction(title: "FILL_TITLE".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        self.present(confirmDialog, animated: true, completion: nil)
    }

    
}
