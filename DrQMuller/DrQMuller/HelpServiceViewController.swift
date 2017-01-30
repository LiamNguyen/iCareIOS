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
    private var btn_Language: UIButton!
    private var view_BtnMessageContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getViewHeight()
        
        self.view.layer.cornerRadius = 30
        self.view.backgroundColor = ThemeColor
        
        createButtonLanguage()
        createButtonMessage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createButtonLanguage() {
        self.btn_Language = UIButton(frame: CGRect(x: 0, y: 0, width: viewHeight - 10, height: viewHeight - 10))
        let radius = min(self.btn_Language.frame.size.width, self.btn_Language.frame.size.height) / 2.0
        
        self.btn_Language.center = CGPoint(x: 70, y: viewHeight / 2)
        self.btn_Language.backgroundColor = UIColor.white
        self.btn_Language.setTitleColor(ThemeColor, for: .normal)
        self.btn_Language.setTitle("VI", for: .normal)
        self.btn_Language.layer.cornerRadius = radius
        self.btn_Language.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        self.btn_Language.showsTouchWhenHighlighted = true
        self.btn_Language.addTarget(self, action: #selector(btn_Language_OnClick), for: .touchUpInside)
        
        self.view.addSubview(self.btn_Language)
    }
    
    func createButtonMessage() {
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
        self.view.addSubview(view_BtnMessageContainer)
    }
    
    @objc private func btn_Language_OnClick(sender: UIButton) {
        UIFunctionality.addShakyAnimation(elementToBeShake: sender)
    }
    
    @objc private func view_BtnMessageContainer_OnClick(sender: UIButton) {
        UIFunctionality.addShakyAnimation(elementToBeShake: sender)
    }
    
    func getViewHeight() {
        let receiveHeight = UserDefaults.standard.float(forKey: "containerHeight")
        
        if receiveHeight == 0 {
            self.viewHeight = self.view.frame.height
        } else {
            self.viewHeight = CGFloat(receiveHeight)
        }
    }
}
