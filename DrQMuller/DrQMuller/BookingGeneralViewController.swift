//
//  BookingGeneralViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /22/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit
import QuartzCore

class BookingGeneralViewController: UIViewController {
    
    @IBOutlet weak var lbl_Notification: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//=========CUSTOM STYLE FOR NOTIFICATION ICON=========
        
        let radius = min(lbl_Notification.frame.size.width, lbl_Notification.frame.size.height) / 2.0
        lbl_Notification.layer.cornerRadius = radius

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
