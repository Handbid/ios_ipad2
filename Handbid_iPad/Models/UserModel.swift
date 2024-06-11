// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct UserModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
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

		addresses = (json["addresses"]?.collection ?? [json["addresses"]].compactMap { $0 }).map { jsonItem in
			var address = AddressModel()
			address.deserialize(jsonItem)
			return address
		}

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
}
