// Copyright (c) 2024 by Handbid. All rights reserved.

class DataServiceFactory {
	static var defaultService: any DataService = AuctionDataService()

	static func getService() -> DataServiceWrapper {
		DataServiceWrapper(wrappedService: defaultService)
	}
}
