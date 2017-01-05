//
//  BookingDetailViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /22/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class BookingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var lbl_Notification: UILabel!
    @IBOutlet private weak var view_TopView: UIView!
    @IBOutlet private weak var tableView_BookingTime: UITableView!
    
    private var modelHandelBookingDetail: ModelHandleBookingDetail!
    private var freeTimeDataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//=========OBSERVING NOTIFICATION FROM ModelHandleBookingDetail=========
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "freeTimeDataSource"), object: nil, queue: nil, using: updateTable)
        
//=========MODELHANDELBOOKINGDETAIL=========
        
        modelHandelBookingDetail = ModelHandleBookingDetail(isEco: false)
        
//=========OBSERVING NOTIFICATION FROM ModelHandleBookingDetail=========

        modelHandelBookingDetail.bindFreeTimeDataSource(selectedDayOfWeek_ID: "1")
        
//=========DELEGATING TABLEVIEW=========

        self.tableView_BookingTime.dataSource = self
        self.tableView_BookingTime.delegate = self
        
//=========CUSTOM STYLE FOR NOTIFICATION ICON=========

        let radius = min(lbl_Notification.frame.size.width, lbl_Notification.frame.size.height) / 2.0
        lbl_Notification.layer.cornerRadius = radius
        
//=========SET UP TOAST COLOR STYLE=========
        
        UIView.hr_setToastThemeColor(color: ToastColor)
    }
    
    func updateTable(notification: Notification) {
        if let userInfo = notification.userInfo {
            let freeTimeDataSource = userInfo["returnArrayDataSource"]! as! [String]
            
            self.freeTimeDataSource = freeTimeDataSource
            DispatchQueue.main.async {
                self.tableView_BookingTime.reloadData()
                
                //self.tableView(self.tableView_BookingTime, numberOfRowsInSection: freeTimeDataSource.count)
                
            }
            print(freeTimeDataSource)
        }
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
