// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct CreditCardModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: String
	var creditCardsGuid: String?
	var creditCardHandle: String?
	var creditCardToken: String?
	var stripeId: String?
	var lastFour: String?
	var cardType: String?
	var nameOnCard: String?
	var expMonth: Int?
	var expYear: Int?
	var isActiveCard: Int?
	var ccAddressStreet1: String?
	var ccAddressStreet2: String?
	var ccAddressCity: String?
	var ccAddressProvinceId: Int?
	var ccAddressPostalCode: String?
	var ccAddressCountryId: Int?
	var gatewayId: Int?
	var tokenizedCard: String?
}

extension CreditCardModel: ArrowParsable {
	init() {
		self.id = String()
	}

	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		creditCardsGuid <-- json["creditCardsGuid"]
		creditCardHandle <-- json["creditCardHandle"]
		creditCardToken <-- json["creditCardToken"]
		stripeId <-- json["stripeId"]
		lastFour <-- json["lastFour"]
		cardType <-- json["cardType"]
		nameOnCard <-- json["nameOnCard"]
		expMonth <-- json["expMonth"]
		expYear <-- json["expYear"]
		isActiveCard <-- json["isActiveCard"]
		ccAddressStreet1 <-- json["ccAddressStreet1"]
		ccAddressStreet2 <-- json["ccAddressStreet2"]
		ccAddressCity <-- json["ccAddressCity"]
		ccAddressProvinceId <-- json["ccAddressProvinceId"]
		ccAddressPostalCode <-- json["ccAddressPostalCode"]
		ccAddressCountryId <-- json["ccAddressCountryId"]
		gatewayId <-- json["gatewayId"]
		tokenizedCard <-- json["tokenizedCard"]
	}
}
