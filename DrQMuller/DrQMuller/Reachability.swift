//
//  Reachability.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /07/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

struct Reachability {
    //CHECK NETWORK CONNECTIVITY
    
    static func isConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static func detectNetworkReachabilityObserver(parentView: UIView) -> (network: NetworkViewManager, timer: Timer) {
        let viewManager = NetworkViewManager()
        viewManager.createNetworkMessage(parentView: parentView)
        
//=========OBSERVING NOTIFICATION FROM AppDelegate FOR NETWORK CONNECTION=========
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "network"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "network"), object: nil, queue: nil) { (Notification) in
            if let userInfo = Notification.userInfo {
                if let isConnected = userInfo["isConnectedToNetwork"] as? Bool {
                    if isConnected {
                        viewManager.updateNetworkMessage(isConnected: true)
                    } else {
                        viewManager.updateNetworkMessage(isConnected: false)
                    }
                }
            }
        }

//=========REALTIME CHECKING FOR NETWORK CONNECTIVITY=========

        var timer = Timer()
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (Timer) in
                if Reachability.isConnectedToNetwork() {
                    viewManager.updateNetworkMessage(isConnected: true)
                } else {
                    viewManager.updateNetworkMessage(isConnected: false)
                }
            })
        } else {
            // Fallback on earlier versions
        }
        
        return (viewManager, timer)
    }
}
