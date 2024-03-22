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

	func application(_: UIApplication, open url: URL,
	                 options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool
	{
		if let environment = EnvironmentManager.makeEnvironment(fromURL: url) ?? EnvironmentManager.makeEnvironment(for: .prod) {
			EnvironmentManager.setEnvironment(environment)
			return true
		}
		return false
	}

	func applicationDidEnterBackground(_: UIApplication) {}

	func applicationWillEnterForeground(_: UIApplication) {}
}
