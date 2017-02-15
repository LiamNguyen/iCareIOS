//
//  AnimationManager.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /07/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import UIKit

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
