// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import SwiftUI
import UIKit

/// ***
// After add Coordinator change App Delegate to class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {
/// ***

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		true
	}

	func application(_: UIApplication, open _: URL,
	                 options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool
	{
		false
	}

	func applicationDidEnterBackground(_: UIApplication) {}

	func applicationWillEnterForeground(_: UIApplication) {}
}
