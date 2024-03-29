// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Combine
import Foundation
import NetworkService

struct AppVersionModel: Decodable {
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

extension AppVersionModel: NetworkingService, NetworkingJSONDecodable {
	var network: NetworkingClient {
		NetworkingClient()
	}

	func fetchAppVersion() -> AnyPublisher<[AppVersionModel], Error> {
		get("/auth/app-info", params: ["appName": AppInfoProvider.appName,
		                               "os": AppInfoProvider.os,
		                               "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try Self.decode($0) }
			.map { [$0] }
			.eraseToAnyPublisher()
	}
}
