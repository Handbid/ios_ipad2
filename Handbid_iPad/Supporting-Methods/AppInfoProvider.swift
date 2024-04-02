// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

enum AppInfoProvider {
	static var appName: String {
		#if HANDBID_IPAD
			return "handbid"
		#else
			return "default"
		#endif
	}

	static var os: String {
		"ios"
	}

	static var whitelabelId: Int {
		#if HANDBID_IPAD
			return 1
		#else
			return 0
		#endif
	}

	static var authClientSecret: String {
		#if HANDBID_IPAD
			return "secret_0bde28331a40673eaa324375"
		#else
			return ""
		#endif
	}

	static var captchaKey: String {
		#if HANDBID_IPAD
			return "6LdU5KkpAAAAANZD-3GdFspTDdqhjg6z29dE9zsR"
		#else
			return ""
		#endif
	}

	static var aboutHandbidLink: String {
		#if HANDBID_IPAD
			return "https://www.handbid.com/about-us/"
		#else
			return ""
		#endif
	}

	static var bundleIdentifier: String {
		Bundle.main.bundleIdentifier ?? ""
	}
}
