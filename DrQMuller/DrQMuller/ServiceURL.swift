//
//  ServiceURL.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation

public class ServiceURL {
    
    private var environment: Environments
    private var prdURL = [String:String]()
    private var URI = [String:String]()
    
    init (environment: Environments) {
        self.environment = environment
//===============IF THIS IS PRODUCTION ENVIRONMENTS================
        switch environment {
        case .PRD:
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
            prdURL["Select_Machines"] = "http://210.211.109.180/drmuller/Select_Machines.php"
            prdURL["Insert_NewCustomer"] = "http://210.211.109.180/drmuller/Insert_NewCustomer.php"
            prdURL["Insert_NewAppointment"] = "http://210.211.109.180/drmuller/Insert_NewAppointment.php"
            prdURL["Insert_NewBookingTime"] = "http://210.211.109.180/drmuller/Insert_NewBookingTime.php"
            prdURL["Update_UnchosenTime"] = "http://210.211.109.180/drmuller/Update_UnchosenTime.php"
            prdURL["Update_CustomerInfo"] = "http://210.211.109.180/drmuller/Update_CustomerInfo.php"
            prdURL["Update_ValidateAppointment"] = "http://210.211.109.180/drmuller/Update_ValidateAppointment.php"
            prdURL["Update_Appointment"] = "http://210.211.109.180/drmuller/Update_Appointment.php"
            prdURL["Update_CancelAppointment"] = "http://210.211.109.180/drmuller/Update_CancelAppointment.php"
            prdURL["Update_VerifyAcc"] = "http://210.211.109.180/drmuller/Update_VerifyAcc.php"
            prdURL["Update_ResetPw"] = "http://210.211.109.180/drmuller/Update_ResetPw.php"
            prdURL["SendMail_VerifyAcc"] = "http://210.211.109.180/drmuller/SendMail_VerifyAcc.php"
            prdURL["SendMail_ResetPassword"] = "http://210.211.109.180/drmuller/SendMail_ResetPassword.php"
            prdURL["BookingTransaction"] = "http://210.211.109.180/drmuller/BookingTransaction.php"
            prdURL["Update_BasicInfo"] = "http://210.211.109.180/drmuller/Update_BasicInfo.php"
            prdURL["Update_NecessaryInfo"] = "http://210.211.109.180/drmuller/Update_NecessaryInfo.php"
            prdURL["Update_ImportantInfo"] = "http://210.211.109.180/drmuller/Update_ImportantInfo.php"
            prdURL["SendMail_NotifyBooking"] = "http://210.211.109.180/drmuller_test/SendMail_NotifyBooking1.php"
        case .BETA, .LOCAL:
//            SELECT
            
            URI["Select_ToAuthenticate"] = "/user/login"
            URI["Select_Countries"] = "/datasource/countries"
            URI["Select_Cities"] = "/datasource/cities"
            URI["Select_Districts"] = "/datasource/districts"
            URI["Select_Locations"] = "/datasource/locations"
            URI["Select_Vouchers"] = "/datasource/vouchers"
            URI["Select_Types"] = "/datasource/types"
            URI["Select_AllTime"] = "/time/alltime"
            URI["Select_EcoTime"] = "/time/ecotime"
            URI["Select_DaysOfWeek"] = "/datasource/daysofweek"
            URI["Select_SelectedTime"] = "/time/selectedtime"
            URI["Select_Machines"] = "/datasource/machines"
            URI["Select_LatestBuild"] = "/version"
            
//            INSERT
            
            URI["Insert_NewCustomer"] = "/user/register"
            URI["Insert_NewAppointment"] = "/appointment/create"
            URI["BookingTransaction"] = "/time/book"
            
//            UPDATE
            
            URI["Update_ReleaseTime"] = "/time/release"
            URI["Update_CustomerInfo"] = "/user"
            URI["Update_ValidateAppointment"] = "/appointment/validate"
            URI["Update_ConfirmAppointment"] = "/appointment/confirm"
            URI["Update_CancelAppointment"] = "/appointment/cancel"
            URI["Update_VerifyAcc"] = "http://localhost/drmuller/Update_VerifyAcc.php"
            URI["Update_ResetPw"] = "http://localhost/drmuller/Update_ResetPw.php"
            URI["Update_BasicInfo"] = "/user/basicinformation"
            URI["Update_NecessaryInfo"] = "/user/necessaryinformation"
            URI["Update_ImportantInfo"] = "/user/importantinformation"
            
//            MAIL SENDER
            
            URI["SendMail_VerifyAcc"] = "http://localhost/drmuller/SendMail_VerifyAcc.php"
            URI["SendMail_ResetPassword"] = "http://localhost/drmuller/SendMail_ResetPassword.php"
            URI["SendMail_NotifyBooking"] = "/SendMail_NotifyBooking.php"
        default:
            break
        }
    }
    
    func getServiceURL(serviceURL: String) -> String {
        var prefix = "/index.php"
        
        if serviceURL == "SendMail_VerifyAcc" || serviceURL == "SendMail_ResetPassword" || serviceURL == "SendMail_NotifyBooking" {
            prefix = String()
        }
        
        switch self.environment {
        case .PRD:
            if let url = prdURL[serviceURL] {
                return Host.PRD + prefix + url
            } else {
                return "Can't find URL"
            }
        case .BETA:
            if let url = URI[serviceURL] {
                return Host.BETA + prefix + url
            } else {
                return "Can't find URL"
            }
        case .LOCAL:
            if let url = URI[serviceURL] {
                return Host.LOCAL + prefix + url
            } else {
                return "Can't find URL"
            }
        default:
            if let url = URI[serviceURL] {
                return Host.UAT + prefix + url
            } else {
                return "Can't find URL"
            }
        }
    }
    
    enum Environments {
        case PRD
        case UAT
        case LOCAL
        case BETA
    }
    
    private struct Host {
        static let PRD = "http://210.211.109.180/drmuller/api"
        static let UAT = "http://drqmuller.com/drmuller/api"
        static let BETA = "http://210.211.109.180/beta_drmuller/api"
        static let LOCAL = "http://localhost/beta_drmuller/api"
    }
}
