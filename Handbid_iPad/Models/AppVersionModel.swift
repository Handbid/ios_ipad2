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
	init(json: [String: Any]) {
		self.id = json["appVersion.id"] as? Int
		self.os = json["appVersion.os"] as? String
		self.appName = json["appVersion.appName"] as? String
		self.minimumVersion = json["appVersion.minimumVersion"] as? String
		self.currentVersion = json["appVersion.currentVersion"] as? String
		self.demoModeEnabled = json["demoModeEnabled"] as? Int
	}

	mutating func deserialize(_ json: JSON) {
		id <-- json["appVersion.id"]
		os <-- json["appVersion.os"]
		appName <-- json["appVersion.appName"]
		minimumVersion <-- json["appVersion.minimumVersion"]
		currentVersion <-- json["appVersion.currentVersion"]
		demoModeEnabled <-- json["demoModeEnabled"]
	}
}
