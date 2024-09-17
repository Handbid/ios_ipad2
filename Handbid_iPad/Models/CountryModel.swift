// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct CountryModel: Identifiable, Codable, NetworkingJSONDecodable {
	var id: Int?
	var name: String?
	var countryCode: String?
	var phoneCode: String?

	func countryFlag() -> String? {
		guard let code = countryCode
		else { return nil }

		return code
			.unicodeScalars
			.map { 127_397 + $0.value }
			.compactMap(UnicodeScalar.init)
			.map(String.init)
			.joined()
	}
}

extension CountryModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		name <-- json["name"]
		countryCode <-- json["countryCode"]
		phoneCode <-- json["phoneCode"]
	}
}
