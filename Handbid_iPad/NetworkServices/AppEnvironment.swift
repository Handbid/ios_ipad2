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

enum EnvironmentFactory {
	static func makeEnvironment(for environment: AppEnvironmentType) -> EnvironmentProtocol? {
		switch environment {
		case .prod: AppEnvironment(baseURL: "https://rest.handbid.com", showLog: true)
		case .d1: AppEnvironment(baseURL: "https://d1-rest.handbid.com", showLog: true)
		case .d2: AppEnvironment(baseURL: "https://d2-rest.handbid.com", showLog: true)
		case .d3: AppEnvironment(baseURL: "https://d3-rest.handbid.com", showLog: true)
		case .qa: AppEnvironment(baseURL: "https://qa-rest.handbid.com", showLog: true)
		}
	}

	static func makeEnvironment(fromURL url: URL) -> EnvironmentProtocol? {
		guard let host = url.host else {
			return nil
		}

		let environments: [(String, AppEnvironmentType)] = [
			("qa-rest.handbid.com", .qa),
			("d1-rest.handbid.com", .d1),
			("d2-rest.handbid.com", .d2),
			("d3-rest.handbid.com", .d3),
			("rest.handbid.com", .prod),
		]

		for (prefix, environment) in environments {
			if host.hasPrefix(prefix) {
				return makeEnvironment(for: environment)
			}
		}

		return makeEnvironment(for: .prod)
	}

	static func isProdActive() -> Bool {
		AppEnvironmentType.currentState == .prod
	}
}

enum AppEnvironmentType: String {
	case prod, d1, d2, d3, qa
}

extension AppEnvironmentType {
	static var currentState: AppEnvironmentType {
		guard let rawValue = UserDefaults.standard.string(forKey: "selectedEnvironment"), !rawValue.isEmpty,
		      let environmentType = AppEnvironmentType(rawValue: rawValue)
		else {
			// Jeśli nie ma ustawionego środowiska w UserDefaults, próbujemy wykryć je na podstawie domyślnego URL
			return detectEnvironmentType(fromURL: URL(string: "https://rest.handbid.com")!)
		}
		return environmentType
	}

	static func detectEnvironmentType(fromURL url: URL) -> AppEnvironmentType {
		guard let host = url.host else {
			return .prod
		}

		let environments: [(String, AppEnvironmentType)] = [
			("qa-rest.handbid.com", .qa),
			("d1-rest.handbid.com", .d1),
			("d2-rest.handbid.com", .d2),
			("d3-rest.handbid.com", .d3),
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
