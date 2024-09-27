// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

protocol MyBidsRepository {
	func findBidder(paddleNumber: String, auctionId: Int) -> AnyPublisher<BidderModel, Error>
	func fetchBidderBids(paddleNumber: String, auctionId: Int) -> AnyPublisher<[BidModel], Error>
}

class MyBidsRepositoryImpl: MyBidsRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func findBidder(paddleNumber: String, auctionId: Int) -> AnyPublisher<BidderModel, Error> {
		get(ApiEndpoints.findBidder, params: ["paddleNumber": paddleNumber,
		                                      "id": auctionId])
			.tryMap { data -> BidderModel in
				guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
				      let jsonDict = jsonObject as? [String: Any],
				      let bidderJSON = jsonDict["Bidder"]
				else {
					throw NSError(domain: "DecodingError",
					              code: 400,
					              userInfo: [NSLocalizedDescriptionKey: "Paddle Number not found"])
				}

				return try BidderModel.decode(bidderJSON)
			}
			.eraseToAnyPublisher()
	}

	func fetchBidderBids(paddleNumber: String, auctionId: Int) -> AnyPublisher<[BidModel], any Error> {
		get(ApiEndpoints.paddleBids, params: ["id": auctionId,
		                                      "paddleNumber": paddleNumber])
			.tryMap { data -> [BidModel] in
				guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
				      let jsonDict = jsonObject as? [String: Any],
				      let bidsJSON = jsonDict["bids"]
				else {
					throw NSError(domain: "DecodingError",
					              code: 400,
					              userInfo: [NSLocalizedDescriptionKey: "Bids Not Found"])
				}

				return try BidModel.decodeArray(bidsJSON)
			}
			.eraseToAnyPublisher()
	}
}
