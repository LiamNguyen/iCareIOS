//
//  CustomTxtField.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /16/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTxtField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 50, dy: 7)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
