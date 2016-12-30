//
//  ServiceURL.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation

public class ServiceURL {
    
    private var isPRD: Bool!
    private var prdURL = [String:String]()
    private var uatURL = [String:String]()
    
    init (isPRD: Bool) {
        self.isPRD = isPRD
//===============IF THIS IS PRODUCTION ENVIRONMENTS================
        switch isPRD {
        case true:
            prdURL["Select_ToAuthenticate"] = "http://210.211.109.180/drmuller/Select_ToAuthenticate.php"
            prdURL["Select_CheckUserExistence"] = "http://210.211.109.180/drmuller/Select_CheckUserExistence.php"
            prdURL["Select_NumberOfCustomer"] = "http://210.211.109.180/drmuller/Select_NumberOfCustomer.php"
            prdURL["Select_Countries"] = "http://210.211.109.180/drmuller/Select_Countries.php"
            prdURL["Select_Cities"] = "http://210.211.109.180/drmuller/Select_Cities.php"
            prdURL["Select_Districts"] = "http://210.211.109.180/drmuller/Select_Districts.php"
            prdURL["Select_Locations"] = "http://210.211.109.180/drmuller/Select_Locations.php"
            prdURL["Select_Vouchers"] = "http://210.211.109.180/drmuller/Select_Vouchers.php"
            prdURL["Select_Types"] = "http://210.211.109.180/drmuller/Select_Types.php"
            prdURL["Select_AllTime"] = "http://210.211.109.180/drmuller/Select_AllTime.php"
            prdURL["Select_EcoTime"] = "http://210.211.109.180/drmuller/Select_EcoTime.php"
            prdURL["Select_DaysOfWeek"] = "http://210.211.109.180/drmuller/Select_DaysOfWeek.php"
            prdURL["Select_SelectedTime"] = "http://210.211.109.180/drmuller/Select_SelectedTime.php"
            prdURL["Insert_NewCustomer"] = "http://210.211.109.180/drmuller/Insert_NewCustomer.php"
            prdURL["Insert_NewAppointment"] = "http://210.211.109.180/drmuller/Insert_NewAppointment.php"
            prdURL["Insert_NewBookingTime"] = "http://210.211.109.180/drmuller/Insert_NewBookingTime.php"
            prdURL["Update_UnchosenTime"] = "http://210.211.109.180/drmuller/Update_UnchosenTime.php"
            prdURL["Update_CustomerInfo"] = "http://210.211.109.180/drmuller/Update_CustomerInfo.php"
            prdURL["Update_ValidateAppointment"] = "http://210.211.109.180/drmuller/Update_ValidateAppointment.php"
            prdURL["Update_Appointment"] = "http://210.211.109.180/drmuller/Update_Appointment.php"
            prdURL["Update_VerifyAcc"] = "http://210.211.109.180/drmuller/Update_VerifyAcc.php"
            prdURL["Update_ResetPw"] = "http://210.211.109.180/drmuller/Update_ResetPw.php"
            prdURL["SendMail_VerifyAcc"] = "http://210.211.109.180/drmuller/SendMail_VerifyAcc.php"
            prdURL["SendMail_ResetPassword"] = "http://210.211.109.180/drmuller/SendMail_ResetPassword.php"
            prdURL["BookingTransaction"] = "http://210.211.109.180/drmuller/BookingTransaction.php"
//===============IF THIS IS UAT ENVIRONMENTS================
        default:
            uatURL["Select_ToAuthenticate"] = "http://drqmuller.com/drmuller/Select_ToAuthenticate.php"
            uatURL["Select_CheckUserExistence"] = "http://drqmuller.com/drmuller/Select_CheckUserExistence.php"
            uatURL["Select_NumberOfCustomer.php"] = "http://drqmuller.com/drmuller/Select_NumberOfCustomer.php"
            uatURL["Select_Countries"] = "http://drqmuller.com/drmuller/Select_Countries.php"
            uatURL["Select_Cities"] = "http://drqmuller.com/drmuller/Select_Cities.php"
            uatURL["Select_Districts"] = "http://drqmuller.com/drmuller/Select_Districts.php"
            uatURL["Select_Locations"] = "http://drqmuller.com/drmuller/Select_Locations.php"
            uatURL["Select_Vouchers"] = "http://drqmuller.com/drmuller/Select_Vouchers.php"
            uatURL["Select_Types"] = "http://drqmuller.com/drmuller/Select_Types.php"
            uatURL["Select_AllTime"] = "http://drqmuller.com/drmuller/Select_AllTime.php"
            uatURL["Select_EcoTime"] = "http://drqmuller.com/drmuller/Select_EcoTime.php"
            uatURL["Select_DaysOfWeek"] = "http://drqmuller.com/drmuller/Select_DaysOfWeek.php"
            uatURL["Select_SelectedTime"] = "http://drqmuller.com/drmuller/Select_SelectedTime.php"
            uatURL["Insert_NewCustomer"] = "http://drqmuller.com/drmuller/Insert_NewCustomer.php"
            uatURL["Insert_NewAppointment"] = "http://drqmuller.com/drmuller/Insert_NewAppointment.php"
            uatURL["Insert_NewBookingTime"] = "http://drqmuller.com/drmuller/Insert_NewBookingTime.php"
            uatURL["Update_UnchosenTime"] = "http://drqmuller.com/drmuller/Update_UnchosenTime.php"
            uatURL["Update_CustomerInfo"] = "http://drqmuller.com/drmuller/Update_CustomerInfo.php"
            uatURL["Update_ValidateAppointment"] = "http://drqmuller.com/drmuller/Update_ValidateAppointment.php"
            uatURL["Update_Appointment"] = "http://drqmuller.com/drmuller/Update_Appointment.php"
            uatURL["Update_VerifyAcc"] = "http://drqmuller.com/drmuller/Update_VerifyAcc.php"
            uatURL["Update_ResetPw"] = "http://drqmuller.com/drmuller/Update_ResetPw.php"
            uatURL["SendMail_VerifyAcc"] = "http://drqmuller.com/drmuller/SendMail_VerifyAcc.php"
            uatURL["SendMail_ResetPassword"] = "http://drqmuller.com/drmuller/SendMail_ResetPassword.php"
            uatURL["BookingTransaction"] = "http://drqmuller.com/drmuller/BookingTransaction.php"
        }
    }
    
    func getServiceURL(serviceURL: String) -> String {
        switch isPRD {
        case true:
            if let url = prdURL[serviceURL] {
                return url
            } else {
                return "Can't find URL"
            }
        default:
            if let url = uatURL[serviceURL] {
                return url
            } else {
                return "Can't find URL"
            }
        }
    }
}
