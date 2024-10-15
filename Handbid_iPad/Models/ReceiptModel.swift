// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct ReceiptModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: Int
	var receiptsGuid: String?
	var auctionId: Int?
	var auctionGuid: String?
	var auctionUrl: String?
	var auctionChatEnabled: Bool?
	var bidderId: Int?
	var bidderName: String?
	var paddleNumber: Int?
	var name: String?
	var paid: Bool?
	var itemsDelivered: Bool?
	var shippingInstructions: String?
	var subTotal: Int?
	var shippingTotal: Int?
	var grandTotal: Int?
	var amountPaid: Int?
	var balanceDueWithFeeAmex: Int?
	var fullPaidTransactionFee: Int?
	var balanceDueWithFee: Int?
	var balanceDue: Int?
	var tax: Int?
	var taxRate: Int?
	var taxLabel: String?
	var enableCreditCardSupport: Bool?
	var currencyCode: String?
	var currencySymbol: String?
	var dateInserted: Int?
	var dateUpdated: Int?
	var lineItems: [ReceiptLineItemModel]?
	var totalItems: Int?
	var requireAddresstoPay: Bool?
	var organizationName: String?
	var gatewayId: Int?
	// var extraGateways: [ExtraGatewayModel]?
	var enablePromptPurchaseCoverCC: Bool?
	var enablePromptPurchaseCoverCCByDefault: Bool?
	var isPaying: Bool?
}

extension ReceiptModel: ArrowParsable {
	init() {
		self.id = Int()
	}

	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		receiptsGuid <-- json["receiptsGuid"]
		auctionId <-- json["auctionId"]
		auctionGuid <-- json["auctionGuid"]
		auctionUrl <-- json["auctionUrl"]
		auctionChatEnabled <-- json["auctionChatEnabled"]
		bidderId <-- json["bidderId"]
		bidderName <-- json["bidderName"]
		paddleNumber <-- json["paddleNumber"]
		name <-- json["name"]
		paid <-- json["paid"]
		itemsDelivered <-- json["itemsDelivered"]
		shippingInstructions <-- json["shippingInstructions"]
		subTotal <-- json["subTotal"]
		shippingTotal <-- json["shippingTotal"]
		grandTotal <-- json["grandTotal"]
		amountPaid <-- json["amountPaid"]
		balanceDueWithFeeAmex <-- json["balanceDueWithFeeAmex"]
		fullPaidTransactionFee <-- json["fullPaidTransactionFee"]
		balanceDueWithFee <-- json["balanceDueWithFee"]
		balanceDue <-- json["balanceDue"]
		tax <-- json["tax"]
		taxRate <-- json["taxRate"]
		taxLabel <-- json["taxLabel"]
		enableCreditCardSupport <-- json["enableCreditCardSupport"]
		currencyCode <-- json["currencyCode"]
		currencySymbol <-- json["currencySymbol"]
		dateInserted <-- json["dateInserted"]
		dateUpdated <-- json["dateUpdated"]
		lineItems <-- json["lineItems"]
		totalItems <-- json["totalItems"]
		requireAddresstoPay <-- json["requireAddresstoPay"]
		organizationName <-- json["organizationName"]
		gatewayId <-- json["gatewayId"]
		//        extraGateways <-- json["extraGateways"]
		enablePromptPurchaseCoverCC <-- json["enablePromptPurchaseCoverCC"]
		enablePromptPurchaseCoverCCByDefault <-- json["enablePromptPurchaseCoverCCByDefault"]
		isPaying <-- json["isPaying"]
	}
}
