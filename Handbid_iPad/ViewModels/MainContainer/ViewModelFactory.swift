// Copyright (c) 2024 by Handbid. All rights reserved.

enum ViewModelFactory {
	static func createAllViewModelsForMainContainer() -> (AuctionViewModel, PaddleViewModel, MyBidsViewModel, ManagerViewModel, LogOutViewModel) {
		let dataService = DataServiceFactory.getService()
		let networkClient = DependencyMainAppProvider.shared.networkClient
		let auctionRepository = AuctionRepositoryImpl(network: networkClient)
		let performTransactionRepository = PerformTransactionRepositoryImpl(network: networkClient)

		return (AuctionViewModel(dataService: dataService, repository: auctionRepository, repositoryPerformTransaction: performTransactionRepository),
		        PaddleViewModel(dataService: dataService),
		        MyBidsViewModel(dataService: dataService),
		        ManagerViewModel(dataService: dataService),
		        LogOutViewModel(dataService: dataService))
	}
}
