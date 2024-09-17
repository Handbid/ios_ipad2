// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Combine
import NetworkService

protocol BidRepository {
	func performTransaction(userID: Int?,
	                        paddleNumber: Int?,
	                        auctionId: Int,
	                        itemId: Int,
	                        amount: Double?,
	                        maxAmount: Double?,
	                        quantity: Int?,
	                        discountId: Int?,
	                        ignoreCC: Bool?,
	                        finalBid: Bool?) -> AnyPublisher<BidModel, any Error>
}

class BidRepositoryImpl: BidRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func performTransaction(userID: Int? = nil,
	                        paddleNumber: Int? = nil,
	                        auctionId: Int,
	                        itemId: Int,
	                        amount: Double? = nil,
	                        maxAmount: Double? = nil,
	                        quantity: Int? = nil,
	                        discountId: Int? = nil,
	                        ignoreCC: Bool? = nil,
	                        finalBid: Bool? = nil) -> AnyPublisher<BidModel, any Error>
	{
		var params: [String: CustomStringConvertible] = [
			"auctionId": auctionId,
			"itemId": itemId,
		]

		params.addOptional(key: "userID", value: userID)
		params.addOptional(key: "paddleNumber", value: paddleNumber)
		params.addOptional(key: "amount", value: amount)
		params.addOptional(key: "maxAmount", value: maxAmount)
		params.addOptional(key: "quantity", value: quantity)
		params.addOptional(key: "discountId", value: discountId)
		params.addOptional(key: "ignoreCC", value: ignoreCC)
		params.addOptional(key: "finalBid", value: finalBid)

		return post(ApiEndpoints.performTransaction, params: params)
			.tryMap { data -> BidModel in
				if let responseError = try? JSONDecoder().decode(ResponseError.self, from: data) {
					throw responseError
				}
				return try BidModel.decode(data)
			}
			.eraseToAnyPublisher()
	}
}
