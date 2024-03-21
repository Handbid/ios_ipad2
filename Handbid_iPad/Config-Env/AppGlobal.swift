// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

enum AppGlobal {
	static var appName: String {
		#if Handbid_iPad
			return "handbid"
		#else
			return "default"
		#endif
	}

	static var os: String {
		"ios"
	}

	static var whitelabelId: Int {
		#if Handbid_iPad
			return 1
		#else
			return 0
		#endif
	}

	static var bundleIdentifier: String {
		Bundle.main.bundleIdentifier ?? ""
	}
}
