//
//  ViewHelper.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /23/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import UIKit

struct UIFunctionality {
    
//CREATE SUBVIEW CONTAINER HOLD INFO MESSAGE
    
    static func createMessageViewContainer(parentView: UIView) -> UIView {
        let messageView = UIView(frame: CGRect(x: -UIScreen.main.bounds.width, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
        messageView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4 + 10)
        parentView.addSubview(messageView)
        
        return messageView
    }
    
//CREATE ACTIVITY INDICATION SUBVIEW
    
    static func createActivityIndicator(view: UIView) -> UIActivityIndicatorView {
        let width = UIScreen.main.bounds.width / 4
        let height = width
        let x = width
        let y = view.center.x - height
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: x, y: y, width: width, height: height))
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.backgroundColor = ThemeColor
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.layer.shadowColor = UIColor.black.cgColor
        activityIndicator.layer.shadowOffset = CGSize.zero
        activityIndicator.layer.shadowOpacity = 0.7
        activityIndicator.layer.shadowRadius = 10
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        return activityIndicator
    }
    
//DRAWING LINE
    
    static func drawLine(fromPoint start: CGPoint, toPoint end:CGPoint, lineWidth: CGFloat, color: UIColor, view: UIView) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = color.cgColor
        line.lineWidth = lineWidth
        line.lineJoin = kCALineJoinRound
        view.layer.addSublayer(line)
    }
    
    static func addShakyAnimation(elementToBeShake: AnyObject) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: elementToBeShake.center.x - 5, y: elementToBeShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: elementToBeShake.center.x + 5, y: elementToBeShake.center.y))
        elementToBeShake.layer.add(animation, forKey: "position")
    }
    
    static func createChooseLanguageView(view: UIView) {
        LoginViewController.view_BackLayer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        LoginViewController.view_BackLayer.center = CGPoint(x: LoginViewController.view_BackLayer.center.x + UIScreen.main.bounds.width, y: UIScreen.main.bounds.height / 2)
        LoginViewController.view_BackLayer.backgroundColor = UIColor.lightGray
        view.addSubview(LoginViewController.view_BackLayer)
        
        let view_Container = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 200))
        view_Container.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        view_Container.layer.cornerRadius = 5
        view_Container.backgroundColor = UIColor.white
        
        LoginViewController.btn_LanguageDropDown = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 50))
        LoginViewController.btn_LanguageDropDown.center = CGPoint(x: view_Container.bounds.width / 2, y: view_Container.bounds.height / 2 - 50)
        LoginViewController.btn_LanguageDropDown.setTitle("Choose language", for: .normal)
        LoginViewController.btn_LanguageDropDown.setTitleColor(ThemeColor, for: .normal)
        LoginViewController.btn_LanguageDropDown.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold)
        LoginViewController.btn_LanguageDropDown.addTarget(self, action: #selector(LoginViewController.btn_LanguageDropDown_OnClick), for: .touchUpInside)
        LoginViewController.btn_LanguageDropDown.showsTouchWhenHighlighted = true
        
        LoginViewController.dropDown_Language.dataSource = ["Vietnamese - Tiếng Việt", "English - Tiếng Anh"]
        LoginViewController.dropDown_Language.anchorView = LoginViewController.btn_LanguageDropDown
        
        LoginViewController.dropDown_Language.selectionAction = { (index, item) in
            LoginViewController.btn_LanguageDropDown.setTitle(item, for: .normal)
            
            LoginViewController.borderBottom.backgroundColor = ThemeColor
            LoginViewController.btn_LanguageDropDown.setTitleColor(ThemeColor, for: .normal)
        }
        
        LoginViewController.borderBottom = UIView(frame: CGRect(x: 0, y: LoginViewController.btn_LanguageDropDown.bounds.height - 10, width: LoginViewController.btn_LanguageDropDown.bounds.width, height: 2.5))
        LoginViewController.borderBottom.backgroundColor = ThemeColor
        
        LoginViewController.btn_LanguageDropDown.addSubview(LoginViewController.borderBottom)
        
        let btn_Confirm = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 60, height: 50))
        btn_Confirm.center = CGPoint(x: view_Container.bounds.width / 2, y: view_Container.bounds.height / 2 + 30)
        btn_Confirm.setTitle("Confirm", for: .normal)
        btn_Confirm.setTitleColor(UIColor.white, for: .normal)
        btn_Confirm.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold)
        btn_Confirm.backgroundColor = ThemeColor
        btn_Confirm.layer.cornerRadius = 10
        btn_Confirm.addTarget(self, action: #selector(LoginViewController.btn_Confirm_OnClick), for: .touchUpInside)
        btn_Confirm.showsTouchWhenHighlighted = true
        
        view_Container.addSubview(LoginViewController.btn_LanguageDropDown)
        view_Container.addSubview(btn_Confirm)
        LoginViewController.view_BackLayer.addSubview(view_Container)
    }
    
    static func createFlyingView(parentView: UIView, startPosition: CGFloat) -> UIView {
        let flyingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        flyingView.center = CGPoint(x: UIScreen.main.bounds.width - 15, y: 25)
        //self.flyingView.backgroundColor = UIColor(patternImage: image)
        flyingView.layer.contents = UIImage(named: "planeIcon")?.cgImage
        parentView.addSubview(flyingView)
        
        let path = UIBezierPath()
        let startPoint = CGPoint(x: 15, y: startPosition)
        path.move(to: startPoint)
        path.addCurve(to: CGPoint(x: UIScreen.main.bounds.width - 15, y: 25), controlPoint1: CGPoint(x: UIScreen.main.bounds.width / 2 + 150, y: startPosition - 20), controlPoint2: CGPoint(x: UIScreen.main.bounds.width / 2 + 200, y: startPosition - 50))
        
        // create a new CAKeyframeAnimation that animates the objects position
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        anim.path = path.cgPath
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = 0
        anim.duration = 1
        
        // we add the animation to the squares 'layer' property
        flyingView.layer.add(anim, forKey: "animate position along path")
        
        return flyingView
    }
}

//CREATE TOAST

struct ToastManager {
    static func alert(view: UIView, msg: String) {
        view.makeToast(message: msg, duration: 2.5, position: HRToastPositionTop as AnyObject)
    }
    
    static func message(view: UIView, msg: String, duration: Double) {
        view.makeToast(message: msg, duration: duration, position: HRToastPositionTop as AnyObject)
    }
}

//CREATE DIALOG

struct DialogManager {
    //=========CREATE POP UP CONFIRM DIALOG=========
    
    static func confirmLogout(sender: UIViewController, segueIdentifier: String) {
        let confirmDialog = UIAlertController(title: "CONFIRM_LOGOUT_TITLE".localized(), message: "CONFIRM_LOGOUT_MESSAGE".localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        confirmDialog.addAction(UIAlertAction(title: "LOGOUT_EXECUTE_TITLE".localized(), style: .default, handler: { (action: UIAlertAction!) in
            sender.performSegue(withIdentifier: segueIdentifier, sender: sender)
        }))
        confirmDialog.addAction(UIAlertAction(title: "DIALOG_CANCEL_TITLE".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        sender.present(confirmDialog, animated: true, completion: nil)
    }
    
    static func errorMessage(sender: UIViewController, msg: String) {
        let confirmDialog = UIAlertController(title: "Thông báo!", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        confirmDialog.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        sender.present(confirmDialog, animated: true, completion: nil)
    }
}

struct AnimationManager {
    static func getAnimation_Fade(duration: Float) -> CATransition {
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = CFTimeInterval(duration)
        
        return animation
    }
    
    static func getAnimation_Transition(duration: Float) -> CATransition {
        let animation = CATransition()
        animation.type = kCATransactionAnimationDuration
        animation.duration = CFTimeInterval(duration)
        
        return animation
    }
}

class CustomStyleCustomerInformation {
    private var updatedWidth: CGFloat!
    
    //=========UPDATE STYLE OF TAB HEADERS FOR DIFFERENT PHONE SIZE=========
    
    func tabHeadersStyleUpdate(FirstTabConstraint: NSLayoutConstraint, SecondTabConstraint: NSLayoutConstraint, ThirdTabConstraint: NSLayoutConstraint) {
        let screenWidth = Double(UIScreen.main.bounds.width)
        updatedWidth = CGFloat((screenWidth - 16) / 3)
        
        FirstTabConstraint.constant = updatedWidth
        SecondTabConstraint.constant = updatedWidth
        ThirdTabConstraint.constant = updatedWidth
    }
    
    //=========UPDATE ORIGIN OF TAB HEADERS FOR DIFFERENT PHONE SIZE=========
    
    func tabHeadersOriginUpdate(view_FirstTabContainer: UIView, view_SecondTabContainer: UIView, view_ThirdTabContainer: UIView) {
        let updatedOriginXSecondTab = updatedWidth + 8
        let updatedOriginXThirdTab = updatedWidth * 2 + 16
        
        view_FirstTabContainer.frame = CGRect(x: 0, y: view_FirstTabContainer.frame.origin.y, width: updatedWidth, height: view_SecondTabContainer.frame.size.height)
        view_SecondTabContainer.frame = CGRect(x: updatedOriginXSecondTab, y: view_SecondTabContainer.frame.origin.y, width: updatedWidth, height: view_SecondTabContainer.frame.size.height)
        view_ThirdTabContainer.frame = CGRect(x: updatedOriginXThirdTab, y: view_ThirdTabContainer.frame.origin.y, width: updatedWidth, height: view_ThirdTabContainer.frame.size.height)
    }
    
    //=========ENABLE TAB HEADERS BASE ON UIFILLSTEP=========
    
    func enableTab(firstTab: UIButton, secondTab: UIButton, thirdTab: UIButton) {
        let uiFillStep = 3
        
        switch uiFillStep {
        case 1:
            applyActiveStyle(button: firstTab)
        case 2:
            applyActiveStyle(button: firstTab)
            applyActiveStyle(button: secondTab)
        default:
            applyActiveStyle(button: firstTab)
            applyActiveStyle(button: secondTab)
            applyActiveStyle(button: thirdTab)
        }
    }
    
    //=========ACTIVE TAB STYLE=========
    
    func applyActiveStyle(button: UIButton) {
        button.isEnabled = true
        button.setTitleColor(UIColor(netHex: 0x8F00B3), for: .normal)
    }
    
    func translateTabHeaderUnderline(view: UIView, view_TabContainer: UIView) {
        let startPoint = CGPoint(x: view_TabContainer.frame.origin.x, y: view_TabContainer.frame.origin.y + view_TabContainer.frame.size.height)
        let endPoint = CGPoint(x: view_TabContainer.frame.origin.x + view_TabContainer.frame.size.width, y: view_TabContainer.frame.origin.y + view_TabContainer.frame.size.height)
        UIFunctionality.drawLine(fromPoint: startPoint, toPoint: endPoint, lineWidth: 3, color: UIColor(netHex: 0x8F00B3), view: view)
    }
}

