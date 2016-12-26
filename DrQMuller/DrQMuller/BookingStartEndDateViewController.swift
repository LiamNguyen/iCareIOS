//
//  BookingStartEndDateViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /23/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class BookingStartEndDateViewController: UIViewController {
    
    @IBOutlet weak var slideBtn_Next: MMSlidingButton!
    @IBOutlet weak var lbl_StartDate: UILabel!
    @IBOutlet weak var lbl_EndDate: UILabel!
    @IBOutlet weak var picker_StartDate: UIDatePicker!
    @IBOutlet weak var picker_EndDate: UIDatePicker!
    @IBOutlet weak var constraint_SlideBtn_picker_StartDate: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
