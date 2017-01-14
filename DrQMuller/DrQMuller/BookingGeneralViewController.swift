//
//  BookingGeneralViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /22/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit
import QuartzCore
import DropDown

let ToastColor = UIColor(netHex: 0xE89D00)
let ThemeColor = UIColor(netHex: 0x8F00B3)
let ToastColorAlert = UIColor.red

class BookingGeneralViewController: UIViewController, SlideButtonDelegate {
    
    @IBOutlet private weak var btn_CountriesDropDown: NiceButton!
    @IBOutlet private weak var btn_CitiesDropDown: NiceButton!
    @IBOutlet private weak var btn_DistrictsDropDown: NiceButton!
    @IBOutlet private weak var btn_LocationsDropDown: NiceButton!
    @IBOutlet private weak var btn_VouchersDropDown: NiceButton!
    @IBOutlet private weak var btn_TypesDropDown: NiceButton!
    @IBOutlet private weak var slideBtn_Next: MMSlidingButton!
    @IBOutlet weak var view_TopView: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    
    //=========MARK: PROPERTIES=========
    
    private let dropDown_Countries = DropDown()
    private let dropDown_Cities = DropDown()
    private let dropDown_Districts = DropDown()
    private let dropDown_Locations = DropDown()
    private let dropDown_Vouchers = DropDown()
    private let dropDown_Types = DropDown()
    
    private let firstPhaseWithOneLocation = true
    
    private let lineDrawer = LineDrawer()
    
    //=========ARRAY OF ALL DROPDOWNS=========
    
    private lazy var dropDowns: [DropDown] = {
        return [self.dropDown_Countries,
                self.dropDown_Cities,
                self.dropDown_Districts,
                self.dropDown_Locations,
                self.dropDown_Vouchers,
                self.dropDown_Types]
    }()
    
    private var modelHandleBookingGeneral = ModelHandleBookingGeneral()
    
//=========VIEW DID LOAD FUNC=========
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_Title.text = "Booking General Information"
        self.btn_VouchersDropDown.setTitle("Select Vouchers", for: .normal)
        self.btn_TypesDropDown.setTitle("Select Types of Service", for: .normal)
        self.slideBtn_Next.buttonText = "Slide to continue"
        
//=========DELEGATING slideBtn_Next=========
        
        self.slideBtn_Next.delegate  = self
        //self.slideBtn_Next.buttonText = "Tiếp tục"
        self.slideBtn_Next.reset()
        
//=========OBSERVING NOTIFICATION FROM PMHandleBooking==========

        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "arrayDataSource"), object: nil, queue: nil, using: bindDataSource)
        
//=========OBSERVING NOTIFICATION FROM PMHandleBooking OFFLINE DATASOURCE==========
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "arrayDataSourceOffline"), object: nil, queue: nil, using: bindDataSourceOffline)
        
//=========SEND REQUEST TO GET DROPDOWNS DATASOURCE=========
        
        modelHandleBookingGeneral.getDropDownsDataSource()
        
//=========TOAST SET UP COLOR==========
        
        UIView.hr_setToastThemeColor(color: ToastColor)

        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//=========BINDING DATASOURCE FOR DROPDOWNS==========
    
    func bindDataSource(notification: Notification) {
        handleReceivedNotificationData(notification: notification, userInfoKey: "returnArrayDataSource")
    }
    
//=========BINDING DATASOURCE OFFLINE FOR DROPDOWNS==========
    
    func bindDataSourceOffline(notification: Notification) {
        handleReceivedNotificationData(notification: notification, userInfoKey: "returnArrayDataSourceOffline")
    }
    
//=========HANDLE RECEIVE DATA FROM NOTIFICATION==========
    
    func handleReceivedNotificationData(notification: Notification, userInfoKey: String) {
        if let userInfo = notification.userInfo {
            let dtoArrays = userInfo[userInfoKey] as? DTOStaticArrayDataSource
            
            dropDownAllWiredUp(countries: (dtoArrays?.dropDownCountriesDataSource)!, cities: (dtoArrays?.dropDownCitiesDataSource)!, districts: (dtoArrays?.dropDownDistrictsDataSource)!, locations: (dtoArrays?.dropDownLocationsDataSource)!, vouchers: (dtoArrays?.dropDownVouchersDataSource)!, types: (dtoArrays?.dropDownTypesDataSource)!)
        }
    }
    
//=========TRANSITION TO START-END DATE VIEW CONTROLLER=========

    func buttonStatus(_ status: String, sender: MMSlidingButton) {
        if dropDown_Vouchers.selectedItem == nil {
            //ToastManager.sharedInstance.alert(view: view_TopView, msg: "Xin vui lòng chọn Vouchers")
            ToastManager.sharedInstance.alert(view: view_TopView, msg: "Please choose Vouchers")
            slideBtn_Next.reset()
            return
        }
        
        if dropDown_Types.selectedItem == nil {
            //ToastManager.sharedInstance.alert(view: view_TopView, msg: "Xin vui lòng chọn Loại Dịch Vụ")
            ToastManager.sharedInstance.alert(view: view_TopView, msg: "Please choose Type of Service")
            slideBtn_Next.reset()
            return
        }
        
        DTOBookingInformation.sharedInstance.country = dropDown_Countries.selectedItem!
        DTOBookingInformation.sharedInstance.city = dropDown_Cities.selectedItem!
        DTOBookingInformation.sharedInstance.district = dropDown_Districts.selectedItem!
        DTOBookingInformation.sharedInstance.location = dropDown_Locations.selectedItem!
        DTOBookingInformation.sharedInstance.voucher = dropDown_Vouchers.selectedItem!
        DTOBookingInformation.sharedInstance.type = dropDown_Types.selectedItem!
        
        self.performSegue(withIdentifier: "segue_BookingGeneralToStartEnDate", sender: self)
    }

//=========btn_CountriesDropDown DROPDOWN=========

    @IBAction func btn_CountriesDropDown_OnClick(_ sender: Any) {
        if firstPhaseWithOneLocation {
            ToastManager.sharedInstance.alert(view: view_TopView, msg: "Hiện tại Dr.Q-Muller chỉ có 1 trung tâm tại Quận 3, Việt Nam")
            return
        }
        dropDown_Countries.show()
    }
    
//=========btn_CitiesDropDown DROPDOWN=========
    
    @IBAction func btn_CitiesDropDown_OnClick(_ sender: Any) {
        if firstPhaseWithOneLocation {
            ToastManager.sharedInstance.alert(view: view_TopView, msg: "Hiện tại Dr.Q-Muller chỉ có 1 trung tâm tại Quận 3, Việt Nam")
            return
        }
        dropDown_Cities.show()
    }
    
//=========btn_DistrictsDropDown DROPDOWN=========
    
    @IBAction func btn_DistrictsDropDown_OnClick(_ sender: Any) {
        if firstPhaseWithOneLocation {
            ToastManager.sharedInstance.alert(view: view_TopView, msg: "Hiện tại Dr.Q-Muller chỉ có 1 trung tâm tại Quận 3, Việt Nam")
            return
        }
        dropDown_Districts.show()
    }
    
//=========btn_LocationsDropDown DROPDOWN=========
    
    @IBAction func btn_LocationsDropDown_OnClick(_ sender: Any) {
        if firstPhaseWithOneLocation {
            ToastManager.sharedInstance.alert(view: view_TopView, msg: "Hiện tại Dr.Q-Muller chỉ có 1 trung tâm tại Quận 3, Việt Nam")
            return
        }
        dropDown_Locations.show()
    }
    
//=========btn_VouchersDropDown DROPDOWN=========
    
    @IBAction func btn_VouchersDropDown_OnClick(_ sender: Any) {
        dropDown_Vouchers.show()
    }
    
//=========btn_TypesDropDown DROPDOWN=========
    
    @IBAction func btn_TypesDropDown_OnClick(_ sender: Any) {
        dropDown_Types.show()
    }
    
//=========WIRED UP ALL DROPDOWNS=========
    
    private func dropDownAllWiredUp(countries: [String], cities: [String], districts: [String], locations: [String], vouchers: [String], types: [String]) {
        dropDownCountriesWiredUp(dataSource: countries)
        dropDownCitiesWiredUp(dataSource: cities)
        dropDownDistrictsWiredUp(dataSource: districts)
        dropDownLocationsWiredUp(dataSource: locations)
        dropDownVouchersWiredUp(dataSource: vouchers)
        dropDownTypesWiredUp(dataSource: types)
        
        DispatchQueue.main.async {
            self.btn_CountriesDropDown.setTitle(self.dropDown_Countries.selectedItem, for: .normal)
            self.btn_CitiesDropDown.setTitle(self.dropDown_Cities.selectedItem, for: .normal)
            self.btn_DistrictsDropDown.setTitle(self.dropDown_Districts.selectedItem, for: .normal)
            self.btn_LocationsDropDown.setTitle(self.dropDown_Locations.selectedItem, for: .normal)
        }
    }
    
//=========WIRED UP dropDown_Countries=========
    
    private func dropDownCountriesWiredUp(dataSource: [String]) {
        dropDown_Countries.anchorView = btn_CountriesDropDown
        
        dropDown_Countries.dataSource = dataSource
        dropDown_Countries.selectRow(at: 234)
        
        dropDown_Countries.selectionAction = { [unowned self] (index, item) in
            self.btn_CountriesDropDown.setTitle(item, for: .normal)
        }
    }
    
//=========WIRED UP dropDown_Cities=========
    
    private func dropDownCitiesWiredUp(dataSource: [String]) {
        dropDown_Cities.anchorView = btn_CitiesDropDown
        
        dropDown_Cities.dataSource = dataSource
        dropDown_Cities.selectRow(at: 57)
        
        dropDown_Cities.selectionAction = { [unowned self] (index, item) in
            self.btn_CitiesDropDown.setTitle(item, for: .normal)
        }
    }
    
//=========WIRED UP dropDown_Districts=========
    
    private func dropDownDistrictsWiredUp(dataSource: [String]) {
        dropDown_Districts.anchorView = btn_DistrictsDropDown
        
        dropDown_Districts.dataSource = dataSource
        dropDown_Districts.selectRow(at: 7)
        
        dropDown_Districts.selectionAction = { [unowned self] (index, item) in
            self.btn_DistrictsDropDown.setTitle(item, for: .normal)
        }
    }
    
    
//=========WIRED UP dropDown_Locations=========
    
    private func dropDownLocationsWiredUp(dataSource: [String]) {
        dropDown_Locations.anchorView = btn_LocationsDropDown
        
        dropDown_Locations.dataSource = dataSource
        dropDown_Locations.selectRow(at: 0)
        
        dropDown_Locations.selectionAction = { [unowned self] (index, item) in
            self.btn_LocationsDropDown.setTitle(item, for: .normal)
        }
    }
    
//=========WIRED UP dropDown_Vouchers=========
    
    private func dropDownVouchersWiredUp(dataSource: [String]) {
        dropDown_Vouchers.anchorView = btn_VouchersDropDown
        
        dropDown_Vouchers.dataSource = dataSource
        
        dropDown_Vouchers.selectionAction = { [unowned self] (index, item) in
            self.btn_VouchersDropDown.setTitle(item, for: .normal)
        }
    }
    
//=========WIRED UP dropDown_Types=========
    
    private func dropDownTypesWiredUp(dataSource: [String]) {
        dropDown_Types.anchorView = btn_TypesDropDown
        
        dropDown_Types.dataSource = dataSource
        
        dropDown_Types.selectionAction = { [unowned self] (index, item) in
            self.btn_TypesDropDown.setTitle(item, for: .normal)
        }
    }
    
    
//=========DEFAULT DROPDOWN STYLE=========
    
    private func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            $0.customCellConfiguration = nil
        }
        
        dropDowns.forEach { $0.dismissMode = .automatic }
        dropDowns.forEach { $0.direction = .any }
    }
}









