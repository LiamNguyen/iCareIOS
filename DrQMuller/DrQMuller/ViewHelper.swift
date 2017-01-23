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
    
    static func confirmDialog(sender: UIViewController) {
        let confirmDialog = UIAlertController(title: "Quý khách sẽ đăng thoát?", message: "Những thông tin chưa được xác nhận sẽ không được lưu trữ.", preferredStyle: UIAlertControllerStyle.alert)
        confirmDialog.addAction(UIAlertAction(title: "Đăng thoát", style: .default, handler: { (action: UIAlertAction!) in
            sender.performSegue(withIdentifier: "segue_CustomerInformationToLogin", sender: sender)
        }))
        confirmDialog.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { (action: UIAlertAction!) in
            
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

