// Copyright (c) 2024 by Handbid. All rights reserved.

import FirebaseAnalytics
import FirebaseCore
import FirebaseCrashlytics
import FirebasePerformance
import NetworkService
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {
	func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		FirebaseApp.configure()
		return true
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
