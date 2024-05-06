// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

class ChooseAuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	private var repository: ChooseAuctionRepository
	var buttonViewModels: [AuctionStateStatuses: AuctionFilterButtonViewModel] = AuctionStateStatuses.allCases.reduce(into: [:]) { $0[$1] = AuctionFilterButtonViewModel() }
	@Published var filteredAuctions: [AuctionModel] = []
	@Published var auctions: [AuctionModel] = []
	@Published var organization: OrganizationModel? {
		didSet {
			updateCenterViewData()
		}
	}

	@Published var centerViewData: TopBarCenterViewData
	@Published var backToPreviewViewPressed: Bool = false
	private var cancellables = Set<AnyCancellable>()

	init(repository: ChooseAuctionRepository, organization: OrganizationModel? = nil) {
		self.repository = repository
		self.organization = organization
		self.centerViewData = TopBarCenterViewData(
			type: .custom,
			customView: AnyView(SelectAuctionTopBarCenterView(title: organization?.name ?? "",
			                                                  countAuctions: organization?.totalAuctions ?? 0))
		)
		setupInitialSelection()
		setupButtonBindings()
		fetchUserAuctions()
	}

	private func setupInitialSelection() {
		buttonViewModels[.all]?.isSelected = true
		filterAuctions()
	}

	func fetchUserAuctions() {
		repository.fetchUserAuctions(status: [.open, .closed, .presale, .preview, .reconciled])
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case let .failure(error):
					if let netError = error as? NetworkingError {
						print(netError)
					}
				}
			}, receiveValue: { auctions in
				self.auctions = auctions
				self.filteredAuctions = auctions
			})
			.store(in: &cancellables)
	}

	private func setupButtonBindings() {
		for (state, viewModel) in buttonViewModels {
			viewModel.$isSelected
				.dropFirst()
				.sink(receiveValue: { [weak self] isSelected in
					self?.handleStateChange(for: state, isSelected: isSelected)
				})
				.store(in: &cancellables)
		}
	}

	private func handleStateChange(for state: AuctionStateStatuses, isSelected: Bool) {
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			if state == .all {
				if isSelected {
					buttonViewModels.forEach { if $0.key != .all { $0.value.isSelected = false } }
				}
			}
			else {
				if isSelected, buttonViewModels[.all]?.isSelected == true {
					buttonViewModels[.all]?.isSelected = false
				}
				else if buttonViewModels.filter({ $0.key != .all }).allSatisfy(\.value.isSelected) {
					buttonViewModels.forEach { $0.value.isSelected = false }
					buttonViewModels[.all]?.isSelected = true
				}
			}
			filterAuctions()
		}
	}

	func filterAuctions() {
		let selectedStates = buttonViewModels.filter { $1.isSelected }.map(\.key)
		let includeAll = selectedStates.contains(.all)
		filteredAuctions = auctions.filter { auction in
			auction.name != nil && (includeAll || (auction.status != nil && selectedStates.contains { $0.rawValue == auction.status }))
		}.sorted { first, second in
			guard let firstName = first.name, let secondName = second.name else { return false }
			return firstName.localizedCompare(secondName) == .orderedAscending
		}
	}

	func updateCenterViewData() {
		centerViewData = TopBarCenterViewData(
			type: .custom,
			customView: AnyView(SelectAuctionTopBarCenterView(title: organization?.name ?? "",
			                                                  countAuctions: organization?.totalAuctions ?? 0))
		)
	}

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "closeIcon", title: nil, action: closeView),
		]
	}

	func closeView() {
		backToPreviewViewPressed.toggle()
	}
}
