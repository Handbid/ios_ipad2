// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

class MainContainerViewModel: ObservableObject, EnterPinAlertDelegate {
	private let managerRepository: ManagerRepository
	private let dataManager: DataManager

	@Published var displayedOverlay: MainContainerOverlayTypeView = .none
	@Published var invoiceViewModel: InvoiceViewModel? = nil
	@Published var selectedView: MainContainerTypeView = .auction
	@Published private var success: Bool? = nil

	var isSuccess: AnyPublisher<Bool?, Never> {
		$success.eraseToAnyPublisher()
	}

	private var cancellables: Set<AnyCancellable> = []
	private var auctionId: Int

	init(managerRepository: ManagerRepository) {
		self.managerRepository = managerRepository
		self.dataManager = DataManager.shared
		self.auctionId = -1

		dataManager.onDataChanged.sink {
			self.updateAuctionId()
		}
		.store(in: &cancellables)

		updateAuctionId()
	}

	private func updateAuctionId() {
		if let auction = try? dataManager.fetchSingle(of: AuctionModel.self, from: .auction),
		   let id = auction.identity
		{
			auctionId = id
		}
	}

	func didEnterPin(pin: String) {
		managerRepository.verifyManagerPin(pin, auctionId: auctionId)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case .failure:
					self.success = false
				}

			}, receiveValue: { response in
				if response.success == true {
					self.success = true
					self.selectedView = .manager
				}
				else {
					self.success = false
				}
			})
			.store(in: &cancellables)
	}
}
