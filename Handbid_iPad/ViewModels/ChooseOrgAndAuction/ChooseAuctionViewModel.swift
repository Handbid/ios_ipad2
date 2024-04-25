// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class ChooseAuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	@Published var auctions: [AuctionItem] = []
	@Published var filteredAuctions: [AuctionItem] = []
	var buttonViewModels: [AuctionState: AuctionButtonViewModel] = AuctionState.allCases.reduce(into: [:]) { $0[$1] = AuctionButtonViewModel() }
	private var cancellables = Set<AnyCancellable>()

	init() {
		loadExampleAuctions()
		setupInitialSelection()
		setupButtonBindings()
	}

	private func setupInitialSelection() {
		buttonViewModels[.all]?.isSelected = true
		filterAuctions()
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

	private func handleStateChange(for state: AuctionState, isSelected: Bool) {
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
		if selectedStates.contains(.all) {
			filteredAuctions = auctions.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
		}
		else {
			filteredAuctions = auctions.filter { auction in
				selectedStates.contains(where: { $0.rawValue == auction.status })
			}.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
		}
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .custom,
			customView: AnyView(SelectAuctionTopBarCenterView(title: "org name",
			                                                  countAuctions: 10))
		)
	}

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "closeIcon", title: nil, action: closeView),
		]
	}

	func closeView() {
		print("close")
	}

	private func loadExampleAuctions() {
		// Sample auctions
		auctions = [
			AuctionItem(name: "Vintage Car Collection", address: "123 Main St, Anytown, USA", endDate: "2024-05-10", itemCount: 5, status: "open", imageUrl: URL(string: "https://example.com/car.jpg")),
			AuctionItem(name: "Estate Fine Art", address: "456 Elm St, Sometown, USA", endDate: "2024-05-15", itemCount: 20, status: "closed", imageUrl: URL(string: "https://example.com/art.jpg")),
			AuctionItem(name: "Antique Furniture", address: "789 Oak St, Yourtown, USA", endDate: "2024-05-20", itemCount: 10, status: "preview", imageUrl: URL(string: "https://example.com/furniture.jpg")),
			AuctionItem(name: "Rare Books Collection", address: "321 Maple St, Theirtown, USA", endDate: "2024-05-25", itemCount: 7, status: "presale", imageUrl: URL(string: "https://example.com/books.jpg")),
		]
	}
}
