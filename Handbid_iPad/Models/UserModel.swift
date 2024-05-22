// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct UserModel: Identifiable, Codable, NetworkingJSONDecodable {
	var id: String
	var identity: Int?
	var pin: Int?
	var usersGuid: String?
	var stripeId: String?
	var name: String?
	var alias: String?
	var currentPaddleNumber: String?
	var currentPlacement: String?
	var placementLabel: String?
	var firstName: String?
	var lastName: String?
	var email: String?
	var requestDataUpdate: Bool?
	var userPhone: String?
	var userCellPhone: String?
	var isPrivate: Bool?
	var shippingAddress: String?
	var userAddressCountryId: Int?
	var countryCode: String?
	var addresses: [AddressModel]?
	var currency: String?
	var timeZone: String?
	var imageUrl: String?
	var organization: [OrganizationModel]?
	var creditCards: [CreditCardModel]?
	var isCheckinAgent: Bool?
	var canCloseAuction: Bool?
	var canSendBroadcast: Bool?
	var canManageItems: Bool?
}

extension UserModel: ArrowParsable {
	init() {
		self.id = String()
	}

	mutating func deserialize(_ json: JSON) {
		id <-- json["usersGuid"]
		identity <-- json["id"]
		pin <-- json["pin"]
		usersGuid <-- json["usersGuid"]
		stripeId <-- json["stripeId"]
		name <-- json["name"]
		alias <-- json["alias"]
		currentPaddleNumber <-- json["currentPaddleNumber"]
		currentPlacement <-- json["currentPlacement"]
		placementLabel <-- json["placementLabel"]
		firstName <-- json["firstName"]
		lastName <-- json["lastName"]
		email <-- json["email"]
		requestDataUpdate <-- json["requestDataUpdate"]
		userPhone <-- json["userPhone"]
		userCellPhone <-- json["userCellPhone"]
		isPrivate <-- json["isPrivate"]
		shippingAddress <-- json["shippingAddress"]
		userAddressCountryId <-- json["userAddressCountryId"]
		countryCode <-- json["countryCode"]
		currency <-- json["currency"]
		timeZone <-- json["timeZone"]
		imageUrl <-- json["imageUrl"]
		isCheckinAgent <-- json["isCheckinAgent"]
		canCloseAuction <-- json["canCloseAuction"]
		canSendBroadcast <-- json["canSendBroadcast"]
		canManageItems <-- json["canManageItems"]

		organization = (json["organization"]?.collection ?? [json["organization"]].compactMap { $0 }).map { jsonItem in
			var org = OrganizationModel()
			org.deserialize(jsonItem)
			return org
		}

		creditCards = (json["creditCards"]?.collection ?? [json["creditCards"]].compactMap { $0 }).map { jsonItem in
			var card = CreditCardModel()
			card.deserialize(jsonItem)
			return card
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(id, forKey: .id)
		try container.encodeIfPresent(identity, forKey: .identity)
		try container.encodeIfPresent(pin, forKey: .pin)
		try container.encodeIfPresent(usersGuid, forKey: .usersGuid)
		try container.encodeIfPresent(stripeId, forKey: .stripeId)
		try container.encodeIfPresent(name, forKey: .name)
		try container.encodeIfPresent(alias, forKey: .alias)
		try container.encodeIfPresent(currentPaddleNumber, forKey: .currentPaddleNumber)
		try container.encodeIfPresent(currentPlacement, forKey: .currentPlacement)
		try container.encodeIfPresent(placementLabel, forKey: .placementLabel)
		try container.encodeIfPresent(firstName, forKey: .firstName)
		try container.encodeIfPresent(lastName, forKey: .lastName)
		try container.encodeIfPresent(email, forKey: .email)
		try container.encodeIfPresent(requestDataUpdate, forKey: .requestDataUpdate)
		try container.encodeIfPresent(userPhone, forKey: .userPhone)
		try container.encodeIfPresent(userCellPhone, forKey: .userCellPhone)
		try container.encodeIfPresent(isPrivate, forKey: .isPrivate)
		try container.encodeIfPresent(shippingAddress, forKey: .shippingAddress)
		try container.encodeIfPresent(userAddressCountryId, forKey: .userAddressCountryId)
		try container.encodeIfPresent(countryCode, forKey: .countryCode)
		try container.encodeIfPresent(addresses, forKey: .addresses)
		try container.encodeIfPresent(currency, forKey: .currency)
		try container.encodeIfPresent(timeZone, forKey: .timeZone)
		try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
		try container.encodeIfPresent(organization, forKey: .organization)
		try container.encodeIfPresent(creditCards, forKey: .creditCards)
		try container.encodeIfPresent(isCheckinAgent, forKey: .isCheckinAgent)
		try container.encodeIfPresent(canCloseAuction, forKey: .canCloseAuction)
		try container.encodeIfPresent(canSendBroadcast, forKey: .canSendBroadcast)
		try container.encodeIfPresent(canManageItems, forKey: .canManageItems)
	}
}
