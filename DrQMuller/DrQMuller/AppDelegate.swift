//
//  AppDelegate.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/11/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pmHandleCurrentVersion: PMHandleGetCurrentVersion?
    var appFirstLaunch = true
    
    override init() {
        super.init()
        
        self.pmHandleCurrentVersion = PMHandleGetCurrentVersion()
        
        
//        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Constants.NotificationName.versionResponse), object: nil, queue: nil) { (Notification) in
//            if let userInfo = Notification.userInfo {
//                if let build = userInfo[Constants.JsonPropertyName.build] as? Int {
//                    if build != Int(Bundle.main.buildVersionNumber!) {
//                        self.alertUpdateDialog()
//                    }
//                }
//            }
//        }
//        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: nil) { (Notification) in
//            if (self.appFirstLaunch) {
//                self.pmHandleCurrentVersion?.checkVersion()
//            }
//        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.pmHandleCurrentVersion?.checkVersion()
        self.appFirstLaunch = false
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "appResignActive"), object: nil)
        self.appFirstLaunch = true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        var isConnectedToNetwork = [String: Any]()
        
        if Reachability.isConnectedToNetwork() {
            isConnectedToNetwork["isConnectedToNetwork"] = true
        } else {
            isConnectedToNetwork["isConnectedToNetwork"] = false
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "network"), object: nil, userInfo: isConnectedToNetwork)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "appTerminate"), object: nil)
    }

    func alertUpdateDialog() {
        let alertUpdateDialog = UIAlertController(title: String(), message: "NEW_UPDATE_NOTIFY".localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        alertUpdateDialog.addAction(UIAlertAction(title: "BTN_UPDATE".localized(), style: .default, handler: { (action: UIAlertAction?) in
            let url = "http://itunes.apple.com/vn/app/dr-q-muller/id1207560048?mt=8"
            
            UIApplication.shared.openURL(NSURL.init(string: url)! as URL)
        }))
        
        self.window?.rootViewController?.present(alertUpdateDialog, animated: true, completion: nil)
    }
}

