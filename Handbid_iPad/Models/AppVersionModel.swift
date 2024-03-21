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
	//    class LogInViewModel: ObservableObject {
	//        private var cancellables = Set<AnyCancellable>()
	//
	//        func fetchAppVersion() {
	//            AppVersionModel().fetchAppVersion()
	//                .sink(receiveCompletion: { completion in
	//                    switch completion {
	//                    case .finished:
	//                        break
	//                    case let .failure(error):
	//                        print("Error fetching app version: \(error)")
	//                    }
	//                }, receiveValue: { version in
	//                    print(version)
	//                })
	//                .store(in: &cancellables)
	//        }
	//    }

	func fetchAppVersion() -> AnyPublisher<[AppVersionModel], Error> {
		get("/auth/app-info", params: ["appName": AppInfoProvider.appName,
		                               "os": AppInfoProvider.os,
		                               "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try Self.decode($0) }
			.map { [$0] }
			.eraseToAnyPublisher()
	}
}
