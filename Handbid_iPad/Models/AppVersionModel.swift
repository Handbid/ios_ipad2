// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct AppVersionModel: Decodable, NetworkingJSONDecodable {
	var demoModeEnabled: Int?
	var id: Int?
	var os: String?
	var appName: String?
	var minimumVersion: String?
	var currentVersion: String?
}

extension AppVersionModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		id <-- json["appVersion.id"]
		os <-- json["appVersion.os"]
		appName <-- json["appVersion.appName"]
		minimumVersion <-- json["appVersion.minimumVersion"]
		currentVersion <-- json["appVersion.currentVersion"]
		demoModeEnabled <-- json["demoModeEnabled"]
	}
}
