// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct VerifyManagerPinModel: Codable, NetworkingJSONDecodable {
	var success: Bool?
	var message: String?
}

extension VerifyManagerPinModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		success <-- json["success"]
		message <-- json["data.message"]
	}
}
