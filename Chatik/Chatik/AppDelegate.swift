//
//  AppDelegate.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 19.02.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        window?.overrideUserInterfaceStyle = .light
        
        return true
    }
   
}

