// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

protocol MyBidsRepository {
	func findBidder(paddleNumber: String, auctionId: Int) -> AnyPublisher<BidderModel, Error>
	func fetchBidderBids(paddleNumber: String, auctionId: Int) -> AnyPublisher<[BidModel], Error>
	func fetchReceipts(paddleNumber: Int, auctionId: Int) -> AnyPublisher<[ReceiptModel], any Error>
	func checkInUser(paddleNumber: Int, auctionId: Int) -> AnyPublisher<BidderModel, Error>
	func sendReceipt(receiptId: Int, email: String?) -> AnyPublisher<Bool, Error>
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

	func fetchReceipts(paddleNumber: Int, auctionId: Int) -> AnyPublisher<[ReceiptModel], any Error> {
		get(ApiEndpoints.fetchInvoice, params: ["id": auctionId,
		                                        "paddleNumber": paddleNumber])
			.tryMap { data -> [ReceiptModel] in
				guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
				      let jsonDict = jsonObject as? [String: Any],
				      let receiptsJSON = jsonDict["receipts"]
				else {
					throw NSError(domain: "DecodingError",
					              code: 400,
					              userInfo: [NSLocalizedDescriptionKey: "Invocies Not Found"])
				}
				return try ReceiptModel.decodeArray(receiptsJSON)
			}
			.eraseToAnyPublisher()
	}

	func checkInUser(paddleNumber: Int, auctionId: Int) -> AnyPublisher<BidderModel, any Error> {
		get(ApiEndpoints.checkInUser, params: ["paddleNumber": paddleNumber,
		                                       "auctionId": auctionId])
			.tryMap { try BidderModel.decode($0) }
			.map { $0 }
			.eraseToAnyPublisher()
	}

	func sendReceipt(receiptId: Int, email: String?) -> AnyPublisher<Bool, Error> {
		var params: [String: CustomStringConvertible] = [
			"id": receiptId,
			"whitelabelId": AppInfoProvider.whitelabelId,
		]

		if let email {
			params["email"] = email
			params["sendType"] = "email"
		}
		else {
			params["sendType"] = "sms"
		}

		return post(ApiEndpoints.sendReceipt, params: params)
			.tryMap { data -> Bool in
				guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
				      let dict = json as? [String: Any]
				else {
					throw NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Incorrect response from the server."])
				}

				if let success = dict["success"] as? Int, success == 1 {
					return true
				}
				else {
					if let data = dict["data"] as? [String: Any],
					   let errors = data["error"] as? [String],
					   !errors.isEmpty
					{
						let errorMessage = errors.joined(separator: "\n")
						throw NSError(domain: "SendReceiptError", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
					}
					else {
						throw NSError(domain: "SendReceiptError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error"])
					}
				}
			}
			.eraseToAnyPublisher()
	}
}
