// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct CreditCardModel: Decodable, NetworkingJSONDecodable {
	var cardNumber: String?
	var cardHolderName: String?
	var expirationDate: String?
	var cvv: String?
}

extension CreditCardModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		cardNumber <-- json["cardNumber"]
		cardHolderName <-- json["cardHolderName"]
		expirationDate <-- json["expirationDate"]
		cvv <-- json["cvv"]
	}
}
