//
//  Session.swift
//  BookClub
//
//  Created by Michael Mecham on 8/4/16.
//  Copyright © 2016 MichaelMecham. All rights reserved.
//

import Foundation

/*
In the AppDelegate method 'didBecomeActive' call SessionController.startSession()
In the AppDelegate method 'applicationDidEnterBackground'
let device = UIDevice.currentDevice()
if !device.name.containsString("Simulator") {
SessionController.sendSessionTime()
}
Change App Transport Security to Allow Arbitrary Loads in PList
 */

let kLaunches: String = "totalLaunches"
let kLastLaunch: String = "lastLaunch"

struct Session {
    
    private let kStart = "start"
    private let kEnd = "end"
    private let kDuration = "duration"
    private let kBundleVersion = "bundleVersion"
    private let kVersionString = "versionString"
    
    let startTime: NSTimeInterval
    var endTime: NSTimeInterval?
    let identifier = NSUUID()
    
    let appName: String = NSBundle.mainBundle().infoDictionary?["CFBundleDisplayName"] as? String ?? "N/A"
    let buildNumber: String = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    let bundleShortVersion: String = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    
    var launches: Int = NSUserDefaults.standardUserDefaults().integerForKey(kLaunches) + 1
    var sessionTime: NSTimeInterval {
        if let endTime = endTime {
            return endTime - startTime
        }
        return 0
    }
    var timeSinceLastLaunch: NSTimeInterval {
        let lastLaunch = NSUserDefaults.standardUserDefaults().doubleForKey(kLastLaunch)
        let time = startTime - lastLaunch
        return time == startTime ? 0 : time
    }
}

extension Session {
    
    var jsonValue: [String:AnyObject] {
        return [kStart:startTime, kEnd:endTime ?? "no end time", kDuration:sessionTime, kLaunches:launches, kBundleVersion: buildNumber, kVersionString: bundleShortVersion, kLastLaunch: timeSinceLastLaunch]
    }
    
    var jsonData: NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(jsonValue, options: .PrettyPrinted)
    }
    
    var endpoint: NSURL? {
        return SessionController.baseURL?.URLByAppendingPathComponent("\(appName)/\(identifier.UUIDString)").URLByAppendingPathExtension("json")
    }
    
    init(start: NSTimeInterval) {
        self.startTime = start
        print(endpoint)
    }
}

class SessionController {
    
    static let baseURL = NSURL(string: "https://mykrobotanalytics.firebaseio.com/api")
    static let getterEndpoint = baseURL?.URLByAppendingPathExtension("json")
    static var session: Session?
    
    static func startSession() {
        session = Session(start: NSDate().timeIntervalSince1970)
    }
    
    static func endSession() {
        session?.endTime = NSDate().timeIntervalSince1970
    }
    
    static func sendSessionTime() {
        endSession()
        handleLaunchCount()
        guard let session = session, url = session.endpoint else { return }
        NetworkController.performRequestForURL(url, httpMethod: .Put, body: session.jsonData) { (data, error) in
            let responseDataString = NSString(data: data!, encoding: NSUTF8StringEncoding) ?? ""
            if error != nil {
                print("Error: \(error)")
            } else if responseDataString.containsString("error") {
                print("Error: \(responseDataString)")
            } else {
                print("Successfully saved data to endpoint. \nResponse: \(responseDataString)")
            }
        }
    }
    
    static func handleLaunchCount() {
        guard let session = session else { return }
        NSUserDefaults.standardUserDefaults().setInteger(session.launches, forKey: kLaunches)
        NSUserDefaults.standardUserDefaults().setDouble(session.startTime, forKey: kLastLaunch)
    }
}
