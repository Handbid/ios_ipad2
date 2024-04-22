// Copyright (c) 2024 by Handbid. All rights reserved.

protocol DataService: ObservableObject {
	func fetchData(completion: @escaping (Result<Data, Error>) -> Void)
	func refreshData()
}
