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
    
    @IBOutlet weak var btn_CountriesDropDown: NiceButton!
    @IBOutlet weak var btn_CitiesDropDown: NiceButton!
    @IBOutlet weak var btn_DistrictsDropDown: NiceButton!
    @IBOutlet weak var btn_LocationsDropDown: NiceButton!
    @IBOutlet weak var btn_VouchersDropDown: NiceButton!
    @IBOutlet weak var btn_TypesDropDown: NiceButton!
    @IBOutlet weak var slideBtn_Next: MMSlidingButton!
    
//=========MARK: PROPERTIES=========
    
    let dropDown_Countries = DropDown()
    let dropDown_Cites = DropDown()
    let dropDown_Districts = DropDown()
    let dropDown_Locations = DropDown()
    let dropDown_Vouchers = DropDown()
    let dropDown_Types = DropDown()

//=========ARRAY OF ALL DROPDOWNS=========

    lazy var dropDowns: [DropDown] = {
       return [self.dropDown_Countries,
               self.dropDown_Cites,
               self.dropDown_Districts,
               self.dropDown_Locations,
               self.dropDown_Vouchers,
               self.dropDown_Types]
    }()
    
//=========VIEW DID LOAD FUNC=========
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//=========WIRED UP ALL DROPDOWNS=========

        dropDownAllWiredUp()
        
//=========SET DEFAULT DROPDOWN STYLE=========

        setupDefaultDropDown()
        
//=========DELEGATING slideBtn_Next=========
        
        self.slideBtn_Next.delegate  = self
        self.slideBtn_Next.reset()
        
    }
    
//=========TRANSITION TO START-END DATE VIEW CONTROLLER=========

    func buttonStatus(_ status:String, sender:MMSlidingButton) {
        self.performSegue(withIdentifier: "segue_BookingGeneralToStartEnDate", sender: self)
    }

//=========btn_CountriesDropDown DROPDOWN=========

    @IBAction func btn_CountriesDropDown_OnClick(_ sender: Any) {
        dropDown_Countries.show()
    }
    
//=========WIRED UP ALL DROPDOWNS=========
    
    func dropDownAllWiredUp() {
        dropDownCountriesWiredUp()
    }
    
//=========WIRED UP dropDown_Countries=========

    func dropDownCountriesWiredUp() {
        dropDown_Countries.anchorView = btn_CountriesDropDown

        //dropDown_Countries.bottomOffset = CGPoint(x: 0, y: btn_CountriesDropDown.bounds.height)
        dropDown_Countries.selectionAction = { [unowned self] (index, item) in
            self.btn_CountriesDropDown.setTitle(item, for: .normal)
        }
        dropDown_Countries.dataSource = ["Việt Nam - Vietnam", "Hàn Quốc - Korean", "Mỹ - America",
        "Canada - Canada", "Singapore - Singapore"]
            
//            , "Nhật Bản - Japan", "Thái Lan - Thailand", "Đức - German", "Pháp - Paris", "Ý - Italia", "Thuỵ Điển - Swedish", "Thuỵ Sĩ - Switzerland"]

    }
    
//=========WIRED UP dropDown_Countries=========


//=========WIRED UP dropDown_Countries=========


//=========WIRED UP dropDown_Countries=========


//=========WIRED UP dropDown_Countries=========


//=========WIRED UP dropDown_Countries=========

    
//=========DEFAULT DROPDOWN STYLE=========
    
    func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            $0.customCellConfiguration = nil
        }
        
        dropDowns.forEach { $0.dismissMode = .automatic }
        dropDowns.forEach { $0.direction = .any }
    }
    
}









