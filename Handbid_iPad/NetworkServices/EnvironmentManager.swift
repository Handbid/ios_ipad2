// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

enum EnvironmentManager {
	static func getCurrentEnvironment() -> AppEnvironmentType {
		guard let selectedEnvironment = UserDefaults.standard.string(forKey: "selectedEnvironment"),
		      let environmentType = AppEnvironmentType(rawValue: selectedEnvironment)
		else {
			return .prod
		}
		return environmentType
	}

	static func getCurrentBaseURL() -> String {
		let currentEnvironment = getCurrentEnvironment()

		switch currentEnvironment {
		case .prod:
			return "https://rest.handbid.com"
		default:
			return "https://\(currentEnvironment.rawValue)-rest.handbid.dev"
		}
	}

	static func setEnvironment(_ environment: EnvironmentProtocol) {
		let defaults = UserDefaults.standard
		defaults.set(environment.baseURL, forKey: "selectedEnvironment")

		if !defaults.synchronize() {
			print("Error: Unable to synchronize UserDefaults.")
		}
	}

	static func setEnvironment(for environment: AppEnvironmentType) {
		guard let environment = EnvironmentFactory.makeEnvironment(for: environment) else {
			print("Error: Unable to create environment for the specified type.")
			return
		}
		setEnvironment(environment)
	}

	static func setEnvironment(fromURL url: URL) {
		if let environment = EnvironmentFactory.makeEnvironment(fromURL: url) {
			setEnvironment(environment)
		}
	}
}
