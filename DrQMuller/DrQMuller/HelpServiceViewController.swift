//
//  HelpServiceViewController.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /29/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class HelpServiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.layer.cornerRadius = 30
        self.view.backgroundColor = ThemeColor
        
        createButtonLanguage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createButtonLanguage() {
        let viewHeight: CGFloat!
        let receiveHeight = UserDefaults.standard.float(forKey: "containerHeight")
        
        if receiveHeight == 0 {
            viewHeight = self.view.frame.height
        } else {
            viewHeight = CGFloat(receiveHeight)
        }
            
        let btn_Language = UIButton(frame: CGRect(x: 0, y: 0, width: viewHeight - 10, height: viewHeight - 10))
        let radius = min(btn_Language.frame.size.width, btn_Language.frame.size.height) / 2.0
        
        btn_Language.center = CGPoint(x: 70, y: viewHeight / 2)
        btn_Language.backgroundColor = UIColor.white
        btn_Language.setTitleColor(ThemeColor, for: .normal)
        btn_Language.setTitle("VI", for: .normal)
        btn_Language.layer.cornerRadius = radius
        btn_Language.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        btn_Language.showsTouchWhenHighlighted = true
        btn_Language.addTarget(self, action: #selector(self.btn_Language_OnClick), for: .touchUpInside)
        
        self.view.addSubview(btn_Language)
    }
    
    @objc private func btn_Language_OnClick(sender: UIButton) {
        UIFunctionality.addShakyAnimation(elementToBeShake: sender)
    }

   }
