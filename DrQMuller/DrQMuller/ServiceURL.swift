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
    }
    
    func getServiceURL(serviceURL: String) -> String {
        var prefix = "/index.php"
        
        if serviceURL == "SendMail_VerifyAcc" || serviceURL == "SendMail_ResetPassword" || serviceURL == "SendMail_NotifyBooking" {
            prefix = String()
        }
        
        switch self.environment {
        case .PRD:
            if let url = URI[serviceURL] {
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
