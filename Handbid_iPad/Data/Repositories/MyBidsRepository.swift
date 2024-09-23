// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

protocol MyBidsRepository {
	func findBidder(paddleId: String, auctionId: Int) -> AnyPublisher<BidderModel, Error>
}

class MyBidsRepositoryImpl: MyBidsRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func findBidder(paddleId: String, auctionId: Int) -> AnyPublisher<BidderModel, Error> {
		get(ApiEndpoints.findBidder, params: ["paddleNumber": paddleId,
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
}
