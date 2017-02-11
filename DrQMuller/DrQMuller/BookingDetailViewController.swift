//
//  BookingDetailViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /22/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit
import QuartzCore
import DropDown

class BookingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SlideButtonDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet private weak var lbl_Notification: UILabel!
    @IBOutlet private weak var btn_ShowCart: UIImageView!
    
    @IBOutlet private weak var view_TopView: UIView!
    @IBOutlet private weak var view_ConfirmView: UIView!
    
    @IBOutlet private weak var tableView_BookingTime: UITableView!
    @IBOutlet private weak var tableView_CartOrder: UITableView!
    
    @IBOutlet private weak var btn_DropDownDaysOfWeek: NiceButton!
    @IBOutlet private weak var btn_DropDownMachines: NiceButton!
    
    @IBOutlet private weak var slideBtn: MMSlidingButton!
    @IBOutlet private weak var btn_ClearAllCartItems: UIButton!
    @IBOutlet private weak var constraint_CartOrderTableView_Height: NSLayoutConstraint!
    @IBOutlet private weak var btn_Back: UIButton!
    
    @IBOutlet private weak var lbl_Title: UILabel!
    @IBOutlet private weak var lbl_VoucherTitle: UILabel!
    @IBOutlet private weak var lbl_TypeTitle: UILabel!
    @IBOutlet private weak var lbl_LocationTitle: UILabel!
        
    private var activityIndicator: UIActivityIndicatorView!
    
    private var modelHandelBookingDetail: ModelHandleBookingDetail!
    private var freeTimeDataSource = [String]()
    
    private let dropDown_DaysOfWeek = DropDown()
    private let dropDown_Machines = DropDown()
    
    private var staticArrayFromUserDefaults: DTOStaticArrayDataSource!
    private var daysOfWeekDataSource: [String]!
    //private var daysOfWeekDataSouceWithID: [String: String]! //Dictionary
    private var machinesDataSource: [String]!
    
    private var isEco = false
    private var isTypeFree = false
    private var dataHasReceive = false

    private var tupleBookingTime_Array = [(id: (day_ID: String, time_ID: String), value: (day: String, time: String))]()
    
    private var tupleBookingTime: (id: (day_ID: String, time_ID: String), value: (day: String, time: String))!
    
    private var tupleBookingMachine: (id: String?, value: String?)
    
    private var presentWindow : UIWindow?
    private var messageView: UIView!
    
    private var timer: Timer!
    private var timer_bookingExpire: Timer?
    private var deleteCartOrderItemIndexPath: NSIndexPath? = nil
    private var dtoBookingTime: [[String]]!
    
    private var dropDownSelectedRowIndex: Int!
    private var isRequiredClearAllCartItems = false
    
    private var deletedTime: String!
    private var hasFinishedInThisPage = false
    private var language: String!
    private var addToCartAnimation_StartPosition: CGFloat?
    private var flyingView: UIView!
    
    private var networkViewManager = NetworkViewManager()
    private var networkCheckInRealTime: Timer!
    
    private func updateUI() {
        self.language = UserDefaults.standard.string(forKey: "lang")
        
        btn_Back.setTitle("BOOKING_INFO_PAGE_TITLE".localized(), for: .normal)
        slideBtn.buttonText = "BTN_FINISH_TITLE".localized()
        slideBtn.buttonUnlockedText = "SLIDE_BTN_UNLOCKED_TITLE".localized()
        btn_DropDownDaysOfWeek.setTitle("BTN_DROPDOWN_DAY_OF_WEEK".localized(), for: .normal)
        btn_ClearAllCartItems.setTitle("BTN_CLEAR_ALL_CART_ITEM".localized(), for: .normal)
        btn_ConfirmBooking.setTitle("CONFIRM_TITLE".localized(), for: .normal)
        
        lbl_Title.text = "BOOKING_INFO_PAGE_TITLE".localized()
        lbl_VoucherTitle.text = "LBL_VOUCHER_TITLE".localized()
        lbl_TypeTitle.text = "LBL_TYPE_TITLE".localized()
        lbl_LocationTitle.text = "LBL_LOCATION_TITLE".localized()
        lbl_BookingTime.text = "LBL_BOOKING_TIME_TITLE".localized()
        lbl_StartDateHeader.text = "LBL_START_DATE".localized() + ": "
        lbl_EndDateHeader.text = "LBL_END_DATE".localized() + ": "
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
//=========OBSERVING NOTIFICATION FROM ModelHandleBookingDetail=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "freeTimeDataSource"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "freeTimeDataSource"), object: nil, queue: nil, using: onReceiveFreeTimeDataSource)
        
//=========OBSERING NOTIFICATION FROM PMHandleBooking FOR CHECKING BOOKING TIME EXISTENCY RESULT=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "existencyResult"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "existencyResult"), object: nil, queue: nil, using: onReceiveExistencyResult)
        
//=========OBSERING NOTIFICATION FROM PMHandleReleaseTime=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "releaseTimeResponse"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "releaseTimeResponse"), object: nil, queue: nil, using: onReceiveReleaseTimeResponse)
        
//=========OBSERING NOTIFICATION FROM ModelHandleBookingDetail WHEN TIME_ID IS NIL=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "timeIDIsNil"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "timeIDIsNil"), object: nil, queue: nil, using: onHandleWhenTimeIDIsNil)
        
//=========OBSERING NOTIFICATION FROM AppDelegate WHEN Application is close=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "appResignActive"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "appResignActive"), object: nil, queue: nil, using: onBookingExpire)
        
//=========OBSERING NOTIFICATION FROM AppDelegate WHEN Application is close=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "appTerminate"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "appTerminate"), object: nil, queue: nil, using: onBookingExpire)
        
//=========OBSERING NOTIFICATION FROM PMHandleBooking WHEN NEW APPOINTMENT IS INSERTED OR NOT=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "insertAppointmentResponse"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "insertAppointmentResponse"), object: nil, queue: nil, using: onReceiveInsertAppointmentResponse)
        
//=========OBSERING NOTIFICATION FROM PMHandleBooking FOR MACHINES DATASOURCE=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "machinesDataSource"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "machinesDataSource"), object: nil, queue: nil, using: onReceiveMachinesDataSource)
        
//=========SET VOUCHER MODELHANDELBOOKINGDETAIL=========
        if DTOBookingInformation.sharedInstance.voucher == "ECO Booking" {
            isEco = true
        }
        
        modelHandelBookingDetail = ModelHandleBookingDetail(isEco: isEco)
        
//=========DELEGATING TABLEVIEW=========

        self.tableView_BookingTime.dataSource = self
        self.tableView_BookingTime.delegate = self
        
        self.tableView_CartOrder.dataSource = self
        self.tableView_CartOrder.delegate = self
        
        self.tableView_BookingTimeConfirm.dataSource = self
        self.tableView_BookingTimeConfirm.delegate = self
        self.tableView_BookingTimeConfirm.isUserInteractionEnabled = false
        
        self.tableView_BookingTime.isHidden = true
        self.tableView_CartOrder.isHidden = true
        
        decorateCartOrderTableView()
        
//=========DELEGATING SLIDE BUTTON=========

        self.slideBtn.delegate = self
        self.slideBtn.reset()
        
//=========CUSTOM STYLE FOR NOTIFICATION ICON=========

        let radius = min(lbl_Notification.frame.size.width, lbl_Notification.frame.size.height) / 2.0
        self.lbl_Notification.layer.cornerRadius = radius
        self.lbl_Notification.isHidden = true
        
//=========SET UP TOAST COLOR STYLE=========
        
        UIView.hr_setToastThemeColor(color: ToastColor)
        
//=========INITIALIZE ACTIVITY INDICATOR=========
        
        self.activityIndicator = UIFunctionality.createActivityIndicator(view: self.view)
        
//=========INITIALIZE TUPLE BOOKING TIME=========
        
        self.tupleBookingTime = (id: (day_ID: "", time_ID: ""), value: (day: "", time: ""))
        
//=========SET TYPE=========
        
        if DTOBookingInformation.sharedInstance.type == "Tự do" {
            self.isTypeFree = true
            
            self.tupleBookingTime.value.day = DTOBookingInformation.sharedInstance.exactDayOfWeek
            self.tupleBookingTime.id.day_ID = modelHandelBookingDetail.returnPreSelectedDayIDForTypeFree()
        }
        
//=========RETRIEVE MACHINES DATASOURCE=========
        
        if !self.activityIndicator.isAnimating {
            self.activityIndicator.startAnimating()
        }
        
        modelHandelBookingDetail.bindMachinesDataSource()
        
//=========RETRIEVE DAYS OF WEEK DATASOURCE=========
        
        self.staticArrayFromUserDefaults = APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()
        self.daysOfWeekDataSource = staticArrayFromUserDefaults.daysOfWeekDisplayArray
        
//=========BIND DAYS OF WEEK DATASOURCE TO DROPDOWN=========
        
        dropDownDaysOfWeekWiredUp()

//=========WIRED UP TAP RECOGNIZER FOR NOTIFICATION BUTTON=========
 
        setUpTapRecognitionForCartButton()
        
        dtoBookingTime = [[String]]()
        
        bindDataConfirmView()
        
        let tupleDetectNetworkReachabilityResult = Reachability.detectNetworkReachabilityObserver(parentView: self.view)
        networkViewManager = tupleDetectNetworkReachabilityResult.network
        networkCheckInRealTime = tupleDetectNetworkReachabilityResult.timer
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view_ConfirmView.center = CGPoint(x: self.view_ConfirmView.center.x + 400, y: self.view_ConfirmView.center.y)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        if !dtoBookingTime.isEmpty {
            modelHandelBookingDetail.releaseTime(timeObj: dtoBookingTime)
        }
        networkCheckInRealTime.invalidate()
    }
    
    
//=========UPDATE FREE TIME LIST WHEN RECEIVING RESPONSE FROM SERVER=========
    
    func onReceiveFreeTimeDataSource(notification: Notification) {
        if dataHasReceive {
            return
        }
        if let userInfo = notification.userInfo {
            DispatchQueue.global(qos: .userInteractive).async {

                let freeTimeDataSource = userInfo["returnArrayDataSource"]! as! [String]
                self.freeTimeDataSource = freeTimeDataSource
                self.dataHasReceive = true
                
                DispatchQueue.main.async {
                    self.tableView_BookingTime.reloadData()
                    
                    self.activityIndicator.layer.add(AnimationManager.getAnimation_Fade(duration: 0.7), forKey: nil)
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    self.tableView_BookingTime.layer.add(AnimationManager.getAnimation_Fade(duration: 0.7), forKey: nil)
                    self.tableView_BookingTime.isHidden = false
                    
                    self.tableView_BookingTime.setContentOffset(CGPoint.zero, animated: true)
                }
            }
        }
    }
    
//=========RECEVING BOOKING TIME EXISTENCY RESULT=========
    
    func onReceiveExistencyResult(notification: Notification) {
        if let userInfo = notification.userInfo {
            
            DispatchQueue.global(qos: .background).async {
                let existencyResult = userInfo["returnExistencyResult"] as! String
                if existencyResult == "1" {
                    DispatchQueue.main.sync {
                        self.activityIndicator.stopAnimating()
                        self.tableView_BookingTime.isUserInteractionEnabled = true
                        ToastManager.alert(view: self.view_TopView, msg: "BOOKING_TIME_HAS_EXISTED_MESSAGE".localized())
                    }
                } else {
                    let bookingTime = [self.tupleBookingTime.id.day_ID, self.tupleBookingTime.id.time_ID]
                    self.dtoBookingTime.insert(bookingTime, at: self.dtoBookingTime.count)
                    DTOBookingInformation.sharedInstance.bookingTime = self.dtoBookingTime
                    if let machine = self.tupleBookingMachine.value {
                        DTOBookingInformation.sharedInstance.machine = machine
                    }
                    print(DTOBookingInformation.sharedInstance.machine)
                    
                    self.tupleBookingTime_Array.insert(self.tupleBookingTime, at: self.tupleBookingTime_Array.count)
                    
                    DispatchQueue.main.async {
                        if self.dtoBookingTime.count == 1 {
                            self.timer_bookingExpire = Timer.scheduledTimer(timeInterval: 15 * 60, target: self, selector: #selector(self.onBookingTimeExpire), userInfo: nil, repeats: false)
                        }
                        
                        if !self.isTypeFree {
                            self.tableView_BookingTime.isHidden = true
                            self.btn_DropDownDaysOfWeek.setTitle("BTN_DROPDOWN_DAY_OF_WEEK".localized(), for: .normal)
                            
                            self.dropDown_DaysOfWeek.deselectRow(at: self.dropDownSelectedRowIndex)
                            self.dropDownSelectedRowIndex = nil

                        } else {
                            for i in 0 ..< self.freeTimeDataSource.count {
                                if self.freeTimeDataSource[i] == self.tupleBookingTime.value.time {
                                    self.freeTimeDataSource.remove(at: i)
                                    break
                                }
                            }
                            self.tableView_BookingTime.reloadData()
                        }
                        
                        self.tableView_CartOrder.reloadData()
                        self.tableView_BookingTimeConfirm.reloadData()
                        
                        //UPDATE NOTIFICATION LABEL
                        
                        self.lbl_Notification.text = String(self.dtoBookingTime.count)
                        let notificationNumber = Int(self.lbl_Notification.text!)
                        if notificationNumber == 1 {
                            self.lbl_Notification.isHidden = false
                        }

                        self.activityIndicator.stopAnimating()
                        if let startPosition = self.addToCartAnimation_StartPosition {
                            self.flyingView = UIFunctionality.createFlyingView(parentView: self.view, startPosition: startPosition)
                            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.viewSelfDestroy), userInfo: nil, repeats: false)
                        }
                        self.tableView_BookingTime.isUserInteractionEnabled = true
                        
                        let msg = ("\("BOOKING_TIME_SUCCESS_MESSAGE".localized())\n\(self.tupleBookingTime_Array[self.tupleBookingTime_Array.count - 1].value.day) - \(self.tupleBookingTime_Array[self.tupleBookingTime_Array.count - 1].value.time)")
                        
                        ToastManager.alert(view: self.view_TopView, msg: msg)
                        
                    }
                }
            }
        }
    }
    
//=========RECEVING INSERT APPOINTMENT RESPONSE=========
    
    func onReceiveInsertAppointmentResponse(notification: Notification) {
        if let userInfo = notification.userInfo {
            
            DispatchQueue.global(qos: .userInteractive).async {
                if let isOk = userInfo["status"] as? Bool {
                    if isOk {
                        DispatchQueue.main.async {
                            ToastManager.alert(view: self.view_ConfirmView, msg: "BOOKING_SUCCESS_MESSAGE".localized())
                        }
                    } else {
                        DispatchQueue.main.async {
                            ToastManager.alert(view: self.view_ConfirmView, msg: "BOOKING_FAIL_MESSAGE".localized())
                        }
                    }
                }
            }
        }
    }
    
//=========RECEVING RELEASE TIME RESPONSE=========
    
    func onReceiveReleaseTimeResponse(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let isOk = userInfo["status"] as? Bool {
                if isOk {
                    if self.isRequiredClearAllCartItems {
                        self.resetBookingTime()
                        self.isRequiredClearAllCartItems = false
                    } else {
                        updateLocalWhenDeleteOneItem()
                    }
                    
                    if self.tupleBookingMachine.value == DTOBookingInformation.sharedInstance.machine {
                        self.getFreeTimeDataSource()
                    } else {
                        self.activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                    }
                    
                    if self.hasFinishedInThisPage {
                        return
                    }
                    ToastManager.alert(view: view_TopView, msg: "DELETE_SUCCESS_MESSAGE".localized())
                } else {
                    ToastManager.alert(view: view_TopView, msg: "DELETE_FAIL_MESSAGE".localized())
                }
            }
        }
    }
    
//=========RECEVING MACHINES DATA SOURCE=========
    
    func onReceiveMachinesDataSource(notification: Notification) {
        if let userInfo = notification.userInfo {
            
            DispatchQueue.global(qos: .userInteractive).async {
                if let returnArrayDataSource = userInfo["returnArrayDataSource"] as? [String: String] {
                    let dataSource = Functionality.returnArrayFromDictionary(dictionary: returnArrayDataSource, isReturnValue: true)
                    self.dropDownMachinesWiredUp(dataSource: dataSource)
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func btn_DropDownDaysOfWeek_OnClick(_ sender: Any) {
        if isTypeFree {
            return
        }
        
        if self.tableView_CartOrder.isHidden == false {
            self.tableView_CartOrder.isHidden = true
        }
        dropDown_DaysOfWeek.show()
    }
    
    @IBAction func btn_DropDownMachines_OnClick(_ sender: Any) {
        if self.tableView_CartOrder.isHidden == false {
            self.tableView_CartOrder.isHidden = true
        }
        dropDown_Machines.show()
    }
    
    @IBAction func btn_ClearAllCartItem_OnClick(_ sender: Any) {
        self.isRequiredClearAllCartItems = true
        let alert = UIAlertController(title: "CONFIRM_TITLE".localized(), message: "CONFIRM_DELETE_MESSAGE".localized(), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "DELETE_EXECUTE_TITLE".localized(), style: .destructive, handler: { (action: UIAlertAction!) in
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            
            self.modelHandelBookingDetail.releaseTime(timeObj: self.dtoBookingTime)
        }))
        alert.addAction(UIAlertAction(title: "DIALOG_CANCEL_TITLE".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
//=========CLOSE CONFIRM BUTTON ONCLICK=========
    
    @IBAction func btn_CloseConfirm_OnClick(_ sender: Any) {
        self.slideBtn.reset()
        self.view_TopView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5) {
            self.view_ConfirmView.center = CGPoint(x: self.view_ConfirmView.center.x + 400, y: self.view_ConfirmView.center.y)
            self.view.backgroundColor = ThemeBackGroundColor
        }
    }
    
//=========TABLE VIEW DELEGATE METHODS=========
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView_CartOrder || tableView == self.tableView_BookingTimeConfirm {
        //CART ORDER TABLE VIEW AND CART ORDER CONFIRM TABLE VIEW
            return dtoBookingTime.count
        } else {
        //FREE TIME TABLE VIEW
            return freeTimeDataSource.count
        }
    }
    
//=========TABLE VIEW DELEGATE METHODS=========
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView_BookingTime {
        //FREE TIME TABLE VIEW
            let cellIdentifier = "TimeTableViewCell"
        
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimeTableViewCell
            
            let item = freeTimeDataSource[indexPath.row]
            
            cell.lbl_Time.text = item
            
            return cell
        } else if tableView == self.tableView_BookingTimeConfirm {
            //CART ORDER CONFIRM
            let cellIdentifier = "CartOrderConfirmTableViewCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CartOrderConfirmTableViewCell
            
            let itemDay = self.tupleBookingTime_Array[indexPath.row]
            
            cell.lbl_DayOfWeek.text = itemDay.value.day
            cell.lbl_Time.text = itemDay.value.time
            
            return cell
        } else {
        //CART ORDER TABLE VIEW
            let cellIdentifier = "CartOrderTableViewCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CartOrderTableViewCell
            
            let itemDay = self.tupleBookingTime_Array[indexPath.row]
            
            cell.lbl_DayOfWeek.text = itemDay.value.day
            cell.lbl_BookingTime.text = itemDay.value.time
            
            return cell
        }
    }
    
//=========TABLE VIEW DELEGATE METHODS=========

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView_BookingTime {
            
            let bookingTime = dtoBookingTime
            
            if bookingTime?.count == 3 {
                alertMessage(message: "FULL_BOOKING_TIME_MESSAGE".localized())
                return
            }
            
            if !(bookingTime?.isEmpty)! {
                for item in bookingTime! {
                    if item[0] == self.tupleBookingTime.id.day_ID {
                        alertMessage(message: "\("DUPLICATE_BOOKING_DAY_OF_WWEK_MESSAGE".localized())\(self.tupleBookingTime.value.day)")
                        return
                    }
                }
            }
            
            DispatchQueue.main.async {
                let rectForCell = tableView.rectForRow(at: indexPath)
                self.addToCartAnimation_StartPosition = tableView.convert(rectForCell, to: self.view).origin.y
            }
            
            self.activityIndicator.startAnimating()
            self.tableView_BookingTime.isUserInteractionEnabled = false
            
            if let machine_ID = self.tupleBookingMachine.id {
                modelHandelBookingDetail.checkBookingTime(day_ID: self.tupleBookingTime.id.day_ID, chosenTime: freeTimeDataSource[indexPath.row], chosenMachineID: machine_ID)
            }
                
            let time_ID = modelHandelBookingDetail.returnTimeID(chosenTime: freeTimeDataSource[indexPath.row])
            
            self.tupleBookingTime.id.time_ID = time_ID
            self.tupleBookingTime.value.time = freeTimeDataSource[indexPath.row]
        } else {
            self.tableView_CartOrder.isHidden = true
            if self.dropDown_DaysOfWeek.selectedItem != nil {
                self.tableView_BookingTime.isHidden = false
            }
            
            ToastManager.alert(view: view_TopView, msg: "DELETE_EACH_CART_ITEM_MESSAGE".localized())
        }

    }
    
//=========TABLE VIEW DELEGATE METHODS=========

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && tableView == self.tableView_CartOrder {
            self.deleteCartOrderItemIndexPath = indexPath as NSIndexPath?
            let rowToDelete = self.tupleBookingTime_Array[indexPath.row]
            confirmDelete(row: rowToDelete)
        }
    }
     
    private func confirmDelete(row: (id: (day_ID: String, time_ID: String), value: (day: String, time: String))) {
        let msg = "\("CONFIRM_DELETE_EACH_ITEM_MESSAGE_1ST_PART".localized())\(row.value.day) - \(row.value.time)\("CONFIRM_DELETE_EACH_ITEM_MESSAGE_2ND_PART".localized())"
        
        let alert = UIAlertController(title: "CONFIRM_TITLE".localized(), message: msg, preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "DELETE_EXECUTE_TITLE".localized(), style: .destructive, handler: handleDeleteCartItem)
        let CancelAction = UIAlertAction(title: "DIALOG_CANCEL_TITLE".localized(), style: .cancel, handler: cancelDeleteCartItem)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func handleDeleteCartItem(alertAction: UIAlertAction!) -> Void {
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        if let indexPath = deleteCartOrderItemIndexPath {
            let timeWillBeDeleted = [self.tupleBookingTime_Array[indexPath.row].id.day_ID, self.tupleBookingTime_Array[indexPath.row].id.time_ID]
            let timeArrayWillBeDeleted = [timeWillBeDeleted]
            self.modelHandelBookingDetail.releaseTime(timeObj: timeArrayWillBeDeleted)
            self.deletedTime = self.tupleBookingTime_Array[indexPath.row].value.time
        } else {
            print("indexPath is nil")
        }
    }
    
    private func updateLocalWhenDeleteOneItem() {
        if let indexPath = deleteCartOrderItemIndexPath {
            
            self.tableView_CartOrder.beginUpdates()
            
            dtoBookingTime.remove(at: indexPath.row)
            self.tupleBookingTime_Array.remove(at: indexPath.row)
            
            self.tableView_CartOrder.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            self.deleteCartOrderItemIndexPath = nil
            
            self.tableView_CartOrder.endUpdates()
            
//            self.freeTimeDataSource.append(self.deletedTime ?? "")
//            self.freeTimeDataSource.sort()
//            self.tableView_BookingTime.reloadData()

            self.tableView_BookingTimeConfirm.reloadData()
            
            self.lbl_Notification.text = String(Int(self.lbl_Notification.text!)! - 1)
            
            updateCartOrderTableViewHeight()
            
            if self.lbl_Notification.text == "0" {
                self.lbl_Notification.isHidden = true
                self.tableView_CartOrder.isHidden = true
                
                if self.dropDown_DaysOfWeek.selectedItem != nil {
                    self.tableView_BookingTime.isHidden = false
                }
            }
        }
    } 
    
    private func cancelDeleteCartItem(alertAction: UIAlertAction!) -> Void {
        self.deleteCartOrderItemIndexPath = nil
    }
    
//=========SLIDE BUTTON_ONSLIDE=========
    
    func buttonStatus(_ status: String, sender: MMSlidingButton) {
        self.slideBtn.reset()
        if self.tupleBookingTime_Array.isEmpty {
            ToastManager.alert(view: view_TopView, msg: "REQUIRE_BOOK_ATLEAST_ONE_TIME_MESSAGE".localized())
            return
        }
        self.view_TopView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.view_ConfirmView.center = CGPoint(x: self.view_ConfirmView.center.x - 400, y: self.view_ConfirmView.center.y)
        }
    }
    
    @IBAction func lbl_Back_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_BookingDetailToBookingGeneral", sender: self)
    }
    
    @IBAction func btn_Back_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_BookingDetailToBookingGeneral", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue_BookingDetailToBookingGeneral"){
            if let tabVC = segue.destination as? UITabBarController{
                Functionality.tabBarItemsLocalized(language: self.language, tabVC: tabVC)
                tabVC.tabBar.items?[0].isEnabled = false
                tabVC.selectedIndex = 1
            }
        }
    }
    
//=========WIRED UP DAYS OF WEEK DROPDOWN=========

    private func dropDownDaysOfWeekWiredUp() {
        var datasource = self.daysOfWeekDataSource!
        
//REMOVE SATURDAY AND SUNDAY IF ISECO
        if isEco && !isTypeFree {
            datasource.removeLast()
            datasource.removeLast()
        }
        
        dropDown_DaysOfWeek.dataSource = getDaysOfWeekLocalized(datasource: datasource)
        
        if isTypeFree {
            btn_DropDownDaysOfWeek.setTitle(self.tupleBookingTime.value.day, for: .normal)
            dropDown_DaysOfWeek.selectRow(at: datasource.index(of: self.tupleBookingTime.value.day))
            return
        }
        
        dropDown_DaysOfWeek.anchorView = btn_DropDownDaysOfWeek
        
        dropDown_DaysOfWeek.selectionAction = { [unowned self] (index, item) in
            self.btn_DropDownDaysOfWeek.setTitle(item, for: .normal)
            
            if self.tupleBookingTime.value.day == item && self.dropDownSelectedRowIndex != nil {
                return
            } 
            
            self.tableView_BookingTime.isHidden = true
            self.activityIndicator.startAnimating()
            let day_ID = String(self.dropDown_DaysOfWeek.indexForSelectedRow! + 1)
            //OBSERVING NOTIFICATION FROM ModelHandleBookingDetail
            //self.modelHandelBookingDetail.bindFreeTimeDataSource(selectedDayOfWeek_ID: day_ID)
            
            self.tupleBookingTime.id.day_ID = day_ID
            self.tupleBookingTime.value.day = item
            
            self.dropDownSelectedRowIndex = self.dropDown_DaysOfWeek.indexForSelectedRow
        
            self.dataHasReceive = false
        }
    }
    
//=========WIRED UP MACHINES DROPDOWN=========
    
    private func dropDownMachinesWiredUp(dataSource: [String]) {
        self.dropDown_Machines.dataSource = dataSource.sorted()
        self.dropDown_Machines.anchorView = btn_DropDownMachines
        self.dropDown_Machines.selectionAction = { [unowned self] (index, item) in
            self.btn_DropDownMachines.setTitle(item, for: .normal)
            
            let machine_ID = Functionality.findKeyFromValue(dictionary: DTOBookingInformation.sharedInstance.machinesDataSource, value: item)
            self.tupleBookingMachine.id = machine_ID
            self.tupleBookingMachine.value = item
            
            self.getFreeTimeDataSource()
        }
    }
    
    private func getFreeTimeDataSource() {
        self.tableView_BookingTime.isHidden = true
        self.activityIndicator.startAnimating()
        
        let day_ID = self.tupleBookingTime.id.day_ID
        let location_ID = Functionality.findKeyFromValue(dictionary: APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()!.dropDownLocationsDataSource, value: DTOBookingInformation.sharedInstance.location)
        if let machine_ID = self.tupleBookingMachine.id {
            self.modelHandelBookingDetail.bindFreeTimeDataSource(selectedDayOfWeek_ID: day_ID, location_ID: location_ID, machine_ID: machine_ID)
        }
        
        self.dataHasReceive = false
    }
    
    //LOCALIZED DAYS OF WEEK
    
    private func getDaysOfWeekLocalized(datasource: [String]) -> [String] {
        if self.language == "en" {
            return ["Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday",
                    "Sunday"]
        } else {
            return datasource
        }
    }
    
//=========DEFAULT DROPDOWN STYLE=========
    
    private func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        dropDown_DaysOfWeek.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
        dropDown_DaysOfWeek.customCellConfiguration = nil
        dropDown_DaysOfWeek.dismissMode = .automatic
        dropDown_DaysOfWeek.direction = .any
    }
    
//========CREATE MESSAGE VIEW CONTAINER=========
    
    private func alertMessage(message: String) {
        if self.messageView == nil {
            self.messageView = UIFunctionality.createMessageViewContainer(parentView: self.view)
        } else {
            if messageView.center.x == UIScreen.main.bounds.width / 2 {
                return
            }
            self.messageView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4 + 10)
        }
        
        ToastManager.message(view: self.messageView, msg: message, duration: 3.5)
        
        self.timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.hideContainer), userInfo: nil, repeats: false)
    }
    
//========HANDLE MESSAGE VIEW CONTAINER=========
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let messageView = self.messageView {
            if messageView.center.x == UIScreen.main.bounds.width / 2 {
                hideContainer()
            }
        }
        
        if self.tableView_CartOrder.isHidden == false {
            self.tableView_CartOrder.isHidden = true
            if self.dropDown_DaysOfWeek.selectedItem != nil {
                self.tableView_BookingTime.isHidden = false
            }
        }
    }
    
    @objc private func hideContainer() {
        self.messageView.center = CGPoint(x: UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width, y: UIScreen.main.bounds.height / 4)
        self.timer.invalidate()
    }
    

    private func setUpTapRecognitionForCartButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.btn_ShowCart_OnClick))
        tap.numberOfTapsRequired = 1
        self.btn_ShowCart.isUserInteractionEnabled = true
        self.btn_ShowCart.addGestureRecognizer(tap)
    }
    
    @objc private func btn_ShowCart_OnClick() {
        
        if dtoBookingTime.count < 1 {
            ToastManager.alert(view: view_TopView, msg: "CART_ORDER_EMPTY_MESSAGE".localized())
            return
        }
        
        if self.tableView_CartOrder.isHidden == true {
            updateCartOrderTableViewHeight()
            
            
            self.tableView_CartOrder.isHidden = false
            
            if self.dropDown_DaysOfWeek.selectedItem != nil {
                self.tableView_BookingTime.isHidden = true
            }
        } else {
            self.tableView_CartOrder.isHidden = true
            
            if self.dropDown_DaysOfWeek.selectedItem != nil {
                self.tableView_BookingTime.isHidden = false
            }
        }
    }
    
    private func updateCartOrderTableViewHeight() {
        let rowHeight = self.tableView_CartOrder.rowHeight
        let numberOfRows = CGFloat(self.tupleBookingTime_Array.count)
        let expectedTableViewHeight = (rowHeight * numberOfRows) + 32
        self.constraint_CartOrderTableView_Height.constant = expectedTableViewHeight
    }

//=========RESET ALL BOOKING TIME AND RELEASE CART ITEM=========
    
    private func resetBookingTime() {
        self.tableView_CartOrder.isHidden = true

        self.lbl_Notification.text = "0"
        self.lbl_Notification.isHidden = true
        
        if isTypeFree {
            self.tableView_BookingTime.isHidden = false
//            self.freeTimeDataSource.append(self.tupleBookingTime_Array[0].value.time)
//            self.freeTimeDataSource.sort()
//            self.tableView_BookingTime.reloadData()
        } else {
            self.tableView_BookingTime.isHidden = true
            self.btn_DropDownDaysOfWeek.setTitle("BTN_DROPDOWN_DAY_OF_WEEK".localized(), for: .normal)
            self.dropDown_DaysOfWeek.deselectRow(at: self.dropDownSelectedRowIndex)
            self.dropDownSelectedRowIndex = nil
        }
        updateCartOrderTableViewHeight()
        print(self.tupleBookingTime_Array)
        self.tupleBookingTime_Array.removeAll()
        dtoBookingTime.removeAll()
        DTOBookingInformation.sharedInstance.bookingTime.removeAll()
        
    }
     
    private func decorateCartOrderTableView() {
        self.tableView_CartOrder.layer.shadowColor = UIColor.black.cgColor
        self.tableView_CartOrder.layer.shadowOffset = CGSize.zero
        self.tableView_CartOrder.layer.shadowOpacity = 0.7
        self.tableView_CartOrder.layer.shadowRadius = 10
    }
    
    private func onHandleWhenTimeIDIsNil(notification: Notification) {
        ToastManager.alert(view: view_TopView, msg: "RETRY_MESSAGE".localized())
    }
    
    private func onBookingExpire(notification: Notification) {
        onBookingTimeExpire()
    }
    
    @objc private func onBookingTimeExpire() {
        if dtoBookingTime.count < 1 {
            print("Not doing anything")
            return
        }
        
        if self.view_ConfirmView.center.x == self.view_ConfirmView.center.x - 400 {
            UIView.animate(withDuration: 0.5) {
                self.view_ConfirmView.center = CGPoint(x: self.view_ConfirmView.center.x + 400, y: self.view_ConfirmView.center.y)
                self.view.backgroundColor = ThemeBackGroundColor
            }
        }
        self.slideBtn.reset()
        self.view_TopView.isUserInteractionEnabled = true
        self.view.backgroundColor = ThemeBackGroundColor
        self.isRequiredClearAllCartItems = true
        modelHandelBookingDetail?.releaseTime(timeObj: dtoBookingTime)
        self.timer_bookingExpire?.invalidate()
        print("Clear all cart items")
    }
    
    @IBOutlet weak var lbl_Voucher: UILabel!
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_StartDateHeader: UILabel!
    @IBOutlet weak var lbl_StartDate: UILabel!
    @IBOutlet weak var lbl_EndDateHeader: UILabel!
    @IBOutlet weak var lbl_EndDate: UILabel!
    @IBOutlet weak var btn_ConfirmBooking: UIButton!
    @IBOutlet weak var lbl_BookingTime: UILabel!
    
    @IBOutlet weak var tableView_BookingTimeConfirm: UITableView!
    
    private func bindDataConfirmView() {
        let bookingInfo = DTOBookingInformation.sharedInstance
        self.lbl_Voucher.text = bookingInfo.voucher
        self.lbl_Location.text = bookingInfo.location
        
        var type = bookingInfo.type
        
        if self.language == "en" {
            if type == "Cố định" {
                type = "Fix time"
            } else {
                type = "Free time"
            }
        }
        
        self.lbl_Type.text = type
        if isTypeFree {
            self.lbl_StartDateHeader.text = "\("LBL_EXACT_DATE".localized()): "
            self.lbl_StartDate.text = Functionality.convertDateFormatFromStringToDate(str: bookingInfo.exactDate)?.shortDateVnFormatted
            self.lbl_EndDateHeader.isHidden = true
            self.lbl_EndDate.isHidden = true
        } else {
            self.lbl_StartDateHeader.text = "\("LBL_START_DATE".localized()): "
            self.lbl_EndDate.isHidden = false
            self.lbl_EndDateHeader.isHidden = false
            self.lbl_StartDate.text = Functionality.convertDateFormatFromStringToDate(str: bookingInfo.startDate)?.shortDateVnFormatted
            self.lbl_EndDate.text = Functionality.convertDateFormatFromStringToDate(str: bookingInfo.endDate)?.shortDateVnFormatted
        }
    }
    
    @IBAction func btn_ConfirmBooking_OnClick(_ sender: Any) {
        modelHandelBookingDetail.insertNewAppointment()
    }
    
    @objc private func viewSelfDestroy() {
        if let flyingView = self.flyingView {
            flyingView.removeFromSuperview()
        }
    }
}


