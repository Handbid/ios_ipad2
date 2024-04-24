// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class ChooseAuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	private var cancellables = Set<AnyCancellable>()
	var buttonViewModels: [AuctionState: AuctionButtonViewModel] = AuctionState.allCases.reduce(into: [:]) { $0[$1] = AuctionButtonViewModel() }
	@Published var auctions: [AuctionItem] = []
	@Published var filteredAuctions: [AuctionItem] = []

	init() {
		loadExampleAuctions()
		buttonViewModels[.all]?.isSelected = true // Initially select 'all'
		filterAuctions()
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

	func filterAuctions() {
		let selectedStates = buttonViewModels.filter { $1.isSelected }.map(\.key.rawValue)

		// Show all auctions if no specific filter is selected or if 'all' is selected
		if selectedStates.isEmpty || selectedStates.contains("all") {
			filteredAuctions = auctions
		}
		else {
			filteredAuctions = auctions.filter { selectedStates.contains($0.status) }
		}
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
