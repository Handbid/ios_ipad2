// Copyright (c) 2024 by Handbid. All rights reserved.

class DataServiceWrapper: ObservableObject {
	var wrappedService: any DataService

	init(wrappedService: any DataService) {
		self.wrappedService = wrappedService
	}

	func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
		wrappedService.fetchData { result in
			switch result {
			case let .success(data):
				completion(.success(data))
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}

	func refreshData() {
		wrappedService.refreshData()
	}
}
