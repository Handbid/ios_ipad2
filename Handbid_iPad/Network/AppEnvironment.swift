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
			Environment.prod
		case .d1:
			Environment.d1
		case .d2:
			Environment.d2
		case .d3:
			Environment.d3
		case .qa:
			Environment.qa
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
