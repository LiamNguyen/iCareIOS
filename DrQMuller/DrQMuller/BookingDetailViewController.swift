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

class BookingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SlideButtonDelegate {
    
    @IBOutlet private weak var lbl_Notification: UILabel!
    @IBOutlet private weak var view_TopView: UIView!
    @IBOutlet private weak var tableView_BookingTime: UITableView!
    @IBOutlet private weak var btn_DropDownDaysOfWeek: NiceButton!
    @IBOutlet private weak var slideBtn: MMSlidingButton!
    private var activityIndicator: UIActivityIndicatorView!
    private var activityIndicatorViewContainer: ActivityIndicatorViewContainer!
    
    private var modelHandelBookingDetail: ModelHandleBookingDetail!
    private var freeTimeDataSource = [String]()
    private let dropDown_DaysOfWeek = DropDown()
    private var staticArrayFromUserDefaults: DTOStaticArrayDataSource!
    private var daysOfWeekDataSource: [String]!
    //private var daysOfWeekDataSouceWithID: [String: String]! //Dictionary
    private var isEco = false
    private var isTypeFree = false
    private var dataHasReceive = false

    private var tupleBookingTime: (id: (day_ID: String, time_ID: String), value: (day: String, time: String))!
    
    private var presentWindow : UIWindow?
    private var messageView: UIView!
    
    private var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tupleBookingTime = (id: (day_ID: "", time_ID: ""), value: (day: "", time: ""))
        
//=========OBSERVING NOTIFICATION FROM ModelHandleBookingDetail=========
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "freeTimeDataSource"), object: nil, queue: nil, using: updateTable)
        
//=========OBSERING NOTIFICATION FROM PMHandleBooking FOR CHECKING BOOKING TIME EXISTENCY RESULT=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "existencyResult"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "existencyResult"), object: nil, queue: nil, using: onReceiveExistencyResult)
        
//=========SET VOUCHER MODELHANDELBOOKINGDETAIL=========
        if DTOBookingInformation.sharedInstance.voucher == "ECO Booking" {
            isEco = true
        }
        
        modelHandelBookingDetail = ModelHandleBookingDetail(isEco: isEco)
        
//=========DELEGATING TABLEVIEW=========

        self.tableView_BookingTime.dataSource = self
        self.tableView_BookingTime.delegate = self
        
//=========DELEGATING SLIDE BUTTON=========

        self.slideBtn.delegate = self
        self.slideBtn.buttonText = "Hoàn Tất"
        self.slideBtn.reset()
        
//=========CUSTOM STYLE FOR NOTIFICATION ICON=========

        let radius = min(lbl_Notification.frame.size.width, lbl_Notification.frame.size.height) / 2.0
        self.lbl_Notification.layer.cornerRadius = radius
        self.lbl_Notification.isHidden = true
        
//=========SET UP TOAST COLOR STYLE=========
        
        UIView.hr_setToastThemeColor(color: ToastColor)
//        presentWindow = UIApplication.shared.keyWindow
//        presentWindow!.makeToastActivity()

//=========HIDE TABLE VIEW=========
        
        self.tableView_BookingTime.isHidden = true
        
//=========RETRIEVE DAYS OF WEEK DATASOURCE=========
        
        self.staticArrayFromUserDefaults = APIHandleBooking.sharedInstace.pulledStaticArrayFromUserDefaults()
        
        self.daysOfWeekDataSource = staticArrayFromUserDefaults.daysOfWeekDisplayArray
        
//=========INITIALIZE ACTIVITY INDICATOR=========
        
        self.activityIndicatorViewContainer = ActivityIndicatorViewContainer()
        self.activityIndicator = activityIndicatorViewContainer.createActivityIndicator(view: self.view)
        
//=========SET TYPE=========
        
        if DTOBookingInformation.sharedInstance.type == "Tự do" {
            self.activityIndicator.startAnimating()
            isTypeFree = true
            
            self.tupleBookingTime.value.day = DTOBookingInformation.sharedInstance.exactDayOfWeek
            self.tupleBookingTime.id.day_ID = modelHandelBookingDetail.returnPreSelectedDayIDForTypeFree()
            
            modelHandelBookingDetail.bindFreeTimeDataSource(selectedDayOfWeek_ID: self.tupleBookingTime.id.day_ID)
        }
        
//=========BIND DAYS OF WEEK DATASOURCE TO DROPDOWN=========
        
        dropDownDaysOfWeekWiredUp()
    
    }
    
//=========UPDATE FREE TIME LIST WHEN RECEIVING RESPONSE FROM SERVER=========
    
    func updateTable(notification: Notification) {
        if dataHasReceive {
            return
        }
        if let userInfo = notification.userInfo {
            let freeTimeDataSource = userInfo["returnArrayDataSource"]! as! [String]
            
            self.freeTimeDataSource = freeTimeDataSource
            DispatchQueue.main.async {
                self.tableView_BookingTime.reloadData()
                
                let animation = CATransition()
                animation.type = kCATransitionFade
                animation.duration = 0.7
                
                self.activityIndicator.layer.add(animation, forKey: nil)
                self.activityIndicator.stopAnimating()

                self.tableView_BookingTime.layer.add(animation, forKey: nil)
                self.tableView_BookingTime.isHidden = false
                
                self.tableView_BookingTime.setContentOffset(CGPoint.zero, animated: true)
            }
            
            dataHasReceive = true
        }
    }
    
//=========RECEVING BOOKING TIME EXISTENCY RESULT=========
    
    func onReceiveExistencyResult(notification: Notification) {
        if let userInfo = notification.userInfo {
            let existencyResult = userInfo["returnExistencyResult"] as! String
            if existencyResult == "1" {
                DispatchQueue.main.sync {
                    ToastManager.sharedInstance.alert(view: self.view_TopView, msg: "Giờ đã bị đặt. Xin vui lòng chọn giờ khác.")
                }
            } else {
                let bookingTime = [self.tupleBookingTime.id.day_ID, self.tupleBookingTime.id.time_ID]
                
                DTOBookingInformation.sharedInstance.bookingTime.insert(bookingTime, at: DTOBookingInformation.sharedInstance.bookingTime.count)
                print(DTOBookingInformation.sharedInstance.bookingTime)
                DispatchQueue.main.async {
                    
                    ToastManager.sharedInstance.alert(view: self.view_TopView, msg: "Chọn thành công\n\(self.tupleBookingTime.value.day) - \(self.tupleBookingTime.value.time)")
                    
                    self.tableView_BookingTime.isHidden = true
                    self.btn_DropDownDaysOfWeek.setTitle("Chọn thứ trong tuần", for: .normal)
                    self.dropDown_DaysOfWeek.deselectRow(at: Int(self.tupleBookingTime.id.day_ID)! - 1)
                    self.tupleBookingTime.value.day = ""
                    
                //UPDATE NOTIFICATION LABEL
                
                    self.lbl_Notification.text = "1"
                    let notificationNumber = Int(self.lbl_Notification.text!)
                    if notificationNumber == 1 {
                        self.lbl_Notification.isHidden = false
                    }
                    
                }
            }
        }
    }
    
    @IBAction func btn_DropDownDaysOfWeek_OnClick(_ sender: Any) {
        if isTypeFree {
            return
        }
        dropDown_DaysOfWeek.show()
    }
    
//=========TABLE VIEW DELEGATE METHODS=========
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freeTimeDataSource.count
    }
    
//=========TABLE VIEW DELEGATE METHODS=========
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TimeTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimeTableViewCell
        
        let item = freeTimeDataSource[indexPath.row]
        
        cell.lbl_Time.text = item
        
        return cell
    }
    
//=========TABLE VIEW DELEGATE METHODS=========

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookingTime = DTOBookingInformation.sharedInstance.bookingTime
        
        if bookingTime.count == 3 {
            alertMessage_ThreeBookingsRestrict()
            
            return
        }
        
        if !bookingTime.isEmpty {
            for item in bookingTime {
                if item[0] == self.tupleBookingTime.id.day_ID {
                    ToastManager.sharedInstance.alert(view: view_TopView, msg: "Chỉ được đặt 1 giờ trong 1 ngày.\nQuý khách đã đặt \(self.tupleBookingTime.value.day).")
                    return
                }
            }
        }
        
        modelHandelBookingDetail.checkBookingTime(day_ID: self.tupleBookingTime.id.day_ID, chosenTime: freeTimeDataSource[indexPath.row])
        
        let time_ID = modelHandelBookingDetail.returnTimeID(chosenTime: freeTimeDataSource[indexPath.row])
        
        self.tupleBookingTime.id.time_ID = time_ID
        self.tupleBookingTime.value.time = freeTimeDataSource[indexPath.row]

    }
    
//=========SLIDE BUTTON_ONSLIDE=========
    
    func buttonStatus(_ status: String, sender: MMSlidingButton) {
        alertMessage_ThreeBookingsRestrict()
        print("Saved")
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
        
        dropDown_DaysOfWeek.dataSource = datasource
        
        if isTypeFree {
            btn_DropDownDaysOfWeek.setTitle(self.tupleBookingTime.value.day, for: .normal)
            dropDown_DaysOfWeek.selectRow(at: datasource.index(of: self.tupleBookingTime.value.day))
            return
        }
        
        dropDown_DaysOfWeek.anchorView = btn_DropDownDaysOfWeek
        
        dropDown_DaysOfWeek.selectionAction = { [unowned self] (index, item) in
            self.btn_DropDownDaysOfWeek.setTitle(item, for: .normal)
            
            if self.tupleBookingTime.value.day == item {
                return
            }
            
            self.tableView_BookingTime.isHidden = true
            self.activityIndicator.startAnimating()
            let day_ID = String(self.dropDown_DaysOfWeek.indexForSelectedRow! + 1)
            //OBSERVING NOTIFICATION FROM ModelHandleBookingDetail
            self.modelHandelBookingDetail.bindFreeTimeDataSource(selectedDayOfWeek_ID: day_ID)
            
            self.tupleBookingTime.id.day_ID = day_ID
            self.tupleBookingTime.value.day = item
            
            self.dataHasReceive = false
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
    
    func alertMessage_ThreeBookingsRestrict() {
        let message = "Quý khách đã đặt 3 giờ trong một tuần.\nXin vui lòng tiếp tục để hoàn tất lịch hẹn."
        
        let messageViewContainer = MessageViewContainer()
        self.messageView = messageViewContainer.createMessageViewContainer(parentView: self.view)
        
        ToastManager.sharedInstance.message(view: self.messageView, msg: message, duration: 3.5)
        
        self.timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.hideContainer), userInfo: nil, repeats: false)
    }
    
//========HANDLE MESSAGE VIEW CONTAINER=========
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let messageView = self.messageView {
            if messageView.center.x == UIScreen.main.bounds.width / 2 {
                hideContainer()
            }
        }
    }
    
    @objc private func hideContainer() {
        self.messageView.center = CGPoint(x: UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width, y: UIScreen.main.bounds.height / 4)
        self.timer.invalidate()
    }
    


    
//=========RETURN DAYS OF WEEK ARRAY =========
    
    //    private func returnArray(dictionary: [String: String]!) -> [String] {
    //        var resultArray = [String]()
    //
    //        if dictionary == nil {
    //            return resultArray
    //        }
    //
    //        for values in dictionary.values {
    //            resultArray.insert(values, at: resultArray.count)
    //        }
    //        return resultArray
    //    }
    
    
}
