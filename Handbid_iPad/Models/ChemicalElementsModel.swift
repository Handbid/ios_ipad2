// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct ChemicalElementsModel: Decodable, NetworkingJSONDecodable {
	var lead: Bool?
	var mercury: Bool?
	var nickel: Bool?
	var cadmium: Bool?
	var arsenic: Bool?
	var chromium: Bool?
}

extension ChemicalElementsModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		lead <-- json["lead"]
		mercury <-- json["mercury"]
		nickel <-- json["nickel"]
		cadmium <-- json["cadmium"]
		arsenic <-- json["arsenic"]
		chromium <-- json["chromium"]
	}
}