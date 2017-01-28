//
//  BookingStartEndDateViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /23/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

class BookingStartEndDateViewController: UIViewController, SlideButtonDelegate {
    
    @IBOutlet private weak var slideBtn_Next: MMSlidingButton!
    @IBOutlet private weak var lbl_StartDate: UILabel!
    @IBOutlet private weak var lbl_EndDate: UILabel!
    @IBOutlet private weak var picker_StartDate: UIDatePicker!
    @IBOutlet private weak var picker_EndDate: UIDatePicker!
    @IBOutlet private weak var view_TopView: UIView!
    @IBOutlet private weak var constraint_DatePickerStartHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_Back: UIButton!
    
    private var isTypeFree = false
    private var isEco = false
    private var constraintDatePicker = DatePickerRange()
    private var datePickerHasChanged = false
    
    private var startDay =  Int()
    private var startMonth = Int()
    private var startYear = Int()
    private var endDay = Int()
    private var endMonth = Int()
    private var endYear = Int()
    
    private var datePickersValues = [Int]()
    
    private var messageView: UIView!
    private var modelHandleBookingStartEnd  = ModelHandelBookingStartEnd()
    private var timer: Timer!
    private var language: String!
    
    private func handleLanguageChanged() {
        self.language = UserDefaults.standard.string(forKey: "lang")
        
        lbl_StartDate.text = "LBL_START_DATE".localized(lang: self.language)
        lbl_EndDate.text = "LBL_END_DATE".localized(lang: self.language)
        
        let date_picker_localization = NSLocale.init(localeIdentifier: Functionality.getDatePickerLocale(language: self.language)) as Locale
        
        picker_StartDate.locale = date_picker_localization
        picker_EndDate.locale = date_picker_localization
        btn_Back.setTitle("BOOKING_INFO_PAGE_TITLE".localized(lang: self.language), for: .normal)
        slideBtn_Next.delegate = self
        slideBtn_Next.buttonText = "BTN_NEXT_TITLE".localized(lang: self.language)
        slideBtn_Next.buttonUnlockedText = "SLIDE_BTN_UNLOCKED_TITLE".localized(lang: self.language)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleLanguageChanged()
        
//=========PREPARE UI BASE ON LOGIC OF DTOBookingInformation=========
        
        prepareUI()
        
//=========SET UP LIST OF DATEPICKER VALUES=========

        setUpDatePickersList()
        
//=========DELEGATING SLIDE BTN=========

        self.slideBtn_Next.reset()
        
//=========CONSTRAINT FOR DATEPICKER START AND END=========

        constraintDatePicker.datePickerConstraintMin(MinRangeFromCurrentDate: 0, DatePicker: picker_StartDate)
        constraintDatePicker.startEndRangeDatePickerConstraintMin(startYear: picker_StartDate.date.year, startMonth: picker_StartDate.date.month, startDay: picker_StartDate.date.day, DatePicker: picker_EndDate)
        
//=========SET ECO FLAG=========

        if DTOBookingInformation.sharedInstance.voucher == "ECO Booking" {
            isEco = true
        }
    }

    @IBAction func lbl_Back_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_BookingDateToBookingGeneral", sender: self)
    }
    
    @IBAction func btn_Back_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_BookingDateToBookingGeneral", sender: self)
    }
    
    @IBAction func picker_StartDate_OnValueChanged(_ sender: Any) {
        datePickerHasChanged = true

        startDay = picker_StartDate.date.day
        startMonth = picker_StartDate.date.month
        startYear = picker_StartDate.date.year
        
        constraintDatePicker.startEndRangeDatePickerConstraintMin(startYear: startYear, startMonth: startMonth, startDay: startDay, DatePicker: picker_EndDate)
        
        endDay = picker_EndDate.date.day
        endMonth = picker_EndDate.date.month
        endYear = picker_EndDate.date.year
        setUpDatePickersList()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_BookingDateToBookingGeneral" {
            if let tabVC = segue.destination as? UITabBarController {
                Functionality.tabBarItemsLocalized(language: self.language, tabVC: tabVC)
                tabVC.tabBar.items?[0].isEnabled = false
                tabVC.selectedIndex = 1
            }
        }
    }
    
//=========SLIDE BUTTON ONCLICK=========
    
    func buttonStatus(_ status:String, sender:MMSlidingButton) {
        
//MAKE SURE THAT DATEPICKER HAS STOP SCROLLING
        
        if datePickerHasChanged {
            var datePickersIsEmpty = false
            datePickersValues.forEach {
                if $0 == 0 {
                    datePickersIsEmpty = true
                    return
                }
            }
        
            if datePickersIsEmpty {
                ToastManager.alert(view: view_TopView, msg: "DATE_PICKER_ONSPINNING_MESSAGE".localized(lang: self.language))
                slideBtn_Next.reset()
                datePickersIsEmpty = false
                return
            }
        }
        
        if !isTypeFree {
            if (endDay - startDay) < 0 || (endMonth - startMonth) < 0 || (endYear - startYear) < 0 {
                ToastManager.alert(view: view_TopView, msg: "END_LESS_THAN_START".localized(lang: self.language))
                slideBtn_Next.reset()
                return
            }
        }
        
        if isTypeFree {
            let translatedSelectedDay = Functionality.translateDaysOfWeek(en: picker_StartDate.date.dayOfWeek)
            if (translatedSelectedDay == "Thứ bảy" || translatedSelectedDay == "Chủ nhật") && isEco {

                alertMessage_WeekendRestrict()
                
                slideBtn_Next.reset()
                return
            }
            DTOBookingInformation.sharedInstance.exactDayOfWeek = translatedSelectedDay
            DTOBookingInformation.sharedInstance.exactDate = picker_StartDate.date.shortDate
        } else {
            DTOBookingInformation.sharedInstance.startDate = picker_StartDate.date.shortDate
            DTOBookingInformation.sharedInstance.endDate = picker_EndDate.date.shortDate
        }
        
        self.performSegue(withIdentifier: "segue_BookingStartEndToDetail", sender: self)
        
    }
    
//=========PREPARE UI BASE ON LOGIC OF DTOBookingInformation=========
    
    private func prepareUI() {
        if DTOBookingInformation.sharedInstance.type == "Tự do" { //TYPE OF FREE DATE
            lbl_StartDate.text = "LBL_EXACT_DATE".localized(lang: self.language)
            lbl_EndDate.isHidden = true
            picker_EndDate.isHidden = true
            constraint_DatePickerStartHeight.constant = 290
            isTypeFree = true
            return
        }
    }
    
//=========SET UP LIST OF DATEPICKER VALUES=========
    
    private func setUpDatePickersList() {
        self.datePickersValues = [Int]()
        self.datePickersValues.append(startDay)
        self.datePickersValues.append(startMonth)
        self.datePickersValues.append(startYear)
        self.datePickersValues.append(endDay)
        self.datePickersValues.append(endMonth)
        self.datePickersValues.append(endYear)
    }
    
//========CREATE MESSAGE VIEW CONTAINER=========
    
    private func alertMessage_WeekendRestrict() {
        let message = "ECO_WEEKEND_RESTRICTION_MESSAGE".localized(lang: self.language)
        if self.messageView == nil {
            self.messageView = UIFunctionality.createMessageViewContainer(parentView: self.view)
        } else {
            if messageView.center.x == UIScreen.main.bounds.width / 2 {
                return
            }
            self.messageView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4 + 10)
        }
        
        ToastManager.message(view: self.messageView, msg: message, duration: 10)
        
        self.timer = Timer.scheduledTimer(timeInterval: 10.5, target: self, selector: #selector(self.hideContainer), userInfo: nil, repeats: false)
    }
    
//========HANDLE MESSAGE VIEW CONTAINER=========
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let messageView = self.messageView {
            if messageView.center.x == UIScreen.main.bounds.width / 2 {
                hideContainer()
            }
        }
    }
    
    @objc private func hideContainer() {
        self.messageView.center = CGPoint(x: UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width, y: UIScreen.main.bounds.height / 4)
        self.timer.invalidate()
    }
    
    
//    private func formShortEndDate() -> String{
//        let endYear = String(picker_EndDate.date.year)
//        let endMonth = String(picker_EndDate.date.month)
//        let endDay = String(picker_EndDate.date.day + 1)
//        
//        let shortDateFormat = "\(endYear)-\(endMonth)-\(endDay)"
//        
//        return shortDateFormat
//    }

}



