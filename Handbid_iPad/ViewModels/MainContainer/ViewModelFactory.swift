// Copyright (c) 2024 by Handbid. All rights reserved.

enum ViewModelFactory {
	static func createAllViewModelsForMainContainer() -> (MainContainerViewModel, AuctionViewModel, PaddleViewModel, MyBidsViewModel, ManagerViewModel, LogOutViewModel) {
		let dataService = DataServiceFactory.getService()
		let networkClient = DependencyMainAppProvider.shared.networkClient
		let auctionRepository = AuctionRepositoryImpl(network: networkClient)
		let myBidsRepository = MyBidsRepositoryImpl(network: networkClient)
		let paddleRepository = PaddleRepositoryImpl(network: networkClient)
		let countriesRepository = CountriesRepositoryImpl(network: networkClient)
		let managerRepository = ManagerRepositoryImpl(network: networkClient)

		return (MainContainerViewModel(managerRepository: managerRepository),
		        AuctionViewModel(dataService: dataService,
		                         repository: auctionRepository),
		        PaddleViewModel(paddleRepository: paddleRepository,
		                        countriesRepository: countriesRepository),
		        MyBidsViewModel(myBidsRepository: myBidsRepository),
		        ManagerViewModel(dataService: dataService),
		        LogOutViewModel(dataService: dataService))
	}
}
