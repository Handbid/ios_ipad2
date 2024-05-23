// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

class ChooseAuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	private let repository: ChooseAuctionRepository
	private var cancellables = Set<AnyCancellable>()

	@Published var filteredAuctions: [AuctionModel] = []
	@Published var auctions: [AuctionModel] = []
	@Published var centerViewData: TopBarCenterViewData
	@Published var backToPreviewViewPressed: Bool = false
	@Published var organization: OrganizationModel? {
		didSet {
			updateCenterViewData()
		}
	}

	private let dataManager: DataManager

	var buttonViewModels: [AuctionStateStatuses: AuctionFilterButtonViewModel]

	init(repository: ChooseAuctionRepository, organization: OrganizationModel? = nil, dataManager: DataManager) {
		self.repository = repository
		self.organization = organization
		self.dataManager = dataManager
		self.buttonViewModels = AuctionStateStatuses.allCases.reduce(into: [:]) { $0[$1] = AuctionFilterButtonViewModel() }
		self.centerViewData = TopBarCenterViewData(type: .custom, customView: AnyView(EmptyView()))
		self.centerViewData = createCenterViewData()
		setupInitialSelection()
		setupButtonBindings()

        let user2: UserModel? = try? dataManager.fetchSingle(of: UserModel.self, from: .user)
		print(user2?.identity)
	}

	func fetchAuctionsIfNeeded() {
		guard auctions.isEmpty else { return }
		fetchUserAuctions()
	}

	private func setupInitialSelection() {
		buttonViewModels[.all]?.isSelected = true
		filterAuctions()
	}

	private func fetchUserAuctions() {
		repository.fetchUserAuctions(status: AuctionStateStatuses.allCases)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: handleCompletion, receiveValue: handleAuctionsReceived)
			.store(in: &cancellables)
	}

	private func setupButtonBindings() {
		for (state, viewModel) in buttonViewModels {
			viewModel.$isSelected
				.dropFirst()
				.sink { [weak self] isSelected in
					self?.handleStateChange(for: state, isSelected: isSelected)
				}
				.store(in: &cancellables)
		}
	}

	private func handleStateChange(for state: AuctionStateStatuses, isSelected: Bool) {
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			updateButtonSelection(for: state, isSelected: isSelected)
			filterAuctions()
		}
	}

	private func updateButtonSelection(for state: AuctionStateStatuses, isSelected: Bool) {
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
	}

	func filterAuctions() {
		let selectedStates = buttonViewModels.filter { $1.isSelected }.map(\.key)
		let includeAll = selectedStates.contains(.all)
		filteredAuctions = auctions.filter { auction in
			auction.name != nil && (includeAll || (auction.status != nil && selectedStates.contains { $0.rawValue == auction.status }))
		}.sorted(by: { $0.name?.localizedCompare($1.name ?? "") == .orderedAscending })
	}

	func updateCenterViewData() {
		centerViewData = createCenterViewData()
	}

	private func createCenterViewData() -> TopBarCenterViewData {
		TopBarCenterViewData(
			type: .custom,
			customView: AnyView(SelectAuctionTopBarCenterView(
				title: organization?.name ?? "",
				countAuctions: organization?.totalAuctions ?? 0
			))
		)
	}

	private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
		if case let .failure(error) = completion, let netError = error as? NetworkingError {
			print(netError)
		}
	}

	private func handleAuctionsReceived(_ auctions: [AuctionModel]) {
		self.auctions = auctions
		filteredAuctions = auctions
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
