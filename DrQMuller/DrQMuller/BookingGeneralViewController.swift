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
let ThemeBackGroundColor = UIColor(netHex: 0xFCECFF)
let ToastColorAlert = UIColor.red

class BookingGeneralViewController: UIViewController, SlideButtonDelegate {
    
    @IBOutlet private weak var btn_CountriesDropDown: NiceButton!
    @IBOutlet private weak var btn_CitiesDropDown: NiceButton!
    @IBOutlet private weak var btn_DistrictsDropDown: NiceButton!
    @IBOutlet private weak var btn_LocationsDropDown: NiceButton!
    @IBOutlet private weak var btn_VouchersDropDown: NiceButton!
    @IBOutlet private weak var btn_TypesDropDown: NiceButton!
    @IBOutlet private weak var icon_Type: UIImageView!
    @IBOutlet private weak var slideBtn_Next: MMSlidingButton!
    @IBOutlet private weak var view_TopView: UIView!
    @IBOutlet private weak var lbl_Title: UILabel!
    
    //=========MARK: PROPERTIES=========
    
    private let dropDown_Countries = DropDown()
    private let dropDown_Cities = DropDown()
    private let dropDown_Districts = DropDown()
    private let dropDown_Locations = DropDown()
    private let dropDown_Vouchers = DropDown()
    private let dropDown_Types = DropDown()
    
    private let firstPhaseWithOneLocation = true
    private var activityIndicator: UIActivityIndicatorView!
    private var language: String!
    
    private var networkViewManager = NetworkViewManager()
    private var networkCheckInRealTime: Timer!
    
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
    
    private func updateUI() {
        self.language = UserDefaults.standard.string(forKey: "lang")
        
        lbl_Title.text = "BOOKING_INFO_PAGE_TITLE".localized()
        slideBtn_Next.delegate = self
        slideBtn_Next.reset()
        slideBtn_Next.buttonText = "BTN_NEXT_TITLE".localized()
        slideBtn_Next.buttonUnlockedText = "SLIDE_BTN_UNLOCKED_TITLE".localized()
        
        btn_VouchersDropDown.setTitle("DROPDOWN_VOUCHER_TITLE".localized(), for: .normal)
        btn_TypesDropDown.setTitle("DROPDOWN_TYPE_TITLE".localized(), for: .normal)
    }
    
    private struct Storyboard {
        static let SEGUE_TO_BOOKING_MANAGER = "segue_BookingGeneralToBookingManager"
        static let SEGUE_TO_BOOKING_DATE = "segue_BookingGeneralToStartEnDate"
    }
    
//=========VIEW DID LOAD FUNC=========
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
//=========OBSERVING NOTIFICATION FROM PMHandleBooking==========

        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "arrayDataSource"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "arrayDataSource"), object: nil, queue: nil, using: bindDataSource)
        
//=========OBSERVING NOTIFICATION FROM PMHandleBooking OFFLINE DATASOURCE==========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "arrayDataSourceOffline"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "arrayDataSourceOffline"), object: nil, queue: nil, using: bindDataSourceOffline)
        
//=========SEND REQUEST TO GET DROPDOWNS DATASOURCE=========
        
        modelHandleBookingGeneral.getDropDownsDataSource()
        
//=========TOAST SET UP COLOR==========
        
        UIView.hr_setToastThemeColor(color: ToastColor)

        self.activityIndicator = UIFunctionality.createActivityIndicator(view: self.view)
        self.activityIndicator.startAnimating()
        
        self.btn_TypesDropDown.isHidden = true
        self.icon_Type.isHidden = true
        
        let tupleDetectNetworkReachabilityResult = Reachability.detectNetworkReachabilityObserver(parentView: self.view)
        networkViewManager = tupleDetectNetworkReachabilityResult.network
        networkCheckInRealTime = tupleDetectNetworkReachabilityResult.timer
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        networkCheckInRealTime.invalidate()
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
            DispatchQueue.global(qos: .userInteractive).async {
                let dtoArrays = userInfo[userInfoKey] as? DTOStaticArrayDataSource
                
                let locationsDisplayArray = Functionality.returnArrayFromDictionary(dictionary: dtoArrays?.dropDownLocationsDataSource, isReturnValue: true)
                let vouchersDisplayArray = Functionality.returnArrayFromDictionary(dictionary: dtoArrays?.dropDownVouchersDataSource, isReturnValue: true)
                let typesDisplayArray = Functionality.returnArrayFromDictionary(dictionary: dtoArrays?.dropDownTypesDataSource, isReturnValue: true)

                self.dropDownAllWiredUp(countries: (dtoArrays?.dropDownCountriesDataSource)!, cities: (dtoArrays?.dropDownCitiesDataSource)!, districts: (dtoArrays?.dropDownDistrictsDataSource)!, locations: locationsDisplayArray, vouchers: vouchersDisplayArray, types: typesDisplayArray)
                DispatchQueue.main.async {
                    self.activityIndicator.layer.add(AnimationManager.getAnimation_Fade(duration: 0.7), forKey: nil)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
//=========TRANSITION TO START-END DATE VIEW CONTROLLER=========

    func buttonStatus(_ status: String, sender: MMSlidingButton) {
        if dropDown_Vouchers.selectedItem == nil {
            ToastManager.alert(view: view_TopView, msg: "DROPDOWN_VOUCHER_EMPTY_MESSAGE".localized())
            slideBtn_Next.reset()
            return
        }
        
        if dropDown_Types.selectedItem == nil {
            ToastManager.alert(view: view_TopView, msg: "DROPDOWN_TYPE_EMPTY_MESSAGE".localized())
            slideBtn_Next.reset()
            return
        }
        
        DTOBookingInformation.sharedInstance.country = dropDown_Countries.selectedItem!
        DTOBookingInformation.sharedInstance.city = dropDown_Cities.selectedItem!
        DTOBookingInformation.sharedInstance.district = dropDown_Districts.selectedItem!
        DTOBookingInformation.sharedInstance.location = dropDown_Locations.selectedItem!
        DTOBookingInformation.sharedInstance.voucher = dropDown_Vouchers.selectedItem!
        
        var chosenType = dropDown_Types.selectedItem!
        
        if self.language == "en" {
            if chosenType == "Fix time" {
                chosenType = "Cố định"
            } else {
                chosenType = "Tự do"
            }
        }
        
        DTOBookingInformation.sharedInstance.type = chosenType
        
        self.performSegue(withIdentifier: Storyboard.SEGUE_TO_BOOKING_DATE, sender: self)
    }

//=========btn_CountriesDropDown DROPDOWN=========

    @IBAction func btn_CountriesDropDown_OnClick(_ sender: Any) {
        if firstPhaseWithOneLocation {
            ToastManager.alert(view: view_TopView, msg: "ONE_LOCATION_MESSAGE".localized())
            return
        }
        dropDown_Countries.show()
    }
    
//=========btn_CitiesDropDown DROPDOWN=========
    
    @IBAction func btn_CitiesDropDown_OnClick(_ sender: Any) {
        if firstPhaseWithOneLocation {
            ToastManager.alert(view: view_TopView, msg: "ONE_LOCATION_MESSAGE".localized())
            return
        }
        dropDown_Cities.show()
    }
    
//=========btn_DistrictsDropDown DROPDOWN=========
    
    @IBAction func btn_DistrictsDropDown_OnClick(_ sender: Any) {
        if firstPhaseWithOneLocation {
            ToastManager.alert(view: view_TopView, msg: "ONE_LOCATION_MESSAGE".localized())
            return
        }
        dropDown_Districts.show()
    }
    
//=========btn_LocationsDropDown DROPDOWN=========
    
    @IBAction func btn_LocationsDropDown_OnClick(_ sender: Any) {
        if firstPhaseWithOneLocation {
            ToastManager.alert(view: view_TopView, msg: "ONE_LOCATION_MESSAGE".localized())
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
        DispatchQueue.global(qos: .userInteractive).async {
            self.dropDownCountriesWiredUp(dataSource: countries)
            self.dropDownCitiesWiredUp(dataSource: cities)
            self.dropDownDistrictsWiredUp(dataSource: districts)
            self.dropDownLocationsWiredUp(dataSource: locations)
            self.dropDownVouchersWiredUp(dataSource: vouchers)
            self.dropDownTypesWiredUp(dataSource: types)
            
            DispatchQueue.main.async {
                self.btn_CountriesDropDown.setTitle(self.dropDown_Countries.selectedItem, for: .normal)
                self.btn_CitiesDropDown.setTitle(self.dropDown_Cities.selectedItem, for: .normal)
                self.btn_DistrictsDropDown.setTitle(self.dropDown_Districts.selectedItem, for: .normal)
                self.btn_LocationsDropDown.setTitle(self.dropDown_Locations.selectedItem, for: .normal)
            }
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
        
        dropDown_Districts.dataSource = getDistrictLocale(datasource: dataSource)
        dropDown_Districts.selectRow(at: 7)
        
        dropDown_Districts.selectionAction = { [unowned self] (index, item) in
            self.btn_DistrictsDropDown.setTitle(item, for: .normal)
        }
    }
    
//=========LOCALIZED DISTRICT DATASOURCE==========
    
    private func getDistrictLocale(datasource: [String]) -> [String] {
        var datasourceLocalized = [String]()
        
        for item in datasource {
            if self.language == "en" && item.contains("Quận") {
                let itemLocalized = item.replacingOccurrences(of: "Quận", with: "District")
                datasourceLocalized.append(itemLocalized)
            } else {
                datasourceLocalized.append(item)
            }
        }
        
        return datasourceLocalized
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
        
        dropDown_Types.dataSource = getTypeLocale(datasource: dataSource)

        if self.language == "vi" {
            dropDown_Types.selectRow(at: getTypeLocale(datasource: dataSource).index(of: "Tự do"))
        } else {
            dropDown_Types.selectRow(at: getTypeLocale(datasource: dataSource).index(of: "Free time"))
        }

        dropDown_Types.selectionAction = { [unowned self] (index, item) in
            self.btn_TypesDropDown.setTitle(item, for: .normal)
        }
    }

    private func getTypeLocale(datasource: [String]) -> [String] {
        if self.language == "en" {
            return ["Fix time", "Free time"]
        }
        return datasource
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.SEGUE_TO_BOOKING_MANAGER {
            if let tabVC = segue.destination as? UITabBarController {
                Functionality.tabBarItemsLocalized(language: UserDefaults.standard.string(forKey: "lang") ?? "vi", tabVC: tabVC)
                tabVC.tabBar.items?[0].isEnabled = false
                tabVC.selectedIndex = 1
            }
        }
    }
}









