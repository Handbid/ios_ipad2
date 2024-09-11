// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

enum AppInfoProvider {
	static var appName: String {
		"handbid"
	}

	static var os: String {
		"ios"
	}

	static var whitelabelId: Int {
		1
	}

	static var authClientSecret: String {
		"secret_0bde28331a40673eaa324375"
	}

	static var captchaKey: String {
		"6LfiSi0qAAAAAAKA7YjZbIksvKYfGPxLFKKSry7S"
	}

	static var aboutHandbidLink: String {
		"https://www.handbid.com/about-us/"
	}

	static var bundleIdentifier: String {
		Bundle.main.bundleIdentifier ?? ""
	}
}
