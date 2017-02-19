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
        DispatchQueue.main.async {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            
            animation.fromValue = NSValue(cgPoint: CGPoint(x: elementToBeShake.center.x - 5, y: elementToBeShake.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: elementToBeShake.center.x + 5, y: elementToBeShake.center.y))
            elementToBeShake.layer.add(animation, forKey: "position")
        }
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
