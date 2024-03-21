// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

enum AppEnvironment {
	case prod
	case d1
	case d2
	case d3
	case qa
}

extension AppEnvironment {
	static var currentState: AppEnvironment {
		// Read status from setting
		.qa
	}
}

extension AppEnvironment {
	static var baseURL: String {
		switch AppEnvironment.currentState {
		case .prod:
			Servers.prod
		case .d1:
			Servers.d1
		case .d2:
			Servers.d2
		case .d3:
			Servers.d3
		case .qa:
			Servers.qa
		}
	}
}

extension AppEnvironment {
	static var showLog: Bool {
		switch AppEnvironment.currentState {
		case .prod:
			false
		case .d1, .d2, .d3, .qa:
			true
		}
	}
}
