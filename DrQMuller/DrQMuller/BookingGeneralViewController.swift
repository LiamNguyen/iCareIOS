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
    
    private var modelHandleBooking = ModelHandleBookingGeneral()
    
//=========VIEW DID LOAD FUNC=========
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//=========WIRED UP ALL DROPDOWNS=========

        dropDownAllWiredUp()
        
//=========DELEGATING slideBtn_Next=========
        
        self.slideBtn_Next.delegate  = self
        self.slideBtn_Next.reset()
        //modelHandleBooking.btn
    }
    
//=========TRANSITION TO START-END DATE VIEW CONTROLLER=========

    func buttonStatus(_ status: String, sender: MMSlidingButton) {
        self.performSegue(withIdentifier: "segue_BookingGeneralToStartEnDate", sender: self)
    }

//=========btn_CountriesDropDown DROPDOWN=========

    @IBAction func btn_CountriesDropDown_OnClick(_ sender: Any) {
        //dropDown_Countries.show()
    }
    
//=========WIRED UP ALL DROPDOWNS=========
    
    func dropDownAllWiredUp() {
        //dropDownCountriesWiredUp()
    }

    
}









