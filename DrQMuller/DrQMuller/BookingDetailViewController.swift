//
//  BookingDetailViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /22/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class BookingDetailViewController: UIViewController
//, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet private weak var lbl_Notification: UILabel!
    @IBOutlet private weak var view_TopView: UIView!
    @IBOutlet private weak var tableView_BookingTime: UITableView!
    
    private var modelHandelBookingDetail = ModelHandleBookingDetail()
    private var allTimeDataSource: [String]!
    private var ecoTimeDataSource: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//=========OBSERVING NOTIFICATION FROM PMHandleBooking==========
    
    NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "arrayDataSource"), object: nil, queue: nil, using: bindDataSource)
    
//=========OBSERVING NOTIFICATION FROM PMHandleBooking OFFLINE DATASOURCE==========
    
    NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "arrayDataSourceOffline"), object: nil, queue: nil, using: bindDataSourceOffline)

//=========DELEGATING TABLE VIEW=========
        
//        self.tableView_BookingTime.delegate = self
//        self.tableView_BookingTime.dataSource = self
        
//=========CUSTOM STYLE FOR NOTIFICATION ICON=========

        let radius = min(lbl_Notification.frame.size.width, lbl_Notification.frame.size.height) / 2.0
        lbl_Notification.layer.cornerRadius = radius
        
//=========SET UP TOAST COLOR STYLE=========
        
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
            allTimeDataSource = dtoArrays?.allTimeDataSource
            ecoTimeDataSource = dtoArrays?.ecoTimeDataSource
            print("All Time: \(allTimeDataSource)")
            print("Eco Time: \(ecoTimeDataSource)")
        }
    }

    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
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
