//
//  AppDelegate.swift
//  NexmoTest
//
//  Created by naomi schettini on 2017-07-25.
//  Copyright © 2017 naomi schettini. All rights reserved.
//

import UIKit
import NexmoVerify
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
        
        private var appId = "9baef0cd"
        private var sharedKey = "483ede94ed051c94"
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            
            FirebaseApp.configure()
            
            // Start up the NexmoClient with your application key(id) and your shared secret key
            NexmoClient.start(applicationId: appId, sharedSecretKey: sharedKey)
        
            return true
    }
}



