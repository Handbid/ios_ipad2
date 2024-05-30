// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
@testable import Handbid_iPad

class MockDataService: DataService {
	func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
		let mockData = Data()
		completion(.success(mockData))
	}

	func refreshData() {}
}
