//
//  HelpServiceViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /29/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class HelpServiceViewController: UIViewController {
    
    private var viewHeight: CGFloat!
    private var btn_TriggerHelpService: UIButton!
    private var btn_Language: UIButton!
    private var view_BtnMessageContainer: UIView!
    private var view_BtnPhoneContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //=========OBSERVING NOTIFICATION FROM PMHandleBooking==========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "helpContainerRequireClose"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "helpContainerRequireClose"), object: nil, queue: nil, using: updateTriggerButton)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getViewHeight()
        
        self.view.layer.cornerRadius = 30
        self.view.backgroundColor = ThemeColor
        
        createButtonTriggerHelpService()
        createButtonLanguage()
        createButtonMessage()
        createButtonPhone()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createButtonTriggerHelpService() {
        self.btn_TriggerHelpService = UIButton(frame: CGRect(x: 0, y: 0, width: viewHeight - 20, height: viewHeight - 10))
        
        self.btn_TriggerHelpService.center = CGPoint(x: 25, y: viewHeight / 2)
        self.btn_TriggerHelpService.showsTouchWhenHighlighted = true
        self.btn_TriggerHelpService.addTarget(self, action: #selector(btn_TriggerHelpService_OnClick), for: .touchUpInside)
        self.btn_TriggerHelpService.layer.contents = UIImage(named: "backBtnIcon")?.cgImage
        
        self.view.addSubview(self.btn_TriggerHelpService)
    }
    
    private func createButtonLanguage() {
        self.btn_Language = UIButton(frame: CGRect(x: 0, y: 0, width: viewHeight - 10, height: viewHeight - 10))
        let radius = min(self.btn_Language.frame.size.width, self.btn_Language.frame.size.height) / 2.0
        
        self.btn_Language.center = CGPoint(x: 70, y: viewHeight / 2)
        self.btn_Language.backgroundColor = UIColor.white
        self.btn_Language.setTitleColor(ThemeColor, for: .normal)
        self.btn_Language.setTitle(UserDefaults.standard.string(forKey: "lang")?.uppercased(), for: .normal)
        self.btn_Language.layer.cornerRadius = radius
        self.btn_Language.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        self.btn_Language.showsTouchWhenHighlighted = true
        self.btn_Language.addTarget(self, action: #selector(btn_Language_OnClick), for: .touchUpInside)
        
        self.view.addSubview(self.btn_Language)
    }
    
    private func createButtonMessage() {
        self.view_BtnMessageContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.btn_Language.frame.width, height: self.btn_Language.frame.height))
        let radius = min(self.view_BtnMessageContainer.frame.size.width, self.view_BtnMessageContainer.frame.size.height) / 2.0

        self.view_BtnMessageContainer.center = CGPoint(x: self.btn_Language.center.x + (viewHeight - 10) + 10, y: viewHeight / 2)
        self.view_BtnMessageContainer.backgroundColor = UIColor.white
        self.view_BtnMessageContainer.layer.cornerRadius = radius
        
        let btn_Message = UIButton(frame: CGRect(x: 0, y: 0, width: self.view_BtnMessageContainer.frame.width - 15, height: self.view_BtnMessageContainer.frame.height - 15))
        btn_Message.center = CGPoint(x: self.view_BtnMessageContainer.frame.width / 2, y: self.view_BtnMessageContainer.frame.height / 2)
        btn_Message.layer.contents = UIImage(named: "messageIcon")?.cgImage
        btn_Message.addTarget(self, action: #selector(view_BtnMessageContainer_OnClick), for: .touchUpInside)
        btn_Message.backgroundColor = UIColor.white
        btn_Message.showsTouchWhenHighlighted = true
        
        self.view_BtnMessageContainer.addSubview(btn_Message)
        self.view.addSubview(self.view_BtnMessageContainer)
    }
    
    private func createButtonPhone() {
        self.view_BtnPhoneContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.btn_Language.frame.width, height: self.btn_Language.frame.height))
        let radius = min(self.view_BtnPhoneContainer.frame.size.width, self.view_BtnPhoneContainer.frame.size.height) / 2.0
        
        self.view_BtnPhoneContainer.center = CGPoint(x: self.view_BtnMessageContainer.center.x + (viewHeight - 10) + 10, y: viewHeight / 2)
        self.view_BtnPhoneContainer.backgroundColor = UIColor.white
        self.view_BtnPhoneContainer.layer.cornerRadius = radius
        
        let btn_Phone = UIButton(frame: CGRect(x: 0, y: 0, width: self.view_BtnPhoneContainer.frame.width - 15, height: self.view_BtnPhoneContainer.frame.height - 15))
        btn_Phone.center = CGPoint(x: self.view_BtnPhoneContainer.frame.width / 2, y: self.view_BtnPhoneContainer.frame.height / 2)
        btn_Phone.layer.contents = UIImage(named: "phoneIcon-1")?.cgImage
        btn_Phone.addTarget(self, action: #selector(view_BtnPhoneContainer_OnClick), for: .touchUpInside)
        btn_Phone.backgroundColor = UIColor.white
        btn_Phone.showsTouchWhenHighlighted = true
        
        self.view_BtnPhoneContainer.addSubview(btn_Phone)
        self.view.addSubview(self.view_BtnPhoneContainer)
    }
    
    @objc private func btn_TriggerHelpService_OnClick(sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "onTriggerHelpService"), object: nil)
        UIView.animate(withDuration: 0.5) { 
            self.btn_TriggerHelpService.transform = self.btn_TriggerHelpService.transform.rotated(by: CGFloat(M_PI))
        }
    }
    
    @objc private func btn_Language_OnClick(sender: UIButton) {
        UIFunctionality.addShakyAnimation(elementToBeShake: sender)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "requireChangeLanguage"), object: nil)
        self.btn_Language.setTitle(UserDefaults.standard.string(forKey: "lang")?.uppercased(), for: .normal)
    }
    
    @objc private func view_BtnMessageContainer_OnClick(sender: UIButton) {
        UIFunctionality.addShakyAnimation(elementToBeShake: sender)
    }
    
    @objc private func view_BtnPhoneContainer_OnClick(sender: UIButton) {
        UIFunctionality.addShakyAnimation(elementToBeShake: sender)
    }
    
    private func getViewHeight() {
        let receiveHeight = UserDefaults.standard.float(forKey: "containerHeight")
        
        if receiveHeight == 0 {
            self.viewHeight = self.view.frame.height
        } else {
            self.viewHeight = CGFloat(receiveHeight)
        }
    }
    
    private func updateTriggerButton(notification: Notification) {
        UIView.animate(withDuration: 0.5) {
            self.btn_TriggerHelpService.transform = self.btn_TriggerHelpService.transform.rotated(by: CGFloat(M_PI))
        }
    }
}
