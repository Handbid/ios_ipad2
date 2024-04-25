// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService

extension EnvironmentManager {
	static func getCurrentSocketBaseURL() -> String {
		var url = AppEnvironmentType.currentURLEnvironment
		url.replace("rest", with: "node")
		url.append(AppEnvironmentType.currentState == .prod ? ":443" : ":3003")

		return url
	}
}
