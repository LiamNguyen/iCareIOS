//
//  BookingManagerDetailViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /12/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class BookingManagerDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Voucher_Title: UILabel!
    @IBOutlet weak var lbl_Type_Title: UILabel!
    @IBOutlet weak var lbl_StartDate_Title: UILabel!
    @IBOutlet weak var lbl_EndDate_Title: UILabel!
    @IBOutlet weak var lbl_Location_Title: UILabel!
    @IBOutlet weak var lbl_BookingTime_Title: UILabel!
    
    @IBOutlet weak var lbl_Voucher: UILabel!
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_StartDate: UILabel!
    @IBOutlet weak var lbl_EndDate: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var tableView_BookingTime: UITableView!
    
    @IBOutlet weak var btn_CancelAppointment: UIButton!
    @IBOutlet weak var btn_Return: UIButton!
    
    private var activityIndicator: UIActivityIndicatorView!
    
    private var language: String?
    private var isTypeFree = false
    
    private var modelHandleBookingManagerDetail: ModelHandleBookingManagerDetail!
    
    var dtoBookingInformation: DTOBookingInformation!
    
    private var networkViewManager: NetworkViewManager!
    private weak var networkCheckInRealTime: Timer?
    
    private func updateUI() {
        self.language = UserDefaults.standard.string(forKey: "lang")

        lbl_Title.text = "BOOKING_INFO_PAGE_TITLE".localized()
        lbl_Voucher_Title.text = "LBL_VOUCHER_TITLE".localized()
        lbl_Type_Title.text = "LBL_TYPE_TITLE".localized()
        lbl_Location_Title.text = "LBL_LOCATION_TITLE".localized()
        lbl_BookingTime_Title.text = "LBL_BOOKING_TIME_TITLE".localized()
        lbl_StartDate_Title.text = "LBL_START_DATE".localized() + ": "
        lbl_EndDate_Title.text = "LBL_END_DATE".localized() + ": "
        
        btn_CancelAppointment.setTitle("DIALOG_CANCEL_TITLE".localized(), for: .normal)
        btn_Return.setTitle("RETURN_TITLE".localized(), for: .normal)
    }
    
    private struct Storyboard {
        static let SEGUE_TO_BOOKING_MANAGER = "segue_BookingManagerDetailToBookingManager"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(BookingManagerDetailViewController.onReceiveCancelAppointmentResponse(notification:)),
            name: Notification.Name(rawValue: "cancelAppointment"),
            object: nil
        )
        
        updateUI()

        wiredUpNetworkChecking()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelHandleBookingManagerDetail = ModelHandleBookingManagerDetail()
        networkViewManager = NetworkViewManager()
        
        
        self.activityIndicator = UIFunctionality.createActivityIndicator(view: self.view)
        self.activityIndicator.stopAnimating()
        
        if dtoBookingInformation.type == "Tự do" {
            self.isTypeFree = true
        }
        
        bindData()
        
        self.tableView_BookingTime.delegate = self
        self.tableView_BookingTime.dataSource = self
        self.tableView_BookingTime.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.networkCheckInRealTime?.invalidate()
    }
    
    deinit {
        print("Booking Manager Detail VC: Dead")
    }
    
    func onReceiveCancelAppointmentResponse(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let isOk = userInfo["status"] as? Bool {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
                if isOk {
                    DispatchQueue.main.async {
                        self.informMessage(message: "CANCEL_APPOINTMENT_SUCCESS_MESSAGE".localized())
                        self.modelHandleBookingManagerDetail.removeAppointmentFromUserDefault(appointment_ID: self.dtoBookingInformation.appointmentID)
                    }
                } else {
                    ToastManager.alert(view: self.view, msg: "CANCEL_APPOINTMENT_FAIL_MESSAGE".localized())
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bookingTime = dtoBookingInformation.bookingTime
        
        return bookingTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CartOrderConfirmTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CartOrderConfirmTableViewCell
        
        let tupleBookingTime_Array = modelHandleBookingManagerDetail.returnTupleOfArrayFromArrayOfDictionary(array: dtoBookingInformation.bookingTime)
        
        var itemDay = tupleBookingTime_Array[indexPath.row]
        
        if self.language == "en" {
            itemDay.day = Functionality.translateDaysOfWeek(translate: itemDay.day, to: .EN)
        }
        
        cell.lbl_DayOfWeek.text = itemDay.day
        cell.lbl_Time.text = itemDay.time
        
        return cell
    }

    @IBAction func btn_CancelAppointment_OnClick(_ sender: Any) {
        let confirmDialog = UIAlertController(title: "WARNING_TITLE".localized(), message: "CANCEL_APPOINTMENT_CONFIRMATION_MESSAGE".localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        confirmDialog.addAction(UIAlertAction(title: "CONFIRM_TITLE".localized(), style: .default, handler: { (action: UIAlertAction?) in
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            
            self.modelHandleBookingManagerDetail.cancelAppointment(appointment_ID: self.dtoBookingInformation.appointmentID)
        }))
        
        confirmDialog.addAction(UIAlertAction(title: "DIALOG_CANCEL_TITLE".localized(), style: .cancel, handler: { (action: UIAlertAction?) in

        }))
        
        self.present(confirmDialog, animated: true, completion: nil)
    }
    @IBAction func btn_Return_Onclick(_ sender: Any) {
        self.performSegue(withIdentifier: Storyboard.SEGUE_TO_BOOKING_MANAGER, sender: self)
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
    
    func informMessage(message: String) {
        let confirmDialog = UIAlertController(title: "INFORMATION_TITLE".localized(), message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        confirmDialog.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction?) in
            self.performSegue(withIdentifier: Storyboard.SEGUE_TO_BOOKING_MANAGER, sender: self)
        }))
        
        self.present(confirmDialog, animated: true, completion: nil)
    }

    private func bindData() {
        let bookingInfo = dtoBookingInformation!
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
            self.lbl_StartDate_Title.text = "\("LBL_EXACT_DATE".localized()): "
            self.lbl_StartDate.text = Functionality.convertDateFormatFromStringToDate(str: bookingInfo.exactDate)?.shortDateVnFormatted
            self.lbl_EndDate_Title.isHidden = true
            self.lbl_EndDate.isHidden = true
        } else {
            self.lbl_StartDate_Title.text = "\("LBL_START_DATE".localized()): "
            self.lbl_EndDate.isHidden = false
            self.lbl_EndDate_Title.isHidden = false
            self.lbl_StartDate.text = Functionality.convertDateFormatFromStringToDate(str: bookingInfo.startDate)?.shortDateVnFormatted
            self.lbl_EndDate.text = Functionality.convertDateFormatFromStringToDate(str: bookingInfo.endDate)?.shortDateVnFormatted
        }
    }
    
    private func wiredUpNetworkChecking() {
        let tupleDetectNetworkReachabilityResult = Reachability.detectNetworkReachabilityObserver(parentView: self.view)
        networkViewManager = tupleDetectNetworkReachabilityResult.network
        networkCheckInRealTime = tupleDetectNetworkReachabilityResult.timer
    }
}
