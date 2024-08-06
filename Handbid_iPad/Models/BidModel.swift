// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Foundation
import NetworkService

struct BidModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: Int?
	var name: String?
	var status: String?
	var statusReason: String?
	var bidType: String?
	var itemId: Int?
	var bidId: Int?
	var receiptId: Int?
	var auctionId: Int?
	var amount: Int?
	var currentAmount: Int?
	var eventRevenue: Int?
	var maxAmount: Int?
	var quantity: Int?
	var microtime: Date?
	var bidderName: String?
	var bidderFullName: String?
	var purchaserName: String?
	var paddleNumber: String?
	var bidderDevice: String?
	var purchaseId: Int?
	var notificationMessage: String?
	var notificationTime: String?
	var notificationType: String?
	var bidderId: Int?
	var phoneCode: String?
	var countryId: Int?
	var countryCode: String?
}

extension BidModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		id <-- json["identity"]
		name <-- json["name"]
		status <-- json["status"]
		statusReason <-- json["statusReason"]
		bidType <-- json["bidType"]
		itemId <-- json["itemId"]
		bidId <-- json["bidId"]
		receiptId <-- json["receiptId"]
		auctionId <-- json["auctionId"]
		amount <-- json["amount"]
		currentAmount <-- json["currentAmount"]
		eventRevenue <-- json["eventRevenue"]
		maxAmount <-- json["maxAmount"]
		quantity <-- json["quantity"]
		microtime <-- json["microtime"]
		bidderName <-- json["bidderName"]
		bidderFullName <-- json["bidderFullName"]
		purchaserName <-- json["purchaserName"]
		paddleNumber <-- json["paddleNumber"]
		bidderDevice <-- json["bidderDevice"]
		purchaseId <-- json["purchaseId"]
		notificationMessage <-- json["notificationMessage"]
		notificationTime <-- json["notificationTime"]
		notificationType <-- json["notificationType"]
		bidderId <-- json["bidderId"]
		phoneCode <-- json["phoneCode"]
		countryId <-- json["countryId"]
		countryCode <-- json["countryCode"]
	}
}
