// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Combine
import Foundation
import NetworkService

protocol ChooseAuctionRepository {
	// func fetchUserAuctionInventory(auctionId: Int) -> AnyPublisher<AuctionModel, Error>
	func fetchUserAuctions(status: [AuctionStateStatuses]) -> AnyPublisher<[AuctionModel], Error>
}

class ChooseAuctionRepositoryImpl: ChooseAuctionRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(_ network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func fetchUserAuctionInventory(auctionId: Int) -> AnyPublisher<AuctionModel, Error> {
		get(ApiEndpoints.auctionInventory, params: ["id": auctionId,
		                                            "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try AuctionModel.decode($0) }
			.receive(on: DispatchQueue.global(qos: .background))
			.eraseToAnyPublisher()
	}

	func fetchUserAuctions(status: [AuctionStateStatuses]) -> AnyPublisher<[AuctionModel], Error> {
		let statusString = status.map(\.rawValue).joined(separator: ",")
		return get(ApiEndpoints.getAuctionsUser, params: ["agent": "bidpad", "status": statusString])
			.tryMap { try AuctionModel.decodeArray($0) }
			.receive(on: DispatchQueue.global(qos: .background))
			.eraseToAnyPublisher()
	}
}
