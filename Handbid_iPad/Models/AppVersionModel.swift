// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Combine
import Foundation

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

	// Example use in viewModel
	//    import Combine
	//    struct ExampleViewModel {
	//        private var cancellables = Set<AnyCancellable>()
	//        mutating func fetchAppVersion() {
	//            AppVersionModel().fetchAppVersion()
	//                .sink(receiveCompletion: { completion in
	//                    switch completion {
	//                    case .finished:
	//                        break
	//                    case .failure(let error):
	//                        print("Error fetching app version: \(error)")
	//                    }
	//                }, receiveValue: { version in
	//                    print(version)
	//                })
	//                .store(in: &cancellables)
	//        }

	func fetchAppVersion() -> AnyPublisher<[AppVersionModel], Error> {
		get("/auth/app-info", params: ["appName": AppGlobal.appName,
		                               "os": AppGlobal.os,
		                               "whitelabelId": AppGlobal.whitelabelId])
			.tryMap { try Self.decode($0) }
			.map { [$0] }
			.eraseToAnyPublisher()
	}
}
