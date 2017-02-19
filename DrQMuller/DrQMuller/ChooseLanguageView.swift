//
//  ChooseLanguageView.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /19/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit
import DropDown

protocol ChooseLanguageViewDelegate {
    func onRequireUIUpdate() -> Void
}

class ChooseLanguageView: UIView {

    private var btn_LanguageDropDown: UIButton!
    private var dropDown_Language = DropDown()
    private var borderBottom: UIView!
    private var view_BackLayer: UIView!
    
    var delegate: ChooseLanguageViewDelegate?
    
    func createChooseLanguageView() -> UIView {
        self.view_BackLayer = createBackLayerView()
        
        let container = createContainer()
        
        self.btn_LanguageDropDown = createBtnLanguageDropDown(view_Container: container)
        
        createLanguageDropDown(btn_LanguageDropDown: btn_LanguageDropDown, borderBottom: self.borderBottom)
        
        let btn_ConfirmLanguage = createBtnConfirmLanguage(view_Container: container)
        
        btn_LanguageDropDown.addSubview(borderBottom)
        container.addSubview(btn_LanguageDropDown)
        container.addSubview(btn_ConfirmLanguage)
        self.view_BackLayer.addSubview(container)
        
        return view_BackLayer
    }
    
    private func createBackLayerView() -> UIView {
        let view_BackLayer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view_BackLayer.center = CGPoint(x: view_BackLayer.center.x + UIScreen.main.bounds.width, y: UIScreen.main.bounds.height / 2)
        view_BackLayer.backgroundColor = UIColor.lightGray
        
        return view_BackLayer
    }
    
    private func createContainer() -> UIView {
        let view_Container = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 200))
        view_Container.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        view_Container.layer.cornerRadius = 5
        view_Container.backgroundColor = UIColor.white
        
        return view_Container
    }
    
    private func createBtnLanguageDropDown(view_Container: UIView) -> UIButton {
        btn_LanguageDropDown = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 50))
        btn_LanguageDropDown.center = CGPoint(x: view_Container.bounds.width / 2, y: view_Container.bounds.height / 2 - 50)
        btn_LanguageDropDown.setTitle("Choose language", for: .normal)
        btn_LanguageDropDown.setTitleColor(ThemeColor, for: .normal)
        btn_LanguageDropDown.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold)
        btn_LanguageDropDown.addTarget(self, action: #selector(btn_LanguageDropDown_OnClick), for: .touchUpInside)
        btn_LanguageDropDown.showsTouchWhenHighlighted = true
        
        createBorderBottom()
        
        return btn_LanguageDropDown
    }
    
    private func createBorderBottom() {
        borderBottom = UIView(frame: CGRect(x: 0, y: self.btn_LanguageDropDown.bounds.height - 10, width: self.btn_LanguageDropDown.bounds.width, height: 2.5))
        borderBottom.backgroundColor = ThemeColor
    }
    
    private func createLanguageDropDown(btn_LanguageDropDown: UIButton, borderBottom: UIView) {
        
        dropDown_Language.dataSource = ["Vietnamese - Tiếng Việt", "English - Tiếng Anh"]
        dropDown_Language.anchorView = btn_LanguageDropDown
        
        dropDown_Language.selectionAction = { (index, item) in
            self.btn_LanguageDropDown.setTitle(item, for: .normal)
            
            self.borderBottom.backgroundColor = ThemeColor
            self.btn_LanguageDropDown.setTitleColor(ThemeColor, for: .normal)
        }
    }
    
    private func createBtnConfirmLanguage(view_Container: UIView) -> UIButton {
        let btn_ConfirmLanguage = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 60, height: 50))
        btn_ConfirmLanguage.center = CGPoint(x: view_Container.bounds.width / 2, y: view_Container.bounds.height / 2 + 30)
        btn_ConfirmLanguage.setTitle("Confirm", for: .normal)
        btn_ConfirmLanguage.setTitleColor(UIColor.white, for: .normal)
        btn_ConfirmLanguage.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold)
        btn_ConfirmLanguage.backgroundColor = ThemeColor
        btn_ConfirmLanguage.layer.cornerRadius = 10
        btn_ConfirmLanguage.addTarget(self, action: #selector(btn_ConfirmLanguage_OnClick), for: .touchUpInside)
        btn_ConfirmLanguage.showsTouchWhenHighlighted = true
        
        return btn_ConfirmLanguage
    }
    
    func showLanguageView() {
        UIView.animate(withDuration: 0.5) {
            self.view_BackLayer.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: self.view_BackLayer.center.y)
        }
    }
    
    func hideLanguageView() {
        UIView.animate(withDuration: 1, animations: {
            self.view_BackLayer.center = CGPoint(x: self.view_BackLayer.center.x - UIScreen.main.bounds.width, y: UIScreen.main.bounds.height / 2)
        })
    }
    
    @objc func btn_LanguageDropDown_OnClick(sender: UIButton) {
        dropDown_Language.show()
    }
    
    @objc func btn_ConfirmLanguage_OnClick(sender: UIButton) {
        if dropDown_Language.selectedItem == nil {
            UIFunctionality.addShakyAnimation(elementToBeShake: btn_LanguageDropDown)
            
            borderBottom.backgroundColor = UIColor.red
            btn_LanguageDropDown.setTitleColor(UIColor.red, for: .normal)
            
            return
        }
        
        hideLanguageView()
        
        if dropDown_Language.indexForSelectedRow == 0 {
            UserDefaults.standard.set("vi", forKey: "lang")
        } else {
            UserDefaults.standard.set("en", forKey: "lang")
        }
        
        self.delegate?.onRequireUIUpdate()
    }
    
}
