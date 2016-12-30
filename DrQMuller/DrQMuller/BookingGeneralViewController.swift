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

class BookingGeneralViewController: UIViewController, SlideButtonDelegate {
    
    @IBOutlet private weak var btn_CountriesDropDown: NiceButton!
    @IBOutlet private weak var btn_CitiesDropDown: NiceButton!
    @IBOutlet private weak var btn_DistrictsDropDown: NiceButton!
    @IBOutlet private weak var btn_LocationsDropDown: NiceButton!
    @IBOutlet private weak var btn_VouchersDropDown: NiceButton!
    @IBOutlet private weak var btn_TypesDropDown: NiceButton!
    @IBOutlet private weak var slideBtn_Next: MMSlidingButton!
    
    //=========MARK: PROPERTIES=========
    
    private let dropDown_Countries = DropDown()
    private let dropDown_Cites = DropDown()
    private let dropDown_Districts = DropDown()
    private let dropDown_Locations = DropDown()
    private let dropDown_Vouchers = DropDown()
    private let dropDown_Types = DropDown()
    
    //=========ARRAY OF ALL DROPDOWNS=========
    
    private lazy var dropDowns: [DropDown] = {
        return [self.dropDown_Countries,
                self.dropDown_Cites,
                self.dropDown_Districts,
                self.dropDown_Locations,
                self.dropDown_Vouchers,
                self.dropDown_Types]
    }()
    
    private var modelHandleBookingGeneral = ModelHandleBookingGeneral()
    
//=========VIEW DID LOAD FUNC=========
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//=========SEND REQUEST TO GET DROPDOWNS DATASOURCE=========
        
        modelHandleBookingGeneral.getDropDownsDataSource()
        
//=========DELEGATING slideBtn_Next=========
        
        self.slideBtn_Next.delegate  = self
        self.slideBtn_Next.reset()
        
//=========OBSERVING NOTIFICATION FROM PMHandleBooking==========
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "arrayDataSource"), object: nil, queue: nil, using: bindDataSource)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//=========BINDING DATASOURCE FOR DROPDOWNS==========
    
    func bindDataSource(notification: Notification) {
        if let userInfo = notification.userInfo {
            let dtoArrays = userInfo["returnArrayDataSource"] as? DTOStaticArrayDataSource
            dropDownAllWiredUp(countries: (dtoArrays?.dropDownCountriesDataSource)!, vouchers: (dtoArrays?.dropDownCitiesDataSource)!, types: (dtoArrays?.dropDownTypesDataSource)!)
        }
    }
    
//=========TRANSITION TO START-END DATE VIEW CONTROLLER=========

    func buttonStatus(_ status: String, sender: MMSlidingButton) {
        self.performSegue(withIdentifier: "segue_BookingGeneralToStartEnDate", sender: self)
    }

//=========btn_CountriesDropDown DROPDOWN=========

    @IBAction func btn_CountriesDropDown_OnClick(_ sender: Any) {
        dropDown_Countries.show()
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
    
    private func dropDownAllWiredUp(countries: [String], vouchers: [String], types: [String]) {
        dropDownCountriesWiredUp(dataSource: countries)
        dropDownVouchersWiredUp(dataSource: vouchers)
        dropDownTypesWiredUp(dataSource: types)
        
        DispatchQueue.main.async {
            self.btn_CountriesDropDown.setTitle(self.dropDown_Countries.selectedItem, for: .normal)
            self.btn_VouchersDropDown.setTitle(self.dropDown_Vouchers.selectedItem, for: .normal)
            self.btn_TypesDropDown.setTitle(self.dropDown_Types.selectedItem, for: .normal)
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
    
    
//=========WIRED UP dropDown_Districts=========
    
    
//=========WIRED UP dropDown_Locations=========
    
    
//=========WIRED UP dropDown_Vouchers=========
    
    private func dropDownVouchersWiredUp(dataSource: [String]) {
        dropDown_Vouchers.anchorView = btn_VouchersDropDown
        
        dropDown_Vouchers.dataSource = dataSource
        dropDown_Vouchers.selectRow(at: 0)
        
        dropDown_Vouchers.selectionAction = { [unowned self] (index, item) in
            self.btn_VouchersDropDown.setTitle(item, for: .normal)
        }
    }
    
//=========WIRED UP dropDown_Types=========
    
    private func dropDownTypesWiredUp(dataSource: [String]) {
        dropDown_Types.anchorView = btn_TypesDropDown
        
        dropDown_Types.dataSource = dataSource
        dropDown_Types.selectRow(at: 0)
        
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









