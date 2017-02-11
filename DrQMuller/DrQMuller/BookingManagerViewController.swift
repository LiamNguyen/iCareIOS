//
//  BookingManagerViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /11/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class BookingManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView_Appointments: UITableView!
    @IBOutlet weak var constraint_TableViewHeight: NSLayoutConstraint!

    private var appoinmentDataSource = [DTOBookingInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView_Appointments.delegate = self
        tableView_Appointments.dataSource = self
        tableView_Appointments.separatorColor = ThemeColor
        
        bindAppointmentDataSource()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appoinmentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AppointmentTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CartBookingInfoTableViewCell
        
        let item = self.appoinmentDataSource[indexPath.row]
        
        cell.lbl_Voucher.text = item.voucher
        cell.lbl_Location.text = item.location
        cell.lbl_StartDate.text = item.startDate
        cell.lbl_EndDate.text = item.endDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(netHex: 0xFEDEFF)
    }
    
    private func bindAppointmentDataSource() {
//        var customerAppointment = [String: DTOBookingInformation]()
//        
//        let firstAppointment = DTOBookingInformation()
//        
//        firstAppointment.voucher = "ECO Booking1"
//        firstAppointment.location = "Trần Quang Diệu"
//        firstAppointment.startDate = "12/02/2016"
//        firstAppointment.endDate = "12/03/2016"
//        customerAppointment["Appointment 1"] = firstAppointment
//        
//        let secondAppointment = DTOBookingInformation()
//        
//        secondAppointment.voucher = "VIP Booking2"
//        secondAppointment.location = "Trần Quang Diệu"
//        secondAppointment.startDate = "21/02/2017"
//        secondAppointment.endDate = "12/03/2017"
//        customerAppointment["Appointment 2"] = secondAppointment
//        
//        let thirdAppointment = DTOBookingInformation()
//        
//        thirdAppointment.voucher = "VIP Booking3"
//        thirdAppointment.location = "Trần Quang Diệu"
//        thirdAppointment.startDate = "21/02/2017"
//        thirdAppointment.endDate = "12/03/2017"
//        customerAppointment["Appointment 3"] = thirdAppointment
//        
//        let fourthAppointment = DTOBookingInformation()
//        
//        fourthAppointment.voucher = "ECO Booking4"
//        fourthAppointment.location = "Trần Quang Diệu"
//        fourthAppointment.startDate = "12/02/2016"
//        fourthAppointment.endDate = "12/03/2016"
//        customerAppointment["Appointment 4"] = fourthAppointment
//        
//        DTOCustomerInformation.sharedInstance.customerAppointmentsDictionary = customerAppointment
//        
//        Functionality.pushToUserDefaults(arrayDataSourceObj: DTOCustomerInformation.sharedInstance, forKey: "1")
        
        if let appointments = Functionality.pulledStaticArrayFromUserDefaults(forKey: "1") as? DTOCustomerInformation {
            var keyArray = Array(appointments.customerAppointmentsDictionary.keys)
            keyArray = keyArray.sorted {$0 > $1}
            
            for item in keyArray {
                self.appoinmentDataSource.append(appointments.customerAppointmentsDictionary[item]!)
            }
        } else {
            DispatchQueue.main.async {
                self.addLabelForEmptyAppointment()
            }
        }

        updateAppointmentTableViewHeight()
    }
    
    private func updateAppointmentTableViewHeight() {
        let numberOfRows: CGFloat!
        let expectedTableViewHeight: CGFloat!
        
        if UIScreen.main.bounds.height == 480 && self.appoinmentDataSource.count > 2 {
            return
        }
        
        let rowHeight = self.tableView_Appointments.rowHeight

        if self.appoinmentDataSource.count > 3 {
            numberOfRows = 3
            expectedTableViewHeight = (rowHeight * numberOfRows) + 20
        } else {
            numberOfRows = CGFloat(self.appoinmentDataSource.count)
            expectedTableViewHeight = (rowHeight * numberOfRows)
        }
        
        self.constraint_TableViewHeight.constant = expectedTableViewHeight
    }
    
    private func addLabelForEmptyAppointment() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 70, height: 250))
        label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
        label.textColor = UIColor.gray
        label.text = "NO_APPOINTMENT_MESSAGE".localized()
        label.textAlignment = .center
        label.numberOfLines = 5
        
        self.view.addSubview(label)
    }
}
