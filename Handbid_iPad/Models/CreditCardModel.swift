// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct CreditCardModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable, Hashable {
	var id: Int
	var creditCardsGuid: String?
	var creditCardHandle: String?
	var creditCardToken: String?
	var stripeId: String?
	var lastFour: String?
	var cardTypeString: String?
	var cardType: CardType?
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
	var numberCard: String?

	enum CardType: String, Codable, Hashable {
		case visa = "Visa"
		case mastercard = "MasterCard"
		case amex = "Amex"
		case dankort = "Dankort"
		case diners = "Diners"
		case discover = "Discover"
		case electron = "Electron"
		case interpayment = "Interpayment"
		case maestro = "Maestro"
		case unionpay = "UnionPay"
	}
}

extension CreditCardModel.CardType {
	var imageName: String {
		switch self {
		case .amex:
			"amex_Image"
		case .dankort:
			"dankort_Image"
		case .diners:
			"diners_Image"
		case .discover:
			"discover_Image"
		case .electron:
			"electron_Image"
		case .interpayment:
			"interPay_Image"
		case .maestro:
			"maestro_Image"
		case .mastercard:
			"masterdCard_Image"
		case .unionpay:
			"unionPay_Image"
		case .visa:
			"visa_Image"
		}
	}
}

extension CreditCardModel: ArrowParsable {
	init() {
		self.id = Int()
	}

	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		creditCardsGuid <-- json["creditCardsGuid"]
		creditCardHandle <-- json["creditCardHandle"]
		creditCardToken <-- json["creditCardToken"]
		stripeId <-- json["stripeId"]
		lastFour <-- json["lastFour"]
		cardTypeString <-- json["cardType"]
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

		if let cardTypeString {
			cardType = CardType(rawValue: cardTypeString)
		}
	}
}
