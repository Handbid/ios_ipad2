// Copyright (c) 2024 by Handbid. All rights reserved.

enum ViewModelFactory {
	static func createAllViewModelsForMainContainer() -> (AuctionViewModel, PaddleViewModel, MyBidsViewModel, ManagerViewModel, LogOutViewModel) {
		let dataService = DataServiceFactory.getService()
		return (AuctionViewModel(dataService: dataService),
		        PaddleViewModel(dataService: dataService),
		        MyBidsViewModel(dataService: dataService),
		        ManagerViewModel(dataService: dataService),
		        LogOutViewModel(dataService: dataService))
	}
}
