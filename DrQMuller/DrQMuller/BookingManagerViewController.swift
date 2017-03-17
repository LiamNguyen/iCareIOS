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
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var view_TopView: UIView!
    
    private var message_NoAppointment: UILabel!
    
    private var modelHandleBookingManager: ModelHandleBookingManager!
    private var modelHandleBookingManagerDetail: ModelHandleBookingManagerDetail!
    
    private var appoinmentDataSource = [DTOBookingInformation]()
    
    private var networkViewManager: NetworkViewManager!
    private weak var networkCheckInRealTime: Timer?
    
    private func updateUI() {
        lbl_Title.text = "BOOKING_MANAGER_PAGE_TITLE".localized()
        if let message = self.message_NoAppointment {
            message.text = "NO_APPOINTMENT_MESSAGE".localized()
        }
    }
    
    private struct Storyboard {
        static let CELL_IDENTIFIER_APPOINTMENT_TBLVIEW = "AppointmentTableViewCell"
        static let SEGUE_TO_BOOKING_MANAGER_DETAIL = "segue_BookingManagerToBookingManagerDetail"
        static let SEGUE_TO_BOOKING_VERIFICATION = "segue_BookingManagerToBookingVerification"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindAppointmentDataSource()
        
        print("\nBooking Manager VC ONLOAD: ")
        DTOBookingInformation.sharedInstance.printBookingInfo()
        
        updateUI()

        wiredUpNetworkChecking()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView_Appointments.delegate = self
        tableView_Appointments.dataSource = self
        tableView_Appointments.separatorColor = ThemeColor
        
        modelHandleBookingManager = ModelHandleBookingManager()
        modelHandleBookingManager.validateAppointment()
        
        modelHandleBookingManagerDetail = ModelHandleBookingManagerDetail()
        
        networkViewManager = NetworkViewManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.networkCheckInRealTime?.invalidate()
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
        
        if item.isConfirmed == "1" {
            cell.lbl_Status.textColor = UIColor.green
        } else {
            cell.lbl_Status.textColor = UIColor.red
        }
        
        if !item.startDate.isEmpty {
            cell.lbl_StartDate.text = Functionality.convertDateFormatFromStringToDate(str: item.startDate)?.shortDateVnFormatted
            cell.lbl_EndDate.text = Functionality.convertDateFormatFromStringToDate(str: item.endDate)?.shortDateVnFormatted
        } else {
            cell.lbl_StartDate_Title.text = "LBL_EXACT_DATE".localized() + ": "
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
        if let appointments = Functionality.pulledStaticArrayFromUserDefaults(forKey: DTOCustomerInformation.sharedInstance.customerInformationDictionary[JsonPropertyName.userId] as! String) as? DTOCustomerInformation {
            appoinmentDataSource.removeAll(keepingCapacity: false)
            if appointments.customerAppointmentsDictionary.count > 0 {
                                
//                let model = ModelHandleBookingManagerDetail()
//                model.removeAppointmentFromUserDefault(appointment_ID: "364")
                
                var keyArray = Array(appointments.customerAppointmentsDictionary.keys)
                keyArray = keyArray.sorted {$0 > $1}
                
                print("\nPulling from User Default: \n")
                
                for i in 0...keyArray.count - 1 {
                    let item = keyArray[i]
                    
                    print("\n================START================\nAPPOINTMENT ID: \(item)")
                    
                    appointments.customerAppointmentsDictionary[item]?.printBookingInfo()
                    
                //Limit appointment list to maximum of 5 items
                    if i == 5 {
                        print("Item to clear: App_ID - \(item)")
                        modelHandleBookingManagerDetail.removeAppointmentFromUserDefault(appointment_ID: item)
                        break
                    }
                
                    self.appoinmentDataSource.append(appointments.customerAppointmentsDictionary[item]!)
                }
                
                self.tableView_Appointments.reloadData()
                if let msg_NoAppointment = self.message_NoAppointment {
                    msg_NoAppointment.isHidden = true
                }
                self.tableView_Appointments.isHidden = false
            } else {
                displayLabelForEmptyAppointment()
            }
        } else {
            displayLabelForEmptyAppointment()
        }
    }
    
    private func createLabelForEmptyAppointment() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 70, height: 250))
        label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
        label.textColor = UIColor.gray
        label.text = "NO_APPOINTMENT_MESSAGE".localized()
        label.textAlignment = .center
        label.numberOfLines = 5
        
        self.view.addSubview(label)
        self.message_NoAppointment = label
    }
    
    private func displayLabelForEmptyAppointment() {
        if self.message_NoAppointment == nil {
            createLabelForEmptyAppointment()
        } else {
            self.message_NoAppointment.isHidden = false
        }
        self.tableView_Appointments.isHidden = true
    }
    
    private func returnDisplayValueForStatus(isConfirmed: String) -> String {
        if isConfirmed == "1" {
            return "IS_CONFIRMED".localized()
        } else {
            return "IS_NOT_CONFIRMED".localized()
        }
    }
    
    private func wiredUpNetworkChecking() {
        let tupleDetectNetworkReachabilityResult = Reachability.detectNetworkReachabilityObserver(parentView: self.view)
        networkViewManager = tupleDetectNetworkReachabilityResult.network
        networkCheckInRealTime = tupleDetectNetworkReachabilityResult.timer
    }
    
    @IBAction func unwindToBookingManager(segue: UIStoryboardSegue) {}
}
