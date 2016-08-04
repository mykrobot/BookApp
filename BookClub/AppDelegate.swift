//
//  AppDelegate.swift
//  BookClub
//
//  Created by Michael Mecham on 5/26/16.
//  Copyright © 2016 MichaelMecham. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        AppearanceController.initializeAppearanceDefaults()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        let device = UIDevice.currentDevice()
        if !device.name.containsString("Simulator") {
            SessionController.sendSessionTime()
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        SessionController.startSession()
    }
}

