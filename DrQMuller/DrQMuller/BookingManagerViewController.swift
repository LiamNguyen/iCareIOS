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
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var view_TopView: UIView!
    
    private var modelHandleBookingManger = ModelHandleBookingManager()
    private var appoinmentDataSource = [DTOBookingInformation]()
    
    private func updateUI() {
        lbl_Title.text = "BOOKING_MANAGER_PAGE_TITLE".localized()
    }
    
    private struct Storyboard {
        static let CELL_IDENTIFIER_APPOINTMENT_TBLVIEW = "AppointmentTableViewCell"
        static let SEGUE_TO_BOOKING_MANAGER_DETAIL = "segue_BookingManagerToBookingManagerDetail"
        static let SEGUE_TO_BOOKING_VERIFICATION = "segue_BookingManagerToBookingVerification"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        tableView_Appointments.delegate = self
        tableView_Appointments.dataSource = self
        tableView_Appointments.separatorColor = ThemeColor
        
        modelHandleBookingManger.validateAppointment()
        
        bindAppointmentDataSource()
        
        print("\nBooking Manager VC ONLOAD: ")
        DTOBookingInformation.sharedInstance.printBookingInfo()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appoinmentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = Storyboard.CELL_IDENTIFIER_APPOINTMENT_TBLVIEW
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CartBookingInfoTableViewCell
        
        let item = self.appoinmentDataSource[indexPath.row]
        
        cell.lbl_Voucher_Title.text = "LBL_VOUCHER_TITLE".localized()
        cell.lbl_Location_Title.text = "LBL_LOCATION_TITLE".localized() + ": "
        cell.lbl_StartDate_Title.text = "LBL_START_DATE".localized() + ": "
        cell.lbl_EndDate_Title.text = "LBL_END_DATE".localized() + ": "
        cell.lbl_Status_Title.text = "LBL_STATUS_TITLE".localized()
        
        cell.lbl_Voucher.text = item.voucher
        cell.lbl_Location.text = item.location
        cell.lbl_Status.text = returnDisplayValueForStatus(isConfirmed: item.isConfirmed)
        
        if !item.startDate.isEmpty {
            cell.lbl_StartDate.text = Functionality.convertDateFormatFromStringToDate(str: item.startDate)?.shortDateVnFormatted
            cell.lbl_EndDate.text = Functionality.convertDateFormatFromStringToDate(str: item.endDate)?.shortDateVnFormatted
        } else {
            cell.lbl_StartDate_Title.text = "LBL_EXACT_DATE".localized()
            cell.lbl_StartDate.text = Functionality.convertDateFormatFromStringToDate(str: item.exactDate)?.shortDateVnFormatted
            cell.lbl_EndDate_Title.isHidden = true
            cell.lbl_EndDate.isHidden = true
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)! as! CartBookingInfoTableViewCell
        selectedCell.contentView.backgroundColor = UIColor(netHex: 0xFEDEFF)
        
        let dtoBookingInfo = self.appoinmentDataSource[indexPath.row]
        print("Sending appointment_ID: \(dtoBookingInfo.appointmentID)")
        if selectedCell.lbl_Status.text == "Confirmed" || selectedCell.lbl_Status.text == "Đã xác nhận" {
            self.performSegue(withIdentifier: Storyboard.SEGUE_TO_BOOKING_MANAGER_DETAIL, sender: dtoBookingInfo)
        } else {
            self.performSegue(withIdentifier: Storyboard.SEGUE_TO_BOOKING_VERIFICATION, sender: dtoBookingInfo)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.SEGUE_TO_BOOKING_MANAGER_DETAIL {
            let bookingManagerDetail = segue.destination as! BookingManagerDetailViewController
            let data = sender as! DTOBookingInformation
            bookingManagerDetail.dtoBookingInformation = data
        } else if segue.identifier == Storyboard.SEGUE_TO_BOOKING_VERIFICATION {
            let bookingVerification = segue.destination as! BookingVerificationViewController
            let data = sender as! DTOBookingInformation
            bookingVerification.dtoBookingInformation = data
        }
    }
    
    private func bindAppointmentDataSource() {
        if let appointments = Functionality.pulledStaticArrayFromUserDefaults(forKey: DTOCustomerInformation.sharedInstance.customerInformationDictionary["userId"] as! String) as? DTOCustomerInformation {

            if appointments.customerAppointmentsDictionary.count > 0 {
                                
//                let model = ModelHandleBookingManagerDetail()
//                model.removeAppointmentFromUserDefault(appointment_ID: "364")
                
                var keyArray = Array(appointments.customerAppointmentsDictionary.keys)
                keyArray = keyArray.sorted {$0 > $1}
                print("\nPulling from User Default: \n")
                for item in keyArray {
                    self.appoinmentDataSource.append(appointments.customerAppointmentsDictionary[item]!)
                    print("\n================START================\nAPPOINTMENT ID: \(item)")
                    appointments.customerAppointmentsDictionary[item]?.printBookingInfo()
                }
                self.tableView_Appointments.isHidden = false
            } else {
                self.addLabelForEmptyAppointment()
                self.tableView_Appointments.isHidden = true
            }
        } else {
            self.addLabelForEmptyAppointment()
            self.tableView_Appointments.isHidden = true
        }

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
    
    private func returnDisplayValueForStatus(isConfirmed: String) -> String {
        if isConfirmed == "1" {
            return "IS_CONFIRMED".localized()
        } else {
            return "IS_NOT_CONFIRMED".localized()
        }
    }
}
