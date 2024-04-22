// Copyright (c) 2024 by Handbid. All rights reserved.

class AuctionDataService: DataService {
	enum DataServiceError: Error {
		case fetchFailed
	}

	func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
		completion(.failure(DataServiceError.fetchFailed))
	}

	func refreshData() {}
}
