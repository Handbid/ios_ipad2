// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

protocol EnvironmentProtocol {
	var baseURL: String { get }
	var showLog: Bool { get }
}

struct AppEnvironment: EnvironmentProtocol {
	let baseURL: String
	let showLog: Bool
}

enum AppEnvironmentType: String {
	case prod, d1, d2, d3, qa
}

extension AppEnvironmentType {
	static var currentState: AppEnvironmentType {
		guard let selectedEnvironment = UserDefaults.standard.string(forKey: "selectedEnvironment"), !selectedEnvironment.isEmpty else { return .prod }
		guard let environmentUrl = URL(string: selectedEnvironment) else { return .prod }
		return EnvironmentManager.detectEnvironmentType(fromURL: environmentUrl)
	}

	static var currentURLEnvironment: String {
		guard let selectedEnvironment = UserDefaults.standard.string(forKey: "selectedEnvironment"), !selectedEnvironment.isEmpty else { return "rest.handbid.com" }
		return selectedEnvironment
	}
}
