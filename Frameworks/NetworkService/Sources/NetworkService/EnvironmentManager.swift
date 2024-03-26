// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

public enum EnvironmentManager {
	public static func getCurrentBaseURL() -> String {
		AppEnvironmentType.currentURLEnvironment
	}

	public static func isProdActive() -> Bool {
		AppEnvironmentType.currentState == .prod ? true : false
	}

	public static func setEnvironment(_ environment: EnvironmentProtocol) {
		let defaults = UserDefaults.standard
		defaults.set(environment.baseURL, forKey: "selectedEnvironment")

		if !defaults.synchronize() {
			print("Error: Unable to synchronize UserDefaults.")
		}
	}

	public static func setEnvironment(for environment: AppEnvironmentType) {
		guard let environment = makeEnvironment(for: environment) else {
			print("Error: Unable to create environment for the specified type.")
			return
		}
		setEnvironment(environment)
	}

	public static func setEnvironment(fromURL url: URL) {
		if let environment = makeEnvironment(fromURL: url) {
			setEnvironment(environment)
		}
	}

	public static func makeEnvironment(for environment: AppEnvironmentType) -> EnvironmentProtocol? {
		switch environment {
		case .d1: AppEnvironment(baseURL: "https://d1-rest.handbid.dev", showLog: true)
		case .d2: AppEnvironment(baseURL: "https://d2-rest.handbid.dev", showLog: true)
		case .d3: AppEnvironment(baseURL: "https://d3-rest.handbid.dev", showLog: true)
		case .qa: AppEnvironment(baseURL: "https://qa-rest.handbid.dev", showLog: true)
		case .prod: AppEnvironment(baseURL: "https://rest.handbid.com", showLog: true)
		}
	}

	public static func makeEnvironment(fromURL url: URL) -> EnvironmentProtocol? {
		guard let host = url.host else {
			return nil
		}

		let environments: [(String, AppEnvironmentType)] = [
			("qa-rest.handbid.dev", .qa),
			("d1-rest.handbid.dev", .d1),
			("d2-rest.handbid.dev", .d2),
			("d3-rest.handbid.dev", .d3),
			("rest.handbid.com", .prod),
		]

		for (prefix, environment) in environments {
			if host.hasPrefix(prefix) {
				return makeEnvironment(for: environment)
			}
		}

		return makeEnvironment(for: .prod)
	}

	public static func detectEnvironmentType(fromURL url: URL) -> AppEnvironmentType {
		guard let host = url.host else {
			return .prod
		}

		let environments: [(String, AppEnvironmentType)] = [
			("qa-rest.handbid.dev", .qa),
			("d1-rest.handbid.dev", .d1),
			("d2-rest.handbid.dev", .d2),
			("d3-rest.handbid.dev", .d3),
			("rest.handbid.com", .prod),
		]

		for (prefix, environment) in environments {
			if host.hasPrefix(prefix) {
				return environment
			}
		}

		return .prod
	}
}
