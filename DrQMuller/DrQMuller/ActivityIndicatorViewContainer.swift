//
//  ActivityIndicatorViewContainer.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /08/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class ActivityIndicatorViewContainer: UIView {

    func createActivityIndicator(view: UIView) -> UIActivityIndicatorView {
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

}
