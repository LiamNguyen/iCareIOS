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
    private var selectedDay: String!
    
    private var presentWindow : UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//=========OBSERVING NOTIFICATION FROM ModelHandleBookingDetail=========
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "freeTimeDataSource"), object: nil, queue: nil, using: updateTable)
        
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
        lbl_Notification.layer.cornerRadius = radius
        
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
            self.selectedDay = DTOBookingInformation.sharedInstance.exactDayOfWeek
            let selectedDay_ID = modelHandelBookingDetail.returnPreSelectedDayIDForTypeFree()
            modelHandelBookingDetail.bindFreeTimeDataSource(selectedDayOfWeek_ID: selectedDay_ID)
        }
        
//=========BIND DAYS OF WEEK DATASOURCE TO DROPDOWN=========
        
        dropDownDaysOfWeekWiredUp()
    
    }
    
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
    
    @IBAction func btn_DropDownDaysOfWeek_OnClick(_ sender: Any) {
        if isTypeFree {
            return
        }
        dropDown_DaysOfWeek.show()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freeTimeDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TimeTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimeTableViewCell
        
        let item = freeTimeDataSource[indexPath.row]
        
        cell.lbl_Time.text = item
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(freeTimeDataSource[indexPath.row])
    }
    
    func buttonStatus(_ status: String, sender: MMSlidingButton) {
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
            btn_DropDownDaysOfWeek.setTitle(self.selectedDay, for: .normal)
            dropDown_DaysOfWeek.selectRow(at: datasource.index(of: self.selectedDay))
            return
        }
        
        dropDown_DaysOfWeek.anchorView = btn_DropDownDaysOfWeek
        
        dropDown_DaysOfWeek.selectionAction = { [unowned self] (index, item) in
            self.btn_DropDownDaysOfWeek.setTitle(item, for: .normal)
            if let selected = self.selectedDay {
                if selected == item {
                    return
                }
            }
            self.tableView_BookingTime.isHidden = true
            self.activityIndicator.startAnimating()
            let day_ID = String(self.dropDown_DaysOfWeek.indexForSelectedRow! + 1)
            //OBSERVING NOTIFICATION FROM ModelHandleBookingDetail
            self.modelHandelBookingDetail.bindFreeTimeDataSource(selectedDayOfWeek_ID: day_ID)
            self.selectedDay = item
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
