//
//  LineDrawer.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /20/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation
import UIKit

class LineDrawer: UIViewController {
    func addLine(fromPoint start: CGPoint, toPoint end:CGPoint, lineWidth: CGFloat, color: UIColor, view: UIView) {
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
