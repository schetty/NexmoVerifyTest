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
        
        private var appId = "5131d721-3f76-453f-ac78-f6ba89c785ff"
        private var sharedKey = "78e562f458f1252"
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            
            FirebaseApp.configure()
            
            // Start up the NexmoClient with your application key(id) and your shared secret key
            NexmoClient.start(applicationId: appId, sharedSecretKey: sharedKey)
        
            return true
    }
}



