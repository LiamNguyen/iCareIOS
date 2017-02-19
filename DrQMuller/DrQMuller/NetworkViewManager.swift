//
//  NetworkViewManager.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /06/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import UIKit

class NetworkViewManager: UIView {
    private var parentView: UIView!
    private var messageView: UIView!
    private var messageLabel: UILabel!
    private var isConnected = true
    
    func createNetworkMessage(parentView: UIView) {
        messageView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        messageView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: -60)
        
        messageView.layer.shadowColor = UIColor.black.cgColor
        messageView.layer.shadowOffset = CGSize.zero
        messageView.layer.shadowOpacity = 0.7
        messageView.layer.shadowRadius = 10
        
        messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: messageView.frame.width, height: messageView.frame.height))
        messageLabel.center = CGPoint(x: messageView.frame.width / 2, y: messageView.frame.height / 2)
        messageLabel.textColor = UIColor.white
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.textAlignment = .center
        
        messageView.addSubview(messageLabel)
        parentView.addSubview(messageView)
        
        messageView.isHidden = true
        
        self.parentView = parentView
    }
    
    func showNetworkMessage() {
        DispatchQueue.main.async {
            self.messageView.isHidden = false
            UIView.animate(withDuration: 0.8) {
                self.messageView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 30)
            }
        }
    }
    
    func dismissNetworkMessage() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8) {
                self.messageView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: -60)
                self.messageView.isHidden = true
            }
        }
    }
    
    func updateNetworkMessage(isConnected: Bool) {
        if isConnected {
            messageView.backgroundColor = UIColor.green
            messageLabel.text = "NETWORK_REACHED".localized()
            self.parentView.isUserInteractionEnabled = true
            dismissNetworkMessage()
        } else {
            messageView.backgroundColor = UIColor.red
            messageLabel.text = "NETWORK_UNREACHED".localized()
            self.parentView.isUserInteractionEnabled = false
            showNetworkMessage()
        }
        self.isConnected = isConnected
    }
    
    
}
