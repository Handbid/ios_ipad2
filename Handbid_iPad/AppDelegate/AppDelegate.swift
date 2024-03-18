//Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import UIKit
import SwiftUI

///***
///After add Coordinator change App Delegate to class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {
///***

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return false
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
}
