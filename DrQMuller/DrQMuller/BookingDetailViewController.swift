//
//  BookingDetailViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /22/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class BookingDetailViewController: UIViewController {
    
    @IBOutlet weak var lbl_Notification: UILabel!
    private let ThemeColor   = UIColor(red: 255/255.0, green: 163/255.0, blue: 0/255.0, alpha: 1.0)
    private var presentWindow : UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//=========CUSTOM STYLE FOR NOTIFICATION ICON=========

        let radius = min(lbl_Notification.frame.size.width, lbl_Notification.frame.size.height) / 2.0
        lbl_Notification.layer.cornerRadius = radius
        edgesForExtendedLayout = UIRectEdge()
        UIView.hr_setToastThemeColor(color: ThemeColor)
        presentWindow = UIApplication.shared.keyWindow
    }
    
    @IBAction func btn_Toast_OnClick(_ sender: Any) {
        view.makeToast(message: "Simple Toast", duration: 2, position: HRToastPositionTop as AnyObject, title: "<Title>")
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
    
    
}
