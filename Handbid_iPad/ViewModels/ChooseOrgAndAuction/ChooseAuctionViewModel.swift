// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class ChooseAuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	var buttonViewModels: [AuctionStateStatuses: AuctionFilterButtonViewModel] = AuctionStateStatuses.allCases.reduce(into: [:]) { $0[$1] = AuctionFilterButtonViewModel() }
	@Published var filteredAuctions: [AuctionModel] = []
	@Published var auctions: [AuctionModel] = []
	@Published var backToPreviewViewPressed: Bool = false
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
		backToPreviewViewPressed.toggle()
	}

	private func loadExampleAuctions() {
		// Sample auctions
		auctions = [
			AuctionModel(name: "Vintage Car Collection", address: "123 Main St, Anytown, USA", endDate: "2024-05-10", itemCount: 5, status: "open", imageUrl: URL(string: "https://example.com/car.jpg")),
			AuctionModel(name: "Estate Fine Art", address: "456 Elm St, Sometown, USA", endDate: "2024-05-15", itemCount: 20, status: "closed", imageUrl: URL(string: "https://example.com/art.jpg")),
			AuctionModel(name: "Antique Furniture Antique Furniture Antique Furniture", address: "789 Oak St, Yourtown, USA", endDate: "2024-05-20", itemCount: 10, status: "preview", imageUrl: URL(string: "https://example.com/furniture.jpg")),
			AuctionModel(name: "Rare Books Collection", address: "321 Maple St, Theirtown, USA", endDate: "2024-05-25", itemCount: 7, status: "presale", imageUrl: URL(string: "https://example.com/books.jpg")),
			AuctionModel(name: "Luxury Watches", address: "12 Timezone Ave, Watchcity, USA", endDate: "2024-05-30", itemCount: 15, status: "open", imageUrl: URL(string: "https://example.com/watches.jpg")),
			AuctionModel(name: "Modern Art Pieces", address: "500 Art Rd, Artville, USA", endDate: "2024-06-05", itemCount: 30, status: "closed", imageUrl: URL(string: "https://example.com/modernart.jpg")),
			AuctionModel(name: "Vintage Vinyl Records", address: "25 Music Ln, Audiocity, USA", endDate: "2024-06-10", itemCount: 50, status: "open", imageUrl: URL(string: "https://example.com/vinyl.jpg")),
			AuctionModel(name: "Antique Jewelry", address: "100 Gem St, Jewelcity, USA 100 Gem St, Jewelcity, USA", endDate: "2024-06-15", itemCount: 25344, status: "preview", imageUrl: URL(string: "https://example.com/jewelry.jpg")),
			AuctionModel(name: "Historic Documents", address: "200 History Ave, Archivecity, USA", endDate: "2024-06-20", itemCount: 40, status: "presale", imageUrl: URL(string: "https://example.com/documents.jpg")),
			AuctionModel(name: "Sports Memorabilia", address: "321 Sports Rd, Sportstown, USA", endDate: "2024-06-25", itemCount: 35, status: "open", imageUrl: URL(string: "https://example.com/sports.jpg")),
			AuctionModel(name: "Designer Clothing", address: "1 Fashion Blvd, Fashioncity, USA", endDate: "2024-06-30", itemCount: 45, status: "closed", imageUrl: URL(string: "https://example.com/clothing.jpg")),
			AuctionModel(name: "Cinema Props", address: "101 Movie St, Hollywood, USA", endDate: "2024-07-05", itemCount: 20, status: "open", imageUrl: URL(string: "https://example.com/props.jpg")),
			AuctionModel(name: "Rare Coins Collection", address: "77 Coin Ave, Coincity, USA", endDate: "2024-07-10", itemCount: 100, status: "preview", imageUrl: URL(string: "https://example.com/coins.jpg")),
			AuctionModel(name: "Classic Motorcycles", address: "69 Bike Rd, Motorcity, USA", endDate: "2024-07-15", itemCount: 8, status: "open", imageUrl: URL(string: "https://example.com/motorcycles.jpg")),
			AuctionModel(name: "Vintage Cameras", address: "55 Lens St, Cameratown, USA", endDate: "2024-07-20", itemCount: 20, status: "presale", imageUrl: URL(string: "https://example.com/cameras.jpg")),
			AuctionModel(name: "Old Maps Collection", address: "32 Compass Rd, Mapville, USA", endDate: "2024-07-25", itemCount: 60, status: "open", imageUrl: URL(string: "https://example.com/maps.jpg")),
			AuctionModel(name: "Gourmet Kitchen Equipment", address: "101 Chef Ave, Cooktown, USA", endDate: "2024-07-30", itemCount: 25, status: "closed", imageUrl: URL(string: "https://example.com/kitchen.jpg")),
			AuctionModel(name: "Gaming Memorabilia", address: "88 Game Rd, Gametown, USA", endDate: "2024-08-05", itemCount: 30, status: "preview", imageUrl: URL(string: "https://example.com/gaming.jpg")),
			AuctionModel(name: "Sci-Fi Collectibles", address: "2024 Future Rd, Fandomcity, USA", endDate: "2024-08-10", itemCount: 50, status: "presale", imageUrl: URL(string: "https://example.com/scifi.jpg")),
			AuctionModel(name: "Handcrafted Pottery", address: "707 Craft St, Craftsville, USA", endDate: "2024-08-15", itemCount: 18, status: "open", imageUrl: URL(string: "https://example.com/pottery.jpg")),
		]
	}
}
