//
//  MessageViewContainer.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /12/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class MessageViewContainer: UIView {

    func createMessageViewContainer(parentView: UIView) -> UIView {
        let messageView = UIView(frame: CGRect(x: -UIScreen.main.bounds.width, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
        messageView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4 + 10)
        parentView.addSubview(messageView)
        
        return messageView
    }

}
