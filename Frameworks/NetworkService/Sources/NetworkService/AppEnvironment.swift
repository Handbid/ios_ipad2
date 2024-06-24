// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

public protocol EnvironmentProtocol {
	var baseURL: String { get }
	var showLog: Bool { get }
}

public struct AppEnvironment: EnvironmentProtocol {
	public let baseURL: String
	public let showLog: Bool
}

public enum AppEnvironmentType: String {
	case prod, d1, d2, d3, d3v2, qa
}

public extension AppEnvironmentType {
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
